# EXI Insurance Exchange - Project Structure

## 📁 Complete Directory Structure

```
exi/
├── 📄 README.md                           # Main project documentation
├── 📄 docker-compose.yml                  # Complete development environment
├── 📄 .env.example                        # Environment variables template
├── 📄 .gitignore                          # Git ignore rules
│
├── 📁 backend/                            # Backend microservices
│   ├── 📁 api-gateway/                    # API Gateway service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   ├── 📄 tsconfig.json
│   │   └── 📁 src/
│   │       ├── 📄 index.ts                # Main entry point
│   │       ├── 📁 middleware/             # Express middleware
│   │       │   ├── 📄 auth.ts             # Authentication middleware
│   │       │   ├── 📄 errorHandler.ts     # Error handling
│   │       │   └── 📄 requestLogger.ts    # Request logging
│   │       ├── 📁 routes/                 # API routes
│   │       │   └── 📄 health.ts           # Health check endpoint
│   │       ├── 📁 utils/                  # Utility functions
│   │       │   └── 📄 logger.ts           # Winston logger
│   │       └── 📁 config/                 # Configuration files
│   │           └── 📄 swagger.ts          # API documentation config
│   │
│   ├── 📁 user-service/                   # User management service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   ├── 📄 tsconfig.json
│   │   └── 📁 src/
│   │       ├── 📄 index.ts                # Main entry point
│   │       ├── 📁 controllers/            # Business logic controllers
│   │       │   ├── 📄 AuthController.ts   # Authentication logic
│   │       │   └── 📄 UserController.ts   # User management logic
│   │       ├── 📁 models/                 # Data models
│   │       │   └── 📄 User.ts             # User model
│   │       ├── 📁 routes/                 # API routes
│   │       │   ├── 📄 auth.ts             # Authentication routes
│   │       │   ├── 📄 users.ts            # User management routes
│   │       │   └── 📄 admin.ts            # Admin routes
│   │       ├── 📁 services/               # Business services
│   │       │   ├── 📄 AuthService.ts      # Authentication service
│   │       │   ├── 📄 UserService.ts      # User management service
│   │       │   └── 📄 EmailService.ts     # Email service
│   │       ├── 📁 middleware/             # Express middleware
│   │       │   ├── 📄 validation.ts       # Request validation
│   │       │   ├── 📄 auth.ts             # Authentication
│   │       │   └── 📄 errorHandler.ts     # Error handling
│   │       ├── 📁 utils/                  # Utility functions
│   │       │   ├── 📄 logger.ts           # Winston logger
│   │       │   ├── 📄 bcrypt.ts           # Password hashing
│   │       │   └── 📄 jwt.ts              # JWT utilities
│   │       └── 📁 config/                 # Configuration files
│   │           ├── 📄 database.ts         # Database configuration
│   │           └── 📄 redis.ts            # Redis configuration
│   │
│   ├── 📁 policy-service/                 # Policy management service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📄 index.ts
│   │       ├── 📁 controllers/
│   │       │   ├── 📄 PolicyController.ts
│   │       │   └── 📄 ProductController.ts
│   │       ├── 📁 models/
│   │       │   ├── 📄 Policy.ts
│   │       │   └── 📄 Product.ts
│   │       ├── 📁 routes/
│   │       │   ├── 📄 policies.ts
│   │       │   └── 📄 products.ts
│   │       └── 📁 services/
│   │           ├── 📄 PolicyService.ts
│   │           └── 📄 ProductService.ts
│   │
│   ├── 📁 quote-engine/                   # Quote calculation service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📄 index.ts
│   │       ├── 📁 controllers/
│   │       │   └── 📄 QuoteController.ts
│   │       ├── 📁 models/
│   │       │   └── 📄 Quote.ts
│   │       ├── 📁 routes/
│   │       │   └── 📄 quotes.ts
│   │       └── 📁 services/
│   │           ├── 📄 QuoteService.ts
│   │           └── 📄 PricingEngine.ts
│   │
│   ├── 📁 payment-service/                # Payment processing service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📄 index.ts
│   │       ├── 📁 controllers/
│   │       │   └── 📄 PaymentController.ts
│   │       ├── 📁 models/
│   │       │   └── 📄 Payment.ts
│   │       ├── 📁 routes/
│   │       │   └── 📄 payments.ts
│   │       └── 📁 services/
│   │           ├── 📄 PaymentService.ts
│   │           ├── 📄 StripeService.ts
│   │           └── 📄 PayPalService.ts
│   │
│   ├── 📁 claims-service/                 # Claims management service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📄 index.ts
│   │       ├── 📁 controllers/
│   │       │   └── 📄 ClaimsController.ts
│   │       ├── 📁 models/
│   │       │   └── 📄 Claim.ts
│   │       ├── 📁 routes/
│   │       │   └── 📄 claims.ts
│   │       └── 📁 services/
│   │           ├── 📄 ClaimsService.ts
│   │           └── 📄 ClaimsProcessor.ts
│   │
│   ├── 📁 notification-service/           # Notification service
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📄 index.ts
│   │       ├── 📁 controllers/
│   │       │   └── 📄 NotificationController.ts
│   │       ├── 📁 models/
│   │       │   └── 📄 Notification.ts
│   │       ├── 📁 routes/
│   │       │   └── 📄 notifications.ts
│   │       └── 📁 services/
│   │           ├── 📄 NotificationService.ts
│   │           ├── 📄 EmailService.ts
│   │           ├── 📄 SMSService.ts
│   │           └── 📄 PushService.ts
│   │
│   └── 📁 document-service/               # Document management service
│       ├── 📄 package.json
│       ├── 📄 Dockerfile
│       └── 📁 src/
│           ├── 📄 index.ts
│           ├── 📁 controllers/
│           │   └── 📄 DocumentController.ts
│           ├── 📁 models/
│           │   └── 📄 Document.ts
│           ├── 📁 routes/
│           │   └── 📄 documents.ts
│           └── 📁 services/
│               ├── 📄 DocumentService.ts
│               ├── 📄 S3Service.ts
│               └── 📄 FileProcessor.ts
│
├── 📁 frontend/                           # Frontend applications
│   ├── 📁 user-portal/                    # Customer portal
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   ├── 📄 next.config.js
│   │   ├── 📄 tailwind.config.js
│   │   ├── 📄 tsconfig.json
│   │   └── 📁 src/
│   │       ├── 📁 app/                    # Next.js 13+ app directory
│   │       │   ├── 📄 layout.tsx          # Root layout
│   │       │   ├── 📄 page.tsx            # Home page
│   │       │   ├── 📁 auth/               # Authentication pages
│   │       │   │   ├── 📄 login/page.tsx
│   │       │   │   └── 📄 register/page.tsx
│   │       │   ├── 📁 dashboard/          # Dashboard pages
│   │       │   │   ├── 📄 page.tsx
│   │       │   │   ├── 📁 policies/       # Policy management
│   │       │   │   ├── 📁 claims/         # Claims management
│   │       │   │   └── 📁 payments/       # Payment management
│   │       │   └── 📁 quotes/             # Quote pages
│   │       │       └── 📄 page.tsx
│   │       ├── 📁 components/             # Reusable components
│   │       │   ├── 📁 ui/                 # UI components
│   │       │   │   ├── 📄 Button.tsx
│   │       │   │   ├── 📄 Input.tsx
│   │       │   │   ├── 📄 Modal.tsx
│   │       │   │   └── 📄 Card.tsx
│   │       │   ├── 📁 forms/              # Form components
│   │       │   │   ├── 📄 LoginForm.tsx
│   │       │   │   ├── 📄 RegisterForm.tsx
│   │       │   │   └── 📄 QuoteForm.tsx
│   │       │   ├── 📁 layout/             # Layout components
│   │       │   │   ├── 📄 Header.tsx
│   │       │   │   ├── 📄 Sidebar.tsx
│   │       │   │   └── 📄 Footer.tsx
│   │       │   └── 📁 features/           # Feature components
│   │       │       ├── 📄 PolicyCard.tsx
│   │       │       ├── 📄 ClaimsTable.tsx
│   │       │       └── 📄 QuoteCalculator.tsx
│   │       ├── 📁 hooks/                  # Custom React hooks
│   │       │   ├── 📄 useAuth.ts
│   │       │   ├── 📄 useApi.ts
│   │       │   └── 📄 useLocalStorage.ts
│   │       ├── 📁 services/               # API services
│   │       │   ├── 📄 api.ts
│   │       │   ├── 📄 auth.ts
│   │       │   ├── 📄 policies.ts
│   │       │   └── 📄 claims.ts
│   │       ├── 📁 store/                  # Redux store
│   │       │   ├── 📄 index.ts
│   │       │   ├── 📄 authSlice.ts
│   │       │   └── 📄 policySlice.ts
│   │       ├── 📁 utils/                  # Utility functions
│   │       │   ├── 📄 constants.ts
│   │       │   ├── 📄 helpers.ts
│   │       │   └── 📄 validation.ts
│   │       └── 📁 styles/                 # Global styles
│   │           └── 📄 globals.css
│   │
│   ├── 📁 admin-dashboard/                # Admin interface
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📁 app/
│   │       │   ├── 📄 layout.tsx
│   │       │   ├── 📄 page.tsx
│   │       │   ├── 📁 users/              # User management
│   │       │   ├── 📁 policies/           # Policy management
│   │       │   ├── 📁 claims/             # Claims management
│   │       │   ├── 📁 reports/            # Reports and analytics
│   │       │   └── 📁 settings/           # System settings
│   │       ├── 📁 components/
│   │       │   ├── 📁 ui/
│   │       │   ├── 📁 charts/             # Chart components
│   │       │   ├── 📁 tables/             # Data tables
│   │       │   └── 📁 forms/              # Admin forms
│   │       └── 📁 services/
│   │           ├── 📄 admin.ts
│   │           └── 📄 analytics.ts
│   │
│   ├── 📁 provider-portal/                # Provider management interface
│   │   ├── 📄 package.json
│   │   ├── 📄 Dockerfile
│   │   └── 📁 src/
│   │       ├── 📁 app/
│   │       │   ├── 📄 layout.tsx
│   │       │   ├── 📄 page.tsx
│   │       │   ├── 📁 products/           # Product management
│   │       │   ├── 📁 policies/           # Policy management
│   │       │   ├── 📁 claims/             # Claims processing
│   │       │   └── 📁 analytics/          # Performance analytics
│   │       ├── 📁 components/
│   │       └── 📁 services/
│   │
│   └── 📁 broker-portal/                  # Broker and agent tools
│       ├── 📄 package.json
│       ├── 📄 Dockerfile
│       └── 📁 src/
│           ├── 📁 app/
│           │   ├── 📄 layout.tsx
│           │   ├── 📄 page.tsx
│           │   ├── 📁 clients/            # Client management
│           │   ├── 📁 quotes/             # Quote generation
│           │   ├── 📁 policies/           # Policy management
│           │   └── 📁 commissions/        # Commission tracking
│           ├── 📁 components/
│           └── 📁 services/
│
├── 📁 mobile/                             # React Native mobile app
│   ├── 📄 package.json
│   ├── 📄 app.json                        # Expo configuration
│   ├── 📄 babel.config.js
│   ├── 📄 tsconfig.json
│   └── 📁 src/
│       ├── 📄 App.tsx                     # Main app component
│       ├── 📁 navigation/                 # Navigation setup
│       │   ├── 📄 index.tsx
│       │   ├── 📄 AppNavigator.tsx
│       │   └── 📄 AuthNavigator.tsx
│       ├── 📁 screens/                    # App screens
│       │   ├── 📁 auth/
│       │   │   ├── 📄 LoginScreen.tsx
│       │   │   └── 📄 RegisterScreen.tsx
│       │   ├── 📁 dashboard/
│       │   │   ├── 📄 DashboardScreen.tsx
│       │   │   ├── 📄 PoliciesScreen.tsx
│       │   │   ├── 📄 ClaimsScreen.tsx
│       │   │   └── 📄 PaymentsScreen.tsx
│       │   ├── 📁 quotes/
│       │   │   └── 📄 QuoteScreen.tsx
│       │   └── 📁 profile/
│       │       └── 📄 ProfileScreen.tsx
│       ├── 📁 components/                 # Reusable components
│       │   ├── 📁 ui/
│       │   │   ├── 📄 Button.tsx
│       │   │   ├── 📄 Input.tsx
│       │   │   └── 📄 Card.tsx
│       │   ├── 📁 forms/
│       │   └── 📁 features/
│       ├── 📁 services/                   # API services
│       │   ├── 📄 api.ts
│       │   ├── 📄 auth.ts
│       │   └── 📄 storage.ts
│       ├── 📁 store/                      # Redux store
│       │   ├── 📄 index.ts
│       │   └── 📄 slices/
│       ├── 📁 utils/                      # Utility functions
│       │   ├── 📄 constants.ts
│       │   └── 📄 helpers.ts
│       └── 📁 assets/                     # Images, fonts, etc.
│           ├── 📁 images/
│           └── 📁 fonts/
│
├── 📁 shared/                             # Shared utilities and types
│   ├── 📁 types/                          # TypeScript type definitions
│   │   ├── 📄 index.ts                    # Main types export
│   │   ├── 📄 user.ts                     # User-related types
│   │   ├── 📄 policy.ts                   # Policy-related types
│   │   ├── 📄 claim.ts                    # Claim-related types
│   │   ├── 📄 payment.ts                  # Payment-related types
│   │   └── 📄 api.ts                      # API-related types
│   ├── 📁 utils/                          # Shared utility functions
│   │   ├── 📄 validation.ts               # Validation utilities
│   │   ├── 📄 formatting.ts               # Data formatting
│   │   ├── 📄 constants.ts                # Shared constants
│   │   └── 📄 helpers.ts                  # Helper functions
│   └── 📁 config/                         # Shared configuration
│       ├── 📄 api.ts                      # API configuration
│       └── 📄 constants.ts                # System constants
│
├── 📁 docs/                               # Documentation
│   ├── 📄 project-structure.md            # This file
│   ├── 📄 api-documentation.md            # API documentation
│   ├── 📄 deployment-guide.md             # Deployment instructions
│   ├── 📄 development-guide.md            # Development setup
│   ├── 📄 architecture.md                 # System architecture
│   └── 📄 contributing.md                 # Contributing guidelines
│
├── 📁 scripts/                            # Deployment and utility scripts
│   ├── 📄 init-db.sql                     # Database initialization
│   ├── 📄 deploy.sh                       # Deployment script
│   ├── 📄 backup.sh                       # Database backup script
│   ├── 📄 migrate.sh                      # Database migration script
│   └── 📄 health-check.sh                 # Health check script
│
├── 📁 monitoring/                         # Monitoring and observability
│   ├── 📄 prometheus.yml                  # Prometheus configuration
│   ├── 📁 grafana/                        # Grafana dashboards
│   │   ├── 📁 dashboards/
│   │   │   ├── 📄 system-overview.json
│   │   │   ├── 📄 api-metrics.json
│   │   │   └── 📄 business-metrics.json
│   │   └── 📁 datasources/
│   │       └── 📄 prometheus.json
│   └── 📁 alerts/                         # Alert rules
│       ├── 📄 api-gateway.yml
│       ├── 📄 database.yml
│       └── 📄 business.yml
│
├── 📁 tests/                              # End-to-end and integration tests
│   ├── 📁 e2e/                            # End-to-end tests
│   │   ├── 📄 user-journey.spec.ts
│   │   ├── 📄 quote-flow.spec.ts
│   │   └── 📄 claims-flow.spec.ts
│   ├── 📁 integration/                    # Integration tests
│   │   ├── 📄 api-tests.spec.ts
│   │   └── 📄 database-tests.spec.ts
│   └── 📁 performance/                    # Performance tests
│       ├── 📄 load-tests.js
│       └── 📄 stress-tests.js
│
└── 📁 infrastructure/                     # Infrastructure as Code
    ├── 📁 terraform/                      # Terraform configurations
    │   ├── 📄 main.tf
    │   ├── 📄 variables.tf
    │   ├── 📄 outputs.tf
    │   └── 📁 modules/
    │       ├── 📁 vpc/
    │       ├── 📁 ecs/
    │       ├── 📁 rds/
    │       └── 📁 s3/
    ├── 📁 kubernetes/                     # Kubernetes manifests
    │   ├── 📄 namespace.yaml
    │   ├── 📄 configmap.yaml
    │   ├── 📄 secrets.yaml
    │   └── 📁 deployments/
    │       ├── 📄 api-gateway.yaml
    │       ├── 📄 user-service.yaml
    │       └── 📄 frontend.yaml
    └── 📁 github-actions/                 # CI/CD workflows
        ├── 📄 ci.yml
        ├── 📄 cd.yml
        └── 📄 security-scan.yml
```

