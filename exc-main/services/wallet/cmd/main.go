package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	prom "github.com/prometheus/client_golang/prometheus"
	promhttp "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	depositsTotal    = prom.NewCounter(prom.CounterOpts{Name: "wallet_deposits_total", Help: "total deposits"})
	withdrawalsTotal = prom.NewCounter(prom.CounterOpts{Name: "wallet_withdrawals_total", Help: "total withdrawals"})
)

func main() {
	prom.MustRegister(depositsTotal, withdrawalsTotal)
	r := gin.Default()
	r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))
	r.POST("/deposit", func(c *gin.Context) {
		depositsTotal.Inc()
		c.JSON(200, gin.H{"status": "accepted"})
	})
	r.POST("/withdraw", func(c *gin.Context) {
		withdrawalsTotal.Inc()
		c.JSON(200, gin.H{"status": "accepted"})
	})
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	_ = http.ListenAndServe(fmt.Sprintf(":%s", port), r)
}
