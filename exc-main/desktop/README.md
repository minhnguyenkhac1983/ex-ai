# Desktop Applications

This directory contains the desktop applications for the Crypto Exchange Platform, built with Electron for cross-platform compatibility.

## 🖥️ **Applications**

### 1. Trading App (`trading-app/`)
Professional desktop trading application with advanced features:

**Features:**
- **Real-time Trading**: Live market data and instant order execution
- **Advanced Charting**: TradingView integration with technical indicators
- **Portfolio Management**: Track holdings, P&L, and performance
- **Order Management**: All order types (Market, Limit, Stop-Loss, OCO)
- **Multi-Monitor Support**: Detachable windows for multiple screens
- **Offline Mode**: Limited functionality when internet is unavailable
- **Hot Keys**: Keyboard shortcuts for fast trading
- **Notifications**: Desktop notifications for price alerts and order fills

**Tech Stack:**
- **Electron**: Cross-platform desktop framework
- **React + TypeScript**: Modern UI development
- **Redux Toolkit**: State management
- **Styled Components**: CSS-in-JS styling
- **WebSocket**: Real-time data connections
- **TradingView**: Professional charting library

### 2. Admin Panel (`admin-panel/`)
Administrative desktop application for exchange operators:

**Features:**
- **User Management**: KYC approval, account management, support
- **System Monitoring**: Real-time system health and performance
- **Financial Oversight**: Transaction monitoring, reporting, compliance
- **Configuration**: System settings, trading pairs, fees
- **Security**: Audit logs, suspicious activity monitoring
- **Reports**: Generate financial and regulatory reports

**Tech Stack:**
- **Electron**: Desktop framework
- **React + TypeScript**: Administrative interface
- **Ant Design**: Professional UI components
- **Chart.js**: Data visualization
- **Real-time Dashboard**: Live system metrics

### 3. Installer (`installer/`)
Cross-platform installer and distribution system:

**Features:**
- **Multi-Platform**: Windows (NSIS), macOS (DMG), Linux (AppImage)
- **Code Signing**: Digitally signed executables for security
- **Auto-Updates**: Seamless application updates
- **Uninstaller**: Clean removal of applications
- **Registry Management**: Windows registry integration

## 🚀 **Quick Start**

### Prerequisites
- **Node.js**: 18.0+
- **npm**: 8.0+
- **Python**: 3.8+ (for native modules)
- **Visual Studio Build Tools** (Windows)
- **Xcode Command Line Tools** (macOS)

### Development Setup

1. **Install Dependencies**
```bash
# Trading App
cd trading-app
npm install

# Admin Panel
cd ../admin-panel
npm install
```

2. **Start Development**
```bash
# Trading App
cd trading-app
npm run dev

# Admin Panel (in another terminal)
cd admin-panel
npm run dev
```

3. **Launch Electron Apps**
```bash
# Trading App
cd trading-app
npm run electron:dev

# Admin Panel
cd admin-panel
npm run electron:dev
```

## 🔨 **Building for Production**

### Individual Apps
```bash
# Build Trading App
cd trading-app
npm run build
npm run dist:win    # Windows
npm run dist:mac    # macOS
npm run dist:linux  # Linux

# Build Admin Panel
cd admin-panel
npm run build
npm run dist:win    # Windows
npm run dist:mac    # macOS
npm run dist:linux  # Linux
```

### Build All Apps (Automated)
```bash
cd installer
node scripts/build-all.js
```

This will:
- Build both applications for all platforms
- Create installers for Windows, macOS, and Linux
- Generate checksums for security verification
- Create release notes

## 📦 **Distribution**

### Output Structure
```
desktop/installer/output/
├── trading-app/
│   ├── Crypto Exchange Trading Setup 1.0.0.exe  # Windows
│   ├── Crypto Exchange Trading-1.0.0.dmg        # macOS
│   └── Crypto Exchange Trading-1.0.0.AppImage   # Linux
├── admin-panel/
│   ├── Crypto Exchange Admin Setup 1.0.0.exe    # Windows
│   ├── Crypto Exchange Admin-1.0.0.dmg          # macOS
│   └── Crypto Exchange Admin-1.0.0.AppImage     # Linux
├── checksums.txt                                 # SHA256 checksums
└── RELEASE_NOTES.md                             # Release documentation
```

