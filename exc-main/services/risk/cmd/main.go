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
    checksTotal = prom.NewCounter(prom.CounterOpts{Name: "risk_checks_total", Help: "total risk checks"})
)

func main() {
    prom.MustRegister(checksTotal)
    r := gin.Default()
    r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
    r.GET("/metrics", gin.WrapH(promhttp.Handler()))
    r.POST("/check", func(c *gin.Context) { checksTotal.Inc(); c.JSON(200, gin.H{"status": "ok"}) })
    port := os.Getenv("PORT")
    if port == "" { port = "8080" }
    _ = http.ListenAndServe(fmt.Sprintf(":%s", port), r)
}


