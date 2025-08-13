# Backend Microservices

Backend services được thiết kế theo kiến trúc microservices với Domain-Driven Design (DDD) và Hexagonal Architecture.

## 🏗️ **Kiến trúc**

- **Domain-Driven Design (DDD)**: Tách biệt domain logic khỏi framework
- **Hexagonal/Clean Architecture**: Dễ kiểm thử và thay thế công nghệ
- **Event-Driven**: Outbox Pattern + Debezium CDC
- **API-First**: OpenAPI 3.1, gRPC, AsyncAPI

## 📁 **Cấu trúc thư mục**

```
backend/
├── core-banking/              # Core banking services
│   ├── customer-service/      # Quản lý khách hàng
│   ├── account-service/       # Quản lý tài khoản
│   ├── transaction-service/   # Xử lý giao dịch
│   └── payment-service/       # Thanh toán
│
├── lending/                   # Dịch vụ cho vay
│   ├── loan-service/          # Quản lý khoản vay
│   ├── credit-assessment/     # Đánh giá tín dụng
│   └── collection-service/    # Thu hồi nợ
│
├── cards/                     # Dịch vụ thẻ
│   ├── card-service/          # Quản lý thẻ
│   ├── atm-service/           # Dịch vụ ATM
│   └── authorization-service/ # Ủy quyền giao dịch
│
├── security/                  # Dịch vụ bảo mật
│   ├── auth-service/          # Xác thực & phân quyền
│   ├── encryption-service/    # Mã hóa dữ liệu
│   └── audit-service/         # Kiểm toán
│
├── analytics/                 # Dịch vụ phân tích
│   ├── data-warehouse/        # Kho dữ liệu
│   ├── reporting-service/     # Báo cáo
│   └── ml-service/            # Machine Learning
│
└── shared/                    # Thư viện dùng chung
    ├── common/                # Common utilities
    ├── utils/                 # Utility functions
    └── models/                # Shared models
```

## 🛠️ **Technology Stack**

### Core Services
- **Java 21 + Spring Boot 3.3**: Virtual Threads, AOT/GraalVM
- **Go 1.22**: High-performance services
- **Node.js 20/22 + NestJS**: API/BFF services

### Database
- **PostgreSQL 16/17**: Primary database (pgvector for RAG)
- **Redis 7.2**: Cache, session, rate limiting
- **ClickHouse 24.x**: Analytics, OLAP

### Event Streaming
- **Kafka 3.6+/Redpanda**: Event streaming
- **Debezium**: Change Data Capture (CDC)
- **Schema Registry**: Event schema management

### Observability
- **OpenTelemetry**: Distributed tracing
- **Micrometer**: Metrics collection
- **Structured logging**: JSON logs

## 🚀 **Development**

### Prerequisites
- Java 21+
- Go 1.22+
- Node.js 20+
- Docker & Docker Compose

### Local Development
```bash
# Start infrastructure services
docker-compose up -d postgres redis kafka

# Run customer-service
cd backend/core-banking/customer-service
./gradlew bootRun

# Run account-service
cd backend/core-banking/account-service
./gradlew bootRun
```

### Testing
- **Unit Tests**: JUnit 5, Testcontainers
- **Integration Tests**: Spring Boot Test
- **Contract Tests**: Pact
- **Performance Tests**: k6, Gatling

## 📋 **API Documentation**

- **OpenAPI 3.1**: REST API documentation
- **AsyncAPI**: Event documentation
- **gRPC**: Internal service communication

## 🔐 **Security**

- **OAuth2/OIDC**: Authentication & Authorization
- **mTLS**: Service-to-service encryption
- **OPA/Gatekeeper**: Policy enforcement
- **Audit Logging**: Compliance & security

## 📊 **Monitoring**

- **Health Checks**: Spring Boot Actuator
- **Metrics**: Prometheus endpoints
- **Tracing**: OpenTelemetry integration
- **Logging**: Structured JSON logs
