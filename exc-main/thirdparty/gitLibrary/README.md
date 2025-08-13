# Git Library References

Thư mục này chứa các tham chiếu và nghiên cứu từ các dự án mã nguồn mở có liên quan đến crypto exchange.

## 📚 Referenced Projects

### 🏦 Bank-Go
- **Repository**: https://github.com/gitLibrary/Bank-Go
- **Language**: Go
- **Focus**: Banking service patterns, gRPC/REST APIs, authentication
- **Key Features**:
  - Microservices architecture
  - gRPC Gateway integration
  - SQLC for type-safe database access
  - OAuth2/OIDC authentication
  - Event-driven architecture

#### 🎯 Learning Objectives
- **Authentication Patterns**: OAuth2/OIDC implementation
- **gRPC Gateway**: REST to gRPC translation
- **Database Design**: SQLC patterns for Go
- **API Design**: RESTful banking APIs
- **Event Sourcing**: Transaction event patterns

#### 📁 Implementation Guide
```go
// Example: OAuth2 implementation from Bank-Go
type OAuth2Service struct {
    clientStore    ClientStore
    tokenStore     TokenStore
    userService    UserService
    eventPublisher EventPublisher
}

func (o *OAuth2Service) Authorize(ctx context.Context, req *AuthorizeRequest) (*AuthorizeResponse, error) {
    // Validate client
    client, err := o.clientStore.GetByID(req.ClientID)
    if err != nil {
        return nil, err
    }
    
    // Generate authorization code
    code := o.generateAuthCode(client, req.UserID, req.Scope)
    
    // Publish authorization event
    o.eventPublisher.Publish("auth.authorized", &AuthorizationEvent{
        UserID: req.UserID,
        ClientID: req.ClientID,
        Scope: req.Scope,
    })
    
    return &AuthorizeResponse{Code: code}, nil
}
```

### 🔄 go_binance_futures
- **Repository**: https://github.com/gitLibrary/go_binance_futures
- **Language**: Go
- **Focus**: Binance Futures API integration, trading workflows
- **Key Features**:
  - Binance Futures API client
  - WebSocket streaming
  - Order management
  - Position tracking
  - Risk management

#### 🎯 Learning Objectives
- **Exchange Integration**: Binance API patterns
- **WebSocket Handling**: Real-time data streaming
- **Trading Workflows**: Order lifecycle management
- **Risk Management**: Position monitoring
- **Error Handling**: API error patterns

#### 📁 Implementation Guide
```go
// Example: Binance Futures client from go_binance_futures
type BinanceFuturesClient struct {
    apiKey    string
    secretKey string
    baseURL   string
    client    *http.Client
}

func (b *BinanceFuturesClient) PlaceOrder(order *FuturesOrder) (*OrderResponse, error) {
    // Build request
    params := map[string]string{
        "symbol":      order.Symbol,
        "side":        order.Side,
        "type":        order.Type,
        "quantity":    fmt.Sprintf("%.8f", order.Quantity),
        "timestamp":   fmt.Sprintf("%d", time.Now().UnixMilli()),
    }
    
    // Add optional parameters
    if order.Price > 0 {
        params["price"] = fmt.Sprintf("%.8f", order.Price)
    }
    
    // Sign request
    signature := b.signRequest(params)
    params["signature"] = signature
    
    // Send request
    resp, err := b.sendRequest("POST", "/fapi/v1/order", params)
    if err != nil {
        return nil, err
    }
    
    return b.parseOrderResponse(resp)
}
```

### ⚡ opencx
- **Repository**: https://github.com/mit-dci/opencx
- **Language**: Go
- **Focus**: Decentralized exchange, order matching, blockchain integration
- **Key Features**:
  - Decentralized order book
  - Atomic swaps
  - Multi-asset trading
  - Privacy features
  - Cross-chain trading

#### 🎯 Learning Objectives
- **Order Book Design**: Decentralized matching engine
- **Atomic Swaps**: Cross-chain trading
- **Privacy**: Zero-knowledge proofs
- **Blockchain Integration**: Multi-chain support
- **Decentralized Architecture**: P2P trading

#### 📁 Implementation Guide
```go
// Example: Order book from opencx
type OrderBook struct {
    bids *OrderTree
    asks *OrderTree
    mu   sync.RWMutex
}

func (ob *OrderBook) AddOrder(order *Order) error {
    ob.mu.Lock()
    defer ob.mu.Unlock()
    
    if order.Side == "buy" {
        return ob.bids.AddOrder(order)
    } else {
        return ob.asks.AddOrder(order)
    }
}

func (ob *OrderBook) MatchOrder(order *Order) []Trade {
    ob.mu.Lock()
    defer ob.mu.Unlock()
    
    var trades []Trade
    
    if order.Side == "buy" {
        trades = ob.matchBuyOrder(order)
    } else {
        trades = ob.matchSellOrder(order)
    }
    
    return trades
}

func (ob *OrderBook) matchBuyOrder(order *Order) []Trade {
    var trades []Trade
    
    for order.Quantity > 0 && ob.asks.Len() > 0 {
        bestAsk := ob.asks.GetBestOrder()
        
        if order.Price < bestAsk.Price {
            break // No more matches
        }
        
        // Execute trade
        tradeQuantity := math.Min(order.Quantity, bestAsk.Quantity)
        trade := Trade{
            Price:    bestAsk.Price,
            Quantity: tradeQuantity,
            Taker:    order.ID,
            Maker:    bestAsk.ID,
        }
        
        trades = append(trades, trade)
        
        // Update orders
        order.Quantity -= tradeQuantity
        bestAsk.Quantity -= tradeQuantity
        
        if bestAsk.Quantity == 0 {
            ob.asks.RemoveOrder(bestAsk.ID)
        }
    }
    
    return trades
}
```

