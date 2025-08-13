# Frontend Applications

Thư mục này chứa các ứng dụng frontend theo mô hình Backend-for-Frontend (BFF).

## Cấu trúc

```
apps/
├── bff-web/           # Backend-for-Frontend cho Web (Next.js + OIDC PKCE)
├── bff-mobile/        # Backend-for-Frontend cho Mobile
├── bff-desktop/       # Backend-for-Frontend cho Desktop
└── admin/             # Admin Panel (skeleton)
```

## BFF Pattern

Backend-for-Frontend (BFF) là một pattern kiến trúc giúp:
- Tối ưu hóa API cho từng platform cụ thể
- Giảm thiểu network calls
- Xử lý authentication và authorization
- Aggregation data từ nhiều microservices

## Technology Stack

- **BFF Web**: Next.js 14+, TypeScript, OIDC PKCE, Tailwind CSS
- **BFF Mobile**: React Native, TypeScript
- **BFF Desktop**: Electron, React, TypeScript
- **Admin**: React, TypeScript, Material-UI

## Development

```bash
# Install dependencies
pnpm install

# Run development servers
pnpm dev

# Build for production
pnpm build
```
