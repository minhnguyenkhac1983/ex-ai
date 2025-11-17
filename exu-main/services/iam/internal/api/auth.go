package api

import (
	"database/sql"
	"net/http"
	"time"

	"github.com/exu-financial/iam/internal/config"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

// GenerateTokens generates both access and refresh tokens
func GenerateTokens(userID uuid.UUID, email string, jwtSecret string) (string, string, error) {
	// Access token (24 hours)
	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID.String(),
		"email":   email,
		"type":    "access",
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
	})

	accessTokenString, err := accessToken.SignedString([]byte(jwtSecret))
	if err != nil {
		return "", "", err
	}

	// Refresh token (7 days)
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID.String(),
		"email":   email,
		"type":    "refresh",
		"exp":     time.Now().Add(time.Hour * 24 * 7).Unix(),
	})

	refreshTokenString, err := refreshToken.SignedString([]byte(jwtSecret))
	if err != nil {
		return "", "", err
	}

	return accessTokenString, refreshTokenString, nil
}

type RegisterRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Phone    string `json:"phone" binding:"required"`
	Password string `json:"password" binding:"required,min=8"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

func RegisterHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req RegisterRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Hash password
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
			return
		}

		// Create user
		userID := uuid.New()
		_, err = db.Exec(
			"INSERT INTO users (id, email, phone, password_hash) VALUES ($1, $2, $3, $4)",
			userID, req.Email, req.Phone, string(hashedPassword),
		)
		if err != nil {
			c.JSON(http.StatusConflict, gin.H{"error": "User already exists"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{
			"id":    userID,
			"email": req.Email,
			"phone": req.Phone,
		})
	}
}

func LoginHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req LoginRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Get user
		var userID uuid.UUID
		var email, phone, passwordHash string
		err := db.QueryRow(
			"SELECT id, email, phone, password_hash FROM users WHERE email = $1",
			req.Email,
		).Scan(&userID, &email, &phone, &passwordHash)
		if err == sql.ErrNoRows {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		// Verify password
		if err := bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(req.Password)); err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
			return
		}

		// Generate tokens
		cfg := config.Load()
		accessToken, refreshToken, err := GenerateTokens(userID, email, cfg.JWTSecret)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate tokens"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"access_token":  accessToken,
			"refresh_token": refreshToken,
			"token_type":    "Bearer",
			"expires_in":    86400, // 24 hours in seconds
			"user": gin.H{
				"id":    userID,
				"email": email,
				"phone": phone,
			},
		})
	}
}

func RefreshTokenHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Get refresh token from request
		var req struct {
			RefreshToken string `json:"refresh_token" binding:"required"`
		}
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Validate refresh token (simplified - should check in database)
		cfg := config.Load()
		token, err := jwt.Parse(req.RefreshToken, func(token *jwt.Token) (interface{}, error) {
			return []byte(cfg.JWTSecret), nil
		})

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid refresh token"})
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
			return
		}

		// Generate new access token
		newToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"user_id": claims["user_id"],
			"email":   claims["email"],
			"exp":     time.Now().Add(time.Hour * 24).Unix(),
		})

		tokenString, err := newToken.SignedString([]byte(cfg.JWTSecret))
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"token": tokenString,
		})
	}
}

func LogoutHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// TODO: Implement token blacklist in Redis
		// For now, just return success
		c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
	}
}

func GetCurrentUserHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, exists := c.Get("user_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
			return
		}

		// Get user from database
		var id uuid.UUID
		var email, phone, status string
		var createdAt, updatedAt time.Time

		err := db.QueryRow(
			"SELECT id, email, phone, status, created_at, updated_at FROM users WHERE id = $1",
			userID,
		).Scan(&id, &email, &phone, &status, &createdAt, &updatedAt)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"id":         id,
			"email":      email,
			"phone":      phone,
			"status":     status,
			"created_at": createdAt,
			"updated_at": updatedAt,
		})
	}
}

func GetUserHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userIDStr := c.Param("id")
		userID, err := uuid.Parse(userIDStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
			return
		}

		var id uuid.UUID
		var email, phone, status string
		var createdAt, updatedAt time.Time

		err = db.QueryRow(
			"SELECT id, email, phone, status, created_at, updated_at FROM users WHERE id = $1",
			userID,
		).Scan(&id, &email, &phone, &status, &createdAt, &updatedAt)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
			return
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"id":         id,
			"email":      email,
			"phone":      phone,
			"status":     status,
			"created_at": createdAt,
			"updated_at": updatedAt,
		})
	}
}

func UpdateCurrentUserHandler(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, exists := c.Get("user_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
			return
		}

		var req struct {
			Phone string `json:"phone"`
		}
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Update user
		_, err := db.Exec(
			"UPDATE users SET phone = $1, updated_at = NOW() WHERE id = $2",
			req.Phone, userID,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user"})
			return
		}

		// Get updated user
		var id uuid.UUID
		var email, phone, status string
		var createdAt, updatedAt time.Time

		err = db.QueryRow(
			"SELECT id, email, phone, status, created_at, updated_at FROM users WHERE id = $1",
			userID,
		).Scan(&id, &email, &phone, &status, &createdAt, &updatedAt)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"id":         id,
			"email":      email,
			"phone":      phone,
			"status":     status,
			"created_at": createdAt,
			"updated_at": updatedAt,
		})
	}
}

