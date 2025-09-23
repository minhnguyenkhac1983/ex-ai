# CẤU TRÚC THƯ MỤC DỰ ÁN VIETNAM E-WALLET EXCHANGE

## TỔNG QUAN CẤU TRÚC

Dự án được tổ chức theo kiến trúc microservices với cấu trúc thư mục rõ ràng, dễ bảo trì và mở rộng.

```
vietnam-ewallet-exchange/
├── 📁 apps/                          # Ứng dụng chính
│   ├── 📁 mobile/                    # Mobile applications
│   │   ├── 📁 ios/                   # iOS app (React Native)
│   │   ├── 📁 android/               # Android app (React Native)
│   │   └── 📁 shared/                # Shared components & logic
│   ├── 📁 web/                       # Web applications
│   │   ├── 📁 customer-portal/       # Customer web portal
│   │   ├── 📁 merchant-portal/       # Merchant dashboard
│   │   └── 📁 admin-dashboard/       # Admin management panel
│   └── 📁 api-gateway/               # API Gateway service
├── 📁 services/                      # Backend microservices
│   ├── 📁 auth-service/              # Authentication & Authorization
│   ├── 📁 user-service/              # User management
│   ├── 📁 wallet-service/            # Wallet operations
│   ├── 📁 transaction-service/       # Transaction processing
│   ├── 📁 payment-service/           # Payment gateway integration
│   ├── 📁 notification-service/      # Notifications (SMS, Email, Push)
│   ├── 📁 fraud-detection-service/   # Fraud detection & ML
│   ├── 📁 merchant-service/          # Merchant management
│   ├── 📁 kyc-service/              # KYC verification
│   ├── 📁 audit-service/            # Audit logging
│   └── 📁 crypto-service/           # Cryptocurrency support
├── 📁 shared/                        # Shared libraries & utilities
│   ├── 📁 database/                  # Database schemas & migrations
│   ├── 📁 types/                     # TypeScript type definitions
│   ├── 📁 utils/                     # Utility functions
│   ├── 📁 constants/                 # Application constants
│   ├── 📁 validators/                # Validation schemas
│   └── 📁 middleware/                # Common middleware
├── 📁 infrastructure/                # Infrastructure as Code
│   ├── 📁 terraform/                 # Terraform configurations
│   ├── 📁 kubernetes/                # Kubernetes manifests
│   ├── 📁 helm/                      # Helm charts
│   ├── 📁 docker/                    # Docker configurations
│   └── 📁 monitoring/                # Monitoring & observability
├── 📁 docs/                          # Documentation
│   ├── 📁 api/                       # API documentation
│   ├── 📁 architecture/              # Architecture documents
│   ├── 📁 deployment/                # Deployment guides
│   └── 📁 user-guides/               # User documentation
├── 📁 scripts/                       # Automation scripts
│   ├── 📁 setup/                     # Setup scripts
│   ├── 📁 deployment/                # Deployment scripts
│   ├── 📁 backup/                    # Backup scripts
│   └── 📁 maintenance/               # Maintenance scripts
├── 📁 tests/                         # Test suites
│   ├── 📁 unit/                      # Unit tests
│   ├── 📁 integration/               # Integration tests
│   ├── 📁 e2e/                       # End-to-end tests
│   └── 📁 performance/               # Performance tests
├── 📁 tools/                         # Development tools
│   ├── 📁 code-generators/           # Code generation tools
│   ├── 📁 linters/                   # Linting configurations
│   ├── 📁 formatters/                # Code formatting tools
│   └── 📁 validators/                # Code validation tools
├── 📁 config/                        # Configuration files
│   ├── 📁 environments/              # Environment-specific configs
│   ├── 📁 secrets/                   # Secret management
│   └── 📁 feature-flags/             # Feature flag configurations
├── 📁 .github/                       # GitHub workflows
├── 📁 .gitlab/                       # GitLab CI/CD
├── 📁 plan/                          # Project planning documents
├── 📄 README.md                      # Project overview
├── 📄 package.json                   # Root package.json
├── 📄 docker-compose.yml             # Local development setup
├── 📄 .env.example                   # Environment variables template
├── 📄 .gitignore                     # Git ignore rules
├── 📄 .dockerignore                  # Docker ignore rules
└── 📄 LICENSE                        # Project license
```

