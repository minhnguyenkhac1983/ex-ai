# Hướng dẫn triển khai Vietnam E-Wallet Exchange

## 📋 Tổng quan

Hướng dẫn này cung cấp các bước chi tiết để triển khai hệ thống Vietnam E-Wallet Exchange từ môi trường development đến production.

## 🛠️ Yêu cầu hệ thống

### Development Environment
- **Node.js**: >= 20.0.0
- **Docker**: >= 24.0.0
- **Docker Compose**: >= 2.20.0
- **Git**: >= 2.40.0
- **Memory**: >= 8GB RAM
- **Storage**: >= 50GB SSD

### Production Environment
- **Kubernetes**: >= 1.28.0
- **Helm**: >= 3.12.0
- **Terraform**: >= 1.6.0
- **Memory**: >= 32GB RAM
- **Storage**: >= 500GB SSD
- **CPU**: >= 16 cores

## 🚀 Triển khai Development

### 1. Clone Repository
```bash
git clone https://github.com/minhnguyenkhac1983/exw.git
cd exw
```

### 2. Cài đặt Dependencies
```bash
# Cài đặt dependencies cho tất cả services
npm run setup:deps

# Hoặc cài đặt từng service
npm run setup:auth
npm run setup:user
npm run setup:wallet
npm run setup:transaction
npm run setup:payment
npm run setup:notification
npm run setup:fraud
npm run setup:analytics
npm run setup:ai
npm run setup:blockchain
```

### 3. Cấu hình Environment
```bash
# Copy file cấu hình mẫu
cp env.example .env

# Chỉnh sửa các biến môi trường
nano .env
```

### 4. Khởi động Infrastructure
```bash
# Khởi động database và cache
npm run docker:up

# Kiểm tra trạng thái services
docker-compose ps
```

### 5. Chạy Services
```bash
# Chạy tất cả services
npm run dev:all

# Hoặc chạy từng service riêng
npm run dev:auth      # Port 3001
npm run dev:user      # Port 3002
npm run dev:wallet    # Port 3003
npm run dev:transaction # Port 3004
npm run dev:payment   # Port 3005
npm run dev:notification # Port 3006
npm run dev:fraud     # Port 3007
npm run dev:analytics # Port 3008
npm run dev:ai        # Port 3009
npm run dev:blockchain # Port 3010
```

### 6. Chạy Frontend Applications
```bash
# Customer Portal
cd apps/web/customer-portal
npm install
npm run dev  # Port 4000

# Merchant Portal
cd apps/web/merchant-portal
npm install
npm run dev  # Port 4001

# Admin Dashboard
cd apps/web/admin-dashboard
npm install
npm run dev  # Port 4002
```

### 7. Kiểm tra Health
```bash
# Kiểm tra tất cả services
npm run health:all

# Kiểm tra từng service
npm run health:auth
npm run health:user
npm run health:wallet
# ... các services khác
```

## 🏗️ Triển khai Staging

### 1. Chuẩn bị Infrastructure
```bash
# Tạo namespace staging
kubectl create namespace ewallet-staging

# Apply Kubernetes manifests
kubectl apply -f infrastructure/kubernetes/staging/
```

### 2. Cấu hình Secrets
```bash
# Tạo secrets cho staging
kubectl create secret generic ewallet-secrets \
  --from-literal=db-password=staging_password \
  --from-literal=jwt-secret=staging_jwt_secret \
  --from-literal=redis-password=staging_redis_password \
  --namespace=ewallet-staging
```

### 3. Deploy Services
```bash
# Deploy tất cả services
helm install ewallet-staging ./infrastructure/helm/ewallet \
  --namespace ewallet-staging \
  --values ./infrastructure/helm/ewallet/values-staging.yaml

# Hoặc deploy từng service
helm install auth-service ./infrastructure/helm/auth-service \
  --namespace ewallet-staging
```

### 4. Kiểm tra Deployment
```bash
# Kiểm tra pods
kubectl get pods -n ewallet-staging

# Kiểm tra services
kubectl get services -n ewallet-staging

# Kiểm tra logs
kubectl logs -f deployment/auth-service -n ewallet-staging
```

## 🏭 Triển khai Production

### 1. Chuẩn bị Infrastructure với Terraform
```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

### 2. Cấu hình Production Secrets
```bash
# Tạo secrets cho production
kubectl create secret generic ewallet-prod-secrets \
  --from-literal=db-password=production_password \
  --from-literal=jwt-secret=production_jwt_secret \
  --from-literal=redis-password=production_redis_password \
  --from-literal=openai-api-key=production_openai_key \
  --from-literal=ethereum-rpc-url=production_ethereum_url \
  --namespace=ewallet-production
```

### 3. Deploy Production
```bash
# Deploy với Helm
helm install ewallet-production ./infrastructure/helm/ewallet \
  --namespace ewallet-production \
  --values ./infrastructure/helm/ewallet/values-production.yaml \
  --set replicaCount=3 \
  --set resources.limits.memory=2Gi \
  --set resources.limits.cpu=1000m
```

### 4. Cấu hình Load Balancer
```bash
# Apply load balancer configuration
kubectl apply -f infrastructure/kubernetes/production/load-balancer.yaml

# Kiểm tra ingress
kubectl get ingress -n ewallet-production
```

### 5. Cấu hình Monitoring
```bash
# Deploy monitoring stack
helm install monitoring ./infrastructure/helm/monitoring \
  --namespace ewallet-production

# Deploy logging stack
helm install logging ./infrastructure/helm/logging \
  --namespace ewallet-production
```

## 🔧 Cấu hình Database

### 1. PostgreSQL Setup
```bash
# Tạo database
psql -h localhost -U postgres -c "CREATE DATABASE ewallet_db;"