### Platform-Specific Notes

#### Windows
- **Requirements**: Windows 10+ (x64)
- **Installer**: NSIS with custom UI
- **Code Signing**: Requires valid certificate
- **Admin Rights**: Required for admin panel installation

#### macOS
- **Requirements**: macOS 10.14+ (Intel/Apple Silicon)
- **Installer**: DMG with custom background
- **Code Signing**: Apple Developer Certificate required
- **Notarization**: Required for Gatekeeper approval

#### Linux
- **Requirements**: Ubuntu 18.04+ or equivalent
- **Installer**: AppImage (portable) or DEB package
- **Dependencies**: Automatically bundled
- **Desktop Integration**: .desktop files included

## 🔧 **Development**

### Project Structure
```
desktop/
├── trading-app/
│   ├── src/
│   │   ├── main/          # Electron main process
│   │   ├── renderer/      # React renderer process
│   │   ├── shared/        # Shared utilities
│   │   └── components/    # React components
│   ├── assets/           # Icons, images, etc.
│   ├── build/            # Build configuration
│   └── dist/             # Distribution output
├── admin-panel/
│   └── [similar structure]
└── installer/
    ├── scripts/          # Build automation
    ├── windows/         # Windows installer config
    ├── macos/           # macOS installer config
    └── linux/           # Linux installer config
```

### Configuration Files
- **package.json**: Dependencies and build scripts
- **webpack.main.config.js**: Main process build configuration
- **webpack.renderer.config.js**: Renderer process build configuration
- **electron-builder.json**: Distribution configuration

### Security Considerations
- **Context Isolation**: Enabled for all windows
- **Node Integration**: Disabled in renderer processes
- **Preload Scripts**: Secure API exposure
- **CSP Headers**: Content Security Policy enforcement
- **Auto-Updates**: Signed update packages only

## 🧪 **Testing**

### Unit Testing
```bash
npm test                    # Run unit tests
npm run test:watch         # Watch mode
npm run test:coverage      # Coverage report
```

### E2E Testing
```bash
npm run test:e2e           # Playwright E2E tests
```

### Manual Testing
1. **Functionality**: All features work as expected
2. **Performance**: Responsive UI, fast data updates
3. **Security**: No vulnerabilities in dependencies
4. **Compatibility**: Works on all target platforms

## 📋 **Deployment Checklist**

- [ ] Update version numbers in package.json
- [ ] Test on all target platforms
- [ ] Run security audit (`npm audit`)
- [ ] Generate fresh certificates (if expired)
- [ ] Build and test installers
- [ ] Verify code signing
- [ ] Update release notes
- [ ] Create GitHub release
- [ ] Distribute to users

## 🐛 **Troubleshooting**

### Common Issues

**Build Failures:**
- Check Node.js version compatibility
- Clear `node_modules` and reinstall
- Verify build tools are installed

**Code Signing:**
- Ensure certificates are valid and imported
- Check certificate chain completeness
- Verify timestamping servers are accessible

**App Crashes:**
- Check Electron compatibility with OS
- Review console logs for errors
- Verify all dependencies are included

**Performance Issues:**
- Profile with Chrome DevTools
- Check for memory leaks
- Optimize bundle size

## 🔗 **Related Documentation**

- [Main Project README](../README.md)
- [API Documentation](../docs/api/)
- [Deployment Guide](../docs/deployment/)
- [Security Guide](../docs/security/)

## 🆘 **Support**

For desktop application issues:
- **GitHub Issues**: [Report bugs](https://github.com/your-org/crypto-exchange-platform/issues)
- **Discussions**: [Community support](https://github.com/your-org/crypto-exchange-platform/discussions)
- **Email**: desktop-support@yourexchange.com

---

**Built with ❤️ for professional crypto traders and exchange operators**
