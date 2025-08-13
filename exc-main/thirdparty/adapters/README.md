# Custom Adapters

Thư mục này chứa các adapter tùy chỉnh để tích hợp với các hệ thống bên ngoài và xử lý dữ liệu.

## 🏗️ Adapter Architecture

```
adapters/
├── market-data/          # Market data adapters
│   ├── aggregator/       # Price aggregation logic
│   ├── normalizer/       # Data normalization
│   ├── validator/        # Data validation
│   └── publisher/        # Data publishing
├── trading/              # Trading adapters
│   ├── order-manager/    # Order management
│   ├── position-tracker/ # Position tracking
│   ├── risk-calculator/  # Risk calculations
│   └── execution/        # Order execution
└── payment/              # Payment adapters
    ├── stripe/           # Stripe integration
    ├── paypal/           # PayPal integration
    ├── crypto/           # Crypto payments
    └── bank/             # Bank transfers
```

## 📊 Market Data Adapters

### Price Aggregator
```go
type PriceAggregator struct {
    providers map[string]MarketDataProvider
    cache     cache.Cache
    publisher EventPublisher
}

func (pa *PriceAggregator) AggregatePrice(symbol string) (*AggregatedPrice, error) {
    var prices []PriceData
    var volumes []float64
    
    // Collect prices from all providers
    for name, provider := range pa.providers {
        price, err := provider.GetPrice(symbol)
        if err != nil {
            log.Warn("Failed to get price from provider", "provider", name, "error", err)
            continue
        }
        
        prices = append(prices, price)
        volumes = append(volumes, price.Volume)
    }
    
    if len(prices) == 0 {
        return nil, errors.New("no valid prices available")
    }
    
    // Calculate VWAP (Volume Weighted Average Price)
    vwap := pa.calculateVWAP(prices, volumes)
    
    // Calculate price statistics
    stats := pa.calculatePriceStats(prices)
    
    aggregated := &AggregatedPrice{
        Symbol:    symbol,
        Price:     vwap,
        Volume:    pa.sumVolumes(volumes),
        Sources:   len(prices),
        Timestamp: time.Now(),
        Statistics: stats,
    }
    
    // Cache result
    pa.cache.Set(fmt.Sprintf("price:%s", symbol), aggregated, 5*time.Second)
    
    // Publish event
    pa.publisher.Publish("price.aggregated", aggregated)
    
    return aggregated, nil
}

func (pa *PriceAggregator) calculateVWAP(prices []PriceData, volumes []float64) float64 {
    var totalValue float64
    var totalVolume float64
    
    for i, price := range prices {
        value := price.Price * volumes[i]
        totalValue += value
        totalVolume += volumes[i]
    }
    
    if totalVolume == 0 {
        return 0
    }
    
    return totalValue / totalVolume
}

func (pa *PriceAggregator) calculatePriceStats(prices []PriceData) *PriceStatistics {
    if len(prices) == 0 {
        return nil
    }
    
    var priceValues []float64
    for _, p := range prices {
        priceValues = append(priceValues, p.Price)
    }
    
    sort.Float64s(priceValues)
    
    return &PriceStatistics{
        Min:     priceValues[0],
        Max:     priceValues[len(priceValues)-1],
        Median:  pa.calculateMedian(priceValues),
        StdDev:  pa.calculateStdDev(priceValues),
        Spread:  (priceValues[len(priceValues)-1] - priceValues[0]) / priceValues[0],
    }
}
```

