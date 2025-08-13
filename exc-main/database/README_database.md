# 🗄️ CRYPTO EXCHANGE DATABASE README
## Schema V2 — Multi‑Schema, Microservices‑Aligned

---

## 📋 Tổng quan

Schema V2 tổ chức database theo hướng microservices + đa schema (namespace) để tách miền nghiệp vụ, hỗ trợ multi‑tenant, dễ mở rộng và đảm bảo bảo mật/kiểm toán tốt hơn.

### 🎯 Mục tiêu thiết kế
- Scalability: Hỗ trợ hàng triệu người dùng
- Security: Mã hoá dữ liệu, audit trails, RLS
- Performance: Index hợp lý, view, trigger, seed cần thiết
- Compliance: KYC/AML, audit, báo cáo

---

## 🏗️ Kiến trúc đa schema (chính)

- `tenant` (multi‑tenant orgs), `auth` (users, roles, 2FA, API keys), `kyc`, `compliance`
- `accounts` (account types, user accounts, sub‑accounts)
- `wallet` (crypto/fiat, balances, deposits/withdrawals)
- `custody` (hot/cold/multi‑sig, key registry)
- `trading` (pairs, orders, trades, orderbook snapshots)
- `payments` (fiat methods/gateways, reconciliation)
- `fees` (tiers, user tiers, fee tx, rebates)
- `risk` (limits, alerts, exposures, circuit breakers + events)
- `margin` (accounts, positions, futures, liquidations)
- `market_data` (feeds, OHLCV partitions, ticks, stats)
- `integrations` (external APIs), `notifications`
- `audit` (audit/system logs), `admin` (settings, maintenance)
- `settlement` (settlements, clearing, netting batches/records)
- `liquidity` (pools, treasury ops, exposures)
- `accounting` (double‑entry ledger, journal/ledger, daily reconciliation)
- `reporting` (financial/regulatory reports, views)
- `api` (rate limits), `monitoring` (alerts, metrics, health), `ops` (incidents)

Chi tiết bảng: xem định nghĩa trong `database/schema_v2.sql`.

---

## 🔧 Tính năng chính

### Security
- Password hashing (bcrypt), API key hashing (SHA-256)
- AES-256 cho dữ liệu nhạy cảm (pgcrypto)
- Row Level Security (RLS), audit trails đầy đủ

### Performance
- B-tree indexes cho truy vấn phổ biến
- View và trigger cập nhật `updated_at`
- Có seed dữ liệu cơ bản (roles, currencies, pairs)

### Scalability
- Modular/microservices, sharding/partitioning thân thiện
- Read replicas, connection pooling

---

## 🚀 Triển khai

### Prerequisites
```bash
# PostgreSQL 14+
sudo apt-get install postgresql-14 postgresql-14-pgcrypto
```

### Cách 1 (khuyến nghị): dùng schema V2 (namespaced, mở rộng)
```bash
createdb exc_production
psql -d exc_production -f database/schema_v2.sql
# Xác minh các schema chính đã tạo
psql -d exc_production -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('auth','wallet','trading','risk','fees','payments','market_data','audit','admin','settlement','accounting');"
```

### Cách 2: (tuỳ chọn) — không khuyến nghị
Sử dụng các bản cũ không còn hỗ trợ. Vui lòng dùng `schema_v2.sql`.

---

## 📊 Sample queries

### User Portfolio
```sql
SELECT 
    u.email,
    c.symbol,
    uw.balance,
    uw.locked_balance
FROM auth.users u
JOIN wallet.user_wallets uw ON u.id = uw.user_id
JOIN wallet.cryptocurrencies c ON uw.cryptocurrency_id = c.id
WHERE u.id = $1;
```

### Trading Statistics (24h)
```sql
SELECT 
    tp.symbol,
    COUNT(t.id) as total_trades,
    SUM(t.quantity) as total_volume,
    AVG(t.price) as avg_price
FROM trading.trading_pairs tp
LEFT JOIN trading.orders o ON tp.id = o.trading_pair_id
LEFT JOIN trading.trades t ON tp.id = t.trading_pair_id
WHERE t.executed_at >= NOW() - INTERVAL '24 hours'
GROUP BY tp.id, tp.symbol;
```

### Risk Analysis (24h)
```sql
SELECT 
    u.email,
    COUNT(o.id) as total_orders,
    SUM(o.quantity * o.price) as total_value
FROM auth.users u
JOIN trading.orders o ON u.id = o.user_id
WHERE o.created_at >= NOW() - INTERVAL '24 hours'
GROUP BY u.id, u.email
HAVING SUM(o.quantity * o.price) > 10000;
```

---

## 🛠️ Vận hành
- Hàng ngày: backup, monitor performance, kiểm tra alerts
- Hàng tuần: phân tích slow queries, cập nhật statistics, review security logs
- Hàng tháng: full backup, archive, audit bảo mật

---

## 📚 Tài liệu liên quan
- `database/schema_v2.sql` (nguồn sự thật)

---

## ✅ Xác minh nhanh
```bash
# Liệt kê schema chính
psql -d exc_production -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('pg_catalog','information_schema') ORDER BY schema_name;"

# Liệt kê bảng theo schema trọng yếu
psql -d exc_production -c "SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema IN ('auth','wallet','trading','risk','fees','payments','market_data','audit','admin','settlement','accounting') ORDER BY table_schema, table_name;"

# Kiểm tra indexes (ví dụ schema trading)
psql -d exc_production -c "SELECT schemaname, indexname, tablename FROM pg_indexes WHERE schemaname = 'trading';"
```

---

Database đã được chuẩn hoá theo Schema V2 (đa schema, microservices‑aligned).
