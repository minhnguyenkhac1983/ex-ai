# Analytics Services

Thư mục chứa các microservice phân tích dữ liệu và báo cáo trong hệ thống EXB.

## 📁 Cấu trúc

```
analytics/
├── ml-service/          # Machine Learning Service
├── reporting-service/   # Reporting Service
└── data-warehouse/      # Data Warehouse Service
```

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21), Python 3.12 + FastAPI
- **Database**: ClickHouse, PostgreSQL, Redis
- **Event Streaming**: Apache Kafka
- **API**: REST API + gRPC
- **Observability**: OpenTelemetry

## 📋 Thành phần chính

### ML Service
- Fraud detection models
- Credit scoring algorithms
- Customer segmentation
- Predictive analytics
- Model training và deployment

### Reporting Service
- Financial reports
- Regulatory reports
- Business intelligence
- Dashboard data
- Export functionality

### Data Warehouse
- Data ingestion từ multiple sources
- ETL/ELT processes
- Data modeling
- Query optimization
- Data governance

## 🚀 Khởi chạy

```bash
# ML Service
cd ml-service
python -m uvicorn main:app --reload

# Reporting Service
cd reporting-service
./gradlew bootRun

# Data Warehouse
cd data-warehouse
docker-compose up -d
```

## 📡 API Endpoints

### ML Service
- `POST /api/v1/ml/fraud-detection` - Phát hiện gian lận
- `POST /api/v1/ml/credit-scoring` - Đánh giá tín dụng
- `GET /api/v1/ml/models` - Danh sách models

### Reporting Service
- `GET /api/v1/reports/financial` - Báo cáo tài chính
- `GET /api/v1/reports/regulatory` - Báo cáo tuân thủ
- `POST /api/v1/reports/export` - Xuất báo cáo

## 🔗 Tích hợp

- **Core Banking Services**: Dữ liệu giao dịch
- **Customer Service**: Dữ liệu khách hàng
- **Transaction Service**: Dữ liệu giao dịch
- **Notification Service**: Gửi báo cáo

## 📊 Monitoring

- Metrics: Prometheus
- Logs: Loki
- Traces: Tempo
- Model performance tracking

## 🔒 Bảo mật

- OAuth2/OIDC với Keycloak
- Role-based access control
- Data encryption at rest
- GDPR compliance
