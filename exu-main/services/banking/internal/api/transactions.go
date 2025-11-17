package api

import (
	"database/sql"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type DepositRequest struct {
	AccountID uuid.UUID `json:"account_id" binding:"required"`
	Amount    string    `json:"amount" binding:"required"`
	Description string  `json:"description"`
}

type WithdrawRequest struct {
	AccountID uuid.UUID `json:"account_id" binding:"required"`
	Amount    string    `json:"amount" binding:"required"`
	Description string  `json:"description"`
}

type TransferRequest struct {
	FromAccountID uuid.UUID `json:"from_account_id" binding:"required"`
	ToAccountID   uuid.UUID `json:"to_account_id" binding:"required"`
	Amount         string    `json:"amount" binding:"required"`
	Description    string    `json:"description"`
}

func DepositHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req DepositRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Start transaction
		tx, err := db.Begin()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to start transaction"})
			return
		}
		defer tx.Rollback()

		// Update account balance
		var newBalance string
		err = tx.QueryRow(
			`UPDATE accounts 
			 SET balance = balance + $1, available_balance = available_balance + $1, updated_at = NOW()
			 WHERE id = $2
			 RETURNING balance`,
			req.Amount, req.AccountID,
		).Scan(&newBalance)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Account not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update balance"})
			return
		}

		// Create transaction record
		transactionID := uuid.New()
		referenceNumber := generateReferenceNumber()
		_, err = tx.Exec(
			`INSERT INTO transactions (id, account_id, transaction_type, amount, balance_after, description, reference_number, status)
			 VALUES ($1, $2, 'deposit', $3, $4, $5, $6, 'completed')`,
			transactionID, req.AccountID, req.Amount, newBalance, req.Description, referenceNumber,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create transaction"})
			return
		}

		// Commit transaction
		if err = tx.Commit(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to commit transaction"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"transaction_id":   transactionID,
			"reference_number": referenceNumber,
			"amount":           req.Amount,
			"balance_after":    newBalance,
			"status":           "completed",
		})
	}
}

func WithdrawHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req WithdrawRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Start transaction
		tx, err := db.Begin()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to start transaction"})
			return
		}
		defer tx.Rollback()

		// Check balance
		var currentBalance string
		err = tx.QueryRow(
			`SELECT available_balance FROM accounts WHERE id = $1 FOR UPDATE`,
			req.AccountID,
		).Scan(&currentBalance)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Account not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		// TODO: Compare amounts (convert to decimal)
		// For now, assume validation passed

		// Update account balance
		var newBalance string
		err = tx.QueryRow(
			`UPDATE accounts 
			 SET balance = balance - $1, available_balance = available_balance - $1, updated_at = NOW()
			 WHERE id = $2
			 RETURNING balance`,
			req.Amount, req.AccountID,
		).Scan(&newBalance)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update balance"})
			return
		}

		// Create transaction record
		transactionID := uuid.New()
		referenceNumber := generateReferenceNumber()
		_, err = tx.Exec(
			`INSERT INTO transactions (id, account_id, transaction_type, amount, balance_after, description, reference_number, status)
			 VALUES ($1, $2, 'withdrawal', $3, $4, $5, $6, 'completed')`,
			transactionID, req.AccountID, req.Amount, newBalance, req.Description, referenceNumber,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create transaction"})
			return
		}

		// Commit transaction
		if err = tx.Commit(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to commit transaction"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"transaction_id":   transactionID,
			"reference_number": referenceNumber,
			"amount":           req.Amount,
			"balance_after":    newBalance,
			"status":           "completed",
		})
	}
}

func TransferHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req TransferRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Start transaction
		tx, err := db.Begin()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to start transaction"})
			return
		}
		defer tx.Rollback()

		// Check from account balance
		var fromBalance string
		err = tx.QueryRow(
			`SELECT available_balance FROM accounts WHERE id = $1 FOR UPDATE`,
			req.FromAccountID,
		).Scan(&fromBalance)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "From account not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		// TODO: Validate balance sufficient

		// Update from account
		var fromNewBalance string
		err = tx.QueryRow(
			`UPDATE accounts 
			 SET balance = balance - $1, available_balance = available_balance - $1, updated_at = NOW()
			 WHERE id = $2
			 RETURNING balance`,
			req.Amount, req.FromAccountID,
		).Scan(&fromNewBalance)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update from account"})
			return
		}

		// Update to account
		var toNewBalance string
		err = tx.QueryRow(
			`UPDATE accounts 
			 SET balance = balance + $1, available_balance = available_balance + $1, updated_at = NOW()
			 WHERE id = $2
			 RETURNING balance`,
			req.Amount, req.ToAccountID,
		).Scan(&toNewBalance)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "To account not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update to account"})
			return
		}

		// Create transfer record
		transferID := uuid.New()
		referenceNumber := generateReferenceNumber()
		_, err = tx.Exec(
			`INSERT INTO transfers (id, from_account_id, to_account_id, amount, description, reference_number, status, completed_at)
			 VALUES ($1, $2, $3, $4, $5, $6, 'completed', NOW())`,
			transferID, req.FromAccountID, req.ToAccountID, req.Amount, req.Description, referenceNumber,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create transfer"})
			return
		}

		// Create transaction records for both accounts
		fromTransactionID := uuid.New()
		_, err = tx.Exec(
			`INSERT INTO transactions (id, account_id, transaction_type, amount, balance_after, description, reference_number, status)
			 VALUES ($1, $2, 'transfer_out', $3, $4, $5, $6, 'completed')`,
			fromTransactionID, req.FromAccountID, req.Amount, fromNewBalance, req.Description, referenceNumber,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create transaction"})
			return
		}

		toTransactionID := uuid.New()
		_, err = tx.Exec(
			`INSERT INTO transactions (id, account_id, transaction_type, amount, balance_after, description, reference_number, status)
			 VALUES ($1, $2, 'transfer_in', $3, $4, $5, $6, 'completed')`,
			toTransactionID, req.ToAccountID, req.Amount, toNewBalance, req.Description, referenceNumber,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create transaction"})
			return
		}

		// Commit transaction
		if err = tx.Commit(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to commit transaction"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"transfer_id":      transferID,
			"reference_number": referenceNumber,
			"amount":           req.Amount,
			"from_account": gin.H{
				"id":            req.FromAccountID,
				"balance_after": fromNewBalance,
			},
			"to_account": gin.H{
				"id":            req.ToAccountID,
				"balance_after": toNewBalance,
			},
			"status": "completed",
		})
	}
}

func GetTransactionHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		transactionIDStr := c.Param("id")
		transactionID, err := uuid.Parse(transactionIDStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid transaction ID"})
			return
		}

		var id, accountID uuid.UUID
		var transactionType, amount, balanceAfter, description, referenceNumber, status string
		var createdAt time.Time

		err = db.QueryRow(
			`SELECT id, account_id, transaction_type, amount, balance_after, description, reference_number, status, created_at
			 FROM transactions WHERE id = $1`,
			transactionID,
		).Scan(&id, &accountID, &transactionType, &amount, &balanceAfter, &description, &referenceNumber, &status, &createdAt)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Transaction not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
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
}

func generateReferenceNumber() string {
	id := uuid.New().String()
	if len(id) >= 8 {
		return id[:8]
	}
	return id
}

