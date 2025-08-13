# BFF Web (Next.js 14)

Chạy local:
```bash
pnpm i
pnpm dev
```

OpenTelemetry Web:
- Cấu hình endpoint qua `NEXT_PUBLIC_OTEL_EXPORTER_OTLP_ENDPOINT` (mặc định `/v1/traces`).
- Khi chạy chung `docker-compose.otel.yml`, đặt `NEXT_PUBLIC_OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318/v1/traces`.


