# 🏗️ SECURITIES EXCHANGE SYSTEM (EXS)

## 📋 **TỔNG QUAN DỰ ÁN**

Dự án Securities Exchange System (EXS) là một hệ thống giao dịch chứng khoán hiện đại được thiết kế theo kiến trúc hiện đại.

### 🎯 **Mục tiêu:**
- Xây dựng hệ thống giao dịch chứng khoán hiệu suất cao
- Đảm bảo tính bảo mật và tuân thủ quy định
- Hỗ trợ giao dịch real-time với độ trễ thấp
- Khả năng mở rộng và bảo trì dễ dàng

---

## 📁 **CẤU TRÚC DỰ ÁN (HIỆN TẠI - ĐÃ SCAFFOLD)**

```
exs/
├── 📁 .github/                                 # GitHub Actions workflows
│   └── 📁 workflows/
│       └── 📄 ci.yml                           # CI: buf lint + docker build
├── 📁 services/                             # Backend services (domain-based)
│   ├── 📁 matching-engine/                  # Core matching (low-latency)
│   │   ├── 📄 Dockerfile                     # Java/Maven (có sẵn)
│   │   ├── 📄 pom.xml                        # Maven configuration
│   │   ├── 📄 Makefile                       # Build/deploy commands
│   │   ├── 📄 README.md                      # Service documentation
│   │   ├── 📄 .dockerignore                  # Docker ignore rules
│   │   ├── 📄 .gitignore                     # Git ignore rules
│   │   └── 📄 .gitkeep                       # Keep empty directory
│   ├── 📁 market-data-gateway/              # Market data gateway service
│   ├── 📁 order-gateway/                     # Order gateway service
│   ├── 📁 risk-engine/                       # Risk management engine
│   ├── 📁 clearing/                          # Clearing service
│   ├── 📁 settlement-service/                # Settlement processing
│   ├── 📁 custody-service/                   # Custody management
│   ├── 📁 compliance-service/                # Compliance monitoring
│   ├── 📁 surveillance-service/              # Market surveillance
│   ├── 📁 member-service/                    # Member management
│   ├── 📁 reporting-service/                 # Reporting & analytics
│   ├── 📁 api-gateway/                       # API gateway (BFF)
│   └── 📁 data-pipeline/                     # Data processing pipeline
├── 📁 apps/                                 # UI và ứng dụng người dùng
│   ├── 📁 admin-ui/                         # Admin dashboard
│   └── 📁 trader-ui/                        # Trading platform UI
│       ├── 📄 package.json                  # React/Next.js (có sẵn)
│       └── 📄 .gitkeep                      # Keep empty directory
├── 📁 packages/                              # Thư viện dùng chung (hạn chế)
│   ├── 📁 shared-domain/                     # Shared domain models
│   ├── 📁 shared-utils/                      # Shared utilities
│   └── 📁 clients/                            # Generated from proto (Go/Java/TS)
├── 📁 proto/                                 # gRPC protobuf (schema-first)
│   └── 📁 exs/trading/v1/
│       └── 📄 trading.proto                   # Order service example
├── 📁 schemas/                               # Avro/JSON Schema cho events
├── 📁 platform/                              # Hạ tầng, GitOps, observability, security
│   ├── 📁 kubernetes/
│   │   ├── 📁 charts/
│   │   │   └── 📁 service/                    # Generic Helm chart
│   │   │       ├── 📄 Chart.yaml              # Helm chart metadata
│   │   │       ├── 📄 values.yaml             # Default values
│   │   │       └── 📁 templates/
│   │   │           ├── 📄 deployment.yaml     # K8s deployment
│   │   │           └── 📄 service.yaml        # K8s service
│   ├── 📁 argo/                              # ArgoCD configurations
│   ├── 📁 observability/                     # Monitoring & logging
│   ├── 📁 security/                          # Security policies
│   └── 📁 terraform/                         # Infrastructure as Code
├── 📁 ops/                                   # Runbooks, SRE
│   ├── 📁 runbooks/                          # Operational runbooks
│   └── 📁 sre/                               # SRE practices
├── 📁 docs/                                  # Documentation
│   └── 📁 architecture/modern-architectures.md
├── 📁 plan/                                  # Planning documents
│   ├── 📄 securities_exchanges_components.md
│   └── 📄 securities_exchange_components.md
├── 📁 scripts/                               # Utility scripts
│   ├── 📄 docker-setup.ps1                   # PowerShell setup
│   ├── 📄 docker-setup.sh                    # Bash setup
│   └── 📄 README.md                          # Scripts documentation
├── 📁 infrastructure/                        # Legacy infrastructure (sẽ di chuyển)
├── 📁 shared/                                # Tài liệu/chuẩn chung
├── 📁 thirdparty/                            # Third-party integrations
├── 📁 tools/                                 # Development tools
├── 📁 databases/                             # Database schemas & migrations
├── 📄 buf.yaml                               # Buf configuration
├── 📄 buf.gen.yaml                           # Code generation config
├── 📄 docker-compose.yml                     # Full Docker Compose
├── 📄 docker-compose.dev.yml                 # Development Docker Compose
├── 📄 DOCKER_README.md                       # Docker setup documentation
├── 📄 database_architecture.md               # Database architecture
├── 📄 database_schema.sql                    # Database schema
├── 📄 project_structure.md                   # This file
└── 📄 README.md                              # Project README
```

