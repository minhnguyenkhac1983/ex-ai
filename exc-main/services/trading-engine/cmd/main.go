package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
    "sort"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	// Minimal metrics registry
	registry := prometheus.NewRegistry()
	// Register default Go and process collectors so /metrics is non-empty
	registry.MustRegister(prometheus.NewGoCollector())
	registry.MustRegister(prometheus.NewProcessCollector(prometheus.ProcessCollectorOpts{}))

    ordersTotal := prometheus.NewCounter(prometheus.CounterOpts{Name: "te_orders_total", Help: "Total orders received"})
    tradesTotal := prometheus.NewCounter(prometheus.CounterOpts{Name: "te_trades_total", Help: "Total trades executed"})
    registry.MustRegister(ordersTotal, tradesTotal)

    type Order struct {
        ID    string  `json:"id"`
        Side  string  `json:"side"` // buy or sell
        Price float64 `json:"price"`
        Qty   float64 `json:"qty"`
    }

    var buys []Order
    var sells []Order

    sortBooks := func() {
        sort.Slice(buys, func(i, j int) bool { return buys[i].Price > buys[j].Price })
        sort.Slice(sells, func(i, j int) bool { return sells[i].Price < sells[j].Price })
    }

    match := func(incoming Order) []map[string]any {
        trades := []map[string]any{}
        if incoming.Side == "buy" {
            // match against best sells
            for incoming.Qty > 0 && len(sells) > 0 && incoming.Price >= sells[0].Price {
                tradeQty := incoming.Qty
                if tradeQty > sells[0].Qty { tradeQty = sells[0].Qty }
                trades = append(trades, map[string]any{"price": sells[0].Price, "qty": tradeQty})
                tradesTotal.Inc()
                incoming.Qty -= tradeQty
                sells[0].Qty -= tradeQty
                if sells[0].Qty == 0 { sells = sells[1:] }
            }
            if incoming.Qty > 0 { buys = append(buys, incoming); sortBooks() }
        } else {
            // sell matches best buys
            for incoming.Qty > 0 && len(buys) > 0 && incoming.Price <= buys[0].Price {
                tradeQty := incoming.Qty
                if tradeQty > buys[0].Qty { tradeQty = buys[0].Qty }
                trades = append(trades, map[string]any{"price": buys[0].Price, "qty": tradeQty})
                tradesTotal.Inc()
                incoming.Qty -= tradeQty
                buys[0].Qty -= tradeQty
                if buys[0].Qty == 0 { buys = buys[1:] }
            }
            if incoming.Qty > 0 { sells = append(sells, incoming); sortBooks() }
        }
        return trades
    }

	// Setup HTTP server
	router := gin.Default()
	router.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
	router.GET("/metrics", gin.WrapH(promhttp.HandlerFor(registry, promhttp.HandlerOpts{})))

    router.GET("/book", func(c *gin.Context) {
        // top of book only
        var bestBuy, bestSell *Order
        if len(buys) > 0 { bestBuy = &buys[0] }
        if len(sells) > 0 { bestSell = &sells[0] }
        c.JSON(200, gin.H{"best_buy": bestBuy, "best_sell": bestSell})
    })

    router.POST("/orders", func(c *gin.Context) {
        var o Order
        if err := c.BindJSON(&o); err != nil { c.JSON(400, gin.H{"error": err.Error()}); return }
        if o.Side != "buy" && o.Side != "sell" { c.JSON(400, gin.H{"error": "side must be buy|sell"}); return }
        if o.Price <= 0 || o.Qty <= 0 { c.JSON(400, gin.H{"error": "price, qty must be > 0"}); return }
        ordersTotal.Inc()
        trades := match(o)
        c.JSON(200, gin.H{"trades": trades})
    })

	server := &http.Server{Addr: ":8080", Handler: router}

	// Start server
	go func() {
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("Server failed to start: %v", err)
		}
	}()

	// Wait for interrupt signal to gracefully shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")

	// Graceful shutdown with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := server.Shutdown(ctx); err != nil {
		log.Fatal("Server forced to shutdown:", err)
	}

	log.Println("Server exited")
}
