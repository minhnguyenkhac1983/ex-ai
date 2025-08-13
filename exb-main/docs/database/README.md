# Database Documentation

Tài liệu cơ sở dữ liệu cho hệ thống ngân hàng EXB, bao gồm schema, migration, và data models.

## 📋 **Tổng quan**

Thư mục này chứa tài liệu chi tiết về cơ sở dữ liệu:

- **Database Schema**: Table structures và relationships
- **Migration Scripts**: Database versioning và changes
- **Data Models**: Entity relationships và constraints
- **Performance Tuning**: Indexing và optimization

## 📁 **Cấu trúc tài liệu**

```
docs/database/
├── schemas/                     # Database schemas
│   ├── core-banking/           # Core banking tables
│   ├── lending/                # Lending tables
│   ├── cards/                  # Card tables
│   └── security/               # Security tables
│
├── migrations/                  # Migration documentation
│   ├── postgresql/             # PostgreSQL migrations
│   ├── redis/                  # Redis migrations
│   └── clickhouse/             # ClickHouse migrations
│
├── models/                      # Data models
│   ├── erd/                    # Entity Relationship Diagrams
│   ├── uml/                    # UML class diagrams
│   └── ddl/                    # Data Definition Language
│
└── performance/                 # Performance documentation
    ├── indexes/                # Indexing strategies
    ├── partitioning/           # Table partitioning
    └── optimization/           # Query optimization
```

## 🗄️ **Database Architecture**

### Polyglot Persistence
- **PostgreSQL**: Primary transactional database
- **Redis**: Caching và session storage
- **ClickHouse**: Analytics và reporting
- **Elasticsearch**: Search và logging

### Data Distribution
- **Sharding**: Horizontal partitioning
- **Replication**: Read replicas
- **Backup**: Point-in-time recovery
- **Archive**: Long-term storage

## 📊 **Core Banking Schema**

### Customer Management
```sql
-- Customer table
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    kyc_status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer addresses
CREATE TABLE customer_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customers(id),
    address_type VARCHAR(20) NOT NULL,
    street_address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Account Management
```sql
-- Account table
CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id UUID REFERENCES customers(id),
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) DEFAULT 'ACTIVE',
    interest_rate DECIMAL(5,4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Account transactions
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id VARCHAR(50) UNIQUE NOT NULL,
    from_account_id UUID REFERENCES accounts(id),
    to_account_id UUID REFERENCES accounts(id),
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔄 **Event Sourcing Schema**

### Event Store
```sql
-- Event store table
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aggregate_id VARCHAR(255) NOT NULL,
    aggregate_type VARCHAR(255) NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    event_data JSONB NOT NULL,
    event_version INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Event store indexes
CREATE INDEX idx_events_aggregate ON events(aggregate_id, aggregate_type);
CREATE INDEX idx_events_type ON events(event_type);
CREATE INDEX idx_events_created_at ON events(created_at);
```

### Outbox Pattern
```sql
-- Outbox table for reliable event publishing
CREATE TABLE outbox_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aggregatetype VARCHAR(255) NOT NULL,
    aggregateid VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    payload JSONB NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE
);

-- Outbox indexes
CREATE INDEX idx_outbox_processed ON outbox_events(processed, timestamp);
CREATE INDEX idx_outbox_aggregate ON outbox_events(aggregatetype, aggregateid);
```

## 📈 **Performance Optimization**

### Indexing Strategy
```sql
-- Primary indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_phone ON customers(phone);
CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX idx_accounts_account_number ON accounts(account_number);
CREATE INDEX idx_transactions_account_id ON transactions(from_account_id, to_account_id);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);

-- Composite indexes
CREATE INDEX idx_transactions_date_type ON transactions(created_at, transaction_type);
CREATE INDEX idx_customers_name_email ON customers(last_name, first_name, email);

-- Partial indexes
CREATE INDEX idx_active_accounts ON accounts(customer_id) WHERE status = 'ACTIVE';
CREATE INDEX idx_pending_transactions ON transactions(created_at) WHERE status = 'PENDING';
```

### Table Partitioning
```sql
-- Partitioned transactions table
CREATE TABLE transactions_partitioned (
    LIKE transactions INCLUDING ALL
) PARTITION BY RANGE (created_at);

-- Create monthly partitions
CREATE TABLE transactions_2024_01 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
CREATE TABLE transactions_2024_02 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
```

## 🔐 **Security & Compliance**

### Row-Level Security
```sql
-- Enable RLS on customers table
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

-- Policy for customer data access
CREATE POLICY customer_access_policy ON customers
    FOR ALL
    USING (auth.uid() = customer_id OR auth.role() = 'admin');
```

### Data Encryption
```sql
-- Encrypt sensitive columns
ALTER TABLE customers 
ADD COLUMN ssn_encrypted BYTEA;

-- Create encryption function
CREATE OR REPLACE FUNCTION encrypt_ssn(ssn TEXT)
RETURNS BYTEA AS $$
BEGIN
    RETURN pgp_sym_encrypt(ssn, current_setting('app.encryption_key'));
END;
$$ LANGUAGE plpgsql;
```

## 📊 **Monitoring & Maintenance**

### Database Monitoring
```sql
-- Slow query monitoring
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;

-- Table size monitoring
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Health Checks
```sql
-- Database connectivity
SELECT 1;

-- Data availability
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM transactions;

-- Replication status
SELECT pg_is_in_recovery();
SELECT * FROM pg_stat_replication;
```

## 🔄 **Migration Strategy**

### Version Control
```sql
-- Migration table
CREATE TABLE schema_migrations (
    version VARCHAR(255) PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example migration
-- V1__create_customers_table.sql
CREATE TABLE customers (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO schema_migrations (version) VALUES ('V1__create_customers_table');
```

### Zero-Downtime Migrations
- **Blue-Green Deployment**: Zero downtime
- **Feature Flags**: Gradual rollout
- **Backward Compatibility**: Schema evolution
- **Rollback Strategy**: Quick rollback

## 📚 **Documentation Standards**

### Schema Documentation
- **Table Descriptions**: Purpose và usage
- **Column Definitions**: Data types và constraints
- **Relationship Diagrams**: Foreign key relationships
- **Index Documentation**: Performance optimization

### Migration Documentation
- **Change Log**: Version history
- **Rollback Scripts**: Revert changes
- **Testing Procedures**: Validation steps
- **Deployment Notes**: Environment-specific notes

---

*Database documentation được thiết kế để hỗ trợ developers và DBAs trong việc quản lý và tối ưu hóa cơ sở dữ liệu của hệ thống ngân hàng EXB.*
