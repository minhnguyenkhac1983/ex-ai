package config

import (
	"os"
)

type Config struct {
	Environment string
	Port        string
	DatabaseURL string
	IAMServiceURL string
}

func Load() *Config {
	return &Config{
		Environment:   getEnv("ENVIRONMENT", "development"),
		Port:          getEnv("PORT", "8081"),
		DatabaseURL:   getEnv("DATABASE_URL", "postgres://exu:exu_dev_password@localhost:5432/exu_financial?sslmode=disable"),
		IAMServiceURL: getEnv("IAM_SERVICE_URL", "http://localhost:8080"),
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

