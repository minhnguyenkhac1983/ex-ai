# 🔧 Backend Services - EXI Insurance Exchange

> **Microservices-based backend architecture for the EXI Insurance Exchange platform.**

## 📋 Overview

The backend directory contains a collection of microservices built with Node.js, TypeScript, and Express.js. Each service is designed to handle specific business domains and follows modern API design patterns.

## 🏗️ Architecture

```
backend/
├── 📁 api-gateway/         # API Gateway & Routing
├── 📁 user-service/        # User Management
├── 📁 policy-service/      # Policy Management
├── 📁 quote-engine/        # Quote Calculation
├── 📁 payment-service/     # Payment Processing
├── 📁 claims-service/      # Claims Management
├── 📁 notification-service/ # Notifications
└── 📁 document-service/    # Document Management
```

## 🚀 Services

### 🌐 API Gateway (`api-gateway/`)
**Central entry point for all API requests with routing, authentication, and rate limiting.**

- **Responsibilities**:
  - Request routing and load balancing
  - Authentication and authorization
  - Rate limiting and throttling
  - Request/response transformation
  - API documentation (Swagger)

- **Tech Stack**:
  - Express.js + TypeScript
  - JWT authentication
  - Rate limiting (express-rate-limit)
  - Request validation (joi)
  - Swagger documentation

### 👤 User Service (`user-service/`)
**User management, authentication, and profile management.**

- **Responsibilities**:
  - User registration and authentication
  - Profile management
  - Role and permission management
  - Session management
  - User analytics

- **Tech Stack**:
  - Express.js + TypeScript
  - PostgreSQL (users, profiles)
  - Redis (sessions, caching)
  - bcrypt (password hashing)
  - JWT (tokens)

### 📋 Policy Service (`policy-service/`)
**Insurance policy lifecycle management and underwriting.**

- **Responsibilities**:
  - Policy creation and management
  - Underwriting rules engine
  - Policy lifecycle management
  - Risk assessment
  - Policy analytics

- **Tech Stack**:
  - Express.js + TypeScript
  - PostgreSQL (policies, underwriting)
  - Redis (caching)
  - Business rules engine
  - Risk calculation algorithms

### 🧮 Quote Engine (`quote-engine/`)
**Real-time insurance quote calculation and pricing.**

- **Responsibilities**:
  - Premium calculation
  - Risk assessment
  - Pricing rules engine
  - Quote comparison
  - Rate optimization

- **Tech Stack**:
  - Express.js + TypeScript
  - PostgreSQL (quotes, rates)
  - Redis (caching)
  - Mathematical models
  - Pricing algorithms

### 💳 Payment Service (`payment-service/`)
**Payment processing and financial transactions.**

- **Responsibilities**:
  - Payment processing
  - Gateway integration
  - Transaction management
  - Refund processing
  - Financial reporting

- **Tech Stack**:
  - Express.js + TypeScript
  - PostgreSQL (transactions)
  - Payment gateways (Stripe, PayPal)
  - Encryption (AES-256)
  - PCI DSS compliance

### 📝 Claims Service (`claims-service/`)
**Claims processing and settlement management.**

- **Responsibilities**:
  - Claims intake and processing
  - Investigation management
  - Settlement calculation
  - Claims analytics
  - Fraud detection

- **Tech Stack**:
  - Express.js + TypeScript
  - PostgreSQL (claims, investigations)
  - Redis (caching)
  - Document processing
  - Fraud detection algorithms

### 📧 Notification Service (`notification-service/`)
**Multi-channel notification delivery system.**

- **Responsibilities**:
  - Email notifications
  - SMS notifications
  - Push notifications
  - Notification templates
  - Delivery tracking

- **Tech Stack**:
  - Express.js + TypeScript
  - PostgreSQL (notifications)
  - Email providers (SendGrid, AWS SES)
  - SMS providers (Twilio)
  - Push notification services

### 📄 Document Service (`document-service/`)
**Document storage, processing, and management.**

- **Responsibilities**:
  - Document storage and retrieval
  - File processing and conversion
  - Document security
  - Version control
  - Digital signatures

- **Tech Stack**:
  - Express.js + TypeScript
  - AWS S3 (storage)
  - PostgreSQL (metadata)
  - File processing libraries
  - Digital signature tools

## 🛠️ Development Setup

### Prerequisites
- Node.js 18+
- PostgreSQL 15+
- Redis 7+
- Docker & Docker Compose

### Installation

1. **Install dependencies for all services**
   ```bash
   cd backend
   npm install
   ```

2. **Set up databases**
   ```bash
   # Start PostgreSQL and Redis
   docker-compose up -d postgres redis
   
   # Run migrations
   npm run migrate
   
   # Seed initial data
   npm run seed
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start development servers**
   ```bash
   # Start all services
   npm run dev
   
   # Or start individual services
   npm run dev:api-gateway
   npm run dev:user-service
   npm run dev:policy-service
   # ... etc
   ```

### Development Commands

```bash
# Install dependencies
npm install

# Start development servers
npm run dev

# Run tests
npm run test

# Run tests with coverage
npm run test:coverage

# Run linting
npm run lint

# Run type checking
npm run type-check

# Run database migrations
npm run migrate

# Seed database
npm run seed

