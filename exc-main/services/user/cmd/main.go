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
	usersTotal = prom.NewCounter(prom.CounterOpts{Name: "user_created_total", Help: "total users created (demo)"})
)

func main() {
	prom.MustRegister(usersTotal)
	r := gin.Default()
	r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))
	r.POST("/users", func(c *gin.Context) { usersTotal.Inc(); c.JSON(201, gin.H{"id": "u-demo"}) })
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	_ = http.ListenAndServe(fmt.Sprintf(":%s", port), r)
}
