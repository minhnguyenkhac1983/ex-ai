# Shared Domain Models - Securities Exchange System

## Overview
Shared domain models and business logic that are common across multiple services in the Securities Exchange System.

## Domain Models

### Trading Domain
- **Order**: Order entity with validation rules
- **Trade**: Executed trade information
- **OrderBook**: Market depth and order matching
- **Symbol**: Trading instrument definitions

### User Domain
- **User**: User account information
- **Member**: Trading member details
- **Account**: Trading account management
- **Permission**: Role-based access control

### Market Domain
- **Market**: Market session management
- **Price**: Price tick data
- **Volume**: Trading volume statistics
- **Index**: Market indices calculation

## Usage

### Java/Kotlin
```java
// Maven dependency
<dependency>
    <groupId>com.exs</groupId>
    <artifactId>shared-domain</artifactId>
    <version>1.0.0</version>
</dependency>

// Usage
import com.exs.shared.domain.trading.Order;
import com.exs.shared.domain.trading.OrderSide;
```

### Go
```go
// Go module
go get github.com/exs/packages/shared-domain

// Usage
import "github.com/exs/packages/shared-domain/trading"
```

### TypeScript
```typescript
// NPM package
npm install @exs/shared-domain

// Usage
import { Order, OrderSide } from '@exs/shared-domain';
```

## Validation Rules
- **Order Validation**: Price limits, quantity constraints
- **User Validation**: KYC requirements, trading permissions
- **Market Validation**: Trading hours, circuit breakers

## Business Logic
- **Order Matching**: Price-time priority algorithms
- **Risk Calculation**: Position limits, margin requirements
- **Settlement**: T+2 settlement processing

## Versioning
- **Backward Compatibility**: Maintained across minor versions
- **Breaking Changes**: Major version updates only
- **Migration**: Automated migration scripts provided

## Contributing
- **Domain Changes**: Update models and validation rules
- **Testing**: Comprehensive unit tests for business logic
- **Documentation**: Update API documentation for changes