### Data Normalizer
```go
type DataNormalizer struct {
    rules map[string]NormalizationRule
}

type NormalizationRule struct {
    SymbolMapping map[string]string
    PriceMultiplier float64
    VolumeMultiplier float64
    DecimalPlaces int
}

func (dn *DataNormalizer) NormalizeTicker(ticker *TickerData, exchange string) *NormalizedTicker {
    rule := dn.rules[exchange]
    
    // Normalize symbol
    symbol := ticker.Symbol
    if mapped, exists := rule.SymbolMapping[ticker.Symbol]; exists {
        symbol = mapped
    }
    
    // Normalize price
    price := ticker.Price * rule.PriceMultiplier
    price = math.Round(price*math.Pow(10, float64(rule.DecimalPlaces))) / math.Pow(10, float64(rule.DecimalPlaces))
    
    // Normalize volume
    volume := ticker.Volume * rule.VolumeMultiplier
    
    return &NormalizedTicker{
        Symbol:    symbol,
        Price:     price,
        Volume:    volume,
        Exchange:  exchange,
        Timestamp: ticker.Timestamp,
    }
}
```

### Data Validator
```go
type DataValidator struct {
    rules []ValidationRule
}

type ValidationRule struct {
    Name        string
    Description string
    Validate    func(data interface{}) error
}

func (dv *DataValidator) ValidateTicker(ticker *TickerData) error {
    for _, rule := range dv.rules {
        if err := rule.Validate(ticker); err != nil {
            return fmt.Errorf("validation failed for rule %s: %w", rule.Name, err)
        }
    }
    return nil
}

// Example validation rules
var (
    PricePositiveRule = ValidationRule{
        Name:        "price_positive",
        Description: "Price must be positive",
        Validate: func(data interface{}) error {
            ticker := data.(*TickerData)
            if ticker.Price <= 0 {
                return errors.New("price must be positive")
            }
            return nil
        },
    }
    
    VolumePositiveRule = ValidationRule{
        Name:        "volume_positive",
        Description: "Volume must be positive",
        Validate: func(data interface{}) error {
            ticker := data.(*TickerData)
            if ticker.Volume < 0 {
                return errors.New("volume must be non-negative")
            }
            return nil
        },
    }
    
    PriceChangeRule = ValidationRule{
        Name:        "price_change_limit",
        Description: "Price change must be within reasonable limits",
        Validate: func(data interface{}) error {
            ticker := data.(*TickerData)
            if ticker.PriceChangePercent > 50 || ticker.PriceChangePercent < -50 {
                return errors.New("price change exceeds reasonable limits")
            }
            return nil
        },
    }
)
```

## ⚡ Trading Adapters

### Order Manager
```go
type OrderManager struct {
    orderStore OrderStore
    riskEngine RiskEngine
    eventBus   EventBus
    cache      cache.Cache
}

func (om *OrderManager) PlaceOrder(order *Order) (*OrderResponse, error) {
    // Validate order
    if err := om.validateOrder(order); err != nil {
        return nil, err
    }
    
    // Risk checks
    if err := om.riskEngine.ValidateOrder(order); err != nil {
        return nil, fmt.Errorf("risk validation failed: %w", err)
    }
    
    // Generate order ID
    order.ID = om.generateOrderID()
    order.Status = "pending"
    order.CreatedAt = time.Now()
    
    // Store order
    if err := om.orderStore.Create(order); err != nil {
        return nil, err
    }
    
    // Cache order
    om.cache.Set(fmt.Sprintf("order:%s", order.ID), order, 24*time.Hour)
    
    // Publish event
    om.eventBus.Publish("order.placed", &OrderPlacedEvent{
        Order: order,
    })
    
    return &OrderResponse{
        OrderID: order.ID,
        Status:  order.Status,
    }, nil
}

func (om *OrderManager) CancelOrder(orderID string, userID string) error {
    // Get order
    order, err := om.orderStore.GetByID(orderID)
    if err != nil {
        return err
    }
    
    // Check ownership
    if order.UserID != userID {
        return errors.New("unauthorized")
    }
    
    // Check if order can be cancelled
    if order.Status != "pending" && order.Status != "partial" {
        return errors.New("order cannot be cancelled")
    }
    
    // Update status
    order.Status = "cancelled"
    order.UpdatedAt = time.Now()
    
    // Update in store
    if err := om.orderStore.Update(order); err != nil {
        return err
    }
    
    // Publish event
    om.eventBus.Publish("order.cancelled", &OrderCancelledEvent{
        Order: order,
    })
    
    return nil
}
```

