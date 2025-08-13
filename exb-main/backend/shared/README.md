# Shared Components

Thư mục chứa các thành phần dùng chung cho tất cả microservices trong hệ thống EXB.

## 📁 Cấu trúc

```
shared/
├── common/          # Các utility và helper classes
├── models/          # Data models và DTOs dùng chung
└── utils/           # Utility functions và constants
```

## 🏗️ Kiến trúc

- **Framework**: Spring Boot 3.3 (Java 21)
- **Pattern**: Shared Library
- **Packaging**: JAR/WAR
- **Versioning**: Semantic Versioning

## 📋 Thành phần chính

### Common
- Base entities và repositories
- Common exceptions và error handlers
- Configuration classes
- Health check components

### Models
- DTOs cho API requests/responses
- Event models cho Kafka
- Database entities
- Validation annotations

### Utils
- Date/time utilities
- String manipulation
- Encryption/decryption helpers
- Logging utilities

## 🚀 Sử dụng

```xml
<!-- Maven -->
<dependency>
    <groupId>com.exb</groupId>
    <artifactId>shared</artifactId>
    <version>1.0.0</version>
</dependency>
```

```gradle
// Gradle
implementation 'com.exb:shared:1.0.0'
```

## 📊 Monitoring

- Metrics: Prometheus
- Logs: Loki
- Traces: Tempo

## 🔒 Bảo mật

- Data validation
- Input sanitization
- Encryption utilities

