# API Documentation

## Base URL

- **Development**: `http://localhost:8000` (via Kong) or `http://localhost:8080` (direct)
- **Staging**: `https://api-staging.exu.vn`
- **Production**: `https://api.exu.vn`

## Authentication

Most endpoints require authentication using JWT tokens.

### Getting a Token

```bash
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "phone": "+84123456789"
  }
}
```

### Using the Token

Include the token in the Authorization header:

```
Authorization: Bearer <token>
```

## Services

### IAM Service

**Base Path**: `/api/v1`

- [Authentication API](./iam/auth.md)
- [User Management API](./iam/users.md)

### Banking Service

**Base Path**: `/api/v1/banking`

- [Accounts API](./banking/accounts.md)
- [Transactions API](./banking/transactions.md)

### Payment Service

**Base Path**: `/api/v1/payments`

- [Payment API](./payments/payments.md)

## Error Responses

All errors follow this format:

```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": {}
}
```

## Rate Limiting

- **Default**: 100 requests per minute per IP
- **Authenticated**: 1000 requests per minute per user

## Versioning

API versioning is done via URL path: `/api/v1/`, `/api/v2/`, etc.

## OpenAPI Specification

Full API specification available at:
- Swagger UI: `/api/docs`
- OpenAPI JSON: `/api/openapi.json`

