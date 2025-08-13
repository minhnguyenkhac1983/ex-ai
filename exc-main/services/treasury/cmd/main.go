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
    signOpsTotal = prom.NewCounter(prom.CounterOpts{Name: "treasury_sign_ops_total", Help: "total sign ops"})
)

func main() {
    prom.MustRegister(signOpsTotal)
    r := gin.Default()
    r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
    r.GET("/metrics", gin.WrapH(promhttp.Handler()))
    r.POST("/sign", func(c *gin.Context) { signOpsTotal.Inc(); c.JSON(200, gin.H{"status": "queued"}) })
    port := os.Getenv("PORT")
    if port == "" { port = "8080" }
    _ = http.ListenAndServe(fmt.Sprintf(":%s", port), r)
}