## 🏗️ Architecture Overview

### Microservices Architecture
The system follows a microservices architecture with the following services:

1. **API Gateway** - Single entry point for all client requests
2. **User Service** - User management and authentication
3. **Policy Service** - Insurance policy lifecycle management
4. **Quote Engine** - Real-time quote calculation
5. **Payment Service** - Payment processing and management
6. **Claims Service** - Claims processing and tracking
7. **Notification Service** - Multi-channel notifications
8. **Document Service** - Document storage and management

### Frontend Applications
Four separate frontend applications for different user types:

1. **User Portal** - Customer-facing interface
2. **Admin Dashboard** - Administrative control panel
3. **Provider Portal** - Insurance provider management
4. **Broker Portal** - Broker and agent tools

### Mobile Application
React Native mobile app with Expo for cross-platform development.

## 🔧 Technology Stack

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js with TypeScript
- **Database**: PostgreSQL 15+
- **Cache**: Redis 7+
- **Message Queue**: RabbitMQ
- **Search**: Elasticsearch
- **File Storage**: MinIO (S3-compatible)
- **Authentication**: JWT
- **Documentation**: Swagger/OpenAPI

### Frontend
- **Framework**: React 18 with TypeScript
- **Meta Framework**: Next.js 14
- **Styling**: Tailwind CSS
- **State Management**: Redux Toolkit
- **Data Fetching**: React Query
- **UI Components**: Headless UI, Heroicons
- **Forms**: React Hook Form with Zod validation

