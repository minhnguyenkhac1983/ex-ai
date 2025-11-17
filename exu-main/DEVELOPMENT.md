# Development Guide

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Go 1.22+ (for backend services)
- Node.js 18+ (for frontend - optional)

### Start Development Environment

```powershell
# Windows PowerShell
.\scripts\setup.ps1

# Or manually
docker-compose up -d
```

### Start Services

```bash
# Terminal 1 - IAM Service
cd services/iam
go run main.go

# Terminal 2 - Banking Service
cd services/banking
go run main.go
```

## 📝 Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b feature/my-feature
```

### 2. Make Changes

- Write code
- Add tests
- Update documentation

### 3. Test Locally

```bash
# Run unit tests
make test-unit

# Run all tests
make test

# Build services
make build
```

### 4. Commit & Push

```bash
git add .
git commit -m "feat: add new feature"
git push origin feature/my-feature
```

## 🧪 Testing

### Unit Tests

```bash
# Test IAM service
cd services/iam
go test ./...

# Test Banking service
cd services/banking
go test ./...
```

### Integration Tests

```bash
# Start test environment
docker-compose -f docker-compose.test.yml up -d

# Run integration tests
make test-integration
```

### Manual API Testing

```bash
# Register user
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","phone":"+84123456789","password":"password123"}'

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Create account (use token from login)
curl -X POST http://localhost:8081/api/v1/accounts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"account_type":"savings","currency":"VND"}'

# Deposit
curl -X POST http://localhost:8081/api/v1/transactions/deposit \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"account_id":"<account-id>","amount":"1000000","description":"Initial deposit"}'
```

## 📁 Project Structure

```
exu/
├── services/              # Microservices
│   ├── iam/              # Identity & Access Management
│   │   ├── main.go
│   │   ├── internal/
│   │   │   ├── api/      # API handlers
│   │   │   ├── config/   # Configuration
│   │   │   ├── database/ # Database layer
│   │   │   └── middleware/ # Middleware
│   │   └── Dockerfile
│   └── banking/          # Core Banking Service
│       ├── main.go
│       ├── internal/
│       │   ├── api/
│       │   ├── config/
│       │   ├── database/
│       │   └── middleware/
│       └── Dockerfile
├── infrastructure/        # Infrastructure as Code
├── docs/                  # Documentation
└── scripts/               # Utility scripts
```

## 🔧 Code Standards

### Go Code Style

- Follow [Effective Go](https://go.dev/doc/effective_go)
- Use `gofmt` for formatting
- Run `golint` before committing
- Write tests for all new code

### API Design

- RESTful conventions
- Consistent error responses
- Version APIs (`/api/v1/`)
- Use proper HTTP status codes

### Database

- Use transactions for multi-step operations
- Handle errors properly
- Use prepared statements
- Index frequently queried columns

## 🐛 Debugging

### View Logs

```bash
# Docker logs
docker-compose logs -f iam
docker-compose logs -f banking

# Service logs (if running locally)
# Logs go to stdout/stderr
```

### Database Access

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U exu -d exu_financial

# Connect to MongoDB
docker-compose exec mongodb mongosh -u exu -p exu_dev_password
```

### Debug Service

```bash
# Run with debug logging
ENVIRONMENT=development go run main.go

# Use Delve debugger
dlv debug ./main.go
```

## 📊 Monitoring

- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **Kong Admin**: http://localhost:8001

## 🔐 Security

- Never commit secrets
- Use environment variables
- Validate all inputs
- Use prepared statements (SQL injection prevention)
- Implement rate limiting
- Use HTTPS in production

## 📚 Resources

- [Go Documentation](https://go.dev/doc/)
- [Gin Framework](https://gin-gonic.com/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Architecture Documentation](../plan/vietnam-financial-center-tech-architecture.md)

## 🆘 Troubleshooting

### Services won't start

```bash
# Check if ports are in use
netstat -ano | findstr :8080
netstat -ano | findstr :8081

# Check Docker logs
docker-compose logs
```

### Database connection errors

```bash
# Verify database is running
docker-compose ps postgres

# Test connection
docker-compose exec postgres psql -U exu -d exu_financial -c "SELECT 1"
```

### Build errors

```bash
# Clean and rebuild
make clean
make build

# Update dependencies
cd services/iam && go mod tidy
cd services/banking && go mod tidy
```

## 💡 Tips

- Use `make help` to see all available commands
- Keep services running in separate terminals
- Use Postman/Insomnia for API testing
- Check logs regularly during development
- Write tests as you code

