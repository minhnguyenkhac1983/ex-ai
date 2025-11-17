package api

import (
	"database/sql"

	"github.com/exu-financial/iam/internal/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, db *sql.DB) {
	api := router.Group("/api/v1")

	// Health check
	api.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "ok",
			"service": "iam",
		})
	})

	// Auth routes (public)
	auth := api.Group("/auth")
	{
		auth.POST("/register", RegisterHandler(db))
		auth.POST("/login", LoginHandler(db))
		auth.POST("/refresh", RefreshTokenHandler(db))
		auth.POST("/logout", LogoutHandler(db))
	}

	// User routes (protected)
	users := api.Group("/users")
	users.Use(middleware.AuthMiddleware())
	{
		users.GET("/me", GetCurrentUserHandler(db))
		users.PUT("/me", UpdateCurrentUserHandler(db))
		users.GET("/:id", GetUserHandler(db))
	}
}