Ghi chú:
- **Schema-first**: `proto/` + `buf.yaml` + `buf.gen.yaml` → sinh clients (Go/Java/TS) vào `packages/clients/`
- **CI/CD**: `.github/workflows/ci.yml` - buf lint + docker build tất cả services có Dockerfile
- **Helm chart generic**: `platform/kubernetes/charts/service/` - deploy nhanh mọi service với `make helm-install`
- **Scaffold chuẩn**: Mỗi service có `.dockerignore`, `.gitignore`, `Makefile`, `README.md`, `Dockerfile` mẫu
- **Giao tiếp**: Nội bộ gRPC/Kafka; externally qua `services/api-gateway/`
- **Legacy**: `infrastructure/` sẽ di chuyển sang `platform/` khi cần

---

## 🚀 **BẮT ĐẦU NHANH**

### 📋 **Yêu cầu hệ thống:**
- Java 17+
- Node.js 18+
- Docker & Docker Compose
- Kubernetes (minikube hoặc cluster)
- PostgreSQL 15+
- Redis 7+
- buf (protobuf tooling)
- Helm 3+

### 🔧 **Cài đặt:**
```bash
# Clone repository
git clone <repository-url>
cd exs

# Install buf (protobuf tooling)
curl -sSL \
  "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" \
  -o "$HOME/.local/bin/buf" && chmod +x "$HOME/.local/bin/buf"

# Generate proto clients
buf generate

# Setup development environment
./scripts/setup-dev.sh

# Start services
docker-compose up -d

# Build and deploy a service example
cd services/matching-engine
make docker-build tag=dev
make helm-install tag=dev

# Access applications
# Trading Platform: http://localhost:3000
# Admin Dashboard: http://localhost:3001
# API Gateway: http://localhost:8080
```

### 🚀 **Quick Start với Service:**
```bash
# 1. Generate clients từ proto
buf generate

# 2. Build service image
cd services/order-gateway
make docker-build tag=dev

# 3. Deploy với Helm chart generic
make helm-install tag=dev

# 4. Kiểm tra deployment
kubectl get pods -n exs
kubectl logs -f deployment/order-gateway -n exs
```

---

## 📊 **TECHNOLOGY STACK**

### 🔧 **Backend:**
- **Languages**: Java 17+, Kotlin, Rust, C++, Go
- **Frameworks**: Spring Boot, Quarkus, Actix-web, Gin
- **APIs/Protocols**: REST, gRPC, GraphQL (Federation), tRPC, AsyncAPI
- **Databases**: PostgreSQL, Redis, ClickHouse, Cassandra
- **Streaming & Messaging**: Apache Kafka (KRaft), Redpanda, NATS JetStream, RabbitMQ, Apache Pulsar

