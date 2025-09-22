# 🚀 DEVOPS PIPELINE WORKFLOW CHO HỆ THỐNG P2P LENDING

## 📋 TỔNG QUAN

Tài liệu này mô tả một DevOps Pipeline Workflow hiện đại và toàn diện cho hệ thống P2P Lending, bao gồm CI/CD, Infrastructure as Code, Monitoring, Security, và các best practices để đảm bảo tính ổn định, bảo mật và khả năng mở rộng của hệ thống.

---

## 🏗️ KIẾN TRÚC DEVOPS TỔNG THỂ

### **DevOps Architecture Overview**

```mermaid
graph TB
    subgraph "Development"
        A[Developer]
        B[Git Repository]
        C[Feature Branch]
    end
    
    subgraph "CI/CD Pipeline"
        D[GitLab CI/CD]
        E[Build Stage]
        F[Test Stage]
        G[Security Scan]
        H[Deploy Stage]
    end
    
    subgraph "Infrastructure"
        I[Terraform]
        J[Kubernetes]
        K[AWS Services]
    end
    
    subgraph "Monitoring"
        L[Prometheus]
        M[Grafana]
        N[ELK Stack]
        O[AlertManager]
    end
    
    subgraph "Security"
        P[Vault]
        Q[Trivy]
        R[SonarQube]
        S[OWASP ZAP]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    I --> J
    J --> K
    K --> L
    L --> M
    L --> N
    L --> O
    G --> P
    G --> Q
    G --> R
    G --> S
```

---

## 🔄 CI/CD PIPELINE WORKFLOW

### **1. GitLab CI/CD Pipeline**

#### **Pipeline Configuration (.gitlab-ci.yml)**
```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - security
  - package
  - deploy
  - monitor

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"
  DOCKER_BUILDKIT: 1
  COMPOSE_DOCKER_CLI_BUILD: 1

# Build Stage
build:frontend:
  stage: build
  image: node:18-alpine
  script:
    - cd frontend
    - npm ci
    - npm run build
    - npm run test:unit
  artifacts:
    paths:
      - frontend/dist/
    expire_in: 1 hour
  only:
    - main
    - develop
    - merge_requests

build:backend:
  stage: build
  image: node:18-alpine
  script:
    - cd backend
    - npm ci
    - npm run build
    - npm run test:unit
  artifacts:
    paths:
      - backend/dist/
    expire_in: 1 hour
  only:
    - main
    - develop
    - merge_requests

# Test Stage
test:integration:
  stage: test
  image: node:18-alpine
  services:
    - postgres:15
    - redis:7
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: test_user
    POSTGRES_PASSWORD: test_password
    REDIS_URL: redis://redis:6379
  script:
    - cd backend
    - npm run test:integration
  dependencies:
    - build:backend
  only:
    - main
    - develop
    - merge_requests

test:e2e:
  stage: test
  image: cypress/included:12.0.0
  services:
    - postgres:15
    - redis:7
  script:
    - cd frontend
    - npm run test:e2e
  dependencies:
    - build:frontend
    - build:backend
  only:
    - main
    - develop

# Security Stage
security:scan:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy fs --format gitlab .
    - trivy image --format gitlab $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  allow_failure: true
  only:
    - main
    - develop
    - merge_requests

security:owasp:
  stage: security
  image: owasp/zap2docker-stable:latest
  script:
    - zap-baseline.py -t http://backend:3000
  allow_failure: true
  only:
    - main
    - develop

# Package Stage
package:docker:
  stage: package
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  dependencies:
    - build:frontend
    - build:backend
  only:
    - main
    - develop

# Deploy Stage
deploy:staging:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context staging
    - helm upgrade --install p2p-lending ./helm-chart
      --set image.tag=$CI_COMMIT_SHA
      --set environment=staging
  environment:
    name: staging
    url: https://staging.p2plending.com
  dependencies:
    - package:docker
  only:
    - develop

deploy:production:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context production
    - helm upgrade --install p2p-lending ./helm-chart
      --set image.tag=$CI_COMMIT_SHA
      --set environment=production
  environment:
    name: production
    url: https://p2plending.com
  dependencies:
    - package:docker
  when: manual
  only:
    - main

# Monitor Stage
monitor:health:
  stage: monitor
  image: curlimages/curl:latest
  script:
    - curl -f $STAGING_URL/health || exit 1
    - curl -f $STAGING_URL/metrics || exit 1
  dependencies:
    - deploy:staging
  only:
    - develop
```

