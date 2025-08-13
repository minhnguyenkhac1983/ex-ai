# Web Application

Ứng dụng web chính cho khách hàng trong hệ thống ngân hàng EXB.

## 🏗️ Kiến trúc

- **Framework**: Next.js 14/15 (React 18)
- **Styling**: Tailwind CSS
- **State Management**: Zustand/Redux Toolkit
- **API**: REST API + GraphQL
- **Authentication**: OAuth2/OIDC
- **Deployment**: Vercel/Netlify

## 📋 Chức năng chính

- Đăng nhập/đăng ký tài khoản
- Quản lý thông tin cá nhân
- Xem số dư và lịch sử giao dịch
- Chuyển khoản và thanh toán
- Quản lý thẻ ngân hàng
- Đăng ký khoản vay
- Báo cáo và thống kê

## 🚀 Khởi chạy

```bash
# Development
npm run dev

# Production build
npm run build
npm start

# Docker
docker build -t web-app .
docker run -p 3000:3000 web-app
```

## 📁 Cấu trúc

```
web-app/
├── src/
│   ├── components/     # React components
│   ├── pages/         # Next.js pages
│   ├── hooks/         # Custom hooks
│   ├── utils/         # Utility functions
│   ├── styles/        # CSS styles
│   └── types/         # TypeScript types
├── public/            # Static assets
└── package.json       # Dependencies
```

## 🔗 Tích hợp

- **Backend APIs**: Core banking services
- **Authentication**: Keycloak/OAuth2
- **Analytics**: Google Analytics
- **Monitoring**: Sentry
- **CDN**: Cloudflare

## 📊 Performance

- Server-side rendering (SSR)
- Static site generation (SSG)
- Image optimization
- Code splitting
- Lazy loading

## 🔒 Bảo mật

- OAuth2/OIDC authentication
- HTTPS enforcement
- CSP headers
- XSS protection
- CSRF protection

## 📱 Responsive

- Mobile-first design
- Progressive Web App (PWA)
- Offline support
- Push notifications
