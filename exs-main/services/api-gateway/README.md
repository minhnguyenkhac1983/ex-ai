# api-gateway

API Gateway and BFF for external APIs

## Quick Start

\\\ash
# Build the application
make build

# Build Docker image
make docker-build tag=dev

# Deploy with Helm
make helm-install tag=dev
\\\

## Development

This service is built with:
- **Language**: java
- **Framework**: spring-cloud-gateway
- **Architecture**: Domain-Driven Design (DDD)

## API Documentation

- REST API: http://localhost:8080/swagger-ui.html
- Health Check: http://localhost:8080/actuator/health
- Metrics: http://localhost:8080/actuator/metrics