# Chạy migrations
npm run db:migrate

# Seed data
npm run db:seed
```

### 2. Redis Setup
```bash
# Kiểm tra Redis connection
redis-cli ping

# Cấu hình Redis
redis-cli CONFIG SET maxmemory 512mb
redis-cli CONFIG SET maxmemory-policy allkeys-lru
```

## 📊 Monitoring & Logging

### 1. Prometheus & Grafana
```bash
# Khởi động monitoring
npm run monitor

# Truy cập Grafana
open http://localhost:3001
# Username: admin
# Password: admin
```

### 2. ELK Stack
```bash
# Khởi động logging stack
docker-compose up -d elasticsearch kibana logstash

# Truy cập Kibana
open http://localhost:5601
```

### 3. Jaeger Tracing
```bash
# Khởi động Jaeger
docker-compose up -d jaeger

# Truy cập Jaeger UI
open http://localhost:16686
```

## 🔐 Security Configuration

### 1. SSL/TLS Setup
```bash
# Tạo SSL certificates
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# Cấu hình nginx với SSL
cp nginx-ssl.conf /etc/nginx/sites-available/ewallet
ln -s /etc/nginx/sites-available/ewallet /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### 2. Firewall Configuration
```bash
# Cấu hình firewall
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 3000:3010/tcp  # API services
ufw enable
```

### 3. Security Headers
```nginx
# Nginx security headers
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
```

## 🚀 CI/CD Pipeline

### 1. GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Kubernetes
        run: |
          kubectl apply -f infrastructure/kubernetes/production/
```

### 2. Automated Testing
```bash
# Chạy tests trước khi deploy
npm run test
npm run test:integration
npm run test:e2e
```

### 3. Blue-Green Deployment
```bash
# Deploy green environment
helm install ewallet-green ./infrastructure/helm/ewallet \
  --namespace ewallet-green

# Switch traffic
kubectl patch service ewallet-service \
  -p '{"spec":{"selector":{"version":"green"}}}'
```

## 📈 Scaling & Performance

### 1. Horizontal Pod Autoscaling
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: auth-service-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: auth-service
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### 2. Database Scaling
```bash
# Tạo read replicas
kubectl apply -f infrastructure/kubernetes/database/read-replicas.yaml

# Cấu hình connection pooling
kubectl apply -f infrastructure/kubernetes/database/pooling.yaml
```

### 3. Cache Optimization
```bash
# Cấu hình Redis cluster
kubectl apply -f infrastructure/kubernetes/redis/cluster.yaml

# Cấu hình cache warming
kubectl apply -f infrastructure/kubernetes/cache/warming.yaml
```

## 🔄 Backup & Recovery

### 1. Database Backup
```bash
# Tạo backup script
cat > backup-db.sh << EOF
#!/bin/bash
pg_dump -h localhost -U postgres ewallet_db > backup_$(date +%Y%m%d_%H%M%S).sql
EOF

chmod +x backup-db.sh

# Tự động backup hàng ngày
echo "0 2 * * * /path/to/backup-db.sh" | crontab -
```

### 2. Application Backup
```bash
# Backup application data
kubectl exec -it deployment/auth-service -- tar -czf /tmp/app-backup.tar.gz /app/data
kubectl cp auth-service-pod:/tmp/app-backup.tar.gz ./app-backup.tar.gz
```

### 3. Disaster Recovery
```bash
# Restore database
psql -h localhost -U postgres ewallet_db < backup_20250127_020000.sql

# Restore application
kubectl cp ./app-backup.tar.gz auth-service-pod:/tmp/
kubectl exec -it deployment/auth-service -- tar -xzf /tmp/app-backup.tar.gz -C /
```

## 🧪 Testing in Production

### 1. Health Checks
```bash
# Automated health checks
curl -f http://api.ewallet.vn/health || exit 1
curl -f http://api.ewallet.vn/api/v1/health || exit 1
```

### 2. Load Testing
```bash
# Load test với k6
k6 run tests/performance/load-test.js

# Stress test
k6 run tests/performance/stress-test.js
```

### 3. Security Testing
```bash
# Security scan
npm audit
npm run security:scan

# Penetration testing
nmap -sS -O api.ewallet.vn
```

## 📋 Maintenance

### 1. Regular Updates
```bash
# Update dependencies
npm update
npm audit fix

# Update Docker images
docker-compose pull
docker-compose up -d
```

### 2. Log Rotation
```bash
# Cấu hình log rotation
cat > /etc/logrotate.d/ewallet << EOF
/var/log/ewallet/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 root root
}
EOF
```

### 3. Performance Monitoring
```bash
# Monitor performance
kubectl top pods -n ewallet-production
kubectl top nodes

# Check resource usage
kubectl describe nodes
```

## 🆘 Troubleshooting

### 1. Common Issues
```bash
# Service không khởi động
kubectl describe pod <pod-name> -n ewallet-production
kubectl logs <pod-name> -n ewallet-production

# Database connection issues
kubectl exec -it deployment/postgres -- psql -U postgres -d ewallet_db

# Redis connection issues
kubectl exec -it deployment/redis -- redis-cli ping
```

### 2. Performance Issues
```bash
# Check CPU/Memory usage
kubectl top pods -n ewallet-production

# Check network issues
kubectl get networkpolicies -n ewallet-production

# Check storage issues
kubectl get pv,pvc -n ewallet-production
```

### 3. Security Issues
```bash
# Check security policies
kubectl get networkpolicies -n ewallet-production
kubectl get podsecuritypolicies

# Check RBAC
kubectl get roles,rolebindings -n ewallet-production
```

---

**Lưu ý**: Luôn test kỹ trong môi trường staging trước khi triển khai production. Đảm bảo có kế hoạch backup và recovery trước khi triển khai.
