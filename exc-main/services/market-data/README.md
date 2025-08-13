# Market Data Service

Chức năng: phát realtime ticks/order book qua WebSocket/SSE; lưu candles/ticks vào ClickHouse/TimescaleDB.

Gợi ý 2025:
- Consume trades/orders từ Redpanda, build MV với Materialize hoặc stream processing với Flink/RisingWave
- Tail-based sampling cho đường đi nóng, expose metrics Prometheus

Kết nối upstream (tuỳ chọn):
- Binance trade stream: bật biến môi trường `MD_BINANCE_ENABLE=1` và `MD_BINANCE_SYMBOL=btcusdt` để re-broadcast trade làm tick qua WS.
 - Redpanda/Kafka publish: đặt `MD_KAFKA_BROKERS=redpanda:9092` và `MD_KAFKA_TOPIC=md.ticks` để gửi ticks.


