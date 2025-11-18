# EXU Financial Platform - Vietnam Financial Center

A comprehensive, production-ready financial services platform built with microservices architecture for the Vietnam Financial Center.

## 🎯 Overview

EXU Financial Platform là nền tảng tài chính toàn diện cho Trung Tâm Tài Chính Việt Nam, hỗ trợ:
- Banking operations (Ngân hàng)
- Payment processing (Thanh toán)
- Securities trading (Giao dịch chứng khoán)
- Market data streaming (Dữ liệu thị trường)
- Digital wallets (Ví điện tử)
- Identity & Access Management (Quản lý danh tính)
- Crypto Exchange (Sàn giao dịch tiền điện tử)
- Insurance (Bảo hiểm)
- P2P Lending (Cho vay ngang hàng)
- Wealth Management (Quản lý tài sản)
- Remittance (Chuyển tiền)
- BNPL (Mua trước trả sau)
- Trade Finance (Tài trợ thương mại)
- Open Banking (Ngân hàng mở)
- Và 40+ services khác

## ✨ Key Features

### Communication
- ✅ **gRPC** - High-performance inter-service communication
- ✅ **WebSocket** - Real-time market data, trading updates, notifications
- ✅ **REST APIs** - Public-facing HTTP APIs
- ✅ **GraphQL** - Flexible query interface

### Resilience Patterns
- ✅ **Circuit Breaker** - Prevents cascading failures
- ✅ **Retry** - Exponential backoff with jitter
- ✅ **Timeout** - Request timeout management
- ✅ **Bulkhead** - Resource isolation

### Distributed Patterns
- ✅ **Saga Pattern** - Distributed transaction management
- ✅ **Outbox Pattern** - Reliable event publishing
- ✅ **CQRS** - Command Query Responsibility Segregation
- ✅ **Event Sourcing** - Event-driven architecture

### Observability
- ✅ **Distributed Tracing** - OpenTelemetry with Jaeger
- ✅ **Structured Logging** - Zap with correlation IDs
- ✅ **Health Checks** - Advanced dependency checks
- ✅ **Metrics** - Prometheus integration

### Security & Management
- ✅ **mTLS** - Mutual TLS for service-to-service communication
- ✅ **API Key Management** - Secure API key handling
- ✅ **Feature Flags** - Feature toggle management
- ✅ **Distributed Caching** - Redis-based caching strategies

### Infrastructure
- ✅ **Kubernetes** - Complete K8s deployments
- ✅ **HPA** - Horizontal Pod Autoscaling for all services
- ✅ **Proxmox** - Production-ready virtualization platform
- ✅ **GitLab CI/CD** - Automated build, test, and deployment
- ✅ **API Gateway** - Kong Gateway configuration
- ✅ **Certificate Management** - cert-manager integration

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Frontend Applications                       │
│  Admin Dashboard │ Customer Portal │ Mobile App          │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│                   API Gateway (Kong)                    │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│              Core Platform Services                     │
│  Banking │ Payment │ Trading │ Market Data │ Wallet    │
│  IAM │ Notification │ API Key │ Feature Flags          │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│              Data & Infrastructure                      │
│  PostgreSQL │ MongoDB │ Redis │ Kafka │ Elasticsearch  │
└─────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Go 1.22+
- Node.js 18+
- Docker & Docker Compose
- Kubernetes cluster (for production)
- PostgreSQL 17
- Protocol Buffers compiler

### Local Development

1. **Start Infrastructure**
```bash
docker-compose up -d
```

2. **Generate gRPC Code**
```bash
# Linux/Mac
./scripts/generate-proto.sh

# Windows
.\scripts\generate-proto.ps1
```

3. **Run Services**
```bash
# Banking Service
cd services/banking && go run main.go

# Payment Service
cd services/payment && go run main.go

# Trading Service
cd services/trading && go run main.go
```

4. **Run Frontend**
```bash
# Admin Dashboard
cd web/admin && npm install && npm run dev

# Customer Portal
cd web/customer && npm install && npm run dev
```

### Kubernetes Deployment

```bash
# Apply all services
kubectl apply -k infrastructure/kubernetes/services/

# Apply HPAs
kubectl apply -k infrastructure/kubernetes/hpa/

# Apply frontend
kubectl apply -k infrastructure/kubernetes/frontend/

# Apply ingress
kubectl apply -f infrastructure/kubernetes/ingress/
```

## 📁 Project Structure

