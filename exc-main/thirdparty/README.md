# Third-party Integrations & References

Thư mục này chứa các tích hợp và tham chiếu từ bên thứ ba cho dự án EXC.

## 📚 Tham chiếu dự án mã nguồn mở

### 🏦 Banking & Financial Services
- **gitLibrary/Bank-Go**: Mẫu dịch vụ ngân hàng (Go, gRPC/REST, sqlc, auth) - hữu ích cho patterns auth, gRPC gateway
- **gitLibrary/go_binance_futures**: Workflows thao tác Binance Futures - tham chiếu adapter sàn
- **gitLibrary/opencx**: Sàn phi tập trung (Go) - tham chiếu khớp lệnh/orderbook
- **gitLibrary/peatio**: Exchange monolith (Ruby) - tham chiếu domain/ops

### 🔄 Trading & Exchange
- **go-exchange**: Trading engine patterns
- **go-trader**: Trading algorithms
- **golang-crypto-marketplace**: Marketplace implementation

## 🎯 Định hướng tích hợp

### 📊 Market Data
- Viết adapter kéo dữ liệu upstream (Binance, Coinbase, Kraken)
- Publish vào Kafka/Redpanda hoặc trực tiếp phát WebSocket
- Xem `services/market-data/src/connectors/*` để bắt đầu adapter

### ⚡ Trading & Risk
- Tham chiếu thuật toán matching/risk từ opencx
- Implement order book management
- Risk management patterns

### 🔐 Authentication & Security
- OAuth2/OIDC patterns từ Bank-Go
- JWT token management
- API security best practices

### 🗄️ Database & Storage
- SQLC patterns cho type-safe database access
- Migration strategies
- Caching patterns

## 📁 Cấu trúc thư mục

```
thirdparty/
├── exchanges/              # Exchange API integrations
│   ├── binance/           # Binance API adapter
│   ├── coinbase/          # Coinbase API adapter
│   ├── kraken/            # Kraken API adapter
│   └── common/            # Common exchange interfaces
├── gitLibrary/            # Git library references
│   ├── Bank-Go/           # Banking service patterns
│   ├── go_binance_futures/ # Binance futures integration
│   ├── opencx/            # Decentralized exchange
│   └── peatio/            # Monolithic exchange
└── adapters/              # Custom adapters
    ├── market-data/        # Market data adapters
    ├── trading/            # Trading adapters
    └── payment/            # Payment adapters
```

## 🚀 Implementation Guidelines

### Market Data Adapters
```go
// Example: Binance adapter
type BinanceAdapter struct {
    client *binance.Client
    kafka  kafka.Producer
}

func (b *BinanceAdapter) StreamTicker(symbol string) {
    // Stream real-time data
    // Publish to Kafka
    // Broadcast via WebSocket
}
```

### Trading Engine Integration
```go
// Example: Order book from opencx
type OrderBook struct {
    Bids map[float64]float64
    Asks map[float64]float64
}

func (ob *OrderBook) MatchOrder(order Order) []Trade {
    // Implement matching algorithm
    // Return executed trades
}
```

## 📋 Checklist tích hợp

- [ ] **Market Data**: Binance, Coinbase, Kraken adapters
- [ ] **Trading Engine**: Order book, matching engine
- [ ] **Authentication**: OAuth2/OIDC implementation
- [ ] **Database**: SQLC setup, migrations
- [ ] **Monitoring**: Metrics, logging, tracing
- [ ] **Testing**: Unit tests, integration tests
- [ ] **Documentation**: API docs, deployment guides

## 🔗 Useful Links

- [Binance API Documentation](https://binance-docs.github.io/apidocs/)
- [Coinbase API Documentation](https://docs.cloud.coinbase.com/)
- [Kraken API Documentation](https://www.kraken.com/features/api)
- [OpenCX GitHub](https://github.com/mit-dci/opencx)
- [Peatio GitHub](https://github.com/rubykube/peatio)

## 📝 Notes

- Tất cả adapters phải tuân theo interface chung
- Implement proper error handling và retry logic
- Add comprehensive logging và monitoring
- Follow security best practices cho API keys
- Implement rate limiting để tránh API quota issues