### **2. Multi-Environment Pipeline**

#### **Environment Strategy**
```yaml
# environments.yml
environments:
  development:
    url: https://dev.p2plending.com
    kubernetes_context: dev-cluster
    database: dev-postgres
    redis: dev-redis
    
  staging:
    url: https://staging.p2plending.com
    kubernetes_context: staging-cluster
    database: staging-postgres
    redis: staging-redis
    
  production:
    url: https://p2plending.com
    kubernetes_context: prod-cluster
    database: prod-postgres
    redis: prod-redis
```

---

## 🐳 CONTAINERIZATION STRATEGY

### **1. Docker Configuration**

#### **Multi-stage Dockerfile**
```dockerfile
# Dockerfile
# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY frontend/package*.json ./frontend/
COPY backend/package*.json ./backend/

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build applications
RUN npm run build:frontend
RUN npm run build:backend

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Install production dependencies
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/frontend/dist ./frontend/dist
COPY --from=builder /app/backend/dist ./backend/dist
COPY --from=builder /app/backend/package*.json ./backend/

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Set ownership
RUN chown -R nextjs:nodejs /app
USER nextjs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Expose port
EXPOSE 3000

# Start application
CMD ["npm", "start"]
```

#### **Docker Compose for Development**
```yaml
# docker-compose.yml
version: '3.8'

services:
  frontend:
    build:
      context: .
      dockerfile: Dockerfile.frontend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - REACT_APP_API_URL=http://localhost:3001
    volumes:
      - ./frontend:/app
      - /app/node_modules
    depends_on:
      - backend

  backend:
    build:
      context: .
      dockerfile: Dockerfile.backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://user:password@postgres:5432/p2plending
      - REDIS_URL=redis://redis:6379
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=p2plending
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend

volumes:
  postgres_data:
  redis_data:
```

---

## ☸️ KUBERNETES DEPLOYMENT

### **1. Kubernetes Manifests**

#### **Namespace Configuration**
```yaml
# k8s/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: p2p-lending
  labels:
    name: p2p-lending
    environment: production
```

#### **ConfigMap**
```yaml
# k8s/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: p2p-lending-config
  namespace: p2p-lending
data:
  NODE_ENV: "production"
  LOG_LEVEL: "info"
  API_VERSION: "v1"
  CORS_ORIGIN: "https://p2plending.com"
  RATE_LIMIT_WINDOW_MS: "900000"
  RATE_LIMIT_MAX_REQUESTS: "100"
```

#### **Secrets**
```yaml
# k8s/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: p2p-lending-secrets
  namespace: p2p-lending
type: Opaque
data:
  DATABASE_URL: <base64-encoded-database-url>
  REDIS_URL: <base64-encoded-redis-url>
  JWT_SECRET: <base64-encoded-jwt-secret>
  ENCRYPTION_KEY: <base64-encoded-encryption-key>
  API_KEYS: <base64-encoded-api-keys>
```

#### **Deployment**
```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: p2p-lending-backend
  namespace: p2p-lending
  labels:
    app: p2p-lending-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: p2p-lending-backend
  template:
    metadata:
      labels:
        app: p2p-lending-backend
    spec:
      containers:
      - name: backend
        image: registry.gitlab.com/company/p2p-lending:latest
        ports:
        - containerPort: 3001
        env:
        - name: NODE_ENV
          valueFrom:
            configMapKeyRef:
              name: p2p-lending-config
              key: NODE_ENV
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: p2p-lending-secrets
              key: DATABASE_URL
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3001
          initialDelaySeconds: 5
          periodSeconds: 5
        volumeMounts:
        - name: logs
          mountPath: /app/logs
      volumes:
      - name: logs
        emptyDir: {}
```

