# Mobile Application

Ứng dụng di động cho khách hàng trong hệ thống ngân hàng EXB.

## 🏗️ Kiến trúc

- **Framework**: React Native 0.72+
- **Language**: TypeScript
- **State Management**: Redux Toolkit/Zustand
- **Navigation**: React Navigation 6
- **API**: REST API + GraphQL
- **Authentication**: OAuth2/OIDC
- **Platforms**: iOS & Android

## 📋 Chức năng chính

- Đăng nhập/đăng ký tài khoản
- Quản lý thông tin cá nhân
- Xem số dư và lịch sử giao dịch
- Chuyển khoản và thanh toán
- Quản lý thẻ ngân hàng
- QR code payments
- Push notifications
- Biometric authentication

## 🚀 Khởi chạy

```bash
# Install dependencies
npm install

# iOS
cd ios && pod install && cd ..
npx react-native run-ios

# Android
npx react-native run-android

# Metro bundler
npx react-native start
```

## 📁 Cấu trúc

```
mobile-app/
├── android/           # Android native code
├── ios/              # iOS native code
├── src/
│   ├── components/   # React Native components
│   ├── screens/      # App screens
│   ├── navigation/   # Navigation setup
│   ├── hooks/        # Custom hooks
│   ├── utils/        # Utility functions
│   ├── styles/       # Styles
│   └── types/        # TypeScript types
├── shared/           # Shared components
└── package.json      # Dependencies
```

## 🔗 Tích hợp

- **Backend APIs**: Core banking services
- **Authentication**: Keycloak/OAuth2
- **Push Notifications**: Firebase
- **Analytics**: Firebase Analytics
- **Crash Reporting**: Sentry
- **Biometrics**: React Native Biometrics

## 📱 Platform Features

### iOS
- Face ID/Touch ID
- Apple Pay integration
- iOS-specific UI components
- App Store deployment

### Android
- Fingerprint/Face unlock
- Google Pay integration
- Android-specific UI components
- Google Play deployment

## 🔒 Bảo mật

- OAuth2/OIDC authentication
- Biometric authentication
- Certificate pinning
- Code obfuscation
- Secure storage

## 📊 Performance

- Hermes JavaScript engine
- Fast Refresh
- Code splitting
- Image optimization
- Lazy loading
