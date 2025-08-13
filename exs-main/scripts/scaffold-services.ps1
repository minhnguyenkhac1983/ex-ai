# Scaffold Services Script for Securities Exchange System
# This script creates the standard structure for all microservices

param(
    [string]$ServiceName,
    [string]$Language = "java"
)

# Standard service structure
$ServiceStructure = @{
    "matching-engine" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Core matching engine for low-latency order processing"
    }
    "market-data-gateway" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Market data gateway for real-time data distribution"
    }
    "order-gateway" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Order gateway for order management and validation"
    }
    "risk-engine" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Risk management engine for position monitoring"
    }
    "clearing" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Clearing service for trade settlement"
    }
    "settlement-service" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Settlement processing service"
    }
    "custody-service" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Custody management service"
    }
    "compliance-service" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Compliance monitoring and reporting"
    }
    "surveillance-service" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Market surveillance and monitoring"
    }
    "member-service" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Member management and authentication"
    }
    "reporting-service" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Reporting and analytics service"
    }
    "api-gateway" = @{
        Language = "java"
        Framework = "spring-cloud-gateway"
        Description = "API Gateway and BFF for external APIs"
    }
    "data-pipeline" = @{
        Language = "java"
        Framework = "spring-boot"
        Description = "Data processing pipeline for analytics"
    }
}

function Create-ServiceStructure {
    param(
        [string]$ServiceName,
        [hashtable]$Config
    )
    
    $ServicePath = "services/$ServiceName"
    
    Write-Host "Creating service structure for: $ServiceName" -ForegroundColor Green
    
    # Create main service directory
    if (!(Test-Path $ServicePath)) {
        New-Item -ItemType Directory -Path $ServicePath -Force
    }
    
    # Create standard files
    $Files = @{
        "Dockerfile" = @"
# Multi-stage build for $ServiceName
FROM maven:3.9.5-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
"@
        
        "pom.xml" = @"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    
    <groupId>com.exs</groupId>
    <artifactId>$ServiceName</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    
    <name>$ServiceName</name>
    <description>$($Config.Description)</description>
    
    <properties>
        <java.version>17</java.version>
        <spring-cloud.version>2023.0.0</spring-cloud.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
"@
        
        "Makefile" = @"
# Makefile for $ServiceName

SERVICE_NAME = $ServiceName
DOCKER_REGISTRY = localhost:5000
VERSION ?= dev

.PHONY: help build docker-build docker-push helm-install helm-uninstall clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the application
	mvn clean package -DskipTests

docker-build: ## Build Docker image
	docker build -t $(DOCKER_REGISTRY)/$(SERVICE_NAME):$(VERSION) .

docker-push: ## Push Docker image to registry
	docker push $(DOCKER_REGISTRY)/$(SERVICE_NAME):$(VERSION)

helm-install: ## Install service with Helm
	helm install $(SERVICE_NAME) ../../platform/kubernetes/charts/service \
		--set image.repository=$(DOCKER_REGISTRY)/$(SERVICE_NAME) \
		--set image.tag=$(VERSION) \
		--set nameOverride=$(SERVICE_NAME) \
		--namespace exs --create-namespace

helm-uninstall: ## Uninstall service with Helm
	helm uninstall $(SERVICE_NAME) -n exs

clean: ## Clean build artifacts
	mvn clean
	docker rmi $(DOCKER_REGISTRY)/$(SERVICE_NAME):$(VERSION) 2>/dev/null || true
"@
        
        "README.md" = @"
# $ServiceName

$($Config.Description)

## Quick Start

\`\`\`bash
# Build the application
make build

# Build Docker image
make docker-build tag=dev

# Deploy with Helm
make helm-install tag=dev
\`\`\`

## Development

This service is built with:
- **Language**: $($Config.Language)
- **Framework**: $($Config.Framework)
- **Architecture**: Domain-Driven Design (DDD)

## API Documentation

- REST API: http://localhost:8080/swagger-ui.html
- Health Check: http://localhost:8080/actuator/health
- Metrics: http://localhost:8080/actuator/metrics
"@
        
        ".dockerignore" = @"
target/
!target/*.jar
.git
.gitignore
README.md
Makefile
*.md
"@
        
        ".gitignore" = @"
# Compiled class file
*.class

# Log file
*.log

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files #
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*
replay_pid*

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties
.mvn/wrapper/maven-wrapper.jar

# IDE
.idea/
*.iws
*.iml
*.ipr
.vscode/
.settings/
.project
.classpath

# OS
.DS_Store
Thumbs.db
"@
    }
    
    # Create each file
    foreach ($File in $Files.GetEnumerator()) {
        $FilePath = Join-Path $ServicePath $File.Key
        $File.Value | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "Created: $FilePath" -ForegroundColor Yellow
    }
    
    # Create source directory structure
    $SourceDirs = @(
        "src/main/java/com/exs/$($ServiceName.Replace('-', ''))",
        "src/main/java/com/exs/$($ServiceName.Replace('-', ''))/domain",
        "src/main/java/com/exs/$($ServiceName.Replace('-', ''))/application",
        "src/main/java/com/exs/$($ServiceName.Replace('-', ''))/infrastructure",
        "src/main/java/com/exs/$($ServiceName.Replace('-', ''))/interfaces",
        "src/main/resources",
        "src/test/java/com/exs/$($ServiceName.Replace('-', ''))",
        "src/test/resources"
    )
    
    foreach ($Dir in $SourceDirs) {
        $FullPath = Join-Path $ServicePath $Dir
        if (!(Test-Path $FullPath)) {
            New-Item -ItemType Directory -Path $FullPath -Force
            Write-Host "Created directory: $FullPath" -ForegroundColor Cyan
        }
    }
    
    # Create main application class
    $MainClass = @"
package com.exs.$($ServiceName.Replace('-', ''));

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class $($ServiceName.Replace('-', '').Replace('-', '').Substring(0,1).ToUpper() + $ServiceName.Replace('-', '').Replace('-', '').Substring(1))Application {
    
    public static void main(String[] args) {
        SpringApplication.run($($ServiceName.Replace('-', '').Replace('-', '').Substring(0,1).ToUpper() + $ServiceName.Replace('-', '').Replace('-', '').Substring(1))Application.class, args);
    }
}
"@
    
    $MainClassPath = Join-Path $ServicePath "src/main/java/com/exs/$($ServiceName.Replace('-', ''))/$($ServiceName.Replace('-', '').Replace('-', '').Substring(0,1).ToUpper() + $ServiceName.Replace('-', '').Replace('-', '').Substring(1))Application.java"
    $MainClass | Out-File -FilePath $MainClassPath -Encoding UTF8
    Write-Host "Created main class: $MainClassPath" -ForegroundColor Green
}

# Main execution
if ($ServiceName) {
    if ($ServiceStructure.ContainsKey($ServiceName)) {
        Create-ServiceStructure -ServiceName $ServiceName -Config $ServiceStructure[$ServiceName]
    } else {
        Write-Host "Unknown service: $ServiceName" -ForegroundColor Red
        Write-Host "Available services: $($ServiceStructure.Keys -join ', ')" -ForegroundColor Yellow
    }
} else {
    Write-Host "Scaffolding all services..." -ForegroundColor Green
    foreach ($Service in $ServiceStructure.GetEnumerator()) {
        Create-ServiceStructure -ServiceName $Service.Key -Config $Service.Value
        Write-Host "---" -ForegroundColor Gray
    }
}

Write-Host "Service scaffolding completed!" -ForegroundColor Green