## CHI TIẾT CẤU TRÚC THƯ MỤC

### 1. 📁 apps/ - Ứng dụng Frontend

#### 1.1 📁 mobile/ - Mobile Applications
```
mobile/
├── ios/                              # iOS specific code
│   ├── EWallet/                      # iOS project
│   ├── EWallet.xcodeproj/            # Xcode project
│   └── Podfile                       # CocoaPods dependencies
├── android/                          # Android specific code
│   ├── app/                          # Android app module
│   ├── build.gradle                  # Build configuration
│   └── gradle.properties             # Gradle properties
└── shared/                           # Shared React Native code
    ├── src/
    │   ├── components/               # Reusable components
    │   ├── screens/                  # Screen components
    │   ├── navigation/               # Navigation setup
    │   ├── services/                 # API services
    │   ├── store/                    # State management
    │   ├── utils/                    # Utility functions
    │   └── types/                    # TypeScript types
    ├── package.json                  # Dependencies
    ├── metro.config.js               # Metro bundler config
    └── babel.config.js               # Babel configuration
```

#### 1.2 📁 web/ - Web Applications
```
web/
├── customer-portal/                  # Customer web application
│   ├── src/
│   │   ├── components/               # React components
│   │   ├── pages/                    # Page components
│   │   ├── hooks/                    # Custom React hooks
│   │   ├── services/                 # API services
│   │   ├── store/                    # State management
│   │   ├── styles/                   # CSS/SCSS styles
│   │   └── utils/                    # Utility functions
│   ├── public/                       # Static assets
│   ├── package.json                  # Dependencies
│   ├── next.config.js                # Next.js configuration
│   └── tailwind.config.js            # Tailwind CSS config
├── merchant-portal/                  # Merchant dashboard
│   └── [similar structure to customer-portal]
└── admin-dashboard/                  # Admin management panel
    └── [similar structure to customer-portal]
```

### 2. 📁 services/ - Backend Microservices

#### 2.1 Cấu trúc chung cho mỗi service
```
auth-service/
├── src/
│   ├── controllers/                  # Request handlers
│   ├── services/                     # Business logic
│   ├── repositories/                 # Data access layer
│   ├── models/                       # Data models
│   ├── middleware/                   # Express middleware
│   ├── routes/                       # API routes
│   ├── validators/                   # Input validation
│   ├── utils/                        # Utility functions
│   └── types/                        # TypeScript types
├── tests/                            # Service-specific tests
├── migrations/                       # Database migrations
├── package.json                      # Dependencies
├── Dockerfile                        # Container configuration
├── docker-compose.yml                # Local development
└── README.md                         # Service documentation
```

#### 2.2 Các services chính
- **auth-service**: JWT authentication, OAuth, 2FA
- **user-service**: User CRUD, profile management
- **wallet-service**: Wallet operations, balance management
- **transaction-service**: Transaction processing, history
- **payment-service**: Payment gateway integration
- **notification-service**: SMS, email, push notifications
- **fraud-detection-service**: ML-based fraud detection
- **merchant-service**: Merchant onboarding, management
- **kyc-service**: Identity verification
- **audit-service**: Audit logging, compliance
- **crypto-service**: Cryptocurrency support

### 3. 📁 shared/ - Shared Libraries

