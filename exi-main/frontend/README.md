# 🖥️ Frontend Applications - EXI Insurance Exchange

> **Modern React-based frontend applications for the EXI Insurance Exchange platform.**

## 📋 Overview

The frontend directory contains all user-facing applications built with React 18, TypeScript, and Next.js 14. Each application is designed for specific user roles and provides a seamless, responsive experience.

## 🏗️ Architecture

```
frontend/
├── 📁 user-portal/         # Customer-facing portal
├── 📁 admin-dashboard/     # Administrative interface
├── 📁 provider-portal/     # Insurance provider portal
└── 📁 broker-portal/       # Broker and agent portal
```

## 🚀 Applications

### 🏠 User Portal (`user-portal/`)
**Customer-facing application for policy management and insurance purchases.**

- **Features**:
  - Browse and compare insurance policies
  - Get instant quotes
  - Purchase policies online
  - Manage existing policies
  - File and track claims
  - Access policy documents

- **Tech Stack**:
  - React 18 + TypeScript
  - Next.js 14 (App Router)
  - Tailwind CSS
  - Redux Toolkit
  - React Query

### 🏢 Admin Dashboard (`admin-dashboard/`)
**Administrative interface for system management and oversight.**

- **Features**:
  - User management
  - System monitoring
  - Compliance reporting
  - Financial reporting
  - Security management
  - Configuration management

- **Tech Stack**:
  - React 18 + TypeScript
  - Next.js 14
  - Material-UI
  - Recharts (analytics)
  - React Hook Form

### 🏢 Provider Portal (`provider-portal/`)
**Insurance provider interface for product and policy management.**

- **Features**:
  - Product catalog management
  - Pricing and rules configuration
  - Application processing
  - Claims handling
  - Performance analytics
  - Report generation

- **Tech Stack**:
  - React 18 + TypeScript
  - Next.js 14
  - Ant Design
  - D3.js (advanced charts)
  - React Table

### 👥 Broker Portal (`broker-portal/`)
**Broker and agent interface for client and sales management.**

- **Features**:
  - Client portfolio management
  - Quote generation
  - Application processing
  - Commission tracking
  - Sales pipeline
  - Market insights

- **Tech Stack**:
  - React 18 + TypeScript
  - Next.js 14
  - Chakra UI
  - React Hook Form
  - React Query

## 🛠️ Development Setup

### Prerequisites
- Node.js 18+
- npm or yarn
- Git

### Installation

1. **Install dependencies for all applications**
   ```bash
   cd frontend
   npm install
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your configuration
   ```

3. **Start development servers**
   ```bash
   # Start all applications
   npm run dev
   
   # Or start individual applications
   npm run dev:user-portal
   npm run dev:admin-dashboard
   npm run dev:provider-portal
   npm run dev:broker-portal
   ```

### Development Commands

```bash
# Install dependencies
npm install

# Start development servers
npm run dev

# Build for production
npm run build

# Run tests
npm run test

# Run linting
npm run lint

# Run type checking
npm run type-check

# Format code
npm run format
```

## 📁 Project Structure

Each application follows a consistent structure:

```
application-name/
├── 📁 public/              # Static assets
├── 📁 src/
│   ├── 📁 components/      # React components
│   │   ├── 📁 common/      # Shared components
│   │   ├── 📁 forms/       # Form components
│   │   ├── 📁 layout/      # Layout components
│   │   └── 📁 pages/       # Page components
│   ├── 📁 hooks/           # Custom React hooks
│   ├── 📁 services/        # API services
│   ├── 📁 store/           # State management
│   ├── 📁 utils/           # Utility functions
│   ├── 📁 types/           # TypeScript types
│   └── 📁 styles/          # CSS/SCSS files
├── 📄 package.json
├── 📄 tsconfig.json
├── 📄 next.config.js
├── 📄 tailwind.config.js
└── 📄 .env.example
```

## 🎨 Design System

