# ADR 0002: Deployment Topology

Quyết định
- Kubernetes, Service Mesh (Istio), GitOps (Argo), Multi-Region Active-Active; cell-based sharding cho trading path; progressive delivery (canary/blue-green).

Lý do
- Độ trễ thấp theo vùng, cô lập sự cố theo cell, khả năng triển khai an toàn dần.

Hệ quả
- Quản trị multi-cluster, yêu cầu observability và policy-as-code nhất quán; cần playbooks DR/BCP.
- Chiến lược dữ liệu đa vùng (Kafka cluster linking, topic mirroring, CockroachDB/Citus), đồng bộ clock (PTP/NTP) cho audit/miFID.

