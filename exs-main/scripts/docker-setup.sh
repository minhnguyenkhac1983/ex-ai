#!/bin/bash

# EXS Docker Setup Script
# This script helps manage the Docker Compose setup for the Securities Exchange System

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if Docker Compose is available
check_docker_compose() {
    if ! docker-compose --version > /dev/null 2>&1; then
        print_error "Docker Compose is not available. Please install Docker Compose and try again."
        exit 1
    fi
    print_success "Docker Compose is available"
}

# Function to start development environment
start_dev() {
    print_status "Starting development environment..."
    docker-compose -f docker-compose.dev.yml up -d
    print_success "Development environment started"
    print_status "Services available at:"
    echo "  - PostgreSQL: localhost:5432"
    echo "  - Redis: localhost:6379"
    echo "  - Kafka: localhost:9092"
    echo "  - Kafka UI: http://localhost:8080"
    echo "  - Redis Commander: http://localhost:8081"
    echo "  - PgAdmin: http://localhost:8082"
    echo "  - Prometheus: http://localhost:9090"
    echo "  - Grafana: http://localhost:3002"
}

# Function to start full environment
start_full() {
    print_status "Starting full environment..."
    docker-compose up -d
    print_success "Full environment started"
    print_status "Services available at:"
    echo "  - Trading Platform: http://localhost:3000"
    echo "  - Admin Dashboard: http://localhost:3001"
    echo "  - API Gateway: http://localhost:80"
    echo "  - Trading Engine: http://localhost:8080"
    echo "  - Order Management: http://localhost:8082"
    echo "  - Market Data: http://localhost:8084"
    echo "  - Risk Management: http://localhost:8086"
    echo "  - User Management: http://localhost:8088"
}

# Function to stop environment
stop_env() {
    print_status "Stopping environment..."
    if [ "$1" = "dev" ]; then
        docker-compose -f docker-compose.dev.yml down
    else
        docker-compose down
    fi
    print_success "Environment stopped"
}

# Function to restart environment
restart_env() {
    print_status "Restarting environment..."
    stop_env $1
    sleep 2
    if [ "$1" = "dev" ]; then
        start_dev
    else
        start_full
    fi
}

# Function to show logs
show_logs() {
    if [ "$1" = "dev" ]; then
        docker-compose -f docker-compose.dev.yml logs -f
    else
        docker-compose logs -f
    fi
}

# Function to show status
show_status() {
    print_status "Container status:"
    if [ "$1" = "dev" ]; then
        docker-compose -f docker-compose.dev.yml ps
    else
        docker-compose ps
    fi
}

# Function to clean up
cleanup() {
    print_warning "This will remove all containers, networks, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_status "Cleaning up..."
        docker-compose down -v --remove-orphans
        docker-compose -f docker-compose.dev.yml down -v --remove-orphans
        docker system prune -f
        print_success "Cleanup completed"
    else
        print_status "Cleanup cancelled"
    fi
}

# Function to build services
build_services() {
    print_status "Building services..."
    if [ "$1" = "dev" ]; then
        # For dev, we only build infrastructure services
        print_status "Development mode - only infrastructure services will be built"
    else
        docker-compose build
    fi
    print_success "Build completed"
}

# Function to show help
show_help() {
    echo "EXS Docker Setup Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTION]"
    echo ""
    echo "Commands:"
    echo "  start-dev     Start development environment (infrastructure only)"
    echo "  start-full    Start full environment (all services)"
    echo "  stop          Stop environment"
    echo "  restart       Restart environment"
    echo "  logs          Show logs"
    echo "  status        Show container status"
    echo "  build         Build services"
    echo "  cleanup       Remove all containers, networks, and volumes"
    echo "  help          Show this help message"
    echo ""
    echo "Options:"
    echo "  dev           Use development configuration"
    echo ""
    echo "Examples:"
    echo "  $0 start-dev          # Start development environment"
    echo "  $0 start-full         # Start full environment"
    echo "  $0 stop dev           # Stop development environment"
    echo "  $0 logs dev           # Show development logs"
    echo "  $0 status dev         # Show development status"
}

# Main script logic
main() {
    check_docker
    check_docker_compose

    case "$1" in
        "start-dev")
            start_dev
            ;;
        "start-full")
            start_full
            ;;
        "stop")
            stop_env $2
            ;;
        "restart")
            restart_env $2
            ;;
        "logs")
            show_logs $2
            ;;
        "status")
            show_status $2
            ;;
        "build")
            build_services $2
            ;;
        "cleanup")
            cleanup
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