#### **Service**
```yaml
# k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: p2p-lending-backend-service
  namespace: p2p-lending
spec:
  selector:
    app: p2p-lending-backend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3001
  type: ClusterIP
```

#### **Ingress**
```yaml
# k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: p2p-lending-ingress
  namespace: p2p-lending
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
spec:
  tls:
  - hosts:
    - p2plending.com
    - api.p2plending.com
    secretName: p2p-lending-tls
  rules:
  - host: p2plending.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: p2p-lending-frontend-service
            port:
              number: 80
  - host: api.p2plending.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: p2p-lending-backend-service
            port:
              number: 80
```

---

## 🏗️ INFRASTRUCTURE AS CODE

### **1. Terraform Configuration**

#### **Main Configuration**
```hcl
# terraform/main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
  
  backend "s3" {
    bucket = "p2p-lending-terraform-state"
    key    = "infrastructure/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "p2p-lending"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# VPC Configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "p2p-lending-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}

# EKS Cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name    = "p2p-lending-cluster"
  cluster_version = "1.28"
  
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  
  # EKS Managed Node Groups
  eks_managed_node_groups = {
    main = {
      name = "main"
      
      instance_types = ["t3.medium"]
      
      min_size     = 1
      max_size     = 10
      desired_size = 3
      
      disk_size = 50
    }
  }
  
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# RDS PostgreSQL
module "rds" {
  source = "terraform-aws-modules/rds/aws"
  
  identifier = "p2p-lending-db"
  
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  
  db_name  = "p2plending"
  username = "postgres"
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  subnet_ids             = module.vpc.private_subnets
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  tags = {
    Environment = var.environment
  }
}

# ElastiCache Redis
resource "aws_elasticache_subnet_group" "main" {
  name       = "p2p-lending-cache-subnet"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "p2p-lending-redis"
  description                = "Redis cluster for P2P Lending"
  
  node_type                  = "cache.t3.micro"
  port                       = 6379
  parameter_group_name       = "default.redis7"
  
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled          = true
  
  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  tags = {
    Environment = var.environment
  }
}

# S3 Bucket for file storage
resource "aws_s3_bucket" "main" {
  bucket = "p2p-lending-files-${var.environment}"
  
  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_encryption" "main" {
  bucket = aws_s3_bucket.main.id
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
```

#### **Variables**
```hcl
# terraform/variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "p2plending.com"
}
```

### **2. Helm Charts**

#### **Chart Structure**
```yaml
# helm-chart/Chart.yaml
apiVersion: v2
name: p2p-lending
description: P2P Lending Platform
type: application
version: 0.1.0
appVersion: "1.0.0"

dependencies:
- name: postgresql
  version: 12.x.x
  repository: https://charts.bitnami.com/bitnami
  condition: postgresql.enabled
- name: redis
  version: 17.x.x
  repository: https://charts.bitnami.com/bitnami
  condition: redis.enabled
```

#### **Values Template**
```yaml
# helm-chart/values.yaml
replicaCount: 3

image:
  repository: registry.gitlab.com/company/p2p-lending
  pullPolicy: IfNotPresent
  tag: "latest"

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  hosts:
    - host: p2plending.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: p2p-lending-tls
      hosts:
        - p2plending.com

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80

postgresql:
  enabled: false
  auth:
    postgresPassword: "password"
    database: "p2plending"

redis:
  enabled: false
  auth:
    enabled: false
```

---

## 📊 MONITORING & OBSERVABILITY

### **1. Prometheus & Grafana Setup**

