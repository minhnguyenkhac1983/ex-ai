### Kiến trúc hiện đại (khuyến nghị)

1) Hexagonal/Clean Architecture
- Ports & Adapters tách domain khỏi hạ tầng; dễ test, thay thế adapter (DB, MQ, API).

2) Event-Driven + CQRS
- Command model ghi, read model tối ưu truy vấn; Outbox + CDC đảm bảo nhất quán.

3) Saga Orchestration / Choreography
- Orchestrator (Temporal/Camunda) cho quy trình dài (clearing/settlement), choreography cho luồng nhẹ.

4) Anti-Corruption Layer (ACL)
- Bọc biên tích hợp (FIX, SWIFT, Regulator) để không rò rỉ mô hình ngoài vào domain.

5) API Gateway & BFF
- Gateway hợp nhất bảo mật, quota; BFF tối ưu payload/UI; GraphQL federation cho đọc đa domain.

6) Service Mesh
- mTLS, traffic policy, retries/timeouts/circuit breaker, telemetry chuẩn (Istio/Linkerd).

7) Data Mesh & Lakehouse
- Domain data products, hợp đồng dữ liệu; Lakehouse (Delta/Iceberg) + streaming (Flink/Kafka Streams).

8) Multi-Region & Resilience
- Active-Active, cell-based architecture, regional sharding; DR runbooks, chaos testing.

9) Security by Design
- Zero Trust, OIDC, fine-grained RBAC/ABAC, Vault KMS, secret rotation, SBOM/SLSA/Sigstore.

10) Platform Engineering & GitOps
- Golden paths, IDP; GitOps (Argo/Flux), policy-as-code (OPA), progressive delivery.


