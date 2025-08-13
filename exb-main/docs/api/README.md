# API Documentation

Tài liệu API cho hệ thống ngân hàng EXB, bao gồm REST APIs, GraphQL, và Event APIs.

## 📋 **Tổng quan**

Thư mục này chứa tài liệu API chi tiết cho tất cả các services trong hệ thống:

- **OpenAPI 3.1**: REST API specifications
- **GraphQL**: GraphQL schemas và queries
- **AsyncAPI**: Event-driven API documentation
- **gRPC**: Internal service communication

## 📁 **Cấu trúc tài liệu**

```
docs/api/
├── openapi/                    # OpenAPI 3.1 specifications
│   ├── customer-service.yaml   # Customer service API
│   ├── account-service.yaml    # Account service API
│   ├── transaction-service.yaml # Transaction service API
│   └── payment-service.yaml    # Payment service API
│
├── graphql/                    # GraphQL schemas
│   ├── schema.graphql          # Main GraphQL schema
│   ├── queries.graphql         # Query definitions
│   ├── mutations.graphql       # Mutation definitions
│   └── subscriptions.graphql   # Subscription definitions
│
├── asyncapi/                   # AsyncAPI specifications
│   ├── events.yaml             # Event definitions
│   ├── commands.yaml           # Command definitions
│   └── notifications.yaml      # Notification definitions
│
└── grpc/                       # gRPC service definitions
    ├── customer.proto          # Customer service proto
    ├── account.proto           # Account service proto
    └── transaction.proto       # Transaction service proto
```

## 🛠️ **API Standards**

### REST API (OpenAPI 3.1)
- **Base URL**: `https://api.exb.com/v1`
- **Authentication**: OAuth2/OIDC
- **Content-Type**: `application/json`
- **Versioning**: URL versioning (`/v1`, `/v2`)

### GraphQL
- **Endpoint**: `https://api.exb.com/graphql`
- **Authentication**: Bearer token
- **Real-time**: WebSocket subscriptions

### Event APIs (AsyncAPI)
- **Broker**: Apache Kafka/Redpanda
- **Schema Registry**: Confluent Schema Registry
- **Format**: Avro/JSON Schema

## 📚 **API Categories**

### Core Banking APIs
- **Customer Management**: CRUD operations for customers
- **Account Management**: Account operations and balances
- **Transaction Processing**: Payment and transfer operations
- **Card Management**: Card operations and authorizations

### Lending APIs
- **Loan Management**: Loan applications and processing
- **Credit Assessment**: Credit scoring and risk analysis
- **Collection Management**: Debt collection operations

### Security APIs
- **Authentication**: OAuth2/OIDC flows
- **Authorization**: Role-based access control
- **Audit**: Audit logging and compliance

### Analytics APIs
- **Reporting**: Business intelligence and reporting
- **Analytics**: Data analytics and insights
- **ML Services**: Machine learning predictions

## 🔐 **Security & Authentication**

### OAuth2/OIDC Flow
```yaml
# OpenAPI security scheme
components:
  securitySchemes:
    oauth2:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: https://auth.exb.com/oauth/authorize
          tokenUrl: https://auth.exb.com/oauth/token
          scopes:
            read:customers: Read customer data
            write:customers: Write customer data
            read:accounts: Read account data
            write:accounts: Write account data
```

### API Keys
```yaml
# API Key authentication
components:
  securitySchemes:
    apiKey:
      type: apiKey
      in: header
      name: X-API-Key
```

## 📊 **Rate Limiting**

### Rate Limit Headers
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

### Rate Limit Policies
- **Public APIs**: 1000 requests/hour
- **Internal APIs**: 10000 requests/hour
- **Admin APIs**: 100000 requests/hour

## 🧪 **Testing**

### API Testing Tools
- **Postman**: REST API testing
- **Insomnia**: GraphQL testing
- **Kafka UI**: Event testing
- **gRPC UI**: gRPC testing

### Test Environments
- **Development**: `https://dev-api.exb.com`
- **Staging**: `https://staging-api.exb.com`
- **Production**: `https://api.exb.com`

## 📈 **Monitoring**

### API Metrics
- **Response Time**: P50, P95, P99
- **Error Rate**: 4xx, 5xx errors
- **Throughput**: Requests per second
- **Availability**: Uptime percentage

### Health Checks
- **Readiness**: `/health/ready`
- **Liveness**: `/health/live`
- **Startup**: `/health/startup`

## 📚 **Documentation Tools**

### Swagger UI
- **URL**: `https://api.exb.com/docs`
- **Interactive**: Try APIs directly
- **Authentication**: OAuth2 integration

### GraphQL Playground
- **URL**: `https://api.exb.com/graphql`
- **Interactive**: GraphQL queries
- **Documentation**: Auto-generated docs

### AsyncAPI Studio
- **URL**: `https://events.exb.com/docs`
- **Interactive**: Event documentation
- **Examples**: Event examples

## 🤝 **Contributing**

### API Design Guidelines
1. **RESTful Design**: Follow REST principles
2. **Consistent Naming**: Use consistent naming conventions
3. **Error Handling**: Standardized error responses
4. **Versioning**: Backward compatibility

### Documentation Standards
1. **OpenAPI 3.1**: Latest OpenAPI specification
2. **Examples**: Provide request/response examples
3. **Error Codes**: Document all error codes
4. **Authentication**: Clear authentication flows

---

*API documentation được thiết kế để hỗ trợ developers trong việc tích hợp và sử dụng các APIs của hệ thống ngân hàng EXB.*
