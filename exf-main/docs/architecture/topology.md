### Topology triển khai (multi-region)

Sơ đồ tổng quát được nhúng trong cuộc trò chuyện (Mermaid). Các điểm chính:
- Mỗi vùng: 1+ cụm K8s, Kafka cục bộ (hoặc MSK), OLTP (Postgres/Cockroach), mesh mTLS
- Kafka cluster linking giữa các vùng cho chủ đề liên vùng; Schema Registry đồng bộ
- GitOps (Argo CD) điều phối cấu hình và phát hành
- API/BFF route người dùng tới vùng gần nhất, fallback giữa vùng khi DR


