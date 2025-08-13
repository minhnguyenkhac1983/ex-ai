# Generated Client SDKs - Securities Exchange System

## Overview
Auto-generated client SDKs from Protobuf definitions for seamless integration with the Securities Exchange System APIs.

## Generated Clients

### Go Client
```bash
# Location: packages/clients/go/
# Usage:
import "github.com/exs/packages/clients/go/trading/v1"
```

### Java Client
```bash
# Location: packages/clients/java/
# Maven dependency:
<dependency>
    <groupId>com.exs</groupId>
    <artifactId>trading-client</artifactId>
    <version>1.0.0</version>
</dependency>
```

### TypeScript Client
```bash
# Location: packages/clients/typescript/
# Usage:
import { TradingServiceClient } from '@exs/trading-client';
```

## Generation
```bash
# Generate all clients
buf generate

# Generate specific language
buf generate --template buf.gen.yaml
```

## API Contracts
- **Trading Service**: Order management and execution
- **Market Data Service**: Real-time market data feeds
- **User Service**: Authentication and user management
- **Reporting Service**: Analytics and reporting APIs

## Usage Examples

### Go Example
```go
package main

import (
    "context"
    "log"
    pb "github.com/exs/packages/clients/go/trading/v1"
    "google.golang.org/grpc"
)

func main() {
    conn, err := grpc.Dial("localhost:8080", grpc.WithInsecure())
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()
    
    client := pb.NewTradingServiceClient(conn)
    // Use client...
}
```

### TypeScript Example
```typescript
import { TradingServiceClient } from '@exs/trading-client';

const client = new TradingServiceClient('http://localhost:8080');
const order = await client.submitOrder({
    symbol: 'AAPL',
    quantity: 100,
    price: 150.50,
    side: 'BUY'
});
```

## Versioning
- **Semantic Versioning**: Follows semver for API compatibility
- **Breaking Changes**: Documented in CHANGELOG.md
- **Migration Guides**: Available for major version updates

## Contributing
- **Schema Changes**: Update proto files in `proto/` directory
- **Regeneration**: Run `buf generate` after schema changes
- **Testing**: Update integration tests for new APIs