```
exu-financial-platform/                    # Vietnam Financial Center Platform
│
├── 📁 services/                          # Microservices (50+ services)
│   │
│   ├── 🔐 Core Platform Services
│   │   ├── iam/                         # Identity & Access Management
│   │   ├── kyc/                         # KYC/eKYC Service
│   │   ├── notification/                # Notification Service
│   │   ├── api-key/                     # API Key Management
│   │   ├── feature-flags/               # Feature Flags Service
│   │   ├── document/                    # Document Management
│   │   ├── workflow/                    # Workflow Engine
│   │   └── shared/                      # Shared Libraries
│   │
│   ├── 🏦 Banking & Payment Services
│   │   ├── banking/                     # Core Banking Service
│   │   ├── payment/                     # Payment Gateway
│   │   ├── wallet/                      # E-Wallet Service
│   │   ├── account/                     # Account Management
│   │   ├── transaction-engine/         # Transaction Engine
│   │   └── remittance/                  # Remittance Service
│   │
│   ├── 📈 Securities & Trading Services
│   │   ├── trading/                     # Securities Trading
│   │   ├── market-data/                 # Market Data Service
│   │   ├── portfolio/                   # Portfolio Management
│   │   ├── oms/                         # Order Management System
│   │   ├── ems/                         # Execution Management System
│   │   ├── matching-engine/             # Matching Engine
│   │   ├── clearing/                    # Clearing Service
│   │   ├── settlement/                  # Settlement Service
│   │   └── custody/                     # Custody Service
│   │
│   ├── 💰 Crypto & Digital Assets
│   │   └── crypto/                      # Crypto Exchange Service
│   │
│   ├── 🛡️ Risk & Compliance Services
│   │   ├── risk/                        # Risk Management
│   │   ├── compliance/                  # Compliance Engine
│   │   ├── aml/                         # AML Screening
│   │   ├── fraud-detection/             # Fraud Detection
│   │   └── credit-scoring/              # Credit Scoring
│   │
│   ├── 🏥 Insurance Services
│   │   ├── insurance/                   # Insurance Service
│   │   ├── actuarial/                   # Actuarial Service
│   │   └── reinsurance/                 # Reinsurance Service
│   │
│   ├── 💳 Lending & Finance Services
│   │   ├── p2p-lending/                  # P2P Lending Platform
│   │   ├── bnpl/                        # Buy Now Pay Later
│   │   └── tradefinance/                # Trade Finance
│   │
│   ├── 📊 Analytics & Reporting Services
│   │   ├── analytics/                    # Analytics Engine
│   │   ├── reporting/                   # Reporting Service
│   │   └── ml-service/                  # Machine Learning Service
│   │
│   ├── 🔧 Supporting Services
│   │   ├── wealth/                      # Wealth Management
│   │   ├── openbanking/                 # Open Banking Platform
│   │   ├── reconciliation/              # Reconciliation Service
│   │   ├── fee-calculation/             # Fee Calculation
│   │   ├── rules-engine/                # Rules Engine
│   │   ├── batch-processing/           # Batch Processing
│   │   ├── scheduler/                   # Scheduler Service
│   │   ├── ocr-service/                 # OCR Service
│   │   └── esignature/                  # E-Signature Service
│   │
│   └── 📚 Shared Libraries
│       └── shared/                      # Common libraries
│           ├── database/                 # Database utilities
│           ├── grpc/                     # gRPC clients/servers
│           ├── websocket/                # WebSocket utilities
│           ├── middleware/               # HTTP middleware
│           ├── resilience/               # Circuit breaker, retry, timeout
│           ├── saga/                     # Saga pattern
│           ├── outbox/                   # Outbox pattern
│           ├── cqrs/                     # CQRS pattern
│           ├── eventsourcing/            # Event sourcing
│           ├── cache/                     # Caching utilities
│           ├── messaging/                 # Message queue clients
│           ├── observability/             # Tracing, metrics, logging
│           ├── mtls/                     # mTLS utilities
│           └── security/                 # Security utilities
│
├── 📁 web/                               # Frontend Applications
│   ├── admin/                           # Admin Dashboard (Next.js)
│   └── customer/                        # Customer Portal (Next.js)
│
├── 📁 mobile/                           # Mobile Application
│   └── App.tsx                          # React Native App
│
├── 📁 infrastructure/                    # Infrastructure as Code
│   │
│   ├── 🚀 Kubernetes Deployments
│   │   ├── kubernetes/                  # K8s manifests (144 files)
│   │   │   ├── services/                # Service deployments
│   │   │   ├── hpa/                     # Horizontal Pod Autoscalers
│   │   │   ├── frontend/                # Frontend deployments
│   │   │   ├── ingress/                 # Ingress configurations
│   │   │   └── monitoring/              # Monitoring stack
│   │   │
│   │   ├── helm/                        # Helm charts
│   │   │   └── exu-financial/           # Main Helm chart
│   │   │
│   │   └── argocd/                      # ArgoCD applications
│   │
│   ├── 🖥️ Proxmox Infrastructure
│   │   ├── proxmox/                     # Proxmox configs
│   │   │   ├── ansible/                 # Ansible playbooks
│   │   │   │   ├── playbooks/           # Setup playbooks
│   │   │   │   ├── inventory/          # Inventory files
│   │   │   │   └── group_vars/         # Variables
│   │   │   └── scripts/                 # Deployment scripts
│   │   │       ├── create-devsecops-vms.sh    # Create DevSecOps VMs
│   │   │       ├── deploy-production.sh      # Production deployment
│   │   │       └── deploy-test-environment.sh # Test environment
│   │   │
│   │   └── terraform/                   # Terraform configs
│   │
│   ├── 🔒 Security & Certificates
│   │   ├── mtls/                        # mTLS certificates
│   │   └── kong/                        # Kong API Gateway configs
│   │
│   ├── 📊 Monitoring & Logging
│   │   ├── monitoring/                  # Prometheus, Grafana configs
│   │   └── logging/                     # Logging configs
│   │
│   ├── 🛠️ DevSecOps Tools
│   │   └── devsecops/                   # DevSecOps tools configs
│   │       ├── ansible/                  # Ansible playbooks
│   │       ├── kubernetes/               # K8s manifests
│   │       └── scripts/                 # Deployment scripts
│   │
│   ├── 🔧 Modern Tech Stack
│   │   └── modern-tech/                 # gRPC, GraphQL, WebSocket
│   │       ├── proto/                    # Protocol Buffers
│   │       └── graphql/                  # GraphQL schemas
│   │
│   └── ⚙️ Configuration
│       └── config/                      # Application configs
│
├── 📁 scripts/                          # Automation Scripts
│   ├── setup.sh / setup.ps1            # Initial setup
│   ├── generate-proto.sh                # Generate gRPC code
│   ├── deploy.sh / deploy.ps1           # Deployment scripts
│   ├── build-and-push-images.sh        # Build Docker images
│   ├── health-check.sh                  # Health check scripts
│   └── ...                              # Other utility scripts
│
├── 📁 tests/                            # Test Suites
│   ├── unit/                            # Unit tests
│   └── integration/                     # Integration tests
│
├── 📁 docs/                             # Documentation
│   ├── api/                             # API documentation
│   │   ├── openapi.yaml                 # OpenAPI spec
│   │   └── postman/                     # Postman collections
│   ├── COMPLETE_IMPLEMENTATION.md       # Implementation guide
│   ├── PRODUCTION_DEPLOYMENT_READY.md   # Deployment checklist
│   ├── PROXMOX_ENVIRONMENT.md           # Proxmox setup guide
│   ├── GITLAB_CI_CD_SETUP.md           # CI/CD setup guide
│   └── ...                              # Other documentation
│
├── 📁 plan/                             # Architecture & Planning
│   ├── vietnam-financial-center-tech-architecture.md  # Main architecture doc
│   ├── financial-center-tech.md         # Tech architecture
│   └── universal_financial_exchange.txt # Exchange architecture
│
├── 📄 Configuration Files
│   ├── docker-compose.yml               # Local development
│   ├── docker-compose.dev.yml           # Dev environment
│   ├── Makefile                         # Build automation
│   ├── go.mod                           # Go module
│   └── .gitlab-ci.yml                   # GitLab CI/CD pipeline
│
└── 📄 Documentation
    ├── README.md                        # Main README
    ├── SERVICES.md                      # Services overview
    ├── PRODUCTION_READY.md              # Production readiness
    ├── CONTRIBUTING.md                  # Contribution guide
    └── DEVELOPMENT.md                   # Development guide
```

