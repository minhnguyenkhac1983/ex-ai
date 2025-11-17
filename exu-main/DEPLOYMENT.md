# 🚀 Deployment Guide

## Phase 1: Foundation - Initial Setup Complete ✅

### What Has Been Created

1. **Project Structure**
   - ✅ Microservices architecture foundation
   - ✅ IAM Service (Identity & Access Management)
   - ✅ Docker Compose for local development
   - ✅ Infrastructure monitoring (Prometheus, Grafana)
   - ✅ API Gateway (Kong)

2. **Development Environment**
   - ✅ Docker Compose setup
   - ✅ Database services (PostgreSQL, MongoDB, Redis)
   - ✅ Message queue (Kafka)
   - ✅ Monitoring stack

3. **CI/CD Foundation**
   - ✅ GitHub Actions workflow
   - ✅ Makefile for common tasks
   - ✅ Setup scripts

### Current Status

**✅ Completed:**
- Project structure
- IAM Service skeleton
- Docker Compose configuration
- Basic documentation
- CI/CD pipeline setup

**🚧 Next Steps:**
- Complete IAM service implementation
- Add Banking service
- Add Payment Gateway service
- Setup Kubernetes manifests
- Add Terraform configurations

## Quick Start

### 1. Start Infrastructure

```bash
# Windows
.\scripts\setup.ps1

# Linux/Mac
./scripts/setup.sh
```

### 2. Start IAM Service

```bash
cd services/iam
go run main.go
```

### 3. Test API

```bash
# Register user
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","phone":"+84123456789","password":"password123"}'

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## Services Status

| Service | Status | Port | Description |
|---------|--------|------|-------------|
| IAM | ✅ Ready | 8080 | Identity & Access Management |
| PostgreSQL | ✅ Ready | 5432 | Primary database |
| MongoDB | ✅ Ready | 27017 | Document storage |
| Redis | ✅ Ready | 6379 | Cache & sessions |
| Kafka | ✅ Ready | 9092 | Event streaming |
| Kong | ✅ Ready | 8000 | API Gateway |
| Prometheus | ✅ Ready | 9090 | Metrics |
| Grafana | ✅ Ready | 3000 | Dashboards |

## Next Development Tasks

### Week 1-2: Complete IAM Service
- [ ] JWT token refresh
- [ ] User profile management
- [ ] Role management
- [ ] Permission system
- [ ] Unit tests
- [ ] Integration tests

### Week 3-4: Banking Service
- [ ] Account management
- [ ] Transaction processing
- [ ] Balance management
- [ ] Integration with IAM

### Week 5-6: Payment Gateway
- [ ] Payment processing
- [ ] NAPAS integration (test)
- [ ] Transaction reconciliation

## Deployment Environments

### Development
- Local Docker Compose
- Services run in containers
- Database: PostgreSQL (local)

### Staging
- Kubernetes cluster
- AWS EKS (planned)
- Staging database

### Production
- Multi-AZ Kubernetes
- Production database
- DR site
- Monitoring & alerting

## Monitoring

- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **Kong Admin**: http://localhost:8001

## Troubleshooting

### Services won't start
```bash
docker-compose logs
docker-compose restart
```

### Database connection issues
```bash
docker-compose exec postgres psql -U exu -d exu_financial
```

### Port conflicts
Edit `docker-compose.yml` to change ports

## Support

For deployment issues, contact the DevOps team.

