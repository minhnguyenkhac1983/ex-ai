# Observability Stack

Observability và monitoring infrastructure cho hệ thống EXB.

## 📁 Cấu trúc

```
observability/
├── prometheus/        # Metrics collection
├── grafana/           # Visualization dashboards
├── loki/              # Log aggregation
├── tempo/             # Distributed tracing
└── otel-collector/    # OpenTelemetry collector
```

## 🏗️ Kiến trúc

- **Metrics**: Prometheus + Grafana
- **Logs**: Loki + Promtail
- **Traces**: Tempo + OpenTelemetry
- **Alerts**: Alertmanager
- **Dashboards**: Grafana

## 📋 Thành phần chính

### Prometheus
- Metrics collection
- Time-series database
- Alerting rules
- Service discovery
- Data retention

### Grafana
- Dashboard visualization
- Alert management
- Data source integration
- User management
- Plugin ecosystem

### Loki
- Log aggregation
- Log querying
- Log retention
- Multi-tenancy
- Scalability

### Tempo
- Distributed tracing
- Trace storage
- Trace querying
- Service mesh integration
- Performance analysis

### OpenTelemetry Collector
- Telemetry collection
- Data processing
- Export configuration
- Sampling strategies
- Resource detection

## 🚀 Setup

```bash
# Start Prometheus
docker-compose up -d prometheus

# Start Grafana
docker-compose up -d grafana

# Start Loki
docker-compose up -d loki

# Start Tempo
docker-compose up -d tempo

# Start OTel Collector
docker-compose up -d otel-collector
```

## 📊 Monitoring

### Application Metrics
- Request rates
- Response times
- Error rates
- Resource usage
- Business metrics

### Infrastructure Metrics
- CPU usage
- Memory usage
- Disk usage
- Network traffic
- Container metrics

### Business Metrics
- Transaction volume
- Customer activity
- Revenue metrics
- Performance KPIs
- SLA monitoring

## 🔔 Alerting

- Alert rules
- Notification channels
- Escalation policies
- Alert grouping
- Silence management

## 📈 Dashboards

- System overview
- Service dashboards
- Business dashboards
- Custom dashboards
- Real-time monitoring

## 🔒 Bảo mật

- Authentication
- Authorization
- Data encryption
- Audit logging
- Access control
