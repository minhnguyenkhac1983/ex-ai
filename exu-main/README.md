# 🏛️ Vietnam Financial Center Platform
## Universal Financial Exchange Platform

> **Comprehensive Financial Services Platform for Vietnam**  
> Microservices-based, Cloud-native, Event-driven Architecture

---

## 📋 Overview

This is a comprehensive financial services platform designed for the Vietnamese market, providing:

- 🏦 **Core Banking** - Deposits, Loans, Cards, Multi-currency
- 💰 **E-Wallet** - Mobile payments, QR payments, Bill payments
- 📈 **Securities Trading** - Stock trading, Portfolio management
- 💎 **Wealth Management** - Robo-advisory, Investment planning
- 🌍 **Remittance** - Cross-border payments
- 💳 **BNPL** - Buy Now Pay Later
- 🚢 **Trade Finance** - L/C, Guarantees, Supply chain finance
- 🔓 **Open Banking** - API platform, Developer portal
- ₿ **Crypto Exchange** - Digital asset trading
- 🛡️ **Insurance** - Policy administration, Claims
- 🤝 **P2P Lending** - Marketplace lending

---

## 🏗️ Architecture

- **Architecture**: Microservices, Event-driven, CQRS
- **Cloud**: AWS (Primary), Multi-AZ deployment
- **Container**: Kubernetes (EKS)
- **Database**: PostgreSQL, MongoDB, Redis, ClickHouse
- **Messaging**: Apache Kafka
- **API**: REST, gRPC, GraphQL

See [plan/vietnam-financial-center-tech-architecture.md](plan/vietnam-financial-center-tech-architecture.md) for complete architecture documentation.

---

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Kubernetes (minikube/k3s for local)
- Go 1.22+
- Node.js 18+
- Terraform 1.5+
- kubectl

### Local Development Setup

```bash
# Clone repository
git clone <repository-url>
cd exu

# Start local infrastructure
docker-compose up -d

# Run migrations
make migrate-up

# Start services
make dev

# Run tests
make test
```

---

## 📁 Project Structure

```
exu/
├── infrastructure/          # Infrastructure as Code
│   ├── terraform/          # Terraform configurations
│   ├── kubernetes/         # K8s manifests
│   └── helm/               # Helm charts
├── services/               # Microservices
│   ├── api-gateway/        # API Gateway (Kong)
│   ├── iam/                # Identity & Access Management
│   ├── banking/            # Core Banking Service
│   ├── payment/            # Payment Gateway
│   ├── wallet/             # E-Wallet Service
│   ├── trading/            # Securities Trading
│   └── ...                 # Other services
├── libs/                    # Shared libraries
│   ├── common/             # Common utilities
│   ├── database/           # Database clients
│   ├── messaging/          # Kafka clients
│   └── auth/               # Authentication
├── web/                     # Web frontend
│   ├── admin/              # Admin portal
│   └── customer/           # Customer portal
├── mobile/                  # Mobile apps
│   ├── ios/                # iOS app
│   └── android/            # Android app
├── scripts/                 # Utility scripts
├── docs/                    # Documentation
└── tests/                   # Integration tests
```

---

## 🛠️ Technology Stack

### Backend
- **Go** (Golang) - Primary language for microservices
- **Java** - Legacy integration, heavy processing
- **Node.js** - Real-time services, APIs
- **Python** - Data processing, ML models

### Frontend
- **Next.js** - Web applications
- **React Native** - Mobile apps
- **TypeScript** - Type safety

### Infrastructure
- **AWS** - Cloud provider
- **Kubernetes** - Container orchestration
- **Terraform** - Infrastructure as Code
- **Helm** - Kubernetes package manager

### Databases
- **PostgreSQL** - Primary transactional database
- **MongoDB** - Document storage
- **Redis** - Caching, sessions
- **ClickHouse** - Analytics

### Messaging
- **Apache Kafka** - Event streaming
- **RabbitMQ** - Message queue (legacy)

---

## 📊 Development Phases

### Phase 1: Foundation (Months 1-6) ✅ In Progress
- [x] Project structure
- [ ] Infrastructure setup
- [ ] Core platform services
- [ ] Banking module MVP
- [ ] Web & mobile apps

### Phase 2: Core Banking (Months 7-12)
- Enhanced banking features
- Production launch
- Scale to 10,000 users

### Phase 3: E-Wallet & Expansion (Months 13-18)
- E-Wallet launch
- Securities trading
- AI/ML implementation

### Phase 4: Scale & Innovation (Months 19-24)
- Multiple business lines
- Regional expansion
- Platform maturity

---

## 🧪 Testing

```bash
# Unit tests
make test-unit

# Integration tests
make test-integration

# E2E tests
make test-e2e

# All tests
make test
```

---

## 📚 Documentation

- [Architecture Documentation](plan/vietnam-financial-center-tech-architecture.md)
- [API Documentation](docs/api/)
- [Deployment Guide](docs/deployment/)
- [Development Guide](docs/development/)

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## 📄 License

Proprietary - All rights reserved

---

## 📞 Contact

For questions or support, please contact the development team.

---

**Status**: 🚧 Under Active Development  
**Version**: 0.1.0  
**Last Updated**: November 2024