### 🎨 **Frontend:**
- **Framework**: React 18, TypeScript, Next.js (App Router, RSC)
- **State/Data**: Redux Toolkit, Zustand, TanStack Query/SWR
- **UI Libraries**: Material-UI, Ant Design, Tailwind CSS, shadcn/ui
- **Charts**: TradingView, D3.js, Chart.js
- **Frontend Architecture**: Micro-frontend (Module Federation), BFF (Backend For Frontend)

### ☁️ **Infrastructure:**
- **Containerization**: Docker, Kubernetes
- **Service Mesh**: Istio, Linkerd (mTLS, traffic policies, canary)
- **API Gateway/Ingress**: Kong, Envoy Gateway, NGINX/Traefik, Istio GW
- **GitOps & Delivery**: ArgoCD, Argo Rollouts, Helm, Kustomize, Terraform, Crossplane
- **Cloud Platforms**: AWS, Google Cloud, Azure
- **Observability**: OpenTelemetry, Prometheus, Grafana, Loki, Tempo, Jaeger
- **Security/Supply Chain**: OPA/Gatekeeper, Kyverno, Vault/Secrets Store CSI, SPIFFE/SPIRE, Cosign (Sigstore), SBOM (CycloneDX), SLSA

---

## 🧭 **MODERN ARCHITECTURES (RECOMMENDED)**

- **Microservices + Event-Driven**: Kafka/Redpanda/NATS; AsyncAPI; schema registry; outbox pattern
- **CQRS + Event Sourcing**: Command/Query split; snapshotting; idempotent handlers
- **Saga Orchestration/Choreography**: Long-running business transactions with compensations
- **Service Mesh**: Zero-trust mTLS, traffic shaping, fault injection, retries, circuit breaker
- **API Gateway + BFF**: External APIs via gateway; per-channel BFFs for web/mobile
- **Micro-frontend**: Module Federation; independent deployability
- **Data Lakehouse & Mesh**: Apache Iceberg/Delta Lake/Hudi; data contracts; CDC with Debezium
- **Real-time Analytics**: ClickHouse/Pinot + Flink/Spark; materialized views (Materialize/RisingWave)
- **Resilience Patterns**: Retry/backoff, bulkhead, timeout, rate-limit (Resilience4j)
- **Observability by Default**: OpenTelemetry traces/metrics/logs; RED/USE dashboards, SLOs
- **Security by Design**: OIDC/OAuth2.1, FAPI, mTLS, WebAuthn/Passkeys, secrets management
- **Platform Engineering**: IDP/Backstage, golden paths, templates, scorecards
- **Edge & SSR**: CDN/edge functions; Next.js RSC; WebSocket/SSE for realtime

---

## 📈 **PERFORMANCE TARGETS**

- **Latency**: Order Processing < 1ms, Market Data < 100μs
- **Throughput**: 100,000+ orders/sec
- **Availability**: 99.99% uptime
- **Recovery**: RTO < 1 min, RPO < 1 sec

---

## 🔐 **SECURITY & COMPLIANCE**

- **Authentication**: OAuth 2.0, JWT, MFA
- **Encryption**: TLS 1.3, Encryption at rest/transit
- **Compliance**: MiFID II, Dodd-Frank, SOX, GDPR
- **Audit**: Comprehensive audit trails and logging

---

## 📞 **LIÊN HỆ**

- **Project Lead**: [Your Name]
- **Technical Lead**: [Technical Lead Name]
- **Architecture Team**: [Architecture Team]
- **DevOps Team**: [DevOps Team]
- **Security Team**: [Security Team]

---

## 📄 **TÀI LIỆU CHI TIẾT**

- [Kiến trúc hệ thống](docs/architecture/)
- [Kiến trúc hiện đại (đề xuất)](docs/architecture/modern-architectures.md)
- [API Documentation](docs/api/)
- [Hướng dẫn triển khai](docs/deployment/)
- [Quy định tuân thủ](docs/compliance/)
- [Docker Setup Guide](DOCKER_README.md)
- [Database Architecture](database_architecture.md)
- [Project Structure](project_structure.md)

---

*Dự án này tuân theo các nguyên tắc Domain-Driven Design (DDD) và Microservices Architecture để đảm bảo khả năng mở rộng, bảo trì và hiệu suất cao cho hệ thống Securities Exchange.*