#### **Prometheus Configuration**
```yaml
# monitoring/prometheus-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    rule_files:
      - "alert_rules.yml"
    
    alerting:
      alertmanagers:
        - static_configs:
            - targets:
              - alertmanager:9093
    
    scrape_configs:
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
            action: replace
            regex: ([^:]+)(?::\d+)?;(\d+)
            replacement: $1:$2
            target_label: __address__
          - action: labelmap
            regex: __meta_kubernetes_pod_label_(.+)
          - source_labels: [__meta_kubernetes_namespace]
            action: replace
            target_label: kubernetes_namespace
          - source_labels: [__meta_kubernetes_pod_name]
            action: replace
            target_label: kubernetes_pod_name
```

#### **Grafana Dashboard**
```json
{
  "dashboard": {
    "id": null,
    "title": "P2P Lending Platform Dashboard",
    "tags": ["p2p-lending"],
    "timezone": "browser",
    "panels": [
      {
        "id": 1,
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{endpoint}}"
          }
        ]
      },
      {
        "id": 2,
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          }
        ]
      },
      {
        "id": 3,
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m])",
            "legendFormat": "5xx errors"
          }
        ]
      }
    ]
  }
}
```

### **2. ELK Stack for Logging**

#### **Elasticsearch Configuration**
```yaml
# logging/elasticsearch.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: logging
spec:
  serviceName: elasticsearch
  replicas: 3
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
      - name: elasticsearch
        image: docker.elastic.co/elasticsearch/elasticsearch:8.8.0
        env:
        - name: node.name
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: cluster.name
          value: "p2p-lending"
        - name: discovery.seed_hosts
          value: "elasticsearch-0.elasticsearch,elasticsearch-1.elasticsearch,elasticsearch-2.elasticsearch"
        - name: cluster.initial_master_nodes
          value: "elasticsearch-0,elasticsearch-1,elasticsearch-2"
        - name: ES_JAVA_OPTS
          value: "-Xms1g -Xmx1g"
        ports:
        - containerPort: 9200
        - containerPort: 9300
        volumeMounts:
        - name: data
          mountPath: /usr/share/elasticsearch/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

#### **Logstash Configuration**
```yaml
# logging/logstash.conf
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][service] == "p2p-lending" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}" }
    }
    
    date {
      match => [ "timestamp", "ISO8601" ]
    }
    
    mutate {
      add_field => { "service" => "p2p-lending" }
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "p2p-lending-%{+YYYY.MM.dd}"
  }
}
```

---

## 🔒 SECURITY & COMPLIANCE

### **1. Security Scanning**

#### **Trivy Security Scan**
```yaml
# security/trivy-scan.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: trivy-scan
  namespace: security
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: trivy
            image: aquasec/trivy:latest
            command:
            - trivy
            - image
            - --format
            - json
            - --output
            - /tmp/scan-results.json
            - registry.gitlab.com/company/p2p-lending:latest
            volumeMounts:
            - name: scan-results
              mountPath: /tmp
          volumes:
          - name: scan-results
            emptyDir: {}
          restartPolicy: OnFailure
```

#### **OWASP ZAP Security Testing**
```yaml
# security/zap-scan.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: zap-security-scan
  namespace: security
spec:
  template:
    spec:
      containers:
      - name: zap
        image: owasp/zap2docker-stable:latest
        command:
        - zap-baseline.py
        - -t
        - https://staging.p2plending.com
        - -r
        - /tmp/zap-report.html
        volumeMounts:
        - name: zap-reports
          mountPath: /tmp
      volumes:
      - name: zap-reports
        emptyDir: {}
      restartPolicy: Never
```

### **2. Secret Management**

#### **HashiCorp Vault Integration**
```yaml
# security/vault-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: vault-config
  namespace: security
data:
  vault.hcl: |
    storage "file" {
      path = "/vault/file"
    }
    
    listener "tcp" {
      address = "0.0.0.0:8200"
      tls_disable = 1
    }
    
    api_addr = "http://vault:8200"
    ui = true
    
    disable_mlock = true