### Service Categories

**Core Platform (8 services)**: IAM, KYC, Notification, API Key, Feature Flags, Document, Workflow, Shared

**Banking & Payment (6 services)**: Banking, Payment, Wallet, Account, Transaction Engine, Remittance

**Securities & Trading (9 services)**: Trading, Market Data, Portfolio, OMS, EMS, Matching Engine, Clearing, Settlement, Custody

**Crypto & Digital Assets (1 service)**: Crypto Exchange

**Risk & Compliance (5 services)**: Risk, Compliance, AML, Fraud Detection, Credit Scoring

**Insurance (3 services)**: Insurance, Actuarial, Reinsurance

**Lending & Finance (3 services)**: P2P Lending, BNPL, Trade Finance

**Analytics & Reporting (3 services)**: Analytics, Reporting, ML Service

**Supporting Services (8 services)**: Wealth, Open Banking, Reconciliation, Fee Calculation, Rules Engine, Batch Processing, Scheduler, OCR, E-Signature

**Total: 50+ Microservices**

## 📚 Documentation

### Core Documentation
- [Complete Implementation Guide](docs/COMPLETE_IMPLEMENTATION.md)
- [HPA Configuration](docs/HPA_COMPLETE.md)
- [mTLS, API Key, Cache, DLQ, Feature Flags](docs/MTLS_APIKEY_CACHE_DLQ_FEATURES.md)
- [Setup Guide](docs/SETUP_GUIDE.md)
- [Final Implementation Summary](docs/FINAL_IMPLEMENTATION_SUMMARY.md)
- [Services Overview](SERVICES.md)

