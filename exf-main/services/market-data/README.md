### market-data

Trách nhiệm
- Feed handlers (vendor/native), normalization, consolidation
- Phát L1/L2, trade tape; lưu lịch sử

API/Streams
- WebSocket: /ws/market-data (BBO, depth)
- Kafka: quotes, book, trades

Dữ liệu sở hữu
- Quotes, Books, Trades (TimescaleDB/InfluxDB)