### Position Tracker
```go
type PositionTracker struct {
    positionStore PositionStore
    marketData    MarketDataService
    riskEngine    RiskEngine
    eventBus      EventBus
}

func (pt *PositionTracker) UpdatePosition(trade *Trade) error {
    // Get current position
    position, err := pt.positionStore.GetByUserAndSymbol(trade.UserID, trade.Symbol)
    if err != nil && !errors.Is(err, ErrPositionNotFound) {
        return err
    }
    
    if position == nil {
        // Create new position
        position = &Position{
            UserID:   trade.UserID,
            Symbol:   trade.Symbol,
            Side:     trade.Side,
            Quantity: trade.Quantity,
            AvgPrice: trade.Price,
        }
    } else {
        // Update existing position
        if position.Side == trade.Side {
            // Same side - increase position
            totalValue := position.Quantity*position.AvgPrice + trade.Quantity*trade.Price
            totalQuantity := position.Quantity + trade.Quantity
            position.AvgPrice = totalValue / totalQuantity
            position.Quantity = totalQuantity
        } else {
            // Opposite side - reduce position
            if trade.Quantity >= position.Quantity {
                // Close position
                position.Quantity = 0
                position.AvgPrice = 0
            } else {
                // Partial close
                position.Quantity -= trade.Quantity
            }
        }
    }
    
    // Update P&L
    if position.Quantity > 0 {
        currentPrice, err := pt.marketData.GetPrice(trade.Symbol)
        if err == nil {
            if position.Side == "long" {
                position.UnrealizedPnL = (currentPrice - position.AvgPrice) * position.Quantity
            } else {
                position.UnrealizedPnL = (position.AvgPrice - currentPrice) * position.Quantity
            }
        }
    }
    
    // Save position
    if err := pt.positionStore.Save(position); err != nil {
        return err
    }
    
    // Publish event
    pt.eventBus.Publish("position.updated", &PositionUpdatedEvent{
        Position: position,
    })
    
    return nil
}
```

## 💳 Payment Adapters

### Stripe Integration
```go
type StripeAdapter struct {
    client *stripe.Client
    config *StripeConfig
    eventBus EventBus
}

type StripeConfig struct {
    SecretKey      string
    PublishableKey string
    WebhookSecret  string
}

func (sa *StripeAdapter) CreatePaymentIntent(amount int64, currency string, metadata map[string]string) (*PaymentIntent, error) {
    params := &stripe.PaymentIntentParams{
        Amount:   stripe.Int64(amount),
        Currency: stripe.String(currency),
        Metadata: metadata,
    }
    
    intent, err := sa.client.PaymentIntents.New(params)
    if err != nil {
        return nil, err
    }
    
    return &PaymentIntent{
        ID:     intent.ID,
        Amount: intent.Amount,
        Status: string(intent.Status),
    }, nil
}

func (sa *StripeAdapter) ProcessWebhook(payload []byte, signature string) (*WebhookEvent, error) {
    event, err := webhook.ConstructEvent(payload, signature, sa.config.WebhookSecret)
    if err != nil {
        return nil, err
    }
    
    switch event.Type {
    case "payment_intent.succeeded":
        var paymentIntent stripe.PaymentIntent
        err := json.Unmarshal(event.Data.Raw, &paymentIntent)
        if err != nil {
            return nil, err
        }
        
        // Publish event
        sa.eventBus.Publish("payment.succeeded", &PaymentSucceededEvent{
            PaymentIntentID: paymentIntent.ID,
            Amount:          paymentIntent.Amount,
            Currency:        paymentIntent.Currency,
            Metadata:        paymentIntent.Metadata,
        })
        
    case "payment_intent.payment_failed":
        var paymentIntent stripe.PaymentIntent
        err := json.Unmarshal(event.Data.Raw, &paymentIntent)
        if err != nil {
            return nil, err
        }
        
        // Publish event
        sa.eventBus.Publish("payment.failed", &PaymentFailedEvent{
            PaymentIntentID: paymentIntent.ID,
            Error:           paymentIntent.LastPaymentError.Message,
        })
    }
    
    return &WebhookEvent{
        Type: event.Type,
        ID:   event.ID,
    }, nil
}
```

