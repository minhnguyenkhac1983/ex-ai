# Event Streaming

Event streaming configuration và management cho hệ thống EXB.

## 📁 Cấu trúc

```
events/
├── configs/           # Event configurations
└── schemas/           # Event schemas
```

## 🏗️ Kiến trúc

- **Event Streaming**: Apache Kafka 3.6+
- **Schema Registry**: Confluent Schema Registry
- **CDC**: Debezium
- **Outbox Pattern**: Reliable event publishing
- **Event Sourcing**: Event store

## 📋 Thành phần chính

### Configs
- Kafka configurations
- Debezium connectors
- Schema registry settings
- Topic configurations
- Consumer group settings

### Schemas
- Event schemas
- Message formats
- Schema evolution
- Version management
- Compatibility rules

## 🚀 Setup

```bash
# Start Kafka
docker-compose up -d kafka

# Start Schema Registry
docker-compose up -d schema-registry

# Start Debezium
docker-compose up -d connect

# Create topics
kafka-topics --create --topic customer.events --bootstrap-server localhost:9092
```

## 📡 Event Types

### Domain Events
- Customer events
- Account events
- Transaction events
- Payment events
- Security events

### System Events
- Health checks
- Performance metrics
- Error events
- Audit events
- Monitoring events

### Integration Events
- Third-party events
- External system events
- API events
- Webhook events
- Notification events

## 🔄 Event Patterns

### Event Sourcing
- Event store
- Event replay
- Snapshots
- Projections
- CQRS

### Outbox Pattern
- Reliable publishing
- Transactional events
- Dead letter queues
- Retry mechanisms
- Event ordering

### Saga Pattern
- Distributed transactions
- Compensation events
- Orchestration
- Choreography
- Rollback strategies

## 📊 Monitoring

- Event throughput
- Latency metrics
- Error rates
- Consumer lag
- Topic metrics

## 🔒 Bảo mật

- Authentication
- Authorization
- Encryption
- Audit logging
- Data retention

## 🔄 Data Management

- Event retention
- Data archival
- Schema evolution
- Backward compatibility
- Event replay