### Infrastructure & Deployment
- [Production Deployment Ready](PRODUCTION_READY.md)
- [Proxmox Environment Guide](docs/PROXMOX_ENVIRONMENT.md)
- [Production Deployment Guide](docs/DEPLOY_PRODUCTION_PROXMOX.md)
- [GitLab CI/CD Setup](docs/GITLAB_CI_CD_SETUP.md)
- [DevSecOps VMs Creation](infrastructure/proxmox/scripts/README-DEVSECOPS-VMS.md)

### Architecture
- [Project Structure](docs/PROJECT_STRUCTURE.md) - Chi tiết cấu trúc dự án
- [Technology Stack](docs/TECHNOLOGY_STACK.md)
- [Production Architecture](docs/PRODUCTION_ARCHITECTURE.md)
- [Vietnam Financial Center Architecture](plan/vietnam-financial-center-tech-architecture.md)

## 🔧 Configuration

All services use environment variables for configuration:

```bash
# Common variables
PORT=8080
GRPC_PORT=50051
DATABASE_URL=postgres://user:pass@localhost/db
ENVIRONMENT=development
ENABLE_GRPC=true

# Redis
REDIS_URL=redis://localhost:6379

# Kafka
KAFKA_BROKERS=localhost:9092

# mTLS
MTLS_CERT_FILE=/etc/mtls/certs/client.crt
MTLS_KEY_FILE=/etc/mtls/certs/client.key
MTLS_CA_FILE=/etc/mtls/certs/ca.crt
```

## 🚀 Production Deployment

Platform đã sẵn sàng cho production deployment với GitLab CI/CD và Proxmox.

### Quick Start

1. **Setup GitLab CI/CD Variables** (xem [GitLab CI/CD Setup](docs/GITLAB_CI_CD_SETUP.md))
2. **Push to main branch** - Pipeline sẽ tự động build và test
3. **Deploy to Production** - Manual trigger từ GitLab UI

### Documentation

- [Production Deployment Ready](PRODUCTION_READY.md) - Tổng quan deployment
- [GitLab CI/CD Setup](docs/GITLAB_CI_CD_SETUP.md) - Hướng dẫn setup CI/CD
- [Production Deployment Guide](docs/DEPLOY_PRODUCTION_PROXMOX.md) - Chi tiết deployment
- [Production Checklist](docs/PRODUCTION_DEPLOYMENT_READY.md) - Checklist trước khi deploy

## 🧪 Testing

```bash
# Run unit tests
go test ./tests/unit/...

# Run integration tests
go test ./tests/integration/...

# Run all tests
make test
```

## 📊 Service Ports

| Service | HTTP | gRPC |
|---------|------|------|
| Banking | 8080 | 50051 |
| Payment | 8081 | 50054 |
| Trading | 8082 | 50052 |
| Market Data | 8083 | 50053 |
| Wallet | 8085 | 50055 |
| IAM | 8086 | 50056 |
| Notification | 8087 | - |
| API Key | 8088 | - |
| Feature Flags | 8090 | - |

## 🛠️ Technology Stack

### Backend
- **Go 1.22+** - Primary language
- **Gin** - HTTP framework
- **gRPC-Go** - gRPC framework
- **PostgreSQL 17** - Primary database
- **Redis 7.2** - Caching
- **Kafka** - Message streaming
- **MongoDB 7** - Document store

### Frontend
- **Next.js 14** - Web framework
- **React 18** - UI library
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **React Native** - Mobile framework

### Infrastructure
- **Kubernetes** - Orchestration
- **Kong** - API Gateway
- **Prometheus** - Metrics
- **Grafana** - Visualization
- **Jaeger** - Tracing
- **cert-manager** - Certificates

## 📈 Monitoring

- **Metrics**: Prometheus
- **Dashboards**: Grafana
- **Tracing**: Jaeger
- **Logging**: Structured logs with correlation IDs
- **Health Checks**: Advanced dependency checks

## 🔒 Security

- **mTLS** - Service-to-service encryption
- **API Keys** - Secure API access
- **JWT** - Authentication tokens
- **Rate Limiting** - Request throttling
- **IP Whitelisting** - Access control

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📝 License

[Your License Here]

## 🙏 Acknowledgments

Built with modern microservices patterns and best practices.

---

**Status**: ✅ Production Ready
**Version**: 1.0.0
**Last Updated**: December 2024
**Project**: Vietnam Financial Center - EXU Financial Platform
**Total Services**: 50+ microservices
**Infrastructure**: Proxmox cluster với 21 Production VMs + 21 DevSecOps VMs
