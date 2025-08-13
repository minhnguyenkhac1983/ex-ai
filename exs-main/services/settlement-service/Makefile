# Makefile for settlement-service

SERVICE_NAME = settlement-service
DOCKER_REGISTRY = localhost:5000
VERSION ?= dev

.PHONY: help build docker-build docker-push helm-install helm-uninstall clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", 1, 2}' 

build: ## Build the application
	mvn clean package -DskipTests

docker-build: ## Build Docker image
	docker build -t /: .

docker-push: ## Push Docker image to registry
	docker push /:

helm-install: ## Install service with Helm
	helm install  ../../platform/kubernetes/charts/service \
		--set image.repository=/ \
		--set image.tag= \
		--set nameOverride= \
		--namespace exs --create-namespace

helm-uninstall: ## Uninstall service with Helm
	helm uninstall  -n exs

clean: ## Clean build artifacts
	mvn clean
	docker rmi /: 2>/dev/null || true
