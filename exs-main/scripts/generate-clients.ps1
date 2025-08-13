# Generate Client SDK Script
# This script generates client SDKs from protobuf definitions

param(
    [string]$Language = "all",
    [string]$OutputDir = "packages/clients"
)

Write-Host "Generating client SDKs from protobuf definitions..." -ForegroundColor Green

# Check if buf is installed
try {
    $bufVersion = buf --version
    Write-Host "Using buf version: $bufVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: buf is not installed. Please install buf first." -ForegroundColor Red
    Write-Host "Installation guide: https://docs.buf.build/installation" -ForegroundColor Yellow
    exit 1
}

# Create output directories
$Languages = @{
    "go" = "packages/clients/go"
    "java" = "packages/clients/java/src/main/java"
    "typescript" = "packages/clients/typescript/src"
}

if ($Language -eq "all") {
    foreach ($lang in $Languages.Keys) {
        $outputPath = $Languages[$lang]
        if (!(Test-Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath -Force
            Write-Host "Created directory: $outputPath" -ForegroundColor Yellow
        }
    }
} else {
    if ($Languages.ContainsKey($Language)) {
        $outputPath = $Languages[$Language]
        if (!(Test-Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath -Force
            Write-Host "Created directory: $outputPath" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Error: Unsupported language '$Language'. Supported languages: $($Languages.Keys -join ', ')" -ForegroundColor Red
        exit 1
    }
}

# Generate clients using buf
try {
    Write-Host "Running buf generate..." -ForegroundColor Cyan
    buf generate
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Client SDK generation completed successfully!" -ForegroundColor Green
        
        # Show generated files
        Write-Host "`nGenerated files:" -ForegroundColor Cyan
        Get-ChildItem -Path "packages/clients" -Recurse -File | ForEach-Object {
            Write-Host "  $($_.FullName.Replace((Get-Location).Path, '').TrimStart('\'))" -ForegroundColor Gray
        }
        
        # Create package.json for TypeScript client
        if (Test-Path "packages/clients/typescript") {
            $packageJson = @"
{
  "name": "@exs/trading-client",
  "version": "1.0.0",
  "description": "TypeScript client for EXS Trading API",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "clean": "rimraf dist",
    "prepublishOnly": "npm run clean && npm run build"
  },
  "dependencies": {
    "@grpc/grpc-js": "^1.9.0",
    "@grpc/proto-loader": "^0.7.0",
    "google-protobuf": "^3.21.0"
  },
  "devDependencies": {
    "@types/node": "^18.0.0",
    "typescript": "^5.0.0",
    "rimraf": "^5.0.0"
  },
  "keywords": ["trading", "grpc", "protobuf", "exs"],
  "author": "EXS Team",
  "license": "MIT"
}
"@
            $packageJson | Out-File -FilePath "packages/clients/typescript/package.json" -Encoding UTF8
            Write-Host "Created package.json for TypeScript client" -ForegroundColor Green
        }
        
        # Create pom.xml for Java client
        if (Test-Path "packages/clients/java") {
            $pomXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.exs</groupId>
    <artifactId>trading-client</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    
    <name>EXS Trading Client</name>
    <description>Java client for EXS Trading API</description>
    
    <properties>
        <java.version>17</java.version>
        <grpc.version>1.58.0</grpc.version>
        <protobuf.version>3.24.0</protobuf.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>io.grpc</groupId>
            <artifactId>grpc-netty-shaded</artifactId>
            <version>`${grpc.version}</version>
        </dependency>
        <dependency>
            <groupId>io.grpc</groupId>
            <artifactId>grpc-protobuf</artifactId>
            <version>`${grpc.version}</version>
        </dependency>
        <dependency>
            <groupId>io.grpc</groupId>
            <artifactId>grpc-stub</artifactId>
            <version>`${grpc.version}</version>
        </dependency>
        <dependency>
            <groupId>javax.annotation</groupId>
            <artifactId>javax.annotation-api</artifactId>
            <version>1.3.2</version>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>`${java.version}</source>
                    <target>`${java.version}</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
"@
            $pomXml | Out-File -FilePath "packages/clients/java/pom.xml" -Encoding UTF8
            Write-Host "Created pom.xml for Java client" -ForegroundColor Green
        }
        
        # Create go.mod for Go client
        if (Test-Path "packages/clients/go") {
            $goMod = @"
module github.com/exs/trading-client

go 1.21

require (
    google.golang.org/grpc v1.58.0
    google.golang.org/protobuf v1.31.0
)

require (
    github.com/golang/protobuf v1.5.3 // indirect
    golang.org/x/net v0.12.0 // indirect
    golang.org/x/sys v0.10.0 // indirect
    golang.org/x/text v0.11.0 // indirect
    google.golang.org/genproto/googleapis/rpc v0.0.0-20230711160842-782d3b101e98 // indirect
)
"@
            $goMod | Out-File -FilePath "packages/clients/go/go.mod" -Encoding UTF8
            Write-Host "Created go.mod for Go client" -ForegroundColor Green
        }
        
    } else {
        Write-Host "Error: buf generate failed with exit code $LASTEXITCODE" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Error during client generation: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nClient SDK generation completed!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Review generated code in packages/clients/" -ForegroundColor White
Write-Host "2. Build and test the clients" -ForegroundColor White
Write-Host "3. Update your services to use the generated clients" -ForegroundColor White
