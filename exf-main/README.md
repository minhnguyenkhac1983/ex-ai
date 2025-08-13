# exf

[![CI](https://github.com/minhnguyenkhac1983/exf/actions/workflows/ci.yml/badge.svg)](https://github.com/minhnguyenkhac1983/exf/actions/workflows/ci.yml)

## Kiến trúc ở mức cao
- DDD với các bounded context rõ ràng: Trading, Market Data, Risk, Clearing & Settlement, Compliance, Member & Billing, Connectivity, Listing & Corporate Actions, Reference Data, Portfolio & Analytics, IAM & Security, Payments & Treasury, Operations & SRE, Data Platform, AI Platform, External Integration.
- Microservices độc lập, mỗi service sở hữu dữ liệu của mình (database-per-service), giao tiếp qua event streaming và API hợp đồng hóa.
- Event-Driven Architecture (Kafka), CQRS + read models cho low-latency, idempotency và exactly-once semantics nơi cần thiết.

## Kiến trúc hiện đại bổ sung
- Hexagonal/Clean Architecture (Ports & Adapters)
- Saga orchestration (Temporal/Camunda), Outbox + CDC, Anti-Corruption Layer
- API Gateway + BFF, GraphQL federation cho đọc đa domain
- Service Mesh (Istio/Linkerd) với mTLS, policy, telemetry
- Data Mesh & Lakehouse (Delta/Iceberg), stream processing (Flink/Kafka Streams)
- Multi-Region Active-Active, Multi-tenancy & Sharding
- Policy-as-Code (OPA), GitOps (Argo CD/Flux), Supply-chain security (SBOM/SLSA/Sigstore)
- Observability by default (OpenTelemetry), Progressive delivery (canary/blue-green/feature flags)

## Tài liệu
- Kiến trúc tổng quan: `docs/architecture/overview.md`
- Bounded contexts: `docs/architecture/bounded-contexts.md`
- Context map & tích hợp: `docs/architecture/context-map.md`
- Domain events & hợp đồng: `docs/architecture/events.md`
- Lựa chọn công nghệ (hiện đại hoá): `docs/architecture/technology.md`
- ADR (quyết định kiến trúc): `docs/adr/`
- Cấu trúc repo: `docs/architecture/repo-structure.md`
 - Topology triển khai: `docs/architecture/topology.md`
 - Luồng nghiệp vụ chính: `docs/architecture/flows/order-sequence.md`
- Cấu trúc thư mục: `docs/architecture/repo-structure.md`
 - Kiến trúc hiện đại: `docs/architecture/modern-architectures.md`
 - ADRs: `docs/adr/`

## Dịch vụ
Xem `services/README.md` để biết danh sách dịch vụ và trách nhiệm.

## Nền tảng & Hạ tầng
- `platform/` các cấu phần bảo mật/quan sát/dữ liệu chung
- `infra/` mô tả triển khai (IaC, topology, GitOps)

## Cấu trúc dự án

```
docs/
  architecture/
    overview.md
    bounded-contexts.md
    context-map.md
    events.md
    technology.md
    modern-architectures.md
  adr/
    0001-architecture-style.md
    0002-deployment-topology.md
services/
  trading-oms/
  matching-engine/
  market-data/
  risk-service/
  clearing-service/
  settlement-service/
  ...
gateways/
  api-gateway/
bff/
  trading-bff/
contracts/
  api/
  events/
  graphql/
platform/
infra/
  k8s/
  terraform/
deploy/
  k8s/
ops/
  runbooks/
  sre/
security/
```