### 🏛️ peatio
- **Repository**: https://github.com/rubykube/peatio
- **Language**: Ruby
- **Focus**: Monolithic exchange, comprehensive trading platform
- **Key Features**:
  - Complete trading platform
  - Admin interface
  - Multi-currency support
  - KYC/AML integration
  - Reporting system

#### 🎯 Learning Objectives
- **Domain Modeling**: Trading domain concepts
- **Business Logic**: Exchange operations
- **Compliance**: KYC/AML patterns
- **Reporting**: Financial reporting
- **Admin Interface**: Management tools

#### 📁 Implementation Guide
```ruby
# Example: Order model from peatio
class Order < ApplicationRecord
  belongs_to :market
  belongs_to :member
  has_many :trades, dependent: :destroy
  
  validates :ord_type, :volume, :origin_volume, :locked, :origin_locked, presence: true
  validates :price, numericality: { greater_than: 0 }, if: :limit_order?
  validates :price, absence: true, unless: :limit_order?
  
  scope :active, -> { with_state(:wait, :cancel) }
  scope :done, -> { with_state(:done, :cancel) }
  
  def compute_locked
    case ord_type
    when 'limit'
      price * volume
    when 'market'
      if side == 'sell'
        volume
      else
        estimate_required_funds
      end
    end
  end
  
  def estimate_required_funds
    funds = []
    volume_to_trade = volume
    
    OrderBook.new(market, side: 'ask').limit_orders.each do |order|
      break if volume_to_trade.zero?
      
      trade_volume = [volume_to_trade, order.volume].min
      funds << trade_volume * order.price
      volume_to_trade -= trade_volume
    end
    
    funds.sum
  end
end
```

## 🔧 Integration Patterns

### Authentication Integration
```go
// Integrate Bank-Go OAuth2 patterns
type AuthService struct {
    oauth2Service *OAuth2Service
    userService   *UserService
    tokenService  *TokenService
}

func (a *AuthService) AuthenticateUser(credentials *Credentials) (*AuthResponse, error) {
    // Validate credentials
    user, err := a.userService.ValidateCredentials(credentials)
    if err != nil {
        return nil, err
    }
    
    // Generate OAuth2 tokens
    tokens, err := a.oauth2Service.GenerateTokens(user.ID)
    if err != nil {
        return nil, err
    }
    
    // Publish authentication event
    a.eventPublisher.Publish("user.authenticated", &UserAuthenticatedEvent{
        UserID: user.ID,
        IP:     credentials.IP,
        UserAgent: credentials.UserAgent,
    })
    
    return &AuthResponse{
        AccessToken:  tokens.AccessToken,
        RefreshToken: tokens.RefreshToken,
        ExpiresIn:    tokens.ExpiresIn,
    }, nil
}
```

### Trading Engine Integration
```go
// Integrate opencx order book patterns
type TradingEngine struct {
    orderBooks map[string]*OrderBook
    marketData *MarketDataService
    riskEngine *RiskEngine
    eventBus   *EventBus
}

func (te *TradingEngine) PlaceOrder(order *Order) (*OrderResponse, error) {
    // Risk checks
    if err := te.riskEngine.ValidateOrder(order); err != nil {
        return nil, err
    }
    
    // Get order book
    orderBook := te.orderBooks[order.Symbol]
    if orderBook == nil {
        return nil, errors.New("market not found")
    }
    
    // Add order to book
    if err := orderBook.AddOrder(order); err != nil {
        return nil, err
    }
    
    // Match orders
    trades := orderBook.MatchOrder(order)
    
    // Publish events
    for _, trade := range trades {
        te.eventBus.Publish("trade.executed", &TradeExecutedEvent{
            Trade: trade,
        })
    }
    
    return &OrderResponse{
        OrderID: order.ID,
        Status:  order.Status,
        Trades:  trades,
    }, nil
}
```

