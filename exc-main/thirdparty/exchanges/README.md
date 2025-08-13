# Exchange Integrations

Thư mục này chứa các tích hợp với các sàn giao dịch bên ngoài để cung cấp liquidity và market data.

## 📊 Supported Exchanges

### 🟡 Binance
- **API Documentation**: https://binance-docs.github.io/apidocs/
- **Features**: Spot trading, Futures, Options
- **Rate Limits**: 1200 requests/minute (signed), 2400 requests/minute (unsigned)
- **WebSocket**: Real-time market data, user data streams

### 🔵 Coinbase
- **API Documentation**: https://docs.cloud.coinbase.com/
- **Features**: Spot trading, Advanced Trade API
- **Rate Limits**: 3 requests/second (public), 10 requests/second (private)
- **WebSocket**: Real-time market data feeds

### 🟠 Kraken
- **API Documentation**: https://www.kraken.com/features/api
- **Features**: Spot trading, Futures, Staking
- **Rate Limits**: 15 requests/10 seconds (public), 20 requests/10 seconds (private)
- **WebSocket**: Real-time market data, user data

## 🏗️ Architecture

```
exchanges/
├── common/              # Common interfaces và utilities
│   ├── types.go         # Shared data types
│   ├── client.go        # Base HTTP client
│   ├── websocket.go     # WebSocket base implementation
│   └── rate_limiter.go  # Rate limiting utilities
├── binance/             # Binance integration
│   ├── client.go        # Binance API client
│   ├── websocket.go     # Binance WebSocket streams
│   ├── types.go         # Binance-specific types
│   └── adapter.go       # Market data adapter
├── coinbase/            # Coinbase integration
│   ├── client.go        # Coinbase API client
│   ├── websocket.go     # Coinbase WebSocket streams
│   ├── types.go         # Coinbase-specific types
│   └── adapter.go       # Market data adapter
└── kraken/              # Kraken integration
    ├── client.go        # Kraken API client
    ├── websocket.go     # Kraken WebSocket streams
    ├── types.go         # Kraken-specific types
    └── adapter.go       # Market data adapter
```

## 🔌 Common Interfaces

### Market Data Interface
```go
type MarketDataProvider interface {
    // Subscribe to real-time market data
    SubscribeTicker(symbol string) (<-chan TickerData, error)
    SubscribeOrderBook(symbol string) (<-chan OrderBookData, error)
    SubscribeTrades(symbol string) (<-chan TradeData, error)
    
    // Get historical data
    GetKlines(symbol string, interval string, limit int) ([]KlineData, error)
    GetOrderBook(symbol string, depth int) (*OrderBook, error)
    
    // Close connections
    Close() error
}
```

### Trading Interface
```go
type TradingProvider interface {
    // Account information
    GetAccountInfo() (*AccountInfo, error)
    GetBalances() ([]Balance, error)
    
    // Order management
    PlaceOrder(order *OrderRequest) (*OrderResponse, error)
    CancelOrder(symbol, orderID string) error
    GetOrder(symbol, orderID string) (*Order, error)
    GetOpenOrders(symbol string) ([]Order, error)
    
    // Position management (for futures)
    GetPositions() ([]Position, error)
    UpdatePosition(symbol string, side string, size float64) error
}
```

## 🚀 Implementation Examples

### Binance Market Data Adapter
```go
type BinanceAdapter struct {
    client     *binance.Client
    wsClient   *binance.WebSocketClient
    kafka      kafka.Producer
    rateLimiter *rate.Limiter
}

func (b *BinanceAdapter) StreamTicker(symbol string) {
    // Subscribe to ticker stream
    tickerChan := b.wsClient.SubscribeTicker(symbol)
    
    for ticker := range tickerChan {
        // Normalize data format
        normalized := b.normalizeTicker(ticker)
        
        // Publish to Kafka
        b.kafka.Produce("market-data.ticker", normalized)
        
        // Broadcast via WebSocket
        b.broadcastWebSocket("ticker", normalized)
    }
}
```

### Coinbase Order Book Adapter
```go
type CoinbaseAdapter struct {
    client     *coinbase.Client
    wsClient   *coinbase.WebSocketClient
    orderBooks map[string]*OrderBook
}

func (c *CoinbaseAdapter) MaintainOrderBook(symbol string) {
    // Subscribe to order book updates
    updates := c.wsClient.SubscribeOrderBook(symbol)
    
    for update := range updates {
        // Update local order book
        c.orderBooks[symbol].ApplyUpdate(update)
        
        // Publish to Kafka
        c.kafka.Produce("market-data.orderbook", c.orderBooks[symbol])
    }
}
```

## 📈 Market Data Aggregation