### Crypto Payment Adapter
```go
type CryptoPaymentAdapter struct {
    bitcoinClient  *bitcoin.Client
    ethereumClient *ethereum.Client
    eventBus       EventBus
}

func (cpa *CryptoPaymentAdapter) CreatePayment(amount float64, currency string, address string) (*CryptoPayment, error) {
    var client CryptoClient
    var network string
    
    switch currency {
    case "BTC":
        client = cpa.bitcoinClient
        network = "bitcoin"
    case "ETH":
        client = cpa.ethereumClient
        network = "ethereum"
    default:
        return nil, fmt.Errorf("unsupported currency: %s", currency)
    }
    
    // Create payment
    payment, err := client.CreatePayment(amount, address)
    if err != nil {
        return nil, err
    }
    
    return &CryptoPayment{
        ID:       payment.ID,
        Amount:   amount,
        Currency: currency,
        Address:  address,
        Network:  network,
        Status:   "pending",
    }, nil
}

func (cpa *CryptoPaymentAdapter) CheckPaymentStatus(paymentID string, currency string) (*PaymentStatus, error) {
    var client CryptoClient
    
    switch currency {
    case "BTC":
        client = cpa.bitcoinClient
    case "ETH":
        client = cpa.ethereumClient
    default:
        return nil, fmt.Errorf("unsupported currency: %s", currency)
    }
    
    status, err := client.GetPaymentStatus(paymentID)
    if err != nil {
        return nil, err
    }
    
    return &PaymentStatus{
        PaymentID: paymentID,
        Status:    status.Status,
        Confirmations: status.Confirmations,
        BlockHeight:   status.BlockHeight,
    }, nil
}
```

## 🔧 Configuration

### Adapter Configuration
```yaml
adapters:
  market_data:
    aggregator:
      enabled: true
      providers:
        - binance
        - coinbase
        - kraken
      cache_ttl: 5s
      min_providers: 2
    
    normalizer:
      enabled: true
      rules:
        binance:
          price_multiplier: 1.0
          volume_multiplier: 1.0
          decimal_places: 8
        coinbase:
          price_multiplier: 1.0
          volume_multiplier: 1.0
          decimal_places: 8
    
    validator:
      enabled: true
      rules:
        - price_positive
        - volume_positive
        - price_change_limit
  
  trading:
    order_manager:
      enabled: true
      max_orders_per_user: 100
      order_ttl: 24h
    
    position_tracker:
      enabled: true
      update_interval: 1s
  
  payment:
    stripe:
      enabled: true
      secret_key: ${STRIPE_SECRET_KEY}
      publishable_key: ${STRIPE_PUBLISHABLE_KEY}
      webhook_secret: ${STRIPE_WEBHOOK_SECRET}
    
    crypto:
      enabled: true
      bitcoin:
        network: mainnet
        rpc_url: ${BITCOIN_RPC_URL}
      ethereum:
        network: mainnet
        rpc_url: ${ETHEREUM_RPC_URL}
```

## 🧪 Testing

