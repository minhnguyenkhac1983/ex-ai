# Customer Service

Microservice quản lý thông tin khách hàng trong hệ thống ngân hàng EXB.

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+ với Outbox Pattern
- **Event Streaming**: Apache Kafka với Debezium CDC
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Chức năng chính

- Quản lý thông tin khách hàng (CRUD)
- Xác thực danh tính (KYC)
- Quản lý địa chỉ và liên hệ
- Phân loại khách hàng (Retail/Corporate)
- Tích hợp với hệ thống bảo mật

## 🚀 Khởi chạy

```bash
# Development
./gradlew bootRun

# Docker
docker build -t customer-service .
docker run -p 8080:8080 customer-service
```

## 📡 API Endpoints

- `GET /api/v1/customers` - Danh sách khách hàng
- `POST /api/v1/customers` - Tạo khách hàng mới
- `GET /api/v1/customers/{id}` - Chi tiết khách hàng
- `PUT /api/v1/customers/{id}` - Cập nhật khách hàng
- `DELETE /api/v1/customers/{id}` - Xóa khách hàng
- `POST /api/v1/customers/{id}/kyc` - Gửi KYC

## 🔗 Tích hợp

- **Account Service**: Tạo tài khoản cho khách hàng mới
- **Transaction Service**: Xác thực khách hàng cho giao dịch
- **Notification Service**: Gửi thông báo KYC
- **Audit Service**: Ghi log hoạt động

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
