# Account Service

Microservice quản lý tài khoản ngân hàng trong hệ thống EXB.

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+ với Event Sourcing
- **Event Streaming**: Apache Kafka
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Chức năng chính

- Quản lý tài khoản tiết kiệm, vãng lai, tín dụng
- Tạo và đóng tài khoản
- Quản lý số dư và hạn mức
- Tích hợp với Customer Service
- Hỗ trợ đa tiền tệ

## 🚀 Khởi chạy

```bash
# Development
./gradlew bootRun

# Docker
docker build -t account-service .
docker run -p 8081:8081 account-service
```

## 📡 API Endpoints

- `GET /api/v1/accounts` - Danh sách tài khoản
- `POST /api/v1/accounts` - Tạo tài khoản mới
- `GET /api/v1/accounts/{id}` - Chi tiết tài khoản
- `PUT /api/v1/accounts/{id}` - Cập nhật tài khoản
- `DELETE /api/v1/accounts/{id}` - Đóng tài khoản
- `GET /api/v1/accounts/{id}/balance` - Số dư tài khoản

## 🔗 Tích hợp

- **Customer Service**: Xác thực khách hàng
- **Transaction Service**: Cập nhật số dư
- **Payment Service**: Xử lý thanh toán
- **Notification Service**: Thông báo thay đổi tài khoản

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
