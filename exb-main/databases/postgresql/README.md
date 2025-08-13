# PostgreSQL Databases

Cấu hình và quản lý PostgreSQL databases cho hệ thống EXB.

## 📁 Cấu trúc

```
postgresql/
├── core-banking/      # Core banking databases
├── lending/          # Lending databases
├── cards/            # Card management databases
└── security/         # Security databases
```

## 🏗️ Kiến trúc

- **PostgreSQL**: 16/17+
- **Extensions**: pgvector, pg_stat_statements
- **Replication**: Logical replication
- **Backup**: WAL archiving, Point-in-time recovery
- **Security**: Row-level security, encryption

## 📋 Thành phần chính

### Core Banking
- Customer data
- Account information
- Transaction history
- Payment records
- Audit logs

### Lending
- Loan applications
- Credit assessments
- Payment schedules
- Collection records
- Risk data

### Cards
- Card information
- Authorization logs
- Transaction records
- PIN management
- Security events

### Security
- User authentication
- Access logs
- Audit trails
- Encryption keys
- Compliance data

## 🚀 Setup

```bash
# Initialize database
psql -f init.sql

# Run migrations
psql -f migrations/001_init.sql

# Setup replication
psql -f replication/setup.sql

# Configure backup
psql -f backup/configure.sql
```

## 📊 Performance

- Connection pooling
- Query optimization
- Index management
- Partitioning
- Vacuum maintenance

## 🔒 Bảo mật

- Row-level security
- Column encryption
- Access control
- Audit logging
- Data masking

## 📈 Monitoring

- Query performance
- Connection metrics
- Disk usage
- Replication lag
- Backup status

## 🔄 Backup & Recovery

- Automated backups
- Point-in-time recovery
- Disaster recovery
- Data retention
- Compliance archiving