### Exchange Integration
```go
// Integrate go_binance_futures patterns
type ExchangeAdapter struct {
    binanceClient *BinanceFuturesClient
    orderManager  *OrderManager
    positionManager *PositionManager
}

func (ea *ExchangeAdapter) SyncOrders(symbol string) error {
    // Get open orders from exchange
    orders, err := ea.binanceClient.GetOpenOrders(symbol)
    if err != nil {
        return err
    }
    
    // Update local order manager
    for _, order := range orders {
        ea.orderManager.UpdateOrder(order)
    }
    
    return nil
}

func (ea *ExchangeAdapter) SyncPositions() error {
    // Get positions from exchange
    positions, err := ea.binanceClient.GetPositions()
    if err != nil {
        return err
    }
    
    // Update local position manager
    for _, position := range positions {
        ea.positionManager.UpdatePosition(position)
    }
    
    return nil
}
```

## 📊 Monitoring & Observability

### Metrics from Referenced Projects
```go
// Bank-Go inspired metrics
var (
    authRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "auth_requests_total",
            Help: "Total authentication requests",
        },
        []string{"method", "status"},
    )
    
    orderMatchingLatency = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "order_matching_latency_seconds",
            Help: "Order matching latency",
        },
        []string{"symbol", "order_type"},
    )
    
    exchangeAPILatency = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "exchange_api_latency_seconds",
            Help: "Exchange API latency",
        },
        []string{"exchange", "endpoint"},
    )
)
```

### Logging Patterns
```go
// Peatio inspired logging
type Logger struct {
    logger *zap.Logger
}

func (l *Logger) LogOrder(order *Order) {
    l.logger.Info("order_placed",
        zap.String("order_id", order.ID),
        zap.String("symbol", order.Symbol),
        zap.String("side", order.Side),
        zap.Float64("price", order.Price),
        zap.Float64("quantity", order.Quantity),
        zap.String("user_id", order.UserID),
    )
}

func (l *Logger) LogTrade(trade *Trade) {
    l.logger.Info("trade_executed",
        zap.String("trade_id", trade.ID),
        zap.String("symbol", trade.Symbol),
        zap.Float64("price", trade.Price),
        zap.Float64("quantity", trade.Quantity),
        zap.String("taker_order_id", trade.TakerOrderID),
        zap.String("maker_order_id", trade.MakerOrderID),
    )
}
```

## 🧪 Testing Strategies

### Unit Testing Patterns
```go
// Bank-Go inspired testing
func TestOAuth2Service_Authorize(t *testing.T) {
    // Setup
    mockClientStore := &MockClientStore{}
    mockTokenStore := &MockTokenStore{}
    mockUserService := &MockUserService{}
    
    service := &OAuth2Service{
        clientStore: mockClientStore,
        tokenStore:  mockTokenStore,
        userService: mockUserService,
    }
    
    // Expectations
    mockClientStore.On("GetByID", "client123").Return(&Client{ID: "client123"}, nil)
    mockUserService.On("ValidateUser", "user123").Return(&User{ID: "user123"}, nil)
    
    // Test
    req := &AuthorizeRequest{
        ClientID: "client123",
        UserID:   "user123",
        Scope:    "read write",
    }
    
    resp, err := service.Authorize(context.Background(), req)
    
    // Assertions
    assert.NoError(t, err)
    assert.NotEmpty(t, resp.Code)
    mockClientStore.AssertExpectations(t)
}
```

### Integration Testing
```go
// opencx inspired integration tests
func TestOrderBook_Integration(t *testing.T) {
    orderBook := NewOrderBook("BTC/USDT")
    
    // Add buy order
    buyOrder := &Order{
        ID:       "buy1",
        Symbol:   "BTC/USDT",
        Side:     "buy",
        Price:    50000,
        Quantity: 1.0,
    }
    
    err := orderBook.AddOrder(buyOrder)
    assert.NoError(t, err)
    
    // Add sell order that matches
    sellOrder := &Order{
        ID:       "sell1",
        Symbol:   "BTC/USDT",
        Side:     "sell",
        Price:    50000,
        Quantity: 0.5,
    }
    
    trades := orderBook.MatchOrder(sellOrder)
    
    assert.Len(t, trades, 1)
    assert.Equal(t, 0.5, trades[0].Quantity)
    assert.Equal(t, 50000.0, trades[0].Price)
}
```

## 📚 Additional Resources

### Documentation
- [Bank-Go Documentation](https://github.com/gitLibrary/Bank-Go/wiki)
- [go_binance_futures API Reference](https://github.com/gitLibrary/go_binance_futures/blob/master/README.md)
- [opencx Whitepaper](https://github.com/mit-dci/opencx/blob/master/docs/whitepaper.md)
- [Peatio Documentation](https://github.com/rubykube/peatio/wiki)

### Community
- [Bank-Go Community](https://github.com/gitLibrary/Bank-Go/discussions)
- [opencx Discord](https://discord.gg/opencx)
- [Peatio Community](https://github.com/rubykube/peatio/discussions)

### Related Projects
- [ccxt](https://github.com/ccxt/ccxt) - Unified crypto trading API
- [binance-connector-go](https://github.com/binance/binance-connector-go) - Official Binance Go SDK
- [coinbase-pro-go](https://github.com/preichenberger/go-coinbasepro) - Coinbase Pro Go client
- [kraken-go](https://github.com/beldur/kraken-go-api-client) - Kraken Go client