### Price Normalization
```go
type PriceAggregator struct {
    providers map[string]MarketDataProvider
    prices    map[string]*AggregatedPrice
}

func (pa *PriceAggregator) AggregatePrice(symbol string) *AggregatedPrice {
    var prices []float64
    
    for _, provider := range pa.providers {
        ticker, err := provider.GetTicker(symbol)
        if err == nil {
            prices = append(prices, ticker.Price)
        }
    }
    
    return &AggregatedPrice{
        Symbol: symbol,
        Price:  pa.calculateVWAP(prices),
        Volume: pa.calculateTotalVolume(prices),
        Sources: len(prices),
    }
}
```

### Arbitrage Detection
```go
type ArbitrageDetector struct {
    exchanges map[string]TradingProvider
    threshold float64
}

func (ad *ArbitrageDetector) DetectArbitrage(symbol string) []ArbitrageOpportunity {
    var opportunities []ArbitrageOpportunity
    
    // Get prices from all exchanges
    prices := ad.getPrices(symbol)
    
    // Find price differences
    for i, price1 := range prices {
        for j, price2 := range prices {
            if i != j {
                spread := math.Abs(price1.Price - price2.Price) / price1.Price
                if spread > ad.threshold {
                    opportunities = append(opportunities, ArbitrageOpportunity{
                        BuyExchange:  price1.Exchange,
                        SellExchange: price2.Exchange,
                        Spread:       spread,
                        Profit:       spread * price1.Price,
                    })
                }
            }
        }
    }
    
    return opportunities
}
```

## 🔧 Configuration

### Environment Variables
```bash
# Binance
BINANCE_API_KEY=your_api_key
BINANCE_SECRET_KEY=your_secret_key
BINANCE_BASE_URL=https://api.binance.com

# Coinbase
COINBASE_API_KEY=your_api_key
COINBASE_SECRET_KEY=your_secret_key
COINBASE_BASE_URL=https://api.coinbase.com

# Kraken
KRAKEN_API_KEY=your_api_key
KRAKEN_SECRET_KEY=your_secret_key
KRAKEN_BASE_URL=https://api.kraken.com
```

### Configuration File
```yaml
exchanges:
  binance:
    enabled: true
    api_key: ${BINANCE_API_KEY}
    secret_key: ${BINANCE_SECRET_KEY}
    base_url: https://api.binance.com
    rate_limit: 1200
    websocket_url: wss://stream.binance.com:9443/ws
    
  coinbase:
    enabled: true
    api_key: ${COINBASE_API_KEY}
    secret_key: ${COINBASE_SECRET_KEY}
    base_url: https://api.coinbase.com
    rate_limit: 3
    websocket_url: wss://ws-feed.pro.coinbase.com
    
  kraken:
    enabled: true
    api_key: ${KRAKEN_API_KEY}
    secret_key: ${KRAKEN_SECRET_KEY}
    base_url: https://api.kraken.com
    rate_limit: 15
    websocket_url: wss://ws.kraken.com
```

## 🧪 Testing

### Unit Tests
```bash
# Run all exchange tests
go test ./exchanges/...

# Run specific exchange tests
go test ./exchanges/binance/...
go test ./exchanges/coinbase/...
go test ./exchanges/kraken/...
```

### Integration Tests
```bash
# Test with real API (requires API keys)
go test -tags=integration ./exchanges/...

# Test WebSocket connections
go test -tags=websocket ./exchanges/...
```

## 📊 Monitoring

### Metrics
- `exchange_requests_total`: Total API requests per exchange
- `exchange_errors_total`: Total errors per exchange
- `exchange_latency_seconds`: API response latency
- `exchange_websocket_connections`: Active WebSocket connections
- `exchange_rate_limit_remaining`: Remaining rate limit quota

### Alerts
- High error rate (>5% for 5 minutes)
- High latency (>1 second average)
- WebSocket disconnections
- Rate limit exhaustion

## 🔒 Security

### API Key Management
- Store API keys in Vault
- Rotate keys regularly
- Use least privilege principle
- Monitor API key usage

### Rate Limiting
- Implement exponential backoff
- Respect exchange rate limits
- Use connection pooling
- Monitor quota usage

### Data Validation
- Validate all incoming data
- Sanitize user inputs
- Check data integrity
- Log suspicious activities

## 📚 Resources

- [Binance API Documentation](https://binance-docs.github.io/apidocs/)
- [Coinbase API Documentation](https://docs.cloud.coinbase.com/)
- [Kraken API Documentation](https://www.kraken.com/features/api)
- [Exchange API Best Practices](https://github.com/ccxt/ccxt/wiki/Manual)
- [WebSocket Best Practices](https://websocket.org/echo.html)
