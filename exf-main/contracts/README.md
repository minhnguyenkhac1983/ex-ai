### Contracts (API & Events)

Mục tiêu
- Chuẩn hóa giao tiếp giữa microservices (REST/gRPC + Kafka)
- Quản trị version: semver cho API, schema version cho events

Cấu trúc
- `contracts/api/` OpenAPI + gRPC IDL cho từng service (versioned)
- `contracts/events/` Avro/JSON Schema + AsyncAPI cho domain events/streams (versioned)
- `contracts/graphql/` schemas cho các BFF/federation (nếu áp dụng)
 - `contracts/policies/` Rego/OPA policies (authz, rate limiting, data access)

Nguyên tắc
- Backward compatible khi có thể (additive changes)
- Mỗi schema có `$id`, `version`, `eventType`, `occurredAt`, `idempotencyKey`
- Review hợp đồng trước khi triển khai (contract-first)
 - Contract tests (Pact) giữa producer/consumer


