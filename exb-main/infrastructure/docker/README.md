# Docker Infrastructure

Docker configuration và containerization cho hệ thống EXB.

## 📁 Cấu trúc

```
docker/
├── dockerfiles/        # Dockerfile definitions
├── compose/           # Docker Compose files
└── registry/          # Container registry configs
```

## 🏗️ Kiến trúc

- **Docker**: 26.x+
- **Docker Compose**: 2.x+
- **Container Registry**: Docker Hub, AWS ECR, Azure ACR
- **Multi-stage Builds**: Optimization
- **Security**: Image scanning, SBOM

## 📋 Thành phần chính

### Dockerfiles
- Microservices containers
- Database containers
- Monitoring containers
- Base images
- Development images

### Compose Files
- Development environment
- Testing environment
- Local deployment
- Service orchestration
- Volume management

### Registry
- Image repositories
- Access control
- Image scanning
- Vulnerability management
- Image signing

## 🚀 Build & Deploy

```bash
# Build images
docker build -t exb/customer-service .

# Run with Compose
docker-compose up -d

# Push to registry
docker push exb/customer-service:latest

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 .
```

## 📦 Images

### Backend Services
- customer-service:latest
- account-service:latest
- transaction-service:latest
- payment-service:latest

### Frontend Applications
- web-app:latest
- admin-dashboard:latest
- mobile-app:latest

### Infrastructure
- postgresql:16
- redis:7.2
- kafka:3.6
- prometheus:latest

## 📊 Monitoring

- Container metrics
- Resource utilization
- Image vulnerabilities
- Build performance
- Registry usage

## 🔒 Bảo mật

- Image scanning
- SBOM generation
- Image signing
- Access control
- Vulnerability management

## 🚀 Performance

- Multi-stage builds
- Layer caching
- Image optimization
- Size reduction
- Build speed optimization
