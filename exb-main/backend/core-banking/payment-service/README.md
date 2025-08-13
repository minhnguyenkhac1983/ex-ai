# Payment Service

Microservice xử lý thanh toán và quản lý cổng thanh toán trong hệ thống EXB.

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Database**: PostgreSQL 16+ với Outbox Pattern
- **Event Streaming**: Apache Kafka
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Chức năng chính

- Xử lý thanh toán nội bộ và liên ngân hàng
- Quản lý cổng thanh toán (Payment Gateway)
- Hỗ trợ đa phương thức thanh toán
- Tích hợp với hệ thống bên thứ ba
- Quản lý tỷ giá và phí giao dịch

## 🚀 Khởi chạy

```bash
# Development
./gradlew bootRun

# Docker
docker build -t payment-service .
docker run -p 8083:8083 payment-service
```

## 📡 API Endpoints

- `POST /api/v1/payments` - Tạo thanh toán mới
- `GET /api/v1/payments/{id}` - Chi tiết thanh toán
- `PUT /api/v1/payments/{id}/status` - Cập nhật trạng thái
- `POST /api/v1/payments/refund` - Hoàn tiền
- `GET /api/v1/payments/gateways` - Danh sách cổng thanh toán

## 🔗 Tích hợp

- **Transaction Service**: Xử lý giao dịch
- **Account Service**: Kiểm tra số dư
- **Customer Service**: Xác thực khách hàng
- **Notification Service**: Thông báo thanh toán
- **Audit Service**: Ghi log thanh toán

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
- PCI DSS compliance
