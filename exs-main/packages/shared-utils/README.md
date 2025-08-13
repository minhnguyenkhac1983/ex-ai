# Shared Utilities - Securities Exchange System

## Overview
Common utility functions, helpers, and tools shared across all services in the Securities Exchange System.

## Utilities

### Date/Time Utilities
- **Market Hours**: Trading session calculations
- **Settlement Dates**: T+2 settlement processing
- **Timezone Handling**: Multi-timezone support
- **Date Formatting**: Standardized date formats

### Financial Utilities
- **Price Calculations**: Rounding, tick sizes, spreads
- **Quantity Validation**: Lot sizes, minimum quantities
- **Currency Conversion**: Multi-currency support
- **P&L Calculations**: Realized and unrealized gains/losses

### Validation Utilities
- **Input Validation**: Common validation patterns
- **Business Rules**: Trading rule enforcement
- **Data Sanitization**: Input cleaning and normalization
- **Format Validation**: Email, phone, ID formats

### Logging & Monitoring
- **Structured Logging**: JSON log formatting
- **Metrics Collection**: Performance monitoring
- **Error Handling**: Standardized error responses
- **Audit Trail**: Compliance logging

### Security Utilities
- **Encryption**: Data encryption/decryption
- **Hashing**: Password and data hashing
- **JWT Handling**: Token generation and validation
- **Rate Limiting**: API rate limiting utilities

## Usage

### Java/Kotlin
```java
// Maven dependency
<dependency>
    <groupId>com.exs</groupId>
    <artifactId>shared-utils</artifactId>
    <version>1.0.0</version>
</dependency>

// Usage
import com.exs.shared.utils.DateTimeUtils;
import com.exs.shared.utils.PriceUtils;
```

### Go
```go
// Go module
go get github.com/exs/packages/shared-utils

// Usage
import "github.com/exs/packages/shared-utils/datetime"
import "github.com/exs/packages/shared-utils/price"
```

### TypeScript
```typescript
// NPM package
npm install @exs/shared-utils

// Usage
import { DateTimeUtils, PriceUtils } from '@exs/shared-utils';
```

## Examples

### Price Calculations
```typescript
import { PriceUtils } from '@exs/shared-utils';

const price = PriceUtils.roundToTick(150.123, 0.01); // 150.12
const isValid = PriceUtils.validatePrice(150.50, 100, 200); // true
```

### Date/Time Operations
```typescript
import { DateTimeUtils } from '@exs/shared-utils';

const isTradingHours = DateTimeUtils.isTradingHours(new Date());
const settlementDate = DateTimeUtils.getSettlementDate(new Date(), 2); // T+2
```

### Validation
```typescript
import { ValidationUtils } from '@exs/shared-utils';

const isValidOrder = ValidationUtils.validateOrder({
    symbol: 'AAPL',
    quantity: 100,
    price: 150.50
});
```

## Configuration
- **Environment Variables**: Configurable parameters
- **Feature Flags**: Runtime feature toggles
- **Performance Tuning**: Optimizable settings
- **Localization**: Multi-language support

## Testing
- **Unit Tests**: Comprehensive test coverage
- **Integration Tests**: Cross-service testing
- **Performance Tests**: Load and stress testing
- **Security Tests**: Vulnerability scanning

## Contributing
- **New Utilities**: Add with comprehensive tests
- **Documentation**: Update usage examples
- **Performance**: Optimize for high-frequency usage
- **Security**: Follow security best practices
