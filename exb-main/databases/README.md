# Database Architecture

Kiến trúc cơ sở dữ liệu được thiết kế để hỗ trợ hệ thống ngân hàng với hiệu suất cao, khả năng mở rộng và tuân thủ quy định.

## 🏗️ **Kiến trúc Database**

- **Polyglot Persistence**: Sử dụng nhiều loại database phù hợp
- **Event Sourcing**: Audit trail và temporal queries
- **CQRS**: Command Query Responsibility Segregation
- **Data Mesh**: Distributed data ownership
- **Data Governance**: Compliance & security

## 📁 **Cấu trúc thư mục**

```
databases/
├── postgresql/                 # PostgreSQL schemas
│   ├── core-banking/          # Core banking data
│   │   ├── customers/         # Customer management
│   │   ├── accounts/          # Account management
│   │   ├── transactions/      # Transaction processing
│   │   └── outbox/            # Outbox pattern tables
│   ├── lending/               # Lending data
│   │   ├── loans/             # Loan management
│   │   ├── credit/            # Credit assessment
│   │   └── collections/       # Collection management
│   ├── cards/                 # Card data
│   │   ├── cards/             # Card management
│   │   ├── atm/               # ATM transactions
│   │   └── authorization/     # Authorization data
│   └── security/              # Security data
│       ├── auth/              # Authentication data
│       ├── audit/             # Audit logs
│       └── encryption/        # Encryption keys
│
├── redis/                      # Redis configurations
│   ├── cache/                 # Application cache
│   ├── session/               # Session storage
│   ├── rate-limit/            # Rate limiting
│   └── streams/               # Event streams
│
├── clickhouse/                 # ClickHouse configurations
│   ├── analytics/             # Analytics data
│   ├── reporting/             # Reporting data
│   └── events/                # Event analytics
│
└── migrations/                 # Database migrations
    ├── postgresql/            # PostgreSQL migrations
    ├── redis/                 # Redis migrations
    └── clickhouse/            # ClickHouse migrations
```

## 🛠️ **Technology Stack**

### Primary Database
- **PostgreSQL 16/17**: ACID compliance, JSONB, pgvector
- **TimescaleDB**: Time-series extension
- **PostGIS**: Spatial data support

### Caching & Session
- **Redis 7.2**: In-memory data store
- **Redis Cluster**: High availability
- **Redis Sentinel**: Failover management

### Analytics & Reporting
- **ClickHouse 24.x**: Columnar database
- **Apache Kafka**: Event streaming
- **Apache Flink**: Stream processing

### Search & Indexing
- **Elasticsearch 8.x**: Full-text search
- **OpenSearch**: Open source alternative
- **pgvector**: Vector similarity search

## 📊 **Data Models**

