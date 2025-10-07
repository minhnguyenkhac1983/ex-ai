# 📱 Mobile Application - EXI Insurance Exchange

> **React Native mobile application for the EXI Insurance Exchange platform.**

## 📋 Overview

The mobile application provides a native mobile experience for customers to manage their insurance policies, get quotes, file claims, and access their insurance documents on the go.

## 🏗️ Architecture

```
mobile/
├── 📁 src/                 # Source code
│   ├── 📁 components/      # React Native components
│   ├── 📁 screens/         # Screen components
│   ├── 📁 navigation/      # Navigation configuration
│   ├── 📁 services/        # API services
│   ├── 📁 store/           # State management
│   ├── 📁 utils/           # Utility functions
│   ├── 📁 types/           # TypeScript types
│   ├── 📁 assets/          # Images, fonts, etc.
│   └── 📁 styles/          # Styling
├── 📁 android/             # Android configuration
├── 📁 ios/                 # iOS configuration
└── 📄 Configuration files
```

## 🚀 Features

### 🏠 Customer Features
- **Policy Management**: View and manage insurance policies
- **Quote Generation**: Get instant insurance quotes
- **Claims Filing**: File and track insurance claims
- **Document Access**: View policy documents and certificates
- **Notifications**: Real-time push notifications
- **Offline Support**: Basic functionality without internet

### 🔧 Technical Features
- **Cross-Platform**: iOS and Android support
- **Native Performance**: Optimized for mobile devices
- **Offline Capability**: Works with limited connectivity
- **Push Notifications**: Real-time updates
- **Biometric Authentication**: Secure login with fingerprint/face ID
- **Deep Linking**: Direct navigation to specific features

## 🛠️ Development Setup

### Prerequisites
- **Node.js** 18+
- **React Native CLI** or **Expo CLI**
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Git**

### Installation

1. **Install dependencies**
   ```bash
   cd mobile
   npm install
   ```

2. **Install React Native CLI (if not using Expo)**
   ```bash
   npm install -g react-native-cli
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start development server**
   ```bash
   # Start Metro bundler
   npm start
   
   # Run on Android
   npm run android
   
   # Run on iOS
   npm run ios
   ```

### Development Commands

```bash
# Install dependencies
npm install

# Start Metro bundler
npm start

# Run on Android
npm run android

# Run on iOS
npm run ios

# Run tests
npm run test

# Run tests with coverage
npm run test:coverage

# Run linting
npm run lint

# Run type checking
npm run type-check

# Build for production
npm run build:android
npm run build:ios

# Release to stores
npm run release:android
npm run release:ios
```

## 📁 Project Structure

```
mobile/
├── 📁 src/
│   ├── 📁 components/      # Reusable components
│   │   ├── 📁 common/      # Shared components
│   │   ├── 📁 forms/       # Form components
│   │   ├── 📁 navigation/  # Navigation components
│   │   └── 📁 screens/     # Screen components
│   ├── 📁 hooks/           # Custom React hooks
│   ├── 📁 services/        # API services
│   ├── 📁 store/           # State management
│   ├── 📁 utils/           # Utility functions
│   ├── 📁 types/           # TypeScript types
│   ├── 📁 assets/          # Static assets
│   │   ├── 📁 images/      # Image files
│   │   ├── 📁 fonts/       # Font files
│   │   └── 📁 icons/       # Icon files
│   └── 📁 styles/          # Styling
├── 📁 android/             # Android-specific files
├── 📁 ios/                 # iOS-specific files
├── 📄 package.json
├── 📄 tsconfig.json
├── 📄 app.json
├── 📄 babel.config.js
└── 📄 .env.example
```

## 🎨 Design System

### UI Components
- **Button**: Primary, secondary, and tertiary buttons
- **Input**: Text, email, password, and select inputs
- **Card**: Content containers with various styles
- **Modal**: Overlay dialogs and popups
- **List**: Data display with various layouts
- **Form**: Form components with validation

### Styling
- **React Native StyleSheet**: Native styling
- **Styled Components**: Component-based styling
- **Design Tokens**: Consistent colors, spacing, and typography
- **Responsive Design**: Adapts to different screen sizes

## 🔧 Configuration

### Environment Variables
```bash
# API Configuration
API_URL=https://api.exi.com
API_VERSION=v1

# Authentication
AUTH_DOMAIN=your-auth-domain
AUTH_CLIENT_ID=your-client-id

# Push Notifications
PUSH_TOKEN=your-push-token

# Analytics
ANALYTICS_KEY=your-analytics-key

# Feature Flags
ENABLE_BETA_FEATURES=false
ENABLE_ANALYTICS=true
```

### Platform Configuration

#### Android Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.exi.insurance"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

#### iOS Configuration
```swift
// ios/ExiInsurance/Info.plist
<key>CFBundleDisplayName</key>
<string>EXI Insurance</string>
<key>CFBundleIdentifier</key>
<string>com.exi.insurance</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
```

## 🧪 Testing

### Test Strategy
- **Unit Tests**: Component and utility testing
- **Integration Tests**: API integration testing
- **E2E Tests**: User workflow testing
- **Visual Regression**: UI consistency testing

### Running Tests
```bash
# Run all tests
npm run test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run E2E tests
npm run test:e2e