```

#### **Vault Secret Injection**
```yaml
# security/vault-injector.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: p2p-lending-backend
  namespace: p2p-lending
  annotations:
    vault.hashicorp.com/agent-inject: "true"
    vault.hashicorp.com/role: "p2p-lending"
    vault.hashicorp.com/agent-inject-secret-database: "secret/database"
    vault.hashicorp.com/agent-inject-template-database: |
      {{- with secret "secret/database" -}}
      DATABASE_URL=postgresql://{{ .Data.data.username }}:{{ .Data.data.password }}@{{ .Data.data.host }}:5432/{{ .Data.data.database }}
      {{- end -}}
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/role: "p2p-lending"
    spec:
      containers:
      - name: backend
        image: registry.gitlab.com/company/p2p-lending:latest
        env:
        - name: DATABASE_URL
          value: "/vault/secrets/database"
```

---

## 🚀 DEPLOYMENT STRATEGIES

### **1. Blue-Green Deployment**

#### **Blue-Green Script**
```bash
#!/bin/bash
# scripts/blue-green-deploy.sh

set -e

NAMESPACE="p2p-lending"
SERVICE_NAME="p2p-lending-backend-service"
NEW_VERSION=$1
CURRENT_VERSION=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.selector.version}')

echo "Current version: $CURRENT_VERSION"
echo "New version: $NEW_VERSION"

# Deploy new version (Green)
kubectl set image deployment/p2p-lending-backend-$NEW_VERSION backend=registry.gitlab.com/company/p2p-lending:$NEW_VERSION -n $NAMESPACE

# Wait for new deployment to be ready
kubectl rollout status deployment/p2p-lending-backend-$NEW_VERSION -n $NAMESPACE

# Health check
echo "Performing health check..."
kubectl run health-check --image=curlimages/curl:latest --rm -i --restart=Never -- \
  curl -f http://p2p-lending-backend-$NEW_VERSION:3001/health

if [ $? -eq 0 ]; then
  echo "Health check passed. Switching traffic to new version..."
  
  # Switch traffic to new version
  kubectl patch service $SERVICE_NAME -n $NAMESPACE -p '{"spec":{"selector":{"version":"'$NEW_VERSION'"}}}'
  
  # Wait for traffic to switch
  sleep 30
  
  # Verify traffic is flowing to new version
  kubectl run traffic-check --image=curlimages/curl:latest --rm -i --restart=Never -- \
    curl -f http://$SERVICE_NAME:80/health
  
  if [ $? -eq 0 ]; then
    echo "Traffic successfully switched to new version"
    
    # Scale down old version
    kubectl scale deployment p2p-lending-backend-$CURRENT_VERSION --replicas=0 -n $NAMESPACE
    
    echo "Blue-Green deployment completed successfully"
  else
    echo "Traffic switch failed. Rolling back..."
    kubectl patch service $SERVICE_NAME -n $NAMESPACE -p '{"spec":{"selector":{"version":"'$CURRENT_VERSION'"}}}'
    exit 1
  fi
else
  echo "Health check failed. Deployment aborted."
  exit 1
fi
```

### **2. Canary Deployment**

#### **Canary Configuration**
```yaml
# canary/istio-virtual-service.yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: p2p-lending-canary
  namespace: p2p-lending
spec:
  hosts:
  - p2p-lending-backend-service
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: p2p-lending-backend-service
        subset: canary
      weight: 100
  - route:
    - destination:
        host: p2p-lending-backend-service
        subset: stable
      weight: 90
    - destination:
        host: p2p-lending-backend-service
        subset: canary
      weight: 10
```

---

## 📈 PERFORMANCE OPTIMIZATION

### **1. Auto-scaling Configuration**

#### **Horizontal Pod Autoscaler**
```yaml
# scaling/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: p2p-lending-backend-hpa
  namespace: p2p-lending
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: p2p-lending-backend
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "100"
```

#### **Vertical Pod Autoscaler**
```yaml
# scaling/vpa.yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: p2p-lending-backend-vpa
  namespace: p2p-lending
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: p2p-lending-backend
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
    - containerName: backend
      minAllowed:
        cpu: 100m
        memory: 128Mi
      maxAllowed:
        cpu: 1000m
        memory: 1Gi
