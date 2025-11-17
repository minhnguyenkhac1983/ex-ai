# IAM Service - Identity & Access Management

## Overview

IAM Service provides authentication and authorization for the Vietnam Financial Center Platform.

## Features

- User registration and authentication
- JWT token generation and validation
- Role-based access control (RBAC)
- Password hashing (bcrypt)
- User management

## API Endpoints

### Authentication

- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh token
- `POST /api/v1/auth/logout` - Logout user

### Users

- `GET /api/v1/users/me` - Get current user
- `PUT /api/v1/users/me` - Update current user

## Development

```bash
# Run locally
go run main.go

# Run tests
go test ./...

# Build
go build -o bin/iam ./main.go
```

## Environment Variables

- `ENVIRONMENT` - Environment (development/production)
- `PORT` - Server port (default: 8080)
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - JWT signing secret

## Database Schema

- `users` - User accounts
- `roles` - User roles
- `user_roles` - User-role mapping

