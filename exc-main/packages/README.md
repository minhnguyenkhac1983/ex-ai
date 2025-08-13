# Monorepo Packages

Thư mục này chứa các shared packages được sử dụng across toàn bộ monorepo.

## Cấu trúc

```
packages/
├── domain/              # Domain entities, aggregates, value objects
├── application/         # Use cases, services, DTOs
├── shared-kernel/       # Shared types, errors, utilities
├── adapters/            # External adapters (DB, HTTP, gRPC)
├── contracts/           # OpenAPI/gRPC/AsyncAPI contracts
├── config/              # Configuration schemas
└── observability/       # Tracing, metrics, logging
```

## Package Types

### Domain Layer
- **domain/**: Core business logic, entities, aggregates
- **shared-kernel/**: Shared domain concepts across bounded contexts

### Application Layer
- **application/**: Use cases, application services, DTOs
- **contracts/**: API contracts, OpenAPI specs, gRPC protos

### Infrastructure Layer
- **adapters/**: Database, HTTP client, message queue adapters
- **config/**: Configuration management, environment schemas
- **observability/**: Cross-cutting concerns (logging, metrics, tracing)

## Development

```bash
# Install dependencies
pnpm install

# Build packages
pnpm build

# Run tests
pnpm test

# Publish packages (if needed)
pnpm publish
```

## Package Dependencies

```
domain/ ← application/ ← adapters/
  ↑           ↑            ↑
shared-kernel/ ← contracts/ ← config/
  ↑
observability/
```

## Usage

Các packages này được sử dụng bởi:
- Backend services (Go/Node.js)
- Frontend applications (Next.js/React Native)
- Infrastructure components
- Testing frameworks