```

---

## 🔧 BACKUP & DISASTER RECOVERY

### **1. Database Backup**

#### **PostgreSQL Backup Script**
```bash
#!/bin/bash
# scripts/backup-database.sh

set -e

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="p2p_lending_backup_$DATE.sql"
S3_BUCKET="p2p-lending-backups"

# Create backup
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > $BACKUP_DIR/$BACKUP_FILE

# Compress backup
gzip $BACKUP_DIR/$BACKUP_FILE

# Upload to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILE.gz s3://$S3_BUCKET/database/

# Clean up old backups (keep last 30 days)
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

echo "Backup completed: $BACKUP_FILE.gz"
```

#### **Kubernetes CronJob for Backup**
```yaml
# backup/backup-cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: database-backup
  namespace: p2p-lending
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: postgres:15-alpine
            env:
            - name: DB_HOST
              value: "postgres-service"
            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  name: postgres-secret
                  key: username
            - name: DB_NAME
              value: "p2plending"
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: aws-secret
                  key: access-key-id
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: aws-secret
                  key: secret-access-key
            command:
            - /bin/bash
            - -c
            - |
              pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME | gzip | aws s3 cp - s3://p2p-lending-backups/database/backup-$(date +%Y%m%d_%H%M%S).sql.gz
          restartPolicy: OnFailure
```

### **2. Disaster Recovery Plan**

#### **Recovery Procedures**
```yaml
# disaster-recovery/recovery-procedures.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: disaster-recovery-procedures
  namespace: p2p-lending
data:
  recovery-steps.md: |
    # Disaster Recovery Procedures
    
    ## 1. Database Recovery
    1. Stop all application pods
    2. Restore database from latest backup
    3. Verify data integrity
    4. Restart application pods
    
    ## 2. Application Recovery
    1. Deploy to backup cluster
    2. Update DNS records
    3. Verify functionality
    4. Monitor for issues
    
    ## 3. Full Site Recovery
    1. Activate disaster recovery site
    2. Restore all services
    3. Update DNS and load balancers
    4. Notify stakeholders
    5. Begin recovery procedures
```

---

## 🎯 KẾT LUẬN

### **✅ DevOps Pipeline Workflow đã được thiết kế bao gồm:**

1. **CI/CD Pipeline**: GitLab CI/CD với multi-stage deployment
2. **Containerization**: Docker với multi-stage builds
3. **Orchestration**: Kubernetes với Helm charts
4. **Infrastructure**: Terraform cho Infrastructure as Code
5. **Monitoring**: Prometheus, Grafana, ELK Stack
6. **Security**: Trivy, OWASP ZAP, Vault
7. **Deployment**: Blue-Green và Canary deployments
8. **Scaling**: HPA và VPA cho auto-scaling
9. **Backup**: Automated backup và disaster recovery

### **🚀 Lợi ích chính:**

- **Automation**: Tự động hóa toàn bộ quy trình từ code đến production
- **Reliability**: High availability với multi-environment setup
- **Security**: Multi-layer security với scanning và secret management
- **Scalability**: Auto-scaling và load balancing
- **Monitoring**: Comprehensive observability với metrics, logs, và traces
- **Compliance**: Audit trails và regulatory compliance
- **Cost Optimization**: Resource optimization và efficient scaling

### **📈 Best Practices được áp dụng:**

- **GitOps**: Infrastructure và configuration as code
- **Immutable Infrastructure**: Container-based deployments
- **Zero-downtime Deployments**: Blue-green và canary strategies
- **Security by Design**: Security scanning và secret management
- **Observability**: Comprehensive monitoring và alerting
- **Disaster Recovery**: Automated backup và recovery procedures

DevOps Pipeline này đảm bảo một quy trình phát triển và triển khai hiện đại, an toàn và có khả năng mở rộng cho hệ thống P2P Lending.
