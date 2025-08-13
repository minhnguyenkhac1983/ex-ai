### Tổng quan kiến trúc

Hệ thống Exchange Financial được thiết kế dựa trên DDD và Microservices, tối ưu cho low-latency, high-throughput và compliance.

- Triết lý: Bounded Context rõ ràng, dữ liệu sở hữu độc lập, giao tiếp bất đồng bộ ưu tiên (event-first), đồng bộ tối thiểu qua API.
- Mẫu kiến trúc: Event-Driven, CQRS, Outbox, Saga/Process Manager, Circuit Breaker, Bulkhead, Idempotency, Backpressure.
- Kiến trúc dịch vụ: Hexagonal/Clean Architecture cho từng service, tách domain core khỏi adapters (REST/gRPC/Kafka/DB).
- Lớp trình bày: Backends for Frontends (BFF) cho web/mobile; Federation cho GraphQL khi phù hợp.
- Không chức năng: Hiệu năng (<100µs đường critical), HA (99.99%+), bảo mật (Zero-Trust), auditability, tuân thủ, khả năng kiểm toán (MiFID II clock sync).

Các context cốt lõi: Trading, Market Data, Risk, Clearing & Settlement, Compliance, Connectivity, Member & Billing, Listing & Corporate Actions, Reference Data, Portfolio & Analytics, IAM & Security, Payments & Treasury, Operations & SRE, Data Platform (Data Mesh/Lakehouse), AI Platform, External Integration.

Triển khai & vận hành
- Multi-region active/active (eventual consistency), disaster recovery RTO/RPO chặt chẽ
- GitOps (Argo CD), progressive delivery (blue/green, canary), chaos engineering
- Observability end-to-end: metrics, traces, logs, profiling; SLOs/SLIs, error budgets


