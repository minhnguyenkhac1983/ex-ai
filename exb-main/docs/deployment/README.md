# Deployment Documentation

Hướng dẫn triển khai hệ thống ngân hàng EXB trên các môi trường khác nhau.

## 📋 **Tổng quan**

Tài liệu này cung cấp hướng dẫn chi tiết cho việc triển khai:

- **Development Environment**: Môi trường phát triển
- **Staging Environment**: Môi trường kiểm thử
- **Production Environment**: Môi trường sản xuất
- **Disaster Recovery**: Khôi phục thảm họa

## 📁 **Cấu trúc tài liệu**

```
docs/deployment/
├── environments/                # Environment-specific guides
│   ├── development/            # Development setup
│   ├── staging/                # Staging setup
│   └── production/             # Production setup
│
├── kubernetes/                  # Kubernetes deployment
│   ├── helm-charts/            # Helm chart documentation
│   ├── manifests/              # K8s manifest guides
│   └── gitops/                 # GitOps deployment
│
├── docker/                      # Docker deployment
│   ├── docker-compose/         # Docker Compose guides
│   ├── dockerfiles/            # Dockerfile documentation
│   └── registry/               # Container registry
│
└── cloud/                       # Cloud deployment
    ├── aws/                    # AWS deployment
    ├── azure/                  # Azure deployment
    └── gcp/                    # GCP deployment
```

## 🚀 **Deployment Strategies**

### Blue-Green Deployment
```yaml
# Blue-Green deployment with Argo Rollouts
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: customer-service
spec:
  replicas: 5
  strategy:
    blueGreen:
      activeService: customer-service-active
      previewService: customer-service-preview
      autoPromotionEnabled: false
      scaleDownDelaySeconds: 30
      prePromotionAnalysis:
        templates:
        - templateName: success-rate
        args:
        - name: service-name
          value: customer-service-preview
```

### Canary Deployment
```yaml
# Canary deployment strategy
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: customer-service
spec:
  replicas: 5
  strategy:
    canary:
      steps:
      - setWeight: 20
      - pause: {duration: 60s}
      - setWeight: 40
      - pause: {duration: 60s}
      - setWeight: 60
      - pause: {duration: 60s}
      - setWeight: 80
      - pause: {duration: 60s}
      - setWeight: 100
```

## 🐳 **Docker Deployment**

### Docker Compose Development
```yaml
# docker-compose.yml for development
version: '3.8'
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: exb_banking
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7.2-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  kafka:
    image: confluentinc/cp-kafka:7.4.0
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    ports:
      - "9092:9092"
    depends_on:
      - zookeeper

  customer-service:
    build: ./backend/core-banking/customer-service
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/exb_banking
      SPRING_REDIS_HOST: redis
      SPRING_KAFKA_BOOTSTRAP_SERVERS: kafka:9092
    depends_on:
      - postgres
      - redis
      - kafka

volumes:
  postgres_data:
  redis_data:
```

### Multi-stage Dockerfile
```dockerfile
# Multi-stage Dockerfile for Spring Boot application
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app
COPY . .
RUN ./gradlew build -x test

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## ☸️ **Kubernetes Deployment**

### Helm Chart Structure
```yaml
# Chart.yaml
apiVersion: v2
name: exb-banking
description: EXB Banking System
version: 1.0.0
appVersion: "1.0.0"

# values.yaml
global:
  environment: production
  domain: exb.com

postgresql:
  enabled: true
  auth:
    postgresPassword: "postgres123"
    database: "exb_banking"

redis:
  enabled: true
  auth:
    enabled: false

kafka:
  enabled: true
  replicas: 3

customer-service:
  enabled: true
  replicas: 3
  resources:
    requests:
      memory: "512Mi"
      cpu: "250m"
    limits:
      memory: "1Gi"
      cpu: "500m"
```

### Kubernetes Manifests
```yaml
# customer-service-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: customer-service
  labels:
    app: customer-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: customer-service
  template:
    metadata:
      labels:
        app: customer-service
    spec:
      containers:
      - name: customer-service
        image: exb/customer-service:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "production"
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: url
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health/live
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/ready
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 5
```

## ☁️ **Cloud Deployment**

### AWS EKS Deployment
```bash
# Create EKS cluster
eksctl create cluster \
  --name exb-cluster \
  --region us-west-2 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed

# Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Deploy applications
kubectl apply -f infrastructure/gitops/argo-apps/
```

### Azure AKS Deployment
```bash
# Create AKS cluster
az aks create \
  --resource-group exb-rg \
  --name exb-cluster \
  --node-count 3 \
  --enable-addons monitoring \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group exb-rg --name exb-cluster

# Deploy applications
kubectl apply -f infrastructure/gitops/argo-apps/
```

## 🔄 **CI/CD Pipeline**

### GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Run tests
      run: |
        cd backend/core-banking/customer-service
        ./gradlew test

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Build Docker image
      run: |
        docker build -t exb/customer-service:${{ github.sha }} ./backend/core-banking/customer-service
        docker push exb/customer-service:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Deploy to Kubernetes
      run: |
        kubectl set image deployment/customer-service customer-service=exb/customer-service:${{ github.sha }}
        kubectl rollout status deployment/customer-service
```

### GitLab CI
```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

test:
  stage: test
  script:
    - cd backend/core-banking/customer-service
    - ./gradlew test

build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

deploy:
  stage: deploy
  script:
    - kubectl set image deployment/customer-service customer-service=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - kubectl rollout status deployment/customer-service
```

## 🔐 **Security Configuration**

### Secrets Management
```yaml
# Kubernetes secrets
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
data:
  url: amRiYzpwb3N0Z3Jlc3FsOi8vcG9zdGdyZXM6NTQzMi9leGJfYmFua2luZw==
  username: cG9zdGdyZXM=
  password: cG9zdGdyZXMxMjM=

# External secrets operator
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: postgres-secret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: SecretStore
  target:
    name: postgres-secret
  data:
  - secretKey: url
    remoteRef:
      key: postgres/url
  - secretKey: username
    remoteRef:
      key: postgres/username
  - secretKey: password
    remoteRef:
      key: postgres/password
```

### Network Policies
```yaml
# Network policy for customer service
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: customer-service-network-policy
spec:
  podSelector:
    matchLabels:
      app: customer-service
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: database
    ports:
    - protocol: TCP
      port: 5432
```

## 📊 **Monitoring & Observability**

### Prometheus Configuration
```yaml
# prometheus-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
    - job_name: 'customer-service'
      static_configs:
      - targets: ['customer-service:8080']
      metrics_path: '/actuator/prometheus'
```

### Grafana Dashboards
```yaml
# grafana-dashboard.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboard
data:
  dashboard.json: |
    {
      "dashboard": {
        "title": "Customer Service Dashboard",
        "panels": [
          {
            "title": "Request Rate",
            "type": "graph",
            "targets": [
              {
                "expr": "rate(http_requests_total[5m])",
                "legendFormat": "{{method}} {{path}}"
              }
            ]
          }
        ]
      }
    }
```

## 🚨 **Disaster Recovery**

### Backup Strategy
```bash
# Database backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"

# PostgreSQL backup
pg_dump -h postgres -U postgres exb_banking > $BACKUP_DIR/postgres_$DATE.sql

# Redis backup
redis-cli -h redis BGSAVE
cp /var/lib/redis/dump.rdb $BACKUP_DIR/redis_$DATE.rdb

# Upload to S3
aws s3 cp $BACKUP_DIR/postgres_$DATE.sql s3://exb-backups/database/
aws s3 cp $BACKUP_DIR/redis_$DATE.rdb s3://exb-backups/redis/
```

### Recovery Procedures
```bash
# Database recovery script
#!/bin/bash
BACKUP_FILE=$1

# Stop applications
kubectl scale deployment customer-service --replicas=0
kubectl scale deployment account-service --replicas=0

# Restore database
psql -h postgres -U postgres exb_banking < $BACKUP_FILE

# Restart applications
kubectl scale deployment customer-service --replicas=3
kubectl scale deployment account-service --replicas=3
```

## 📚 **Documentation Standards**

### Deployment Checklist
- [ ] Infrastructure provisioning
- [ ] Application deployment
- [ ] Database migration
- [ ] Security configuration
- [ ] Monitoring setup
- [ ] Load testing
- [ ] Rollback plan

### Post-Deployment Validation
- [ ] Health checks passing
- [ ] Metrics collection working
- [ ] Logs flowing correctly
- [ ] Performance benchmarks met
- [ ] Security scans passed

---

*Deployment documentation được thiết kế để hỗ trợ DevOps teams trong việc triển khai và vận hành hệ thống ngân hàng EXB một cách an toàn và hiệu quả.*
