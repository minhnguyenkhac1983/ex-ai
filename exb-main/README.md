# 🏦 EXB - Exchange of Banking

Hệ thống ngân hàng hiện đại với kiến trúc hiện đại.

## 🏗️ **Kiến trúc hiện đại**

- **MACH Architecture**: Microservices, API-first, Cloud-native, Headless
- **Domain-Driven Design (DDD)**: Hexagonal/Clean Architecture
- **Event-Driven Architecture (EDA)**: CQRS/ES, Saga Pattern, Outbox + Debezium CDC
- **Zero-Trust Security**: mTLS, OIDC/OAuth2, OPA/Gatekeeper/Kyverno
- **Observability by Design**: OpenTelemetry, Prometheus/Loki/Tempo, Grafana
- **GitOps & Progressive Delivery**: Argo CD/FluxCD, Argo Rollouts

## 📁 **Cấu trúc dự án**

```
exb/
├── 📁 docs/                    # Tài liệu dự án
│   ├── architecture/           # Kiến trúc, sơ đồ C4
│   ├── adr/                    # Architecture Decision Records
│   ├── api/                    # OpenAPI/GraphQL/AsyncAPI
│   ├── database/               # Schema, migration
│   └── deployment/             # Hướng dẫn triển khai
│
├── 📁 contracts/               # Contract-first development
│   ├── openapi/                # REST contracts (OpenAPI 3.1)
│   ├── asyncapi/               # Event contracts (AsyncAPI)
│   ├── grpc/                   # .proto files
│   └── pact/                   # Consumer-Driven Contracts
│
├── 📁 infrastructure/          # IaC & Platform
│   ├── terraform/              # Terraform modules
│   ├── kubernetes/             # K8s manifests/Kustomize/Helm
│   ├── gitops/                 # Argo CD/FluxCD apps
│   ├── docker/                 # Dockerfiles, compose
│   └── scripts/                # Automation scripts
│
├── 📁 platform/                # Developer Platform (Backstage)
│   └── backstage/
│
├── 📁 gateway/                 # API Gateway & BFF
│   ├── api-gateway/            # Kong/Envoy/Nginx configs
│   └── bff/                    # Backend for Frontend
│
├── 📁 backend/                 # Backend Microservices
│   ├── core-banking/           # Core banking services
│   ├── lending/                # Lending services
│   ├── cards/                  # Card services
│   ├── security/               # Security services
│   ├── analytics/              # Analytics services
│   └── shared/                 # Shared libraries
│
├── 📁 frontend/                # Ứng dụng giao diện
│   ├── web-app/                # Next.js/React RSC
│   ├── admin-dashboard/        # Admin dashboard
│   └── mobile-app/             # React Native/Flutter
│
├── 📁 databases/               # CSDL & di trú dữ liệu
│   ├── postgresql/             # PostgreSQL schemas
│   ├── redis/                  # Redis configs
│   ├── clickhouse/             # ClickHouse configs
│   └── migrations/             # Database migrations
│
├── 📁 events/                  # Event definitions
│   ├── schemas/                # Avro/JSON Schema
│   └── configs/                # Kafka/Redpanda configs
│
├── 📁 ai-ml/                   # AI/ML & LLMOps
│   ├── rag/                    # Retrieval-Augmented Generation
│   ├── models/                 # ML models
│   ├── serving/                # Model serving
│   ├── feature-store/          # Feature store
│   └── evaluation/             # Model evaluation
│
├── 📁 observability/           # Observability stack
│   ├── prometheus/             # Metrics collection
│   ├── grafana/                # Dashboards & visualization
│   ├── loki/                   # Log aggregation
│   ├── tempo/                  # Distributed tracing
│   └── otel-collector/         # OpenTelemetry collector
│
├── 📁 monitoring/              # Legacy monitoring (ELK/Jaeger)
│   ├── prometheus/
│   ├── grafana/
│   ├── jaeger/
│   └── elk/
│
├── 📁 testing/                 # Testing strategy
│   ├── unit-tests/             # Unit tests
│   ├── integration-tests/      # Integration tests
│   ├── contract-tests/         # Contract tests (Pact)
│   ├── e2e-tests/              # End-to-end tests
│   └── performance-tests/      # Performance tests (k6/Gatling)
│
├── 📁 ci-cd/                   # CI/CD pipelines
│   ├── github-actions/         # GitHub Actions workflows
│   ├── gitlab-ci/              # GitLab CI/CD
│   └── jenkins/                # Jenkins pipelines
│
├── 📁 thirdparty/              # Third-party integrations
│
├── 📁 plan/                    # Planning documents
│
├── 📄 docker-compose.yml       # Development environment
├── 📄 docker-compose.redpanda.yml # Redpanda alternative
├── 📄 docker-compose.prod.yml  # Production baseline
├── 📄 Makefile                 # Build/dev commands
├── 📄 project_structure.md     # Detailed project structure
└── 📄 database_architecture.md # Database architecture
```

