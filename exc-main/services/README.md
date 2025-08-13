# Backend Microservices

Thư mục này chứa các microservices backend theo Domain-Driven Design (DDD).

## Cấu trúc DDD

Mỗi service tuân theo cấu trúc DDD chuẩn:

```
service-name/
├── cmd/                    # Application entry point
│   └── main.go
├── internal/               # Private application code
│   ├── domain/             # Domain entities, aggregates, value objects
│   ├── application/        # Use cases, services, DTOs
│   ├── infrastructure/     # External adapters (DB, HTTP, gRPC)
│   └── interfaces/         # API handlers, controllers
├── pkg/                    # Public packages (shared)
├── configs/                # Configuration files
├── migrations/             # Database migrations
├── tests/                  # Unit & integration tests
├── Dockerfile
├── go.mod
└── README.md
```

## Services

### Core Trading Services
- **trading-engine/**: Core matching engine, order book management
- **market-data/**: Real-time market data feeds, WebSocket streaming
- **market-data-consumer/**: Kafka consumer for ClickHouse ingestion

### Financial Services
- **wallet/**: Wallet management, balance tracking
- **treasury/**: Treasury operations, hot/cold wallet management

### Security & Compliance
- **compliance/**: KYC/KYB, AML screening
- **risk/**: Risk management, position monitoring
- **identity/**: Authentication, authorization (skeleton)

### Supporting Services
- **notification/**: Email, SMS, push notifications (skeleton)
- **payment/**: Payment processing (skeleton)
- **reporting/**: Financial reporting (skeleton)
- **api-gateway/**: API Gateway (skeleton)

## Technology Stack

- **Language**: Go 1.22+ (primary), Node.js 20+ (market-data)
- **Framework**: Gin (Go), Express (Node.js)
- **Database**: PostgreSQL (ACID), ClickHouse (analytics)
- **Messaging**: Redpanda/Kafka
- **Observability**: Prometheus metrics, OpenTelemetry tracing

## Development

```bash
# Build all services
make build

# Run specific service
cd services/trading-engine
go run cmd/main.go

# Run with Docker
docker compose up trading-engine

# Run tests
go test ./...
```

## Service Communication

- **Synchronous**: REST APIs, gRPC
- **Asynchronous**: Event-driven via Redpanda/Kafka
- **Real-time**: WebSocket for market data

## Observability

Mỗi service expose:
- `/health` - Health check endpoint
- `/metrics` - Prometheus metrics
- Distributed tracing via OpenTelemetry