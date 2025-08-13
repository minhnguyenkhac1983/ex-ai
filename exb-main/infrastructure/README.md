# Infrastructure as Code

Infrastructure được quản lý bằng code với các công cụ hiện đại để đảm bảo tính nhất quán, bảo mật và khả năng mở rộng.

## 🏗️ **Kiến trúc Infrastructure**

- **Infrastructure as Code**: Terraform, CloudFormation
- **GitOps**: Argo CD, FluxCD
- **Container Orchestration**: Kubernetes
- **Service Mesh**: Istio, Linkerd
- **Security**: Zero-Trust, mTLS, OPA

## 📁 **Cấu trúc thư mục**

```
infrastructure/
├── terraform/                  # Terraform modules
│   ├── modules/               # Reusable modules
│   │   ├── vpc/              # VPC configuration
│   │   ├── eks/              # EKS cluster
│   │   ├── rds/              # Database instances
│   │   ├── redis/            # Redis clusters
│   │   └── monitoring/       # Monitoring stack
│   ├── environments/         # Environment-specific configs
│   │   ├── dev/             # Development environment
│   │   ├── staging/         # Staging environment
│   │   └── prod/            # Production environment
│   └── scripts/             # Terraform automation
│
├── kubernetes/                # Kubernetes manifests
│   ├── apps/                 # Application deployments
│   │   ├── customer-service/ # Customer service Helm chart
│   │   ├── account-service/  # Account service Helm chart
│   │   └── transaction-service/ # Transaction service
│   ├── platform/             # Platform components
│   │   ├── ingress/          # Ingress controllers
│   │   ├── cert-manager/     # SSL certificate management
│   │   ├── monitoring/       # Prometheus, Grafana
│   │   └── security/         # Security policies
│   └── base/                 # Base configurations
│
├── gitops/                    # GitOps configurations
│   ├── argo-apps/            # Argo CD applications
│   ├── flux-apps/            # Flux CD applications
│   └── kustomize/            # Kustomize overlays
│
├── docker/                    # Docker configurations
│   ├── dockerfiles/          # Multi-stage Dockerfiles
│   ├── compose/              # Docker Compose files
│   └── registry/             # Container registry configs
│
└── scripts/                   # Automation scripts
    ├── deployment/           # Deployment scripts
    ├── monitoring/           # Monitoring setup
    └── security/             # Security hardening
```

## 🛠️ **Technology Stack**

### Infrastructure Provisioning
- **Terraform 1.8+**: Infrastructure as Code
- **AWS CDK**: Cloud development kit
- **Pulumi**: Multi-language IaC

### Container Orchestration
- **Kubernetes 1.29+**: Container orchestration
- **Helm 3.x**: Package manager for K8s
- **Kustomize**: Native K8s configuration management

### GitOps
- **Argo CD**: GitOps continuous delivery
- **Flux CD**: GitOps toolkit
- **Argo Rollouts**: Progressive delivery

### Service Mesh
- **Istio**: Service mesh platform
- **Linkerd**: Lightweight service mesh
- **Consul**: Service mesh & service discovery

### Security
- **OPA/Gatekeeper**: Policy enforcement
- **Kyverno**: Kubernetes policy engine
- **Falco**: Runtime security monitoring

## 🚀 **Deployment**

### Prerequisites
- Terraform 1.8+
- kubectl
- helm
- aws-cli (for AWS)

### Environment Setup
```bash
# Initialize Terraform
cd infrastructure/terraform/environments/dev
terraform init
terraform plan
terraform apply

# Configure kubectl
aws eks update-kubeconfig --region us-west-2 --name exb-cluster

# Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Application Deployment
```bash
# Deploy with Argo CD
kubectl apply -f infrastructure/gitops/argo-apps/

# Deploy with Helm
helm install customer-service infrastructure/kubernetes/apps/customer-service/

# Deploy with Kustomize
kubectl apply -k infrastructure/kubernetes/base/
```

## 🔐 **Security**

### Network Security
- **VPC**: Private subnets, NAT gateways
- **Security Groups**: Least privilege access
- **WAF**: Web application firewall
- **DDoS Protection**: AWS Shield, CloudFlare

### Access Control
- **RBAC**: Role-based access control
- **IAM**: Identity and access management
- **Service Accounts**: Kubernetes service accounts
- **mTLS**: Mutual TLS authentication

### Secrets Management
- **AWS Secrets Manager**: Centralized secrets
- **HashiCorp Vault**: Secrets & encryption
- **Kubernetes Secrets**: Encrypted secrets
- **External Secrets Operator**: GitOps for secrets

### Compliance
- **PCI DSS**: Payment card industry compliance
- **ISO 27001**: Information security
- **SOC 2**: Security controls
- **GDPR**: Data protection

## 📊 **Monitoring & Observability**

### Infrastructure Monitoring
- **CloudWatch**: AWS monitoring
- **Prometheus**: Metrics collection
- **Grafana**: Visualization & dashboards
- **Alertmanager**: Alerting

### Application Monitoring
- **OpenTelemetry**: Distributed tracing
- **Jaeger**: Trace visualization
- **Loki**: Log aggregation
- **Tempo**: Trace storage

### Security Monitoring
- **Falco**: Runtime security
- **Trivy**: Vulnerability scanning
- **OPA**: Policy monitoring
- **Audit Logs**: Compliance logging

## 🔄 **CI/CD Integration**

### GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Kubernetes
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy with Argo CD
        run: |
          kubectl apply -f infrastructure/gitops/argo-apps/
```

### GitLab CI
```yaml
# .gitlab-ci.yml
deploy:
  stage: deploy
  script:
    - kubectl apply -f infrastructure/gitops/argo-apps/
```

## 📋 **Best Practices**

### Infrastructure
- **Immutable Infrastructure**: No manual changes
- **Infrastructure as Code**: Version controlled
- **Multi-Environment**: Dev, staging, prod
- **Disaster Recovery**: Backup & recovery

### Security
- **Zero Trust**: Never trust, always verify
- **Least Privilege**: Minimal required access
- **Defense in Depth**: Multiple security layers
- **Regular Audits**: Security assessments

### Performance
- **Auto Scaling**: Horizontal & vertical scaling
- **Load Balancing**: Traffic distribution
- **CDN**: Content delivery networks
- **Caching**: Multi-layer caching

## 📚 **Documentation**

- **Architecture Diagrams**: C4 model
- **Runbooks**: Operational procedures
- **Troubleshooting**: Common issues
- **Security Guidelines**: Security practices