# Run visual regression tests
npm run test:visual
```

## 📊 Performance

### Optimization Techniques
- **Code Splitting**: Lazy loading of components
- **Image Optimization**: Compressed and optimized images
- **Bundle Analysis**: Webpack bundle analyzer
- **Memory Management**: Proper component lifecycle management
- **Caching**: Local storage and API response caching

### Performance Metrics
- **App Launch Time**: < 3 seconds
- **Screen Transition**: < 300ms
- **API Response Time**: < 2 seconds
- **Memory Usage**: < 100MB
- **Battery Usage**: Optimized for minimal impact

## 🔒 Security

### Security Measures
- **Biometric Authentication**: Fingerprint and face ID
- **Secure Storage**: Encrypted local storage
- **Network Security**: HTTPS and certificate pinning
- **Input Validation**: Client-side validation
- **Session Management**: Secure token handling

### Security Configuration
```javascript
// Security configuration
const securityConfig = {
  biometricEnabled: true,
  certificatePinning: true,
  encryptionEnabled: true,
  sessionTimeout: 30 * 60 * 1000, // 30 minutes
};
```

## 🚀 Deployment

### Build Process
```bash
# Build for Android
cd android
./gradlew assembleRelease

# Build for iOS
cd ios
xcodebuild -workspace ExiInsurance.xcworkspace -scheme ExiInsurance -configuration Release
```

### App Store Deployment
```bash
# Android Play Store
npm run release:android

# iOS App Store
npm run release:ios
```

### CI/CD Pipeline
- **Build**: Automated build and testing
- **Deploy**: Automated deployment to stores
- **Monitoring**: Performance and crash monitoring
- **Rollback**: Automated rollback capabilities

## 📱 Platform Support

### Android
- **Minimum SDK**: API 21 (Android 5.0)
- **Target SDK**: API 34 (Android 14)
- **Architecture**: ARM64, x86_64
- **Permissions**: Camera, Location, Storage

### iOS
- **Minimum Version**: iOS 12.0
- **Target Version**: iOS 17.0
- **Architecture**: ARM64
- **Permissions**: Camera, Location, Notifications

## 📊 Analytics

### Analytics Integration
- **User Behavior**: Screen views, button clicks, user flows
- **Performance**: App launch time, screen load time
- **Errors**: Crash reporting and error tracking
- **Business Metrics**: Policy purchases, quote requests

### Analytics Tools
- **Firebase Analytics**: Google Analytics for mobile
- **Crashlytics**: Crash reporting
- **Mixpanel**: User behavior analytics
- **Sentry**: Error tracking

## 🔄 State Management

### Redux Toolkit
```javascript
// Store configuration
import { configureStore } from '@reduxjs/toolkit';
import userReducer from './slices/userSlice';
import policyReducer from './slices/policySlice';

export const store = configureStore({
  reducer: {
    user: userReducer,
    policy: policyReducer,
  },
});
```

### Async Storage
```javascript
// Local storage management
import AsyncStorage from '@react-native-async-storage/async-storage';

const storage = {
  setItem: async (key, value) => {
    await AsyncStorage.setItem(key, JSON.stringify(value));
  },
  getItem: async (key) => {
    const value = await AsyncStorage.getItem(key);
    return value ? JSON.parse(value) : null;
  },
};
```

## 📚 Documentation

### Development Guides
- [Getting Started](./docs/getting-started.md)
- [Component Development](./docs/component-development.md)
- [Navigation Guide](./docs/navigation-guide.md)
- [State Management](./docs/state-management.md)
- [Testing Guide](./docs/testing-guide.md)

### API Integration
- [API Services](./docs/api-services.md)
- [Authentication](./docs/authentication.md)
- [Error Handling](./docs/error-handling.md)
- [Offline Support](./docs/offline-support.md)

## 🤝 Contributing

### Development Workflow
1. Create feature branch
2. Implement changes
3. Write tests
4. Update documentation
5. Submit pull request

### Code Standards
- Follow TypeScript best practices
- Use functional components with hooks
- Implement proper error handling
- Write comprehensive tests
- Follow React Native best practices

## 🆘 Support

For mobile-specific issues:
- 📧 **Email**: mobile@exi.com
- 💬 **Slack**: #mobile-team
- 📚 **Documentation**: [Mobile Docs](https://docs.exi.com/mobile)
- 🐛 **Issues**: [GitHub Issues](https://github.com/exi/insurance-exchange/issues)

## 📱 App Store Links

- **Google Play Store**: [EXI Insurance](https://play.google.com/store/apps/details?id=com.exi.insurance)
- **Apple App Store**: [EXI Insurance](https://apps.apple.com/app/exi-insurance/id123456789)

---

**Built with ❤️ by the Mobile Team**
