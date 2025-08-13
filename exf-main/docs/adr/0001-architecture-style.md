### ADR 0001: Architecture Style

Quyết định
- Áp dụng DDD + Microservices, Event-Driven, Hexagonal Architecture cho từng service.

Lý do
- Biên domain rõ ràng, tính mở rộng, khả năng thay thế adapter công nghệ mà không ảnh hưởng domain core.

Hệ quả
- Tăng số lượng dịch vụ và chi phí vận hành; cần GitOps, observability và tiêu chuẩn hoá hợp đồng.

# ADR 0001: Architecture Style

Quyết định
- Áp dụng DDD + Microservices, ưu tiên Event-Driven, CQRS, Outbox.

Hệ quả
- Ranh giới dữ liệu rõ ràng, tích hợp qua sự kiện, độ phức tạp vận hành tăng (Kafka, schema registry, ops).


