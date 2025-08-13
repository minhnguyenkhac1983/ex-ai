# Card Services

Thư mục chứa các microservice quản lý thẻ ngân hàng trong hệ thống EXB.

## 📁 Cấu trúc

```
cards/
├── card-service/           # Card Management Service
├── authorization-service/  # Card Authorization Service
└── atm-service/           # ATM Service
```

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+, Redis
- **Event Streaming**: Apache Kafka
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Thành phần chính

### Card Service
- Quản lý thẻ debit/credit
- Phát hành và thu hồi thẻ
- Quản lý PIN và thông tin thẻ
- Tích hợp với hệ thống thẻ quốc tế
- Card lifecycle management

### Authorization Service
- Xử lý authorization requests
- Real-time fraud detection
- Risk scoring
- Transaction limits
- 3D Secure integration

### ATM Service
- ATM transaction processing
- Cash withdrawal/deposit
- Balance inquiry
- ATM network management
- Location services

## 🚀 Khởi chạy

```bash
# Card Service
cd card-service
./gradlew bootRun

# Authorization Service
cd authorization-service
./gradlew bootRun

# ATM Service
cd atm-service
./gradlew bootRun
```

## 📡 API Endpoints

### Card Service
- `POST /api/v1/cards` - Tạo thẻ mới
- `GET /api/v1/cards/{id}` - Chi tiết thẻ
- `PUT /api/v1/cards/{id}/status` - Cập nhật trạng thái
- `POST /api/v1/cards/{id}/pin` - Thay đổi PIN

### Authorization Service
- `POST /api/v1/auth/authorize` - Xử lý authorization
- `POST /api/v1/auth/decline` - Từ chối giao dịch
- `GET /api/v1/auth/limits` - Kiểm tra hạn mức

### ATM Service
- `POST /api/v1/atm/withdraw` - Rút tiền
- `POST /api/v1/atm/deposit` - Nạp tiền
- `GET /api/v1/atm/balance` - Kiểm tra số dư

## 🔗 Tích hợp

- **Account Service**: Kiểm tra số dư
- **Customer Service**: Xác thực chủ thẻ
- **Transaction Service**: Ghi nhận giao dịch
- **Security Service**: Fraud detection
- **Notification Service**: Thông báo giao dịch

## 📊 Monitoring

- Metrics: Prometheus
- Logs: Loki
- Traces: Tempo
- Transaction monitoring

## 🔒 Bảo mật

- OAuth2/OIDC với Keycloak
- Role-based access control
- Audit logging
- Data encryption at rest
- PCI DSS compliance
- 3D Secure 2.2