# Build for production
npm run build
```

## 📁 Project Structure

Each service follows a consistent structure:

```
service-name/
├── 📁 src/
│   ├── 📁 controllers/     # Request handlers
│   ├── 📁 models/          # Data models
│   ├── 📁 services/        # Business logic
│   ├── 📁 repositories/    # Data access layer
│   ├── 📁 middleware/      # Custom middleware
│   ├── 📁 routes/          # API routes
│   ├── 📁 utils/           # Utility functions
│   ├── 📁 types/           # TypeScript types
│   └── 📁 config/          # Configuration
├── 📁 migrations/          # Database migrations
├── 📁 tests/               # Test files
├── 📄 package.json
├── 📄 tsconfig.json
├── 📄 Dockerfile
└── 📄 .env.example
```

## 🔧 Configuration

### Environment Variables
```bash
# Database Configuration
DATABASE_URL=postgresql://user:password@localhost:5432/exi_db
REDIS_URL=redis://localhost:6379

# JWT Configuration
JWT_SECRET=your-jwt-secret
JWT_EXPIRES_IN=24h

# API Configuration
API_PORT=3002
API_VERSION=v1
CORS_ORIGIN=http://localhost:3000

# External Services
STRIPE_SECRET_KEY=your-stripe-secret
SENDGRID_API_KEY=your-sendgrid-key
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
AWS_S3_BUCKET=your-s3-bucket

# Monitoring
SENTRY_DSN=your-sentry-dsn
LOG_LEVEL=info
```

### Database Configuration
- **PostgreSQL**: Primary database for structured data
- **Redis**: Caching, sessions, and real-time data
- **Migrations**: Automated database schema management
- **Seeding**: Initial data population

## 🧪 Testing

### Test Strategy
- **Unit Tests**: Service and utility testing
- **Integration Tests**: API and database testing
- **E2E Tests**: Full workflow testing
- **Performance Tests**: Load and stress testing

### Running Tests
```bash
# Run all tests
npm run test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run integration tests
npm run test:integration

# Run performance tests
npm run test:performance
```

## 📊 Performance

### Optimization Techniques
- **Database Optimization**: Indexing, query optimization
- **Caching**: Redis caching for frequently accessed data
- **Connection Pooling**: Database connection management
- **Load Balancing**: Horizontal scaling support
- **Compression**: Response compression

### Performance Metrics
- **Response Time**: < 200ms for 95% of requests
- **Throughput**: > 1000 RPS per service
- **Error Rate**: < 1%
- **Availability**: > 99.9%

## 🔒 Security

### Security Measures
- **Authentication**: JWT-based authentication
- **Authorization**: Role-based access control (RBAC)
- **Input Validation**: Request validation and sanitization
- **Encryption**: Data encryption at rest and in transit
- **Rate Limiting**: API rate limiting and throttling
- **Audit Logging**: Complete request/response logging

### Security Headers
```javascript
// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN,
  credentials: true
}));
app.use(rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
}));
```

## 🚀 Deployment

### Build Process
```bash
# Build all services
npm run build

# Build individual services
npm run build:api-gateway
npm run build:user-service
npm run build:policy-service
# ... etc
```

### Docker Deployment
```bash
# Build Docker images
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Kubernetes Deployment
```bash
# Apply Kubernetes manifests
kubectl apply -f kubernetes/

# Check deployment status
kubectl get pods -n exi

# View service logs
kubectl logs -f deployment/api-gateway -n exi
```

## 📚 API Documentation

### Swagger Documentation
- **API Gateway**: http://localhost:3002/docs
- **User Service**: http://localhost:3003/docs
- **Policy Service**: http://localhost:3004/docs
- **Quote Engine**: http://localhost:3005/docs
- **Payment Service**: http://localhost:3006/docs
- **Claims Service**: http://localhost:3007/docs
- **Notification Service**: http://localhost:3008/docs
- **Document Service**: http://localhost:3009/docs

### API Standards
- **RESTful Design**: Standard REST API patterns
- **JSON Responses**: Consistent JSON response format
- **Error Handling**: Standardized error responses
- **Versioning**: API versioning strategy
- **Pagination**: Consistent pagination

## 📈 Monitoring

### Health Checks
```bash
# Health check endpoints
GET /health
GET /health/ready
GET /health/live
```

### Metrics
- **Application Metrics**: Request count, response time, error rate
- **Database Metrics**: Connection count, query performance
- **System Metrics**: CPU, memory, disk usage
- **Business Metrics**: User registrations, policy purchases

### Logging
- **Structured Logging**: JSON format logs
- **Log Levels**: Error, warn, info, debug
- **Log Aggregation**: Centralized log collection
- **Log Analysis**: Log parsing and analysis

## 🤝 Contributing

### Development Workflow
1. Create feature branch
2. Implement changes
3. Write tests
4. Update documentation
5. Submit pull request

### Code Standards
- Follow TypeScript best practices
- Use async/await for asynchronous operations
- Implement proper error handling
- Write comprehensive tests
- Follow API design patterns

## 🆘 Support

For backend-specific issues:
- 📧 **Email**: backend@exi.com
- 💬 **Slack**: #backend-team
- 📚 **Documentation**: [Backend Docs](https://docs.exi.com/backend)
- 🐛 **Issues**: [GitHub Issues](https://github.com/exi/insurance-exchange/issues)

---

**Built with ❤️ by the Backend Team**
