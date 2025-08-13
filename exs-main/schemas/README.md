# Event Schemas - Securities Exchange System

## Overview
Event schemas and data contracts for the event-driven architecture of the Securities Exchange System.

## Schema Types

### Avro Schemas
- **Trading Events**: Order events, trade events, market data
- **User Events**: Authentication, registration, profile updates
- **System Events**: Health checks, maintenance, alerts
- **Compliance Events**: Audit trails, regulatory reports

### JSON Schemas
- **API Contracts**: REST API request/response schemas
- **Configuration**: System configuration schemas
- **Validation**: Data validation schemas
- **Documentation**: API documentation schemas

## Event Categories

### Trading Events
```json
{
  "type": "record",
  "name": "OrderSubmitted",
  "namespace": "com.exs.trading",
  "fields": [
    {"name": "orderId", "type": "string"},
    {"name": "symbol", "type": "string"},
    {"name": "quantity", "type": "long"},
    {"name": "price", "type": "double"},
    {"name": "side", "type": "string"},
    {"name": "timestamp", "type": "long"}
  ]
}
```

### Market Data Events
```json
{
  "type": "record",
  "name": "PriceTick",
  "namespace": "com.exs.marketdata",
  "fields": [
    {"name": "symbol", "type": "string"},
    {"name": "bid", "type": "double"},
    {"name": "ask", "type": "double"},
    {"name": "last", "type": "double"},
    {"name": "volume", "type": "long"},
    {"name": "timestamp", "type": "long"}
  ]
}
```

### User Events
```json
{
  "type": "record",
  "name": "UserLogin",
  "namespace": "com.exs.user",
  "fields": [
    {"name": "userId", "type": "string"},
    {"name": "sessionId", "type": "string"},
    {"name": "ipAddress", "type": "string"},
    {"name": "userAgent", "type": "string"},
    {"name": "timestamp", "type": "long"}
  ]
}
```

## Schema Registry

### Confluent Schema Registry
```bash
# Register schema
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data @schemas/trading/OrderSubmitted.avsc \
  http://localhost:8081/subjects/trading-OrderSubmitted-value/versions

# Get schema
curl -X GET http://localhost:8081/subjects/trading-OrderSubmitted-value/versions/latest
```

### Apache Kafka Schema Registry
```bash
# Register schema
kafka-avro-console-producer \
  --broker-list localhost:9092 \
  --topic trading-events \
  --property schema.registry.url=http://localhost:8081 \
  --property value.schema=@schemas/trading/OrderSubmitted.avsc
```

## Versioning Strategy

### Backward Compatibility
- **Additive Changes**: New fields can be added
- **Optional Fields**: Existing fields remain optional
- **Default Values**: New fields have default values
- **Deprecation**: Old fields marked as deprecated

### Breaking Changes
- **Field Removal**: Requires major version bump
- **Type Changes**: Incompatible type modifications
- **Required Fields**: Making optional fields required
- **Namespace Changes**: Package/namespace modifications

## Usage Examples

### Java/Kotlin
```java
// Avro schema usage
Schema schema = new Schema.Parser().parse(new File("schemas/trading/OrderSubmitted.avsc"));
GenericRecord record = new GenericData.Record(schema);
record.put("orderId", "ORD-001");
record.put("symbol", "AAPL");
record.put("quantity", 100L);
record.put("price", 150.50);
record.put("side", "BUY");
record.put("timestamp", System.currentTimeMillis());
```

### Python
```python
# Avro schema usage
import avro.schema
from avro.datafile import DataFileWriter
from avro.io import DatumWriter

schema = avro.schema.parse(open("schemas/trading/OrderSubmitted.avsc").read())
writer = DataFileWriter(open("orders.avro", "wb"), DatumWriter(), schema)
writer.append({
    "orderId": "ORD-001",
    "symbol": "AAPL",
    "quantity": 100,
    "price": 150.50,
    "side": "BUY",
    "timestamp": int(time.time() * 1000)
})
writer.close()
```

### TypeScript
```typescript
// JSON schema validation
import Ajv from 'ajv';
import orderSchema from './schemas/trading/OrderSubmitted.json';

const ajv = new Ajv();
const validate = ajv.compile(orderSchema);

const order = {
  orderId: "ORD-001",
  symbol: "AAPL",
  quantity: 100,
  price: 150.50,
  side: "BUY",
  timestamp: Date.now()
};

const isValid = validate(order);
if (!isValid) {
  console.log(validate.errors);
}
```

## Schema Evolution

### Migration Strategy
1. **Add New Schema Version**: Create new schema with additional fields
2. **Deploy Consumer Updates**: Update consumers to handle new schema
3. **Deploy Producer Updates**: Update producers to use new schema
4. **Monitor Compatibility**: Ensure backward compatibility
5. **Cleanup Old Schemas**: Remove deprecated schemas

### Testing
- **Schema Validation**: Validate schema syntax and structure
- **Compatibility Testing**: Test backward/forward compatibility
- **Integration Testing**: Test with Kafka/event streaming
- **Performance Testing**: Test schema serialization performance

## Contributing
- **Schema Changes**: Follow versioning strategy
- **Documentation**: Update schema documentation
- **Testing**: Add comprehensive schema tests
- **Validation**: Ensure schema validation rules