## 🚀 **Quick Start**

### Prerequisites
- Docker & Docker Compose
- Java 21+ (for Spring Boot services)
- Node.js 20+ (for frontend/BFF)
- Go 1.22+ (for Go services)

### Development Setup
```bash
# Clone repository
git clone <repository-url>
cd exb

# Start development environment
docker-compose up -d

# Access services
# - API Gateway: http://localhost:80
# - Customer Service: http://localhost:8080
# - Grafana: http://localhost:3000
# - Keycloak: http://localhost:8085
# - Debezium UI: http://localhost:8088
```

## 📚 **Documentation**

- **Architecture**: [docs/architecture/](docs/architecture/)
- **ADRs**: [docs/adr/](docs/adr/)
- **Project Structure**: [project_structure.md](project_structure.md)
- **Database Architecture**: [database_architecture.md](database_architecture.md)

## 🛠️ **Technology Stack (2025)**

### Backend
- **Java 21 + Spring Boot 3.3** (Virtual Threads, AOT/GraalVM)
- **Go 1.22** (high-performance services)
- **Node.js 20/22 + NestJS** (API/BFF)
- **Python 3.11/3.12 + FastAPI** (AI/ML & batch)

### Frontend
- **Next.js 14/15** (React 18+, RSC, Server Actions)
- **React Native** / **Flutter** (mobile)
- **Tailwind CSS** + **shadcn/ui**

### Data & Events
- **PostgreSQL 16/17** (pgvector for RAG)
- **Redis 7.2** (cache, streams)
- **ClickHouse 24.x** (OLAP)
- **Kafka 3.6+/Redpanda** (event streaming)
- **Debezium** (CDC)

### Observability
- **OpenTelemetry** (traces/metrics/logs)
- **Prometheus** + **Grafana** (metrics)
- **Loki** + **Tempo** (logs/traces)

### Security
- **Keycloak** (OIDC/OAuth2)
- **mTLS** (service-to-service)
- **OPA/Gatekeeper/Kyverno** (policy)
- **Vault** + **HSM** (secrets/keys)

### Infrastructure
- **Kubernetes 1.29+**
- **Argo CD/FluxCD** (GitOps)
- **Argo Rollouts** (progressive delivery)
- **Istio/Linkerd** (service mesh)

## 🎯 **Key Features**

- **Microservices Architecture**: Domain-driven, independently deployable
- **Event-Driven**: Reliable event publishing with Outbox + CDC
- **API-First**: OpenAPI 3.1, GraphQL, AsyncAPI
- **Security by Design**: Zero-trust, compliance-ready
- **Observability**: End-to-end tracing, SLO/Error Budget
- **DevOps**: GitOps, progressive delivery, automated testing

## 📋 **Development Workflow**

1. **Contract-First**: Define APIs with OpenAPI/AsyncAPI
2. **TDD**: Write tests first, implement features
3. **CI/CD**: Automated testing, security scanning, deployment
4. **Monitoring**: SLO tracking, alerting, incident response

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Follow coding standards and testing requirements
4. Submit a pull request

## 📄 **License**

[License information]

---

*Hệ thống ngân hàng hiện đại với khả năng mở rộng cao, bảo mật mạnh mẽ và tuân thủ các quy định tài chính.*
