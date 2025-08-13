# Gateway Services

API Gateway và Backend for Frontend (BFF) services cho hệ thống EXB.

## 📁 Cấu trúc

```
gateway/
├── api-gateway/       # API Gateway
└── bff/              # Backend for Frontend
```

## 🏗️ Kiến trúc

- **API Gateway**: Kong, NGINX, AWS API Gateway
- **BFF**: Custom backend services
- **Load Balancing**: Round-robin, least connections
- **Rate Limiting**: Token bucket, sliding window
- **Authentication**: OAuth2, JWT, API keys

## 📋 Thành phần chính

### API Gateway
- Request routing
- Load balancing
- Rate limiting
- Authentication
- Authorization

### BFF (Backend for Frontend)
- Mobile BFF
- Web BFF
- Admin BFF
- Third-party BFF
- Custom aggregations

## 🚀 Setup

```bash
# Start API Gateway
docker-compose up -d api-gateway

# Start BFF services
docker-compose up -d bff-web bff-mobile bff-admin

# Configure routes
curl -X POST http://localhost:8001/services \
  -d name=customer-service \
  -d url=http://customer-service:8080
```

## 📡 Gateway Features

### Routing
- Path-based routing
- Header-based routing
- Query parameter routing
- Service discovery
- Dynamic routing

### Security
- Authentication
- Authorization
- Rate limiting
- CORS handling
- Request validation

### Performance
- Caching
- Compression
- Connection pooling
- Circuit breaker
- Retry logic

## 🔗 BFF Patterns

### Mobile BFF
- Optimized for mobile
- Reduced payload size
- Offline support
- Push notifications
- Biometric auth

### Web BFF
- Server-side rendering
- SEO optimization
- Progressive enhancement
- Browser caching
- Analytics integration

### Admin BFF
- Administrative functions
- Bulk operations
- Reporting data
- Audit logging
- User management

## 📊 Monitoring

### Gateway Metrics
- Request rates
- Response times
- Error rates
- Throughput
- Resource usage

### BFF Metrics
- Service performance
- Cache hit rates
- Aggregation times
- Error tracking
- User experience

## 🔒 Bảo mật

### Authentication
- OAuth2/OIDC
- API keys
- JWT tokens
- Multi-factor auth
- Session management

### Authorization
- Role-based access
- Resource-based access
- API scopes
- Rate limiting
- IP whitelisting

## 📈 Performance

### Optimization
- Response caching
- Request aggregation
- Data compression
- Connection pooling
- Load balancing

### Scalability
- Horizontal scaling
- Auto-scaling
- Traffic splitting
- Geographic distribution
- CDN integration
