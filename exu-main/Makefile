.PHONY: help dev test build deploy clean migrate-up migrate-down docker-build docker-up docker-down

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dev: ## Start development environment
	@echo "Starting development environment..."
	docker-compose up -d
	@echo "Waiting for services to be ready..."
	sleep 10
	@echo "Development environment ready!"

test: test-unit test-integration ## Run all tests

test-unit: ## Run unit tests
	@echo "Running unit tests..."
	@if [ -f "services/iam/go.mod" ]; then \
		echo "Testing IAM service..."; \
		cd services/iam && go test ./... -v && cd ../..; \
	fi
	@if [ -f "services/banking/go.mod" ]; then \
		echo "Testing Banking service..."; \
		cd services/banking && go test ./... -v && cd ../..; \
	fi

test-integration: ## Run integration tests
	@echo "Running integration tests..."
	@echo "TODO: Implement integration tests"

build: ## Build all services
	@echo "Building services..."
	@if [ -f "services/iam/go.mod" ]; then \
		echo "Building IAM service..."; \
		cd services/iam && go build -o bin/iam ./main.go && cd ../..; \
	fi
	@if [ -f "services/banking/go.mod" ]; then \
		echo "Building Banking service..."; \
		cd services/banking && go build -o bin/banking ./main.go && cd ../..; \
	fi

deploy: ## Deploy to staging
	@echo "Deploying to staging..."
	@echo "TODO: Implement deployment"

clean: ## Clean build artifacts
	@echo "Cleaning..."
	find . -type d -name bin -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name dist -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean complete"

migrate-up: ## Run database migrations
	@echo "Running migrations..."
	@echo "TODO: Implement migrations"

migrate-down: ## Rollback database migrations
	@echo "Rolling back migrations..."
	@echo "TODO: Implement rollback"

docker-build: ## Build Docker images
	@echo "Building Docker images..."
	docker-compose build

docker-up: ## Start Docker containers
	@echo "Starting Docker containers..."
	docker-compose up -d

docker-down: ## Stop Docker containers
	@echo "Stopping Docker containers..."
	docker-compose down

docker-logs: ## View Docker logs
	docker-compose logs -f

lint: ## Run linters
	@echo "Running linters..."
	@echo "TODO: Implement linting"

format: ## Format code
	@echo "Formatting code..."
	@for dir in services/*/; do \
		if [ -f "$$dir/go.mod" ]; then \
			cd $$dir && go fmt ./... && cd ../..; \
		fi \
	done

