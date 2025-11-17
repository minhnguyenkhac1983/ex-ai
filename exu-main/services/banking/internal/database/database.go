package database

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

func NewConnection(databaseURL string) (*sql.DB, error) {
	db, err := sql.Open("postgres", databaseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}

	if err := db.Ping(); err != nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	return db, nil
}

func RunMigrations(db *sql.DB) error {
	migrations := []string{
		// Accounts table
		`CREATE TABLE IF NOT EXISTS accounts (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			user_id UUID NOT NULL,
			account_number VARCHAR(20) UNIQUE NOT NULL,
			account_type VARCHAR(50) NOT NULL DEFAULT 'savings',
			currency VARCHAR(3) NOT NULL DEFAULT 'VND',
			balance DECIMAL(20,2) NOT NULL DEFAULT 0,
			available_balance DECIMAL(20,2) NOT NULL DEFAULT 0,
			status VARCHAR(50) NOT NULL DEFAULT 'active',
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW()
		)`,
		
		// Transactions table
		`CREATE TABLE IF NOT EXISTS transactions (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			account_id UUID NOT NULL REFERENCES accounts(id),
			transaction_type VARCHAR(50) NOT NULL,
			amount DECIMAL(20,2) NOT NULL,
			balance_after DECIMAL(20,2) NOT NULL,
			description TEXT,
			reference_number VARCHAR(100),
			status VARCHAR(50) NOT NULL DEFAULT 'pending',
			created_at TIMESTAMP NOT NULL DEFAULT NOW()
		)`,
		
		// Transfers table
		`CREATE TABLE IF NOT EXISTS transfers (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			from_account_id UUID NOT NULL REFERENCES accounts(id),
			to_account_id UUID NOT NULL REFERENCES accounts(id),
			amount DECIMAL(20,2) NOT NULL,
			currency VARCHAR(3) NOT NULL DEFAULT 'VND',
			description TEXT,
			reference_number VARCHAR(100) UNIQUE,
			status VARCHAR(50) NOT NULL DEFAULT 'pending',
			fee DECIMAL(20,2) NOT NULL DEFAULT 0,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			completed_at TIMESTAMP
		)`,
		
		// Indexes
		`CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_accounts_account_number ON accounts(account_number)`,
		`CREATE INDEX IF NOT EXISTS idx_transactions_account_id ON transactions(account_id)`,
		`CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at)`,
		`CREATE INDEX IF NOT EXISTS idx_transfers_from_account ON transfers(from_account_id)`,
		`CREATE INDEX IF NOT EXISTS idx_transfers_to_account ON transfers(to_account_id)`,
		`CREATE INDEX IF NOT EXISTS idx_transfers_status ON transfers(status)`,
	}

	for _, migration := range migrations {
		if _, err := db.Exec(migration); err != nil {
			return fmt.Errorf("failed to run migration: %w", err)
		}
	}

	return nil
}