### Unit Tests
```go
func TestPriceAggregator_AggregatePrice(t *testing.T) {
    // Setup
    mockProvider1 := &MockMarketDataProvider{}
    mockProvider2 := &MockMarketDataProvider{}
    
    aggregator := &PriceAggregator{
        providers: map[string]MarketDataProvider{
            "provider1": mockProvider1,
            "provider2": mockProvider2,
        },
    }
    
    // Expectations
    mockProvider1.On("GetPrice", "BTC/USDT").Return(&PriceData{
        Price: 50000,
        Volume: 100,
    }, nil)
    
    mockProvider2.On("GetPrice", "BTC/USDT").Return(&PriceData{
        Price: 50100,
        Volume: 200,
    }, nil)
    
    // Test
    result, err := aggregator.AggregatePrice("BTC/USDT")
    
    // Assertions
    assert.NoError(t, err)
    assert.Equal(t, 50066.67, result.Price) // VWAP calculation
    assert.Equal(t, 300.0, result.Volume)
    assert.Equal(t, 2, result.Sources)
}
```

### Integration Tests
```go
func TestStripeAdapter_Integration(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping integration test")
    }
    
    adapter := &StripeAdapter{
        client: stripe.New("sk_test_..."),
    }
    
    // Test payment intent creation
    intent, err := adapter.CreatePaymentIntent(1000, "usd", map[string]string{
        "user_id": "user123",
    })
    
    assert.NoError(t, err)
    assert.NotEmpty(t, intent.ID)
    assert.Equal(t, int64(1000), intent.Amount)
}
```

## 📊 Monitoring

### Metrics
```go
var (
    adapterRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "adapter_requests_total",
            Help: "Total adapter requests",
        },
        []string{"adapter", "method", "status"},
    )
    
    adapterLatencySeconds = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "adapter_latency_seconds",
            Help: "Adapter request latency",
        },
        []string{"adapter", "method"},
    )
    
    priceAggregationErrors = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "price_aggregation_errors_total",
            Help: "Total price aggregation errors",
        },
        []string{"symbol", "provider"},
    )
)
```

### Health Checks
```go
func (pa *PriceAggregator) HealthCheck() *HealthStatus {
    status := &HealthStatus{
        Status: "healthy",
        Timestamp: time.Now(),
    }
    
    // Check providers
    for name, provider := range pa.providers {
        if err := provider.HealthCheck(); err != nil {
            status.Status = "unhealthy"
            status.Errors = append(status.Errors, fmt.Sprintf("provider %s: %v", name, err))
        }
    }
    
    return status
}
```

## 🔒 Security

### API Key Management
```go
type SecureAdapter struct {
    vaultClient *vault.Client
    cache       cache.Cache
}

func (sa *SecureAdapter) GetAPIKey(adapter string) (string, error) {
    // Check cache first
    if key, found := sa.cache.Get(fmt.Sprintf("apikey:%s", adapter)); found {
        return key.(string), nil
    }
    
    // Get from Vault
    secret, err := sa.vaultClient.Logical().Read(fmt.Sprintf("secret/apikeys/%s", adapter))
    if err != nil {
        return "", err
    }
    
    key := secret.Data["key"].(string)
    
    // Cache for 1 hour
    sa.cache.Set(fmt.Sprintf("apikey:%s", adapter), key, time.Hour)
    
    return key, nil
}
```

### Data Encryption
```go
func (pa *PriceAggregator) encryptSensitiveData(data []byte) ([]byte, error) {
    key := []byte(os.Getenv("ENCRYPTION_KEY"))
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }
    
    ciphertext := make([]byte, aes.BlockSize+len(data))
    iv := ciphertext[:aes.BlockSize]
    if _, err := io.ReadFull(rand.Reader, iv); err != nil {
        return nil, err
    }
    
    stream := cipher.NewCFBEncrypter(block, iv)
    stream.XORKeyStream(ciphertext[aes.BlockSize:], data)
    
    return ciphertext, nil
}
```

## 📚 Resources

- [Stripe API Documentation](https://stripe.com/docs/api)
- [Bitcoin RPC API](https://developer.bitcoin.org/reference/rpc/)
- [Ethereum JSON-RPC](https://ethereum.org/en/developers/docs/apis/json-rpc/)
- [WebSocket Best Practices](https://websocket.org/echo.html)
- [Cache Patterns](https://redis.io/topics/patterns)
