# Modern Architectures (EXS Recommendations)

## Principles
- Domain-first (DDD), security-by-design, observability-by-default, platform thinking
- Async-first, contract-first (AsyncAPI/Protobuf/Avro/GraphQL SDL)

## Architecture Building Blocks
- Event-Driven Microservices (Kafka/Redpanda/NATS). Use outbox/inbox, schema registry, idempotency keys
- CQRS + Event Sourcing for critical domains (orders, trades). Snapshotting strategies
- Saga patterns (orchestration/choreography) for cross-service transactions
- BFF for web/mobile; API Gateway for external exposure; rate limiting and auth at the edge
- Service Mesh for mTLS, retries, timeouts, circuit breakers, traffic shifting
- Data Mesh & Lakehouse (Iceberg/Delta/Hudi) for analytics contracts and CDC via Debezium
- Real-time analytics via ClickHouse/Pinot + streaming compute (Flink/Spark). Materialized views

## Observability
- OpenTelemetry SDK + Collector. Propagate trace context through messaging
- Metrics: RED/USE. Dashboards and SLOs with alerting
- Logs: structured JSON; correlation with traceId

## Security
- OIDC/OAuth2.1, mTLS everywhere, FAPI baseline, WebAuthn/Passkeys
- Secrets management with Vault/CSI; SBOM, signing (Cosign), SLSA levels
- Policy-as-code (OPA/Kyverno), default-deny network policies

## Delivery & Platform
- GitOps (ArgoCD). Progressive delivery (Argo Rollouts). Helm/Kustomize
- Golden paths via templates; Backstage as IDP
- Automated quality gates, supply chain attestations

## Reference Tech Choices
- Messaging: Kafka (KRaft)/Redpanda, NATS JetStream
- APIs: REST + gRPC; GraphQL for aggregation; AsyncAPI for events
- Storage: PostgreSQL, Redis, ClickHouse; optional Elastic, Cassandra
- Infra: Kubernetes, Istio/Linkerd, Prometheus, Grafana, Loki, Tempo, OTel

## Migration Path
1. Start with microservices using DDD + Hexagonal + CQRS
2. Introduce Kafka and outbox pattern for domain events
3. Add OTel, metrics, tracing, dashboards, SLOs
4. Add service mesh for mTLS and resilience
5. Add BFF and, if needed, micro-frontend shell
6. Evolve towards event sourcing where auditability is critical
