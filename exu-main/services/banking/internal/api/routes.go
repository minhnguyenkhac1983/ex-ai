package api

import (
	"database/sql"

	"github.com/exu-financial/banking/internal/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, db *sql.DB) {
	api := router.Group("/api/v1")

	// Health check
	api.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "ok",
			"service": "banking",
		})
	})

	// Protected routes
	api.Use(middleware.AuthMiddleware())

	// Accounts
	accounts := api.Group("/accounts")
	{
		accounts.POST("", CreateAccountHandler(db))
		accounts.GET("", ListAccountsHandler(db))
		accounts.GET("/:id", GetAccountHandler(db))
		accounts.GET("/:id/balance", GetBalanceHandler(db))
		accounts.GET("/:id/transactions", GetTransactionsHandler(db))
	}

	// Transactions
	transactions := api.Group("/transactions")
	{
		transactions.POST("/deposit", DepositHandler(db))
		transactions.POST("/withdraw", WithdrawHandler(db))
		transactions.POST("/transfer", TransferHandler(db))
		transactions.GET("/:id", GetTransactionHandler(db))
	}
}

