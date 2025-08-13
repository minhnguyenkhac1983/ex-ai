# Security Services

Thư mục chứa các microservice bảo mật và xác thực trong hệ thống EXB.

## 📁 Cấu trúc

```
security/
├── auth-service/        # Authentication Service
├── encryption-service/  # Encryption Service
└── audit-service/       # Audit Service
```

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+, Redis
- **Event Streaming**: Apache Kafka
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Thành phần chính

### Auth Service
- OAuth2/OIDC implementation
- JWT token management
- User authentication
- Role-based access control (RBAC)
- Multi-factor authentication (MFA)

### Encryption Service
- Data encryption/decryption
- Key management
- HSM integration
- Certificate management
- Secure key storage

### Audit Service
- Audit logging
- Compliance reporting
- Security event tracking
- Data retention policies
- Regulatory compliance

## 🚀 Khởi chạy

```bash
# Auth Service
cd auth-service
./gradlew bootRun

# Encryption Service
cd encryption-service
./gradlew bootRun

# Audit Service
cd audit-service
./gradlew bootRun
```

## 📡 API Endpoints

### Auth Service
- `POST /api/v1/auth/login` - Đăng nhập
- `POST /api/v1/auth/logout` - Đăng xuất
- `POST /api/v1/auth/refresh` - Làm mới token
- `GET /api/v1/auth/user` - Thông tin user

### Encryption Service
- `POST /api/v1/encryption/encrypt` - Mã hóa dữ liệu
- `POST /api/v1/encryption/decrypt` - Giải mã dữ liệu
- `GET /api/v1/encryption/keys` - Quản lý keys

### Audit Service
- `POST /api/v1/audit/log` - Ghi log audit
- `GET /api/v1/audit/events` - Lấy events
- `GET /api/v1/audit/reports` - Báo cáo audit

## 🔗 Tích hợp

- **All Services**: Authentication và authorization
- **Customer Service**: User management
- **Transaction Service**: Fraud detection
- **Notification Service**: Security alerts

## 📊 Monitoring

- Metrics: Prometheus
- Logs: Loki
- Traces: Tempo
- Security metrics

## 🔒 Bảo mật

- OAuth2/OIDC với Keycloak
- Role-based access control
- Audit logging
- Data encryption at rest
- PCI DSS compliance
- ISO 27001 compliance
