# EXS Docker Setup Script for Windows
# This script helps manage the Docker Compose setup for the Securities Exchange System

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$Option
)

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Function to check if Docker is running
function Test-Docker {
    try {
        docker info | Out-Null
        Write-Success "Docker is running"
        return $true
    }
    catch {
        Write-Error "Docker is not running. Please start Docker Desktop and try again."
        return $false
    }
}

# Function to check if Docker Compose is available
function Test-DockerCompose {
    try {
        docker-compose --version | Out-Null
        Write-Success "Docker Compose is available"
        return $true
    }
    catch {
        Write-Error "Docker Compose is not available. Please install Docker Compose and try again."
        return $false
    }
}

# Function to start development environment
function Start-DevEnvironment {
    Write-Status "Starting development environment..."
    docker-compose -f docker-compose.dev.yml up -d
    Write-Success "Development environment started"
    Write-Status "Services available at:"
    Write-Host "  - PostgreSQL: localhost:5432"
    Write-Host "  - Redis: localhost:6379"
    Write-Host "  - Kafka: localhost:9092"
    Write-Host "  - Kafka UI: http://localhost:8080"
    Write-Host "  - Redis Commander: http://localhost:8081"
    Write-Host "  - PgAdmin: http://localhost:8082"
    Write-Host "  - Prometheus: http://localhost:9090"
    Write-Host "  - Grafana: http://localhost:3002"
}

# Function to start full environment
function Start-FullEnvironment {
    Write-Status "Starting full environment..."
    docker-compose up -d
    Write-Success "Full environment started"
    Write-Status "Services available at:"
    Write-Host "  - Trading Platform: http://localhost:3000"
    Write-Host "  - Admin Dashboard: http://localhost:3001"
    Write-Host "  - API Gateway: http://localhost:80"
    Write-Host "  - Trading Engine: http://localhost:8080"
    Write-Host "  - Order Management: http://localhost:8082"
    Write-Host "  - Market Data: http://localhost:8084"
    Write-Host "  - Risk Management: http://localhost:8086"
    Write-Host "  - User Management: http://localhost:8088"
}

# Function to stop environment
function Stop-Environment {
    param([string]$Type)
    
    Write-Status "Stopping environment..."
    if ($Type -eq "dev") {
        docker-compose -f docker-compose.dev.yml down
    }
    else {
        docker-compose down
    }
    Write-Success "Environment stopped"
}

# Function to restart environment
function Restart-Environment {
    param([string]$Type)
    
    Write-Status "Restarting environment..."
    Stop-Environment $Type
    Start-Sleep -Seconds 2
    if ($Type -eq "dev") {
        Start-DevEnvironment
    }
    else {
        Start-FullEnvironment
    }
}

# Function to show logs
function Show-Logs {
    param([string]$Type)
    
    if ($Type -eq "dev") {
        docker-compose -f docker-compose.dev.yml logs -f
    }
    else {
        docker-compose logs -f
    }
}

# Function to show status
function Show-Status {
    param([string]$Type)
    
    Write-Status "Container status:"
    if ($Type -eq "dev") {
        docker-compose -f docker-compose.dev.yml ps
    }
    else {
        docker-compose ps
    }
}

# Function to clean up
function Clear-Environment {
    Write-Warning "This will remove all containers, networks, and volumes. Are you sure? (y/N)"
    $response = Read-Host
    if ($response -match "^[yY](es)?$") {
        Write-Status "Cleaning up..."
        docker-compose down -v --remove-orphans
        docker-compose -f docker-compose.dev.yml down -v --remove-orphans
        docker system prune -f
        Write-Success "Cleanup completed"
    }
    else {
        Write-Status "Cleanup cancelled"
    }
}

# Function to build services
function Build-Services {
    param([string]$Type)
    
    Write-Status "Building services..."
    if ($Type -eq "dev") {
        Write-Status "Development mode - only infrastructure services will be built"
    }
    else {
        docker-compose build
    }
    Write-Success "Build completed"
}

# Function to show help
function Show-Help {
    Write-Host "EXS Docker Setup Script for Windows"
    Write-Host ""
    Write-Host "Usage: .\docker-setup.ps1 [COMMAND] [OPTION]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  start-dev     Start development environment (infrastructure only)"
    Write-Host "  start-full    Start full environment (all services)"
    Write-Host "  stop          Stop environment"
    Write-Host "  restart       Restart environment"
    Write-Host "  logs          Show logs"
    Write-Host "  status        Show container status"
    Write-Host "  build         Build services"
    Write-Host "  cleanup       Remove all containers, networks, and volumes"
    Write-Host "  help          Show this help message"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  dev           Use development configuration"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\docker-setup.ps1 start-dev          # Start development environment"
    Write-Host "  .\docker-setup.ps1 start-full         # Start full environment"
    Write-Host "  .\docker-setup.ps1 stop dev           # Stop development environment"
    Write-Host "  .\docker-setup.ps1 logs dev           # Show development logs"
    Write-Host "  .\docker-setup.ps1 status dev         # Show development status"
}

# Main script logic
function Main {
    if (-not (Test-Docker)) {
        exit 1
    }
    
    if (-not (Test-DockerCompose)) {
        exit 1
    }
    
    switch ($Command) {
        "start-dev" {
            Start-DevEnvironment
        }
        "start-full" {
            Start-FullEnvironment
        }
        "stop" {
            Stop-Environment $Option
        }
        "restart" {
            Restart-Environment $Option
        }
        "logs" {
            Show-Logs $Option
        }
        "status" {
            Show-Status $Option
        }
        "build" {
            Build-Services $Option
        }
        "cleanup" {
            Clear-Environment
        }
        "help" {
            Show-Help
        }
        default {
            Write-Error "Unknown command: $Command"
            Write-Host ""
            Show-Help
            exit 1
        }
    }
}

# Run main function
Main
