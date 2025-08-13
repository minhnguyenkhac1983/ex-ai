# API Contracts

API contracts và specifications cho hệ thống EXB.

## 📁 Cấu trúc

```
contracts/
├── openapi/           # REST API specifications
├── asyncapi/          # Event-driven API specifications
├── grpc/              # gRPC service definitions
└── pact/              # Consumer-driven contracts
```

## 🏗️ Kiến trúc

- **OpenAPI**: 3.1.0
- **AsyncAPI**: 2.6.0
- **gRPC**: Protocol Buffers 3
- **Pact**: Consumer-driven contracts
- **Validation**: Schema validation

## 📋 Thành phần chính

### OpenAPI
- REST API specifications
- Request/response schemas
- Authentication schemes
- Error handling
- API documentation

### AsyncAPI
- Event-driven APIs
- Message schemas
- Channel definitions
- Event documentation
- Streaming specifications

### gRPC
- Service definitions
- Message types
- Streaming services
- HTTP annotations
- Code generation

### Pact
- Consumer contracts
- Provider verification
- Contract testing
- Version management
- Integration testing

## 🚀 Usage

```bash
# Generate OpenAPI docs
openapi-generator generate -i openapi/customer-service.yaml -o docs/

# Validate AsyncAPI
asyncapi validate asyncapi/example.yaml

# Generate gRPC code
protoc --go_out=. --go-grpc_out=. grpc/customer.proto

# Run Pact tests
pact-verifier --provider-base-url=http://localhost:8080
```

## 📡 API Standards

### REST APIs
- HTTP methods
- Status codes
- Error responses
- Pagination
- Filtering

### Event APIs
- Event schemas
- Message headers
- Channel routing
- Event versioning
- Dead letter queues

### gRPC Services
- Service interfaces
- Message serialization
- Streaming patterns
- Error handling
- Interceptors

## 🔒 Bảo mật

- Authentication schemes
- Authorization scopes
- Rate limiting
- Input validation
- Security headers

## 📊 Documentation

- Interactive docs
- Code examples
- SDK generation
- Postman collections
- API testing

## 🔄 Versioning

- Semantic versioning
- Backward compatibility
- Deprecation policies
- Migration guides
- Version management
