# Kubernetes Infrastructure

Cấu hình Kubernetes cho deployment và quản lý hệ thống EXB.

## 📁 Cấu trúc

```
kubernetes/
├── base/              # Base configurations
├── apps/              # Application deployments
└── platform/          # Platform services
```

## 🏗️ Kiến trúc

- **Kubernetes**: 1.29+
- **Ingress**: NGINX/Contour/Traefik
- **Service Mesh**: Istio/Linkerd
- **GitOps**: Argo CD/FluxCD
- **Progressive Delivery**: Argo Rollouts
- **Helm**: Chart management

## 📋 Thành phần chính

### Base
- Namespace definitions
- RBAC configurations
- Network policies
- Storage classes
- Resource quotas

### Apps
- Microservices deployments
- Database deployments
- Monitoring stack
- Security services
- API Gateway

### Platform
- Ingress controllers
- Service mesh
- Monitoring stack
- Logging stack
- Backup solutions

## 🚀 Deployment

```bash
# Apply base configurations
kubectl apply -f base/

# Deploy applications
kubectl apply -f apps/

# Deploy platform services
kubectl apply -f platform/
```

## 📡 Services

### Core Banking
- Customer Service
- Account Service
- Transaction Service
- Payment Service

### Supporting Services
- Authentication Service
- Notification Service
- Analytics Service
- Security Services

### Infrastructure
- PostgreSQL
- Redis
- Kafka
- Monitoring Stack

## 📊 Monitoring

- Prometheus metrics
- Grafana dashboards
- Alertmanager
- Service mesh metrics
- Resource monitoring

## 🔒 Bảo mật

- Network policies
- Pod security policies
- RBAC
- Secrets management
- mTLS
- Admission controllers

## 🔄 GitOps

- Argo CD applications
- FluxCD configurations
- Progressive delivery
- Canary deployments
- Blue-green deployments
