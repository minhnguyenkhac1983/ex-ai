package api

import (
	"database/sql"
	"fmt"
	"math/rand"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type CreateAccountRequest struct {
	AccountType string `json:"account_type" binding:"required,oneof=savings current"`
	Currency    string `json:"currency" binding:"required,len=3"`
}

type AccountResponse struct {
	ID             uuid.UUID `json:"id"`
	UserID         uuid.UUID `json:"user_id"`
	AccountNumber  string    `json:"account_number"`
	AccountType    string    `json:"account_type"`
	Currency       string    `json:"currency"`
	Balance        string    `json:"balance"`
	AvailableBalance string  `json:"available_balance"`
	Status         string    `json:"status"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

func CreateAccountHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userIDStr, exists := c.Get("user_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
			return
		}

		userID, err := uuid.Parse(userIDStr.(string))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
			return
		}

		var req CreateAccountRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Generate account number (10 digits)
		accountNumber := generateAccountNumber()

		// Create account
		accountID := uuid.New()
		_, err = db.Exec(
			`INSERT INTO accounts (id, user_id, account_number, account_type, currency, balance, available_balance)
			 VALUES ($1, $2, $3, $4, $5, 0, 0)`,
			accountID, userID, accountNumber, req.AccountType, req.Currency,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create account"})
			return
		}

		// Get created account
		var account AccountResponse
		err = db.QueryRow(
			`SELECT id, user_id, account_number, account_type, currency, balance, available_balance, status, created_at, updated_at
			 FROM accounts WHERE id = $1`,
			accountID,
		).Scan(
			&account.ID, &account.UserID, &account.AccountNumber, &account.AccountType,
			&account.Currency, &account.Balance, &account.AvailableBalance,
			&account.Status, &account.CreatedAt, &account.UpdatedAt,
		)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve account"})
			return
		}

		c.JSON(http.StatusCreated, account)
	}
}

func ListAccountsHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userIDStr, exists := c.Get("user_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
			return
		}

		userID, err := uuid.Parse(userIDStr.(string))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
			return
		}

		rows, err := db.Query(
			`SELECT id, user_id, account_number, account_type, currency, balance, available_balance, status, created_at, updated_at
			 FROM accounts WHERE user_id = $1 ORDER BY created_at DESC`,
			userID,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}
		defer rows.Close()

		var accounts []AccountResponse
		for rows.Next() {
			var account AccountResponse
			err := rows.Scan(
				&account.ID, &account.UserID, &account.AccountNumber, &account.AccountType,
				&account.Currency, &account.Balance, &account.AvailableBalance,
				&account.Status, &account.CreatedAt, &account.UpdatedAt,
			)
			if err != nil {
				continue
			}
			accounts = append(accounts, account)
		}

		c.JSON(http.StatusOK, gin.H{"accounts": accounts})
	}
}

func GetAccountHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		accountIDStr := c.Param("id")
		accountID, err := uuid.Parse(accountIDStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid account ID"})
			return
		}

		userIDStr, _ := c.Get("user_id")
		userID, _ := uuid.Parse(userIDStr.(string))

		var account AccountResponse
		err = db.QueryRow(
			`SELECT id, user_id, account_number, account_type, currency, balance, available_balance, status, created_at, updated_at
			 FROM accounts WHERE id = $1 AND user_id = $2`,
			accountID, userID,
		).Scan(
			&account.ID, &account.UserID, &account.AccountNumber, &account.AccountType,
			&account.Currency, &account.Balance, &account.AvailableBalance,
			&account.Status, &account.CreatedAt, &account.UpdatedAt,
		)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Account not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		c.JSON(http.StatusOK, account)
	}
}

func GetBalanceHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		accountIDStr := c.Param("id")
		accountID, err := uuid.Parse(accountIDStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid account ID"})
			return
		}

		userIDStr, _ := c.Get("user_id")
		userID, _ := uuid.Parse(userIDStr.(string))

		var balance, availableBalance string
		var currency string
		err = db.QueryRow(
			`SELECT balance, available_balance, currency
			 FROM accounts WHERE id = $1 AND user_id = $2`,
			accountID, userID,
		).Scan(&balance, &availableBalance, &currency)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Account not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"account_id":        accountID,
			"balance":           balance,
			"available_balance": availableBalance,
			"currency":          currency,
		})
	}
}

func GetTransactionsHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		accountIDStr := c.Param("id")
		accountID, err := uuid.Parse(accountIDStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid account ID"})
			return
		}

		// TODO: Implement pagination
		rows, err := db.Query(
			`SELECT id, account_id, transaction_type, amount, balance_after, description, reference_number, status, created_at
			 FROM transactions WHERE account_id = $1 ORDER BY created_at DESC LIMIT 50`,
			accountID,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}
		defer rows.Close()

		var transactions []map[string]interface{}
		for rows.Next() {
			var id, accountID uuid.UUID
			var transactionType, description, referenceNumber, status string
			var amount, balanceAfter string
			var createdAt time.Time

			err := rows.Scan(&id, &accountID, &transactionType, &amount, &balanceAfter, &description, &referenceNumber, &status, &createdAt)
			if err != nil {
				continue
			}

			transactions = append(transactions, map[string]interface{}{
				"id":               id,
				"account_id":       accountID,
				"transaction_type": transactionType,
				"amount":           amount,
				"balance_after":    balanceAfter,
				"description":      description,
				"reference_number": referenceNumber,
				"status":           status,
				"created_at":       createdAt,
			})
		}

		c.JSON(http.StatusOK, gin.H{"transactions": transactions})
	}
}

func generateAccountNumber() string {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return fmt.Sprintf("%010d", r.Intn(10000000000))
}

