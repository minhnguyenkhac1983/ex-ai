# Trading Engine

Tối thiểu: limit order, price-time priority, order book in-memory + snapshot/restore.

Gợi ý 2025:
- Viết bằng Go/Rust; publish trades/order events lên Redpanda
- State snapshot định kỳ (Postgres/ClickHouse), recovery nhanh
- Risk checks trước khi nhận lệnh; idempotency cho submit/cancel

Endpoints hiện có:
- `GET /health`
- `GET /book` (top-of-book)
- `POST /orders` body ví dụ:
  ```json
  {"id":"1","side":"buy","price":100,"qty":1}
  ```
- Metrics: `GET /metrics` (Go/Process collectors, `te_orders_total`, `te_trades_total`)


