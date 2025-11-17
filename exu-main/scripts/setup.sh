#!/bin/bash

set -e

echo "🚀 Setting up Vietnam Financial Center Platform..."

# Check prerequisites
echo "📋 Checking prerequisites..."
command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required but not installed. Aborting." >&2; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "❌ Docker Compose is required but not installed. Aborting." >&2; exit 1; }
command -v go >/dev/null 2>&1 || { echo "⚠️  Go is not installed. Some features may not work." >&2; }

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << EOF
ENVIRONMENT=development
DATABASE_URL=postgres://exu:exu_dev_password@localhost:5432/exu_financial?sslmode=disable
JWT_SECRET=dev-secret-key-change-in-production
REDIS_URL=redis://localhost:6379
KAFKA_BROKERS=localhost:9092
EOF
    echo "✅ .env file created"
fi

# Start infrastructure
echo "🐳 Starting Docker containers..."
docker-compose up -d

echo "⏳ Waiting for services to be ready..."
sleep 15

# Check service health
echo "🏥 Checking service health..."
docker-compose ps

echo "✅ Setup complete!"
echo ""
echo "📊 Services available at:"
echo "  - API Gateway (Kong): http://localhost:8000"
echo "  - Kong Admin: http://localhost:8001"
echo "  - Prometheus: http://localhost:9090"
echo "  - Grafana: http://localhost:3000 (admin/admin)"
echo ""
echo "📚 Next steps:"
echo "  1. Run migrations: make migrate-up"
echo "  2. Start services: make dev"
echo "  3. Run tests: make test"

