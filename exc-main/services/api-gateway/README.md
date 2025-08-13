# API Gateway

Định hướng 2025: Envoy Gateway với Kubernetes Gateway API. Ở môi trường local có thể dùng NGINX/Envoy container; production nên dùng Gateway API + mTLS nội bộ (SPIFFE/SPIRE).

Chức năng chính:
- AuthN/AuthZ (OIDC), rate limiting, idempotency keys
- Observability (OpenTelemetry), access logs
- Routing tới BFF và services nội bộ

Chạy local:
```bash
pnpm i
pnpm -r dev
# hoặc trong thư mục này
pnpm dev
```


