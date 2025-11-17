# Banking Service - Core Banking

## Overview

Banking Service provides core banking functionality including account management, deposits, withdrawals, and transfers.

## Features

- Account creation and management
- Deposit processing
- Withdrawal processing
- Account-to-account transfers
- Balance inquiry
- Transaction history
- Multi-currency support

## API Endpoints

### Accounts

- `POST /api/v1/accounts` - Create new account
- `GET /api/v1/accounts` - List user accounts
- `GET /api/v1/accounts/:id` - Get account details
- `GET /api/v1/accounts/:id/balance` - Get account balance
- `GET /api/v1/accounts/:id/transactions` - Get account transactions

### Transactions

- `POST /api/v1/transactions/deposit` - Deposit funds
- `POST /api/v1/transactions/withdraw` - Withdraw funds
- `POST /api/v1/transactions/transfer` - Transfer between accounts
- `GET /api/v1/transactions/:id` - Get transaction details

## Development

```bash
# Run locally
go run main.go

# Run tests
go test ./...

# Build
go build -o bin/banking ./main.go
```

## Environment Variables

- `ENVIRONMENT` - Environment (development/production)
- `PORT` - Server port (default: 8081)
- `DATABASE_URL` - PostgreSQL connection string
- `IAM_SERVICE_URL` - IAM service URL for token validation

## Database Schema

- `accounts` - Bank accounts
- `transactions` - Transaction records
- `transfers` - Transfer records

## Account Types

- `savings` - Savings account
- `current` - Current/checking account

## Transaction Types

- `deposit` - Deposit transaction
- `withdrawal` - Withdrawal transaction
- `transfer_in` - Incoming transfer
- `transfer_out` - Outgoing transfer

