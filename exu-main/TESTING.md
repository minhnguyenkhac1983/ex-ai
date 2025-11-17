# Testing Guide

## 🧪 Quick Test Guide

### Prerequisites

1. Start infrastructure:
```bash
docker-compose up -d
```

2. Start services:
```bash
# Terminal 1
cd services/iam
go run main.go

# Terminal 2
cd services/banking
go run main.go
```

## 📋 Test Scenarios

### 1. User Registration & Authentication

```bash
# Register a new user
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "phone": "+84123456789",
    "password": "password123"
  }'

# Expected Response:
# {
#   "id": "uuid",
#   "email": "user@example.com",
#   "phone": "+84123456789"
# }

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'

# Expected Response:
# {
#   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
#   "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
#   "token_type": "Bearer",
#   "expires_in": 86400,
#   "user": {
#     "id": "uuid",
#     "email": "user@example.com",
#     "phone": "+84123456789"
#   }
# }
```

### 2. Get Current User

```bash
# Save token from login response
TOKEN="your-access-token-here"

# Get current user
curl -X GET http://localhost:8080/api/v1/users/me \
  -H "Authorization: Bearer $TOKEN"

# Expected Response:
# {
#   "id": "uuid",
#   "email": "user@example.com",
#   "phone": "+84123456789",
#   "status": "active",
#   "created_at": "2024-11-XX...",
#   "updated_at": "2024-11-XX..."
# }
```

### 3. Create Bank Account

```bash
# Create savings account
curl -X POST http://localhost:8081/api/v1/accounts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "account_type": "savings",
    "currency": "VND"
  }'

# Expected Response:
# {
#   "id": "uuid",
#   "user_id": "uuid",
#   "account_number": "1234567890",
#   "account_type": "savings",
#   "currency": "VND",
#   "balance": "0",
#   "available_balance": "0",
#   "status": "active",
#   "created_at": "2024-11-XX...",
#   "updated_at": "2024-11-XX..."
# }
```

### 4. Deposit Funds

```bash
# Save account ID from previous response
ACCOUNT_ID="your-account-id-here"

# Deposit 1,000,000 VND
curl -X POST http://localhost:8081/api/v1/transactions/deposit \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "account_id": "'$ACCOUNT_ID'",
    "amount": "1000000",
    "description": "Initial deposit"
  }'

# Expected Response:
# {
#   "transaction_id": "uuid",
#   "reference_number": "ABC12345",
#   "amount": "1000000",
#   "balance_after": "1000000",
#   "status": "completed"
# }
```

### 5. Check Balance

```bash
# Get account balance
curl -X GET http://localhost:8081/api/v1/accounts/$ACCOUNT_ID/balance \
  -H "Authorization: Bearer $TOKEN"

# Expected Response:
# {
#   "account_id": "uuid",
#   "balance": "1000000",
#   "available_balance": "1000000",
#   "currency": "VND"
# }
```

### 6. Transfer Between Accounts

```bash
# Create second account
curl -X POST http://localhost:8081/api/v1/accounts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "account_type": "current",
    "currency": "VND"
  }'

# Save second account ID
ACCOUNT_ID_2="second-account-id-here"

# Transfer 500,000 VND
curl -X POST http://localhost:8081/api/v1/transactions/transfer \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "from_account_id": "'$ACCOUNT_ID'",
    "to_account_id": "'$ACCOUNT_ID_2'",
    "amount": "500000",
    "description": "Transfer to current account"
  }'

# Expected Response:
# {
#   "transfer_id": "uuid",
#   "reference_number": "XYZ67890",
#   "amount": "500000",
#   "from_account": {
#     "id": "uuid",
#     "balance_after": "500000"
#   },
#   "to_account": {
#     "id": "uuid",
#     "balance_after": "500000"
#   },
#   "status": "completed"
# }
```

### 7. View Transaction History

```bash
# Get transactions for account
curl -X GET http://localhost:8081/api/v1/accounts/$ACCOUNT_ID/transactions \
  -H "Authorization: Bearer $TOKEN"

# Expected Response:
# {
#   "transactions": [
#     {
#       "id": "uuid",
#       "account_id": "uuid",
#       "transaction_type": "deposit",
#       "amount": "1000000",
#       "balance_after": "1000000",
#       "description": "Initial deposit",
#       "reference_number": "ABC12345",
#       "status": "completed",
#       "created_at": "2024-11-XX..."
#     },
#     {
#       "id": "uuid",
#       "account_id": "uuid",
#       "transaction_type": "transfer_out",
#       "amount": "500000",
#       "balance_after": "500000",
#       "description": "Transfer to current account",
#       "reference_number": "XYZ67890",
#       "status": "completed",
#       "created_at": "2024-11-XX..."
#     }
#   ]
# }
```

## 🔍 Health Checks

```bash
# IAM Service health
curl http://localhost:8080/api/v1/health

# Banking Service health
curl http://localhost:8081/api/v1/health
```

## 🐛 Common Issues

### Token Expired
- Error: `"Invalid or expired token"`
- Solution: Login again to get new token

### Account Not Found
- Error: `"Account not found"`
- Solution: Check account ID and ensure it belongs to authenticated user

### Insufficient Balance
- Error: `"Insufficient balance"` (when implemented)
- Solution: Deposit more funds before withdrawal/transfer

## 📊 Test Coverage

### IAM Service
- ✅ User registration
- ✅ User login
- ✅ Token refresh
- ✅ Get current user
- ✅ Update user profile
- ✅ Protected routes

### Banking Service
- ✅ Create account
- ✅ List accounts
- ✅ Get account details
- ✅ Get balance
- ✅ Deposit
- ✅ Withdraw
- ✅ Transfer
- ✅ Transaction history

## 🚀 Automated Testing

```bash
# Run unit tests
make test-unit

# Run integration tests (when implemented)
make test-integration

# Run all tests
make test
```

## 📝 Test Data

### Sample Users
- Email: `user1@example.com`, Password: `password123`
- Email: `user2@example.com`, Password: `password123`

### Sample Accounts
- Savings account: VND
- Current account: VND
- Multi-currency accounts (when implemented)