### Shared Components
- **Button**: Primary, secondary, and tertiary buttons
- **Input**: Text, email, password, and select inputs
- **Card**: Content containers with various styles
- **Modal**: Overlay dialogs and popups
- **Table**: Data display with sorting and filtering
- **Form**: Form components with validation

### Styling
- **Tailwind CSS**: Utility-first CSS framework
- **CSS Modules**: Component-scoped styles
- **Design Tokens**: Consistent colors, spacing, and typography
- **Responsive Design**: Mobile-first approach

## 🔧 Configuration

### Environment Variables
```bash
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:3002
NEXT_PUBLIC_API_VERSION=v1

# Authentication
NEXT_PUBLIC_AUTH_DOMAIN=your-auth-domain
NEXT_PUBLIC_AUTH_CLIENT_ID=your-client-id

# Analytics
NEXT_PUBLIC_GA_TRACKING_ID=your-ga-id
NEXT_PUBLIC_MIXPANEL_TOKEN=your-mixpanel-token

# Feature Flags
NEXT_PUBLIC_ENABLE_BETA_FEATURES=false
NEXT_PUBLIC_ENABLE_ANALYTICS=true
```

### Build Configuration
- **Next.js 14**: App Router, Server Components
- **TypeScript**: Strict mode enabled
- **ESLint**: Code quality and consistency
- **Prettier**: Code formatting
- **Husky**: Git hooks for quality checks

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
- **Code Splitting**: Automatic route-based splitting
- **Image Optimization**: Next.js Image component
- **Bundle Analysis**: Webpack bundle analyzer
- **Lazy Loading**: Component and route lazy loading
- **Caching**: Static generation and ISR

### Performance Metrics
- **Lighthouse Score**: > 90 for all metrics
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Cumulative Layout Shift**: < 0.1
- **First Input Delay**: < 100ms

## 🔒 Security

### Security Measures
- **Content Security Policy**: XSS protection
- **HTTPS Only**: Secure communication
- **Input Validation**: Client and server-side validation
- **Authentication**: OAuth2/OIDC integration
- **Authorization**: Role-based access control

### Security Headers
```javascript
// next.config.js
const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  },
  {
    key: 'X-XSS-Protection',
    value: '1; mode=block'
  },
  {
    key: 'X-Frame-Options',
    value: 'SAMEORIGIN'
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff'
  }
];
```

## 🚀 Deployment

### Build Process
```bash
# Build all applications
npm run build

# Build individual applications
npm run build:user-portal
npm run build:admin-dashboard
npm run build:provider-portal
npm run build:broker-portal
```

### Deployment Targets
- **Development**: Local development servers
- **Staging**: AWS S3 + CloudFront
- **Production**: AWS S3 + CloudFront + Route53

### CI/CD Pipeline
- **Build**: Automated build and testing
- **Deploy**: Automated deployment to environments
- **Monitoring**: Performance and error monitoring
- **Rollback**: Automated rollback capabilities

## 📚 Documentation

### Application-Specific Docs
- [User Portal Guide](./user-portal/README.md)
- [Admin Dashboard Guide](./admin-dashboard/README.md)
- [Provider Portal Guide](./provider-portal/README.md)
- [Broker Portal Guide](./broker-portal/README.md)

### Development Guides
- [Component Development](./docs/component-development.md)
- [State Management](./docs/state-management.md)
- [API Integration](./docs/api-integration.md)
- [Testing Guide](./docs/testing-guide.md)

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
- Follow accessibility guidelines

## 🆘 Support

For frontend-specific issues:
- 📧 **Email**: frontend@exi.com
- 💬 **Slack**: #frontend-team
- 📚 **Documentation**: [Frontend Docs](https://docs.exi.com/frontend)
- 🐛 **Issues**: [GitHub Issues](https://github.com/exi/insurance-exchange/issues)

---

**Built with ❤️ by the Frontend Team**
