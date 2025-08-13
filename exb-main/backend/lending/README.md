# Lending Services

Thư mục chứa các microservice quản lý cho vay và tín dụng trong hệ thống EXB.

## 📁 Cấu trúc

```
lending/
├── loan-service/          # Loan Management Service
├── credit-assessment/     # Credit Assessment Service
└── collection-service/    # Collection Service
```

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+, Redis
- **Event Streaming**: Apache Kafka
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Thành phần chính

### Loan Service
- Quản lý khoản vay cá nhân/doanh nghiệp
- Tính toán lãi suất và phí
- Quản lý lịch trả nợ
- Xử lý thanh toán gốc/lãi
- Loan lifecycle management

### Credit Assessment
- Đánh giá tín dụng
- Credit scoring
- Risk assessment
- Collateral management
- Approval workflow

### Collection Service
- Quản lý nợ quá hạn
- Collection strategies
- Payment reminders
- Legal proceedings
- Recovery management

## 🚀 Khởi chạy

```bash
# Loan Service
cd loan-service
./gradlew bootRun

# Credit Assessment
cd credit-assessment
./gradlew bootRun

# Collection Service
cd collection-service
./gradlew bootRun
```

## 📡 API Endpoints

### Loan Service
- `POST /api/v1/loans` - Tạo khoản vay mới
- `GET /api/v1/loans/{id}` - Chi tiết khoản vay
- `PUT /api/v1/loans/{id}/status` - Cập nhật trạng thái
- `GET /api/v1/loans/{id}/schedule` - Lịch trả nợ

### Credit Assessment
- `POST /api/v1/assessment/evaluate` - Đánh giá tín dụng
- `GET /api/v1/assessment/score` - Credit score
- `POST /api/v1/assessment/approve` - Phê duyệt khoản vay

### Collection Service
- `GET /api/v1/collection/overdue` - Danh sách nợ quá hạn
- `POST /api/v1/collection/reminder` - Gửi nhắc nhở
- `PUT /api/v1/collection/strategy` - Cập nhật chiến lược

## 🔗 Tích hợp

- **Customer Service**: Thông tin khách hàng
- **Account Service**: Tài khoản vay
- **Transaction Service**: Thanh toán gốc/lãi
- **Notification Service**: Thông báo khoản vay
- **Analytics Service**: Credit scoring

## 📊 Monitoring

- Metrics: Prometheus
- Logs: Loki
- Traces: Tempo
- Loan performance tracking

## 🔒 Bảo mật

- OAuth2/OIDC với Keycloak
- Role-based access control
- Audit logging
- Data encryption at rest
- Regulatory compliance