```
shared/
├── database/
│   ├── schemas/                      # Database schemas
│   ├── migrations/                   # Database migrations
│   ├── seeds/                        # Seed data
│   └── connections/                  # Database connections
├── types/
│   ├── api/                          # API type definitions
│   ├── database/                     # Database types
│   └── common/                       # Common types
├── utils/
│   ├── encryption/                   # Encryption utilities
│   ├── validation/                   # Validation helpers
│   ├── formatting/                   # Data formatting
│   └── date/                         # Date utilities
├── constants/
│   ├── api/                          # API constants
│   ├── business/                     # Business rules
│   └── technical/                    # Technical constants
├── validators/
│   ├── schemas/                      # Validation schemas
│   └── rules/                        # Custom validation rules
└── middleware/
    ├── auth/                         # Authentication middleware
    ├── logging/                      # Logging middleware
    └── error/                        # Error handling middleware
```

### 4. 📁 infrastructure/ - Infrastructure as Code

```
infrastructure/
├── terraform/
│   ├── environments/                 # Environment-specific configs
│   │   ├── dev/                      # Development environment
│   │   ├── staging/                  # Staging environment
│   │   └── prod/                     # Production environment
│   ├── modules/                      # Reusable Terraform modules
│   │   ├── vpc/                      # VPC module
│   │   ├── eks/                      # EKS cluster module
│   │   ├── rds/                      # RDS database module
│   │   └── redis/                    # ElastiCache module
│   └── main.tf                       # Main Terraform configuration
├── kubernetes/
│   ├── namespaces/                   # Namespace definitions
│   ├── services/                     # Service definitions
│   ├── deployments/                  # Deployment manifests
│   ├── configmaps/                   # Configuration maps
│   └── secrets/                      # Secret definitions
├── helm/
│   ├── ewallet/                      # Main Helm chart
│   │   ├── Chart.yaml                # Chart metadata
│   │   ├── values.yaml               # Default values
│   │   ├── values-dev.yaml           # Development values
│   │   ├── values-staging.yaml       # Staging values
│   │   ├── values-prod.yaml          # Production values
│   │   └── templates/                # Kubernetes templates
│   └── charts/                       # Sub-charts
├── docker/
│   ├── base/                         # Base Docker images
│   ├── services/                     # Service-specific Dockerfiles
│   └── docker-compose/               # Docker Compose files
└── monitoring/
    ├── prometheus/                   # Prometheus configuration
    ├── grafana/                      # Grafana dashboards
    ├── jaeger/                       # Jaeger tracing
    └── alertmanager/                 # Alert rules
```

### 5. 📁 docs/ - Documentation

```
docs/
├── api/
│   ├── openapi/                      # OpenAPI specifications
│   ├── postman/                      # Postman collections
│   └── examples/                     # API usage examples
├── architecture/
│   ├── system-design/                # System architecture
│   ├── database-design/              # Database design
│   ├── security/                     # Security architecture
│   └── deployment/                   # Deployment architecture
├── deployment/
│   ├── local-setup/                  # Local development setup
│   ├── staging-deployment/           # Staging deployment guide
│   ├── production-deployment/        # Production deployment guide
│   └── troubleshooting/              # Troubleshooting guides
└── user-guides/
    ├── developer/                    # Developer documentation
    ├── admin/                        # Admin user guide
    ├── merchant/                     # Merchant user guide
    └── customer/                     # Customer user guide
```

### 6. 📁 scripts/ - Automation Scripts

```
scripts/
├── setup/
│   ├── install-dependencies.sh       # Install all dependencies
│   ├── setup-database.sh             # Database setup
│   ├── setup-redis.sh                # Redis setup
│   └── setup-env.sh                  # Environment setup
├── deployment/
│   ├── deploy-staging.sh             # Deploy to staging
│   ├── deploy-production.sh          # Deploy to production
│   ├── rollback.sh                   # Rollback deployment
│   └── health-check.sh               # Health check script
├── backup/
│   ├── backup-database.sh            # Database backup
│   ├── backup-redis.sh               # Redis backup
│   ├── restore-database.sh           # Database restore
│   └── cleanup-backups.sh            # Cleanup old backups
└── maintenance/
    ├── update-dependencies.sh        # Update dependencies
    ├── run-migrations.sh             # Run database migrations
    ├── cleanup-logs.sh               # Cleanup log files
    └── performance-check.sh          # Performance monitoring
```