### Mobile
- **Framework**: React Native with TypeScript
- **Development Platform**: Expo
- **Navigation**: React Navigation
- **State Management**: Redux Toolkit
- **UI Components**: React Native Paper

### DevOps & Infrastructure
- **Containerization**: Docker & Docker Compose
- **Orchestration**: Kubernetes (production)
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus & Grafana
- **Infrastructure as Code**: Terraform
- **Cloud Platform**: AWS

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+

### Quick Start
1. Clone the repository
2. Copy `.env.example` to `.env` and configure
3. Run `docker-compose up -d`
4. Access the applications:
   - API Gateway: http://localhost:3000
   - User Portal: http://localhost:4000
   - Admin Dashboard: http://localhost:4001
   - Provider Portal: http://localhost:4002
   - Broker Portal: http://localhost:4003
   - Grafana: http://localhost:3008

## 📊 Key Features

### For Customers
- Browse and compare insurance policies
- Get instant quotes
- Purchase policies online
- Manage existing policies
- File and track claims
- Access policy documents

### For Insurance Providers
- Manage product catalog
- Set pricing and rules
- Process applications
- Handle claims
- Generate reports
- Monitor performance

### For Brokers
- Manage client portfolios
- Generate quotes
- Process applications
- Track commissions
- Access market data
- Client relationship management

### For Administrators
- User management
- System monitoring
- Compliance reporting
- Financial reporting
- Security management
- Configuration management

## 🔒 Security & Compliance

- **GDPR Compliance** - Data protection and privacy
- **SOC 2 Type II** - Security controls
- **PCI DSS** - Payment card security
- **HIPAA** - Health information protection
- **Encryption** - Data at rest and in transit
- **Multi-factor Authentication** - Enhanced security
- **Audit Logging** - Complete activity tracking

## 📈 Monitoring & Observability

- **Real-time Dashboards** - Business intelligence
- **Risk Analytics** - Predictive modeling
- **Performance Metrics** - KPI tracking
- **Regulatory Reports** - Compliance reporting
- **Custom Reports** - Flexible reporting tools
- **Alerting** - Proactive monitoring
- **Log Aggregation** - Centralized logging

This comprehensive structure provides a scalable, maintainable, and secure foundation for the Insurance Exchange platform.
