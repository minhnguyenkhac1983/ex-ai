# Transaction Service

Microservice xử lý giao dịch ngân hàng trong hệ thống EXB.

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+ với CQRS Pattern
- **Event Streaming**: Apache Kafka với Saga Pattern
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Chức năng chính

- Xử lý giao dịch chuyển khoản
- Quản lý lịch sử giao dịch
- Xử lý giao dịch theo lô (Batch)
- Tích hợp với hệ thống thanh toán
- Hỗ trợ đa tiền tệ và tỷ giá

## 🚀 Khởi chạy

```bash
# Development
./gradlew bootRun

# Docker
docker build -t transaction-service .
docker run -p 8082:8082 transaction-service
```

## 📡 API Endpoints

- `POST /api/v1/transactions` - Tạo giao dịch mới
- `GET /api/v1/transactions/{id}` - Chi tiết giao dịch
- `GET /api/v1/transactions` - Lịch sử giao dịch
- `PUT /api/v1/transactions/{id}/status` - Cập nhật trạng thái
- `POST /api/v1/transactions/batch` - Giao dịch theo lô

## 🔗 Tích hợp

- **Account Service**: Cập nhật số dư
- **Customer Service**: Xác thực khách hàng
- **Payment Service**: Xử lý thanh toán
- **Notification Service**: Thông báo giao dịch
- **Audit Service**: Ghi log giao dịch

## 📊 Monitoring

- Metrics: Prometheus
- Logs: Loki
- Traces: Tempo
- Health: `/actuator/health`

## 🔒 Bảo mật

- OAuth2/OIDC với Keycloak
- Role-based access control
- Audit logging
- Data encryption at rest
- Fraud detection