### 7. 📁 tests/ - Test Suites

```
tests/
├── unit/
│   ├── services/                     # Service unit tests
│   ├── utils/                        # Utility function tests
│   └── components/                   # Component tests
├── integration/
│   ├── api/                          # API integration tests
│   ├── database/                     # Database integration tests
│   └── services/                     # Service integration tests
├── e2e/
│   ├── mobile/                       # Mobile E2E tests
│   ├── web/                          # Web E2E tests
│   └── api/                          # API E2E tests
└── performance/
    ├── load-tests/                   # Load testing
    ├── stress-tests/                 # Stress testing
    └── benchmarks/                   # Performance benchmarks
```

### 8. 📁 tools/ - Development Tools

```
tools/
├── code-generators/
│   ├── service-generator/            # Generate new service
│   ├── component-generator/          # Generate React components
│   └── api-generator/                # Generate API endpoints
├── linters/
│   ├── eslint/                       # ESLint configuration
│   ├── tslint/                       # TSLint configuration
│   └── stylelint/                    # StyleLint configuration
├── formatters/
│   ├── prettier/                     # Prettier configuration
│   └── clang-format/                 # C++ formatting
└── validators/
    ├── schema-validator/             # Schema validation
    └── api-validator/                # API validation
```

### 9. 📁 config/ - Configuration Files

```
config/
├── environments/
│   ├── development.json              # Development config
│   ├── staging.json                  # Staging config
│   ├── production.json               # Production config
│   └── test.json                     # Test config
├── secrets/
│   ├── development/                  # Development secrets
│   ├── staging/                      # Staging secrets
│   └── production/                   # Production secrets
└── feature-flags/
    ├── development.json              # Development feature flags
    ├── staging.json                  # Staging feature flags
    └── production.json               # Production feature flags
```

## QUY TẮC ĐẶT TÊN VÀ TỔ CHỨC

### 1. Naming Conventions
- **Files**: kebab-case (user-service.ts)
- **Directories**: kebab-case (auth-service/)
- **Classes**: PascalCase (UserService)
- **Functions**: camelCase (getUserById)
- **Constants**: UPPER_SNAKE_CASE (API_BASE_URL)
- **Environment variables**: UPPER_SNAKE_CASE (DATABASE_URL)

### 2. File Organization
- Mỗi service có cấu trúc thư mục riêng
- Shared code được đặt trong thư mục `shared/`
- Configuration files được tập trung trong `config/`
- Documentation được tổ chức theo chủ đề

### 3. Import/Export Rules
- Sử dụng absolute imports từ root
- Barrel exports (index.ts) cho mỗi module
- Named exports thay vì default exports
- Type-only imports khi chỉ sử dụng types

### 4. Git Organization
- Feature branches từ `develop`
- Hotfix branches từ `main`
- Pull requests bắt buộc cho mọi thay đổi
- Commit messages theo conventional commits

## DEPENDENCY MANAGEMENT

### 1. Package Management
- **Root**: Lerna hoặc Nx cho monorepo management
- **Services**: npm hoặc yarn cho dependencies
- **Frontend**: npm/yarn với lock files
- **Docker**: Multi-stage builds cho optimization

### 2. Version Management
- Semantic versioning (SemVer)
- Automated version bumping
- Changelog generation
- Release notes automation

## SECURITY CONSIDERATIONS

### 1. Secret Management
- Không commit secrets vào repository
- Sử dụng environment variables
- Secret rotation policies
- Encrypted storage cho sensitive data

### 2. Access Control
- Role-based access control (RBAC)
- Principle of least privilege
- Regular access reviews
- Audit logging cho mọi operations

---

Cấu trúc này được thiết kế để hỗ trợ:
- **Scalability**: Dễ dàng thêm services mới
- **Maintainability**: Code được tổ chức rõ ràng
- **Team Collaboration**: Nhiều team có thể làm việc song song
- **CI/CD**: Automated testing và deployment
- **Security**: Bảo mật được tích hợp từ đầu
