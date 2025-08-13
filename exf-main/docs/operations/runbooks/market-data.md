### Runbook: Market Data

1) Triệu chứng: trễ stream cao, missing ticks
2) Chẩn đoán: kiểm tra feed handlers, GC/CPU, network multicast/ingress
3) Ứng phó: restart handler, throttle consumers, tăng partition
4) Hậu kiểm: tối ưu batching, backpressure


