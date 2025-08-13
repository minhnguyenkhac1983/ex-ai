### Runbook: Trading OMS

1) Triệu chứng: API 5xx tăng, latency vượt SLO
2) Chẩn đoán: kiểm tra Kafka, DB, autoscaling, error rate
3) Ứng phó: scale out, rollback canary, mở circuit, bật feature flags
4) Hậu kiểm: RCA, action items


