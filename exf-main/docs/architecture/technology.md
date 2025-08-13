### Công nghệ đề xuất (theo mục tiêu hiệu năng, bảo mật và vận hành)

- Ngôn ngữ
  - Trading core: C++/Rust/Java
  - Dịch vụ xung quanh: Go/Java/Kotlin
  - Data/AI: Python/Scala

- Hạ tầng
  - Messaging: Apache Kafka (+ Schema Registry), Kafka Streams/Flink
  - API: gRPC + REST; GraphQL Federation cho read models/BFF
  - DB OLTP: PostgreSQL; Multi-region OLTP: CockroachDB; NoSQL: Cassandra/MongoDB
  - Time-series: TimescaleDB/InfluxDB; In-memory: Redis; Optional: Aerospike
  - OLAP/Lakehouse: S3/ABFS + Delta Lake/Iceberg + Trino/Presto/Spark
  - Orchestration: Kubernetes, Karpenter/Cluster Autoscaler; Service Mesh: Istio/Linkerd; API Gateway: Envoy/Kong
  - Observability: Prometheus + Thanos, Grafana, OpenTelemetry, Loki/ELK, Jaeger/Tempo, Continuous Profiling (Parca/Pyroscope)
  - Security: OIDC/OAuth2 (Keycloak/Cognito), Vault, mTLS (SPIFFE/SPIRE), WAF, OPA/Gatekeeper, Kyverno
  - GitOps: Argo CD/Flux; Supply-chain: SBOM (Syft), SLSA, Sigstore (cosign), image scanning (Trivy/Grype)
  - Stream processing: Flink/Kafka Streams; Batch: Spark
  - Data governance: Data contracts; Catalog/Lineage: DataHub/Amundsen/OpenMetadata

- Patterns
  - CQRS, Outbox/Transactional Messaging, Saga/Process Manager, Bulkhead, Circuit Breaker, Retry with jitter, Idempotency keys, Backpressure

- Triển khai & Khả dụng
  - Multi-Region Active-Active, cell-based sharding, canary/blue-green/feature flags
  - DR/BCP: RPO/RTO, immutable backups, runbooks, chaos engineering



