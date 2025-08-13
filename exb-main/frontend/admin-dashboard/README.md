# Admin Dashboard

Dashboard quản trị nội bộ cho nhân viên ngân hàng trong hệ thống EXB.

## 🏗️ Kiến trúc

- **Framework**: Next.js 14/15 (React 18)
- **Styling**: Tailwind CSS + Shadcn/ui
- **State Management**: Zustand/Redux Toolkit
- **Charts**: Recharts/D3.js
- **API**: REST API + GraphQL
- **Authentication**: OAuth2/OIDC
- **Deployment**: Vercel/Netlify

## 📋 Chức năng chính

- Quản lý khách hàng và tài khoản
- Xử lý giao dịch và thanh toán
- Quản lý khoản vay và tín dụng
- Báo cáo tài chính và tuân thủ
- Quản lý thẻ ngân hàng
- Monitoring hệ thống
- Quản lý người dùng và phân quyền

## 🚀 Khởi chạy

```bash
# Development
npm run dev

# Production build
npm run build
npm start

# Docker
docker build -t admin-dashboard .
docker run -p 3001:3001 admin-dashboard
```

## 📁 Cấu trúc

```
admin-dashboard/
├── src/
│   ├── components/     # React components
│   ├── pages/         # Next.js pages
│   ├── hooks/         # Custom hooks
│   ├── utils/         # Utility functions
│   ├── styles/        # CSS styles
│   ├── types/         # TypeScript types
│   └── lib/           # Third-party libraries
├── public/            # Static assets
└── package.json       # Dependencies
```

## 🔗 Tích hợp

- **Backend APIs**: Tất cả microservices
- **Authentication**: Keycloak/OAuth2
- **Analytics**: Google Analytics
- **Monitoring**: Sentry
- **Observability**: Grafana dashboards

## 📊 Dashboard Features

- Real-time metrics
- Interactive charts
- Data tables với pagination
- Export functionality
- Search và filtering
- Role-based views

## 🔒 Bảo mật

- OAuth2/OIDC authentication
- Role-based access control (RBAC)
- HTTPS enforcement
- CSP headers
- Audit logging

## 📱 Responsive

- Desktop-first design
- Tablet support
- Mobile responsive
- Keyboard navigation
- Accessibility (WCAG 2.1)
