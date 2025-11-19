# Getting Started Guide - Vietnam Financial Center Platform

Hướng dẫn bắt đầu với EXU Financial Platform cho Trung Tâm Tài Chính Việt Nam.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** & **Docker Compose** - For local infrastructure
- **Go** 1.22+ - For backend services
- **Node.js** 18+ - For frontend (optional)
- **Terraform** 1.5+ - For infrastructure (optional)
- **kubectl** - For Kubernetes (optional)

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd exu
```

### 2. Setup Environment

**Windows (PowerShell):**
```powershell
.\scripts\setup.ps1
```

**Linux/Mac:**
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

Or manually:
```bash
# Create .env file
cp .env.example .env

# Start infrastructure
docker-compose up -d
```

### 3. Verify Services

Check that all services are running:
```bash
docker-compose ps
```

You should see:
- PostgreSQL (port 5432)
- MongoDB (port 27017)
- Redis (port 6379)
- Kafka (port 9092)
- Kong API Gateway (port 8000)
- Prometheus (port 9090)
- Grafana (port 3000)

### 4. Run Migrations

```bash
make migrate-up
```

### 5. Start Services

```bash
# Start IAM service
cd services/iam
go run main.go
```

### 6. Test the API

```bash
# Register a user
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "phone": "+84123456789",
    "password": "password123"
  }'

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes**
   - Write code
   - Add tests
   - Update documentation

3. **Run tests**
   ```bash
   make test
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/my-feature
   ```

## Project Structure

```
exu/
├── services/          # 100+ Microservices
│   ├── iam/          # IAM service (example)
│   ├── banking/      # Banking service
│   ├── payment/      # Payment service
│   └── ...           # 100+ more services
├── infrastructure/    # Infrastructure as Code
├── web/              # Web frontend (7 applications)
├── mobile/           # Mobile apps (5 applications)
├── scripts/          # Utility scripts
└── docs/             # Documentation
```

> **Note**: Hệ thống bao gồm **100+ microservices** được tổ chức theo domain. Xem [Project Structure](PROJECT_STRUCTURE.md) để biết chi tiết.

## Next Steps

- **[Main README](../README.md)** - Tổng quan dự án và quick start
- **[Project Structure](PROJECT_STRUCTURE.md)** - Chi tiết cấu trúc dự án
- **[Services Overview](../SERVICES.md)** - Tổng quan các services
- **[Architecture Documentation](../plan/vietnam-financial-center-tech-architecture.md)** - Kiến trúc tổng thể
- **[API Documentation](./api/)** - API documentation và guides
- **[Production Ready](../PRODUCTION_READY.md)** - Production deployment guide

## Troubleshooting

### Services not starting

```bash
# Check logs
docker-compose logs

# Restart services
docker-compose restart
```

### Database connection issues

```bash
# Verify PostgreSQL is running
docker-compose ps postgres

# Check connection
docker-compose exec postgres psql -U exu -d exu_financial
```

### Port conflicts

If ports are already in use, modify `docker-compose.yml` to use different ports.

## Support

For issues or questions, please contact the development team.

