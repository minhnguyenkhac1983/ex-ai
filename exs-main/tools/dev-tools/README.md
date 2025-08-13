# Development Tools

This directory contains development tools and utilities for the Securities Exchange System.

## Available Tools

### Code Generation
- **buf**: Protobuf linting and code generation
- **openapi-generator**: OpenAPI specification to client code
- **swagger-codegen**: Swagger/OpenAPI code generation

### Testing Tools
- **k6**: Performance testing and load testing
- **postman**: API testing collections
- **jmeter**: Load testing scenarios

### Code Quality
- **sonarqube**: Code quality analysis
- **spotless**: Code formatting
- **checkstyle**: Java code style checking

### Database Tools
- **flyway**: Database migration
- **liquibase**: Database schema management
- **pgadmin**: PostgreSQL administration

### Monitoring Tools
- **grafana**: Dashboard templates
- **prometheus**: Monitoring configurations
- **jaeger**: Distributed tracing

## Usage

### Setup Development Environment
```bash
# Install required tools
./tools/dev-tools/setup-dev-env.sh

# Generate code from schemas
buf generate

# Run code quality checks
./tools/dev-tools/code-quality.sh
```

### Performance Testing
```bash
# Run load test
k6 run tools/dev-tools/k6/load-test.js

# Run stress test
k6 run tools/dev-tools/k6/stress-test.js
```

### Database Management
```bash
# Run migrations
flyway -configFiles=tools/dev-tools/flyway.conf migrate

# Generate migration
flyway -configFiles=tools/dev-tools/flyway.conf info
```

## Configuration

Each tool has its own configuration directory:
- `buf/` - Buf configuration
- `k6/` - Performance test scenarios
- `flyway/` - Database migration scripts
- `sonarqube/` - Code quality rules
- `grafana/` - Dashboard templates