### Core Banking
```sql
-- Customer Management
CREATE TABLE customers (
    id UUID PRIMARY KEY,
    customer_number VARCHAR(20) UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    kyc_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Account Management
CREATE TABLE accounts (
    id UUID PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE,
    customer_id UUID REFERENCES customers(id),
    account_type VARCHAR(20),
    balance DECIMAL(15,2),
    currency VARCHAR(3),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transaction Processing
CREATE TABLE transactions (
    id UUID PRIMARY KEY,
    transaction_id VARCHAR(50) UNIQUE,
    from_account_id UUID REFERENCES accounts(id),
    to_account_id UUID REFERENCES accounts(id),
    amount DECIMAL(15,2),
    currency VARCHAR(3),
    transaction_type VARCHAR(20),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Event Sourcing
```sql
-- Event Store
CREATE TABLE events (
    id UUID PRIMARY KEY,
    aggregate_id VARCHAR(255) NOT NULL,
    aggregate_type VARCHAR(255) NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    event_data JSONB NOT NULL,
    event_version INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Outbox Pattern
CREATE TABLE outbox_events (
    id UUID PRIMARY KEY,
    aggregatetype VARCHAR(255) NOT NULL,
    aggregateid VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    payload JSONB NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔄 **Data Flow**

### Event-Driven Architecture
1. **Command**: Business command được gửi đến service
2. **Domain Logic**: Domain logic xử lý command
3. **Database Transaction**: Lưu trữ vào database chính
4. **Outbox**: Ghi event vào outbox table
5. **CDC**: Debezium capture changes
6. **Event Stream**: Publish events to Kafka
7. **Consumers**: Services consume events

### CQRS Pattern
- **Command Side**: Write operations, domain logic
- **Query Side**: Read operations, optimized views
- **Event Sourcing**: Complete audit trail
- **Projections**: Materialized views

## 🔐 **Security & Compliance**

### Data Protection
- **Encryption at Rest**: AES-256 encryption
- **Encryption in Transit**: TLS 1.3
- **Field-Level Encryption**: Sensitive data
- **Tokenization**: PCI DSS compliance

### Access Control
- **Row-Level Security**: PostgreSQL RLS
- **Column-Level Security**: Sensitive columns
- **Database Roles**: Principle of least privilege
- **Audit Logging**: Complete audit trail

### Compliance
- **PCI DSS**: Payment card data
- **GDPR**: Data protection
- **SOX**: Financial reporting
- **Data Residency**: Geographic restrictions

## 📈 **Performance Optimization**

### Indexing Strategy
```sql
-- Primary indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX idx_transactions_account_id ON transactions(from_account_id);

-- Composite indexes
CREATE INDEX idx_transactions_date_type ON transactions(created_at, transaction_type);

-- Partial indexes
CREATE INDEX idx_active_accounts ON accounts(customer_id) WHERE status = 'ACTIVE';
```

### Partitioning
```sql
-- Time-based partitioning
CREATE TABLE transactions_partitioned (
    LIKE transactions INCLUDING ALL
) PARTITION BY RANGE (created_at);

-- Create partitions
CREATE TABLE transactions_2024_01 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
```

### Caching Strategy
- **Application Cache**: Redis for frequently accessed data
- **Query Cache**: Database query results
- **Session Cache**: User sessions
- **Rate Limiting**: API rate limiting

## 🔄 **Migration Strategy**

### Database Migrations
```sql
-- Version 1: Initial schema
CREATE TABLE customers (
    id UUID PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

-- Version 2: Add phone number
ALTER TABLE customers ADD COLUMN phone VARCHAR(20);

-- Version 3: Add indexes
CREATE INDEX idx_customers_email ON customers(email);
```

### Zero-Downtime Migrations
- **Blue-Green Deployment**: Zero downtime
- **Feature Flags**: Gradual rollout
- **Backward Compatibility**: Schema evolution
- **Rollback Strategy**: Quick rollback

## 📊 **Monitoring & Observability**

### Database Monitoring
- **Query Performance**: Slow query analysis
- **Connection Pooling**: Connection management
- **Lock Monitoring**: Deadlock detection
- **Storage Monitoring**: Disk usage, growth

### Health Checks
```sql
-- Health check queries
SELECT 1; -- Basic connectivity
SELECT COUNT(*) FROM customers; -- Data availability
SELECT pg_is_in_recovery(); -- Replication status
```

### Alerting
- **High CPU Usage**: Database performance
- **Disk Space**: Storage alerts
- **Connection Limits**: Connection pool exhaustion
- **Replication Lag**: Data consistency

## 🚀 **Deployment**

### Docker Compose
```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: exb_banking
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres123
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./databases/postgresql:/docker-entrypoint-initdb.d

  redis:
    image: redis:7.2-alpine
    volumes:
      - redis_data:/data

  clickhouse:
    image: clickhouse/clickhouse-server:24.1
    volumes:
      - clickhouse_data:/var/lib/clickhouse
```

### Kubernetes
```yaml
# postgresql-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgresql
spec:
  serviceName: postgresql
  replicas: 3
  selector:
    matchLabels:
      app: postgresql
  template:
    metadata:
      labels:
        app: postgresql
    spec:
      containers:
      - name: postgresql
        image: postgres:16
        env:
        - name: POSTGRES_DB
          value: exb_banking
```

## 📚 **Documentation**

- **Schema Documentation**: Database schema
- **Migration Guide**: Migration procedures
- **Performance Tuning**: Optimization guide
- **Security Guidelines**: Security practices
