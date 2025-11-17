# PowerShell setup script for Windows

Write-Host "🚀 Setting up Vietnam Financial Center Platform..." -ForegroundColor Green

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker is required but not installed. Aborting." -ForegroundColor Red
    exit 1
}
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker Compose is required but not installed. Aborting." -ForegroundColor Red
    exit 1
}

# Create .env file if it doesn't exist
if (-not (Test-Path .env)) {
    Write-Host "📝 Creating .env file..." -ForegroundColor Yellow
    @"
ENVIRONMENT=development
DATABASE_URL=postgres://exu:exu_dev_password@localhost:5432/exu_financial?sslmode=disable
JWT_SECRET=dev-secret-key-change-in-production
REDIS_URL=redis://localhost:6379
KAFKA_BROKERS=localhost:9092
"@ | Out-File -FilePath .env -Encoding utf8
    Write-Host "✅ .env file created" -ForegroundColor Green
}

# Start infrastructure
Write-Host "🐳 Starting Docker containers..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Check service health
Write-Host "🏥 Checking service health..." -ForegroundColor Yellow
docker-compose ps

Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Services available at:" -ForegroundColor Cyan
Write-Host "  - API Gateway (Kong): http://localhost:8000"
Write-Host "  - Kong Admin: http://localhost:8001"
Write-Host "  - Prometheus: http://localhost:9090"
Write-Host "  - Grafana: http://localhost:3000 (admin/admin)"
Write-Host ""
Write-Host "📚 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Run migrations: make migrate-up"
Write-Host "  2. Start services: make dev"
Write-Host "  3. Run tests: make test"

