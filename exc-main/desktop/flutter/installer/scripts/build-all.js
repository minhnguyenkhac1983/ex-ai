#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const apps = [
  {
    name: 'trading-app',
    path: '../trading-app',
    description: 'Trading Application'
  },
  {
    name: 'admin-panel',
    path: '../admin-panel',
    description: 'Admin Panel'
  }
];

const platforms = [
  { name: 'windows', targets: ['win'], suffix: 'win' },
  { name: 'macos', targets: ['mac'], suffix: 'mac' },
  { name: 'linux', targets: ['linux'], suffix: 'linux' }
];

// Helper functions
function log(message) {
  console.log(`[${new Date().toISOString()}] ${message}`);
}

function execCommand(command, cwd) {
  log(`Executing: ${command} in ${cwd}`);
  try {
    execSync(command, { cwd, stdio: 'inherit' });
    return true;
  } catch (error) {
    log(`Error executing command: ${error.message}`);
    return false;
  }
}

function buildApp(app, platform) {
  log(`Building ${app.description} for ${platform.name}...`);
  
  const appPath = path.resolve(__dirname, app.path);
  
  // Check if package.json exists
  if (!fs.existsSync(path.join(appPath, 'package.json'))) {
    log(`Warning: package.json not found in ${appPath}`);
    return false;
  }
  
  // Install dependencies
  if (!execCommand('npm ci', appPath)) {
    return false;
  }
  
  // Build the app
  if (!execCommand('npm run build', appPath)) {
    return false;
  }
  
  // Create distributable for each target
  for (const target of platform.targets) {
    const command = `npm run dist:${target}`;
    if (!execCommand(command, appPath)) {
      log(`Failed to build ${app.name} for ${target}`);
      return false;
    }
  }
  
  return true;
}

function createInstaller() {
  log('Creating unified installer...');
  
  // Create installer directory structure
  const installerDir = path.resolve(__dirname, '../output');
  if (!fs.existsSync(installerDir)) {
    fs.mkdirSync(installerDir, { recursive: true });
  }
  
  // Copy built applications to installer directory
  for (const app of apps) {
    const appDistPath = path.resolve(__dirname, app.path, 'dist', 'installers');
    const targetPath = path.join(installerDir, app.name);
    
    if (fs.existsSync(appDistPath)) {
      execCommand(`cp -r "${appDistPath}" "${targetPath}"`, __dirname);
    }
  }
  
  log('Installer creation completed');
}

function createChecksums() {
  log('Creating checksums...');
  
  const outputDir = path.resolve(__dirname, '../output');
  const checksumFile = path.join(outputDir, 'checksums.txt');
  
  // Generate checksums for all files
  if (fs.existsSync(outputDir)) {
    execCommand(`find "${outputDir}" -type f -name "*.exe" -o -name "*.dmg" -o -name "*.AppImage" | xargs sha256sum > "${checksumFile}"`, __dirname);
  }
  
  log('Checksums created');
}

function generateReleaseNotes() {
  log('Generating release notes...');
  
  const outputDir = path.resolve(__dirname, '../output');
  const releaseNotesFile = path.join(outputDir, 'RELEASE_NOTES.md');
  
  const version = require(path.resolve(__dirname, '../trading-app/package.json')).version;
  const date = new Date().toISOString().split('T')[0];
  
  const releaseNotes = `# Crypto Exchange Desktop Applications

## Version ${version} - ${date}

### Trading Application
- Professional trading interface
- Real-time market data
- Advanced charting with TradingView
- Portfolio management
- Order management

### Admin Panel
- User management
- System monitoring
- Financial reporting
- Configuration management
- Audit logs

### System Requirements
- **Windows**: Windows 10 or later (x64)
- **macOS**: macOS 10.14 or later (Intel/Apple Silicon)
- **Linux**: Ubuntu 18.04 or later (x64)

### Installation
1. Download the appropriate installer for your platform
2. Run the installer with administrator privileges
3. Follow the installation wizard
4. Launch the application from the desktop shortcut

### Security
All installers are code-signed and verified. Please verify checksums before installation.

### Support
For technical support, please visit: https://support.yourexchange.com
`;
  
  fs.writeFileSync(releaseNotesFile, releaseNotes);
  log('Release notes generated');
}

// Main execution
async function main() {
  log('Starting build process for all desktop applications...');
  
  const startTime = Date.now();
  let success = true;
  
  // Build each app for each platform
  for (const platform of platforms) {
    log(`\n=== Building for ${platform.name.toUpperCase()} ===`);
    
    for (const app of apps) {
      if (!buildApp(app, platform)) {
        success = false;
        log(`Failed to build ${app.name} for ${platform.name}`);
      }
    }
  }
  
  if (success) {
    createInstaller();
    createChecksums();
    generateReleaseNotes();
    
    const endTime = Date.now();
    const duration = Math.round((endTime - startTime) / 1000);
    
    log(`\n✅ Build completed successfully in ${duration} seconds`);
    log('Output directory: ./output/');
  } else {
    log('\n❌ Build failed. Please check the logs above for errors.');
    process.exit(1);
  }
}

// Handle command line arguments
const args = process.argv.slice(2);
if (args.includes('--help') || args.includes('-h')) {
  console.log(`
Usage: node build-all.js [options]

Options:
  --help, -h     Show this help message
  --clean        Clean build directories before building
  --dev          Build in development mode
  
Examples:
  node build-all.js                 # Build all apps for all platforms
  node build-all.js --clean         # Clean and build
  node build-all.js --dev           # Development build
`);
  process.exit(0);
}

if (args.includes('--clean')) {
  log('Cleaning build directories...');
  for (const app of apps) {
    const appPath = path.resolve(__dirname, app.path);
    execCommand('rm -rf dist build', appPath);
  }
}

// Run the main function
main().catch(error => {
  log(`Fatal error: ${error.message}`);
  process.exit(1);
});
