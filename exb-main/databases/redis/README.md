# Redis Caches

Cấu hình và quản lý Redis caches cho hệ thống EXB.

## 📁 Cấu trúc

```
redis/
├── cache/             # Application cache
├── session/           # Session storage
├── rate-limit/        # Rate limiting
└── streams/           # Event streams
```

## 🏗️ Kiến trúc

- **Redis**: 7.2+
- **Clustering**: Redis Cluster
- **Persistence**: RDB + AOF
- **Security**: ACL, TLS
- **Monitoring**: Redis INFO, Prometheus

## 📋 Thành phần chính

### Cache
- Application data caching
- Database query results
- API responses
- Static content
- Configuration data

### Session
- User sessions
- Authentication tokens
- Temporary data
- Shopping carts
- Form data

### Rate Limit
- API rate limiting
- User quotas
- DDoS protection
- Throttling rules
- Usage tracking

### Streams
- Event streaming
- Message queues
- Real-time data
- Log aggregation
- Analytics events

## 🚀 Setup

```bash
# Start Redis
redis-server redis.conf

# Connect to Redis
redis-cli

# Setup clustering
redis-cli --cluster create

# Configure persistence
redis-cli config set save "900 1"
```

## 📊 Performance

- Memory optimization
- Connection pooling
- Pipeline operations
- Lua scripting
- Key expiration

## 🔒 Bảo mật

- Access control lists
- TLS encryption
- Network security
- Key isolation
- Audit logging

## 📈 Monitoring

- Memory usage
- Connection count
- Command statistics
- Hit/miss ratios
- Replication status

## 🔄 High Availability

- Redis Sentinel
- Redis Cluster
- Replication
- Failover
- Backup strategies
