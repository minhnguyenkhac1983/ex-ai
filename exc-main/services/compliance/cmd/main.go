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
    screeningsTotal = prom.NewCounter(prom.CounterOpts{Name: "compliance_screenings_total", Help: "total screenings"})
)

func main() {
    prom.MustRegister(screeningsTotal)
    r := gin.Default()
    r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
    r.GET("/metrics", gin.WrapH(promhttp.Handler()))
    r.POST("/screen", func(c *gin.Context) { screeningsTotal.Inc(); c.JSON(200, gin.H{"status": "accepted"}) })
    port := os.Getenv("PORT")
    if port == "" { port = "8080" }
    _ = http.ListenAndServe(fmt.Sprintf(":%s", port), r)
}


