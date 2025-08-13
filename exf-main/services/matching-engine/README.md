### matching-engine

Trách nhiệm
- Quản lý sổ lệnh theo Instrument, thuật toán Price/Time, Pro-Rata
- Khớp lệnh, tạo Trade, xuất fill

Giao tiếp
- Nhận lệnh từ trading-oms (Kafka topic orders)
- Phát TradeCreated, BookUpdated, ExecutionReport

Dữ liệu sở hữu
- OrderBook state (in-memory + snapshot), audit append-only (TSDB)

Hiệu năng
- Mục tiêu sub-100µs path, batching, lock-free structures


