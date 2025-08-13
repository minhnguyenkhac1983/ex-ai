# CI/CD Open Source On-Premise Recommendations

## Tổng quan

Dựa trên kiến trúc microservices, Kubernetes, và yêu cầu bảo mật cao của dự án crypto exchange, dưới đây là các giải pháp CI/CD open source on-premise được khuyến nghị:

## 1. Jenkins (Khuyến nghị chính)

### Ưu điểm:
- **Mature & Stable**: Hơn 15 năm phát triển, cộng đồng lớn
- **Plugin Ecosystem**: Hơn 1,800 plugins cho mọi nhu cầu
- **Kubernetes Native**: Jenkins Operator, Jenkins X
- **Security**: RBAC, secrets management, audit logs
- **Scalability**: Master-slave architecture, distributed builds

### Tích hợp với dự án:
```yaml
# Jenkinsfile cho dự án
pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        KUBECONFIG = credentials('kubeconfig')
    }
    stages {
        stage('Build & Test') {
            steps {
                sh 'make build'
                sh 'make test'
                sh 'make sbom'
            }
        }
        stage('Security Scan') {
            steps {
                sh 'make cosign-sign'
                sh 'trivy image ${DOCKER_REGISTRY}/exc-wallet-service'
            }
        }
        stage('Deploy to K8s') {
            steps {
                sh 'helm upgrade --install exc ./infrastructure/kubernetes/helm/exc'
            }
        }
    }
}
```

### Cài đặt:
```bash
# Jenkins với Kubernetes
kubectl create namespace jenkins
helm repo add jenkins https://charts.jenkins.io
helm install jenkins jenkins/jenkins -n jenkins
```

## 2. GitLab CI/CD

### Ưu điểm:
- **Integrated**: Git repository + CI/CD + Container Registry
- **Auto DevOps**: Tự động phát hiện và build
- **Security**: Built-in SAST, DAST, dependency scanning
- **Kubernetes**: Native K8s integration
- **Multi-Project**: Pipeline templates, shared runners

### .gitlab-ci.yml cho dự án:
```yaml
variables:
  DOCKER_REGISTRY: "localhost:5000"
  KUBE_NAMESPACE: "exc"

stages:
  - build
  - test
  - security
  - deploy

build:
  stage: build
  script:
    - make build
    - make sbom
  artifacts:
    paths:
      - "**/dist/"
      - "**/*.sbom.json"

test:
  stage: test
  script:
    - make test
    - make pact:verify:wallet

security:
  stage: security
  script:
    - make cosign-sign
    - trivy image ${DOCKER_REGISTRY}/exc-wallet-service

deploy:
  stage: deploy
  script:
    - helm upgrade --install exc ./infrastructure/kubernetes/helm/exc
  environment:
    name: production
    url: https://api.exc.local
```

## 3. ArgoCD (GitOps)

### Ưu điểm:
- **GitOps Native**: Declarative, version-controlled deployments
- **Kubernetes Native**: Native K8s resources
- **Multi-Cluster**: Quản lý nhiều cluster
- **Rollback**: Automatic rollback on failure
- **RBAC**: Fine-grained permissions

### ArgoCD Application cho dự án:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: exc-platform
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/exc
    targetRevision: main
    path: infrastructure/kubernetes/helm/exc
  destination:
    server: https://kubernetes.default.svc
    namespace: exc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

## 4. Tekton (Cloud Native)

### Ưu điểm:
- **Kubernetes Native**: Chạy như K8s resources
- **Event-Driven**: Trigger từ Git events
- **Reusable**: Pipeline templates, shared tasks
- **Security**: Pod security policies
- **Scalable**: Horizontal scaling

### Tekton Pipeline cho dự án:
```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: exc-pipeline
spec:
  workspaces:
    - name: shared-workspace
  params:
    - name: git-url
    - name: git-revision
  tasks:
    - name: fetch-repository
      taskRef:
        name: git-clone
      workspaces:
        - name: output
          workspace: shared-workspace
      params:
        - name: url
          value: $(params.git-url)
        - name: revision
          value: $(params.git-revision)
    
    - name: build-and-test
      runAfter: ["fetch-repository"]
      taskRef:
        name: buildah
      workspaces:
        - name: source
          workspace: shared-workspace
      params:
        - name: IMAGE
          value: "localhost:5000/exc-wallet-service"
```

## 5. Concourse CI

### Ưu điểm:
- **Immutable**: Mỗi build chạy trong container riêng
- **Declarative**: Pipeline as YAML
- **Resource Types**: Rich ecosystem of resources
- **Security**: Isolated builds, no shared state
- **Visualization**: Web UI với pipeline visualization

### Concourse Pipeline cho dự án:
```yaml
resources:
  - name: exc-repo
    type: git
    source:
      uri: https://github.com/your-org/exc
      branch: main
  
  - name: docker-registry
    type: docker-image
    source:
      repository: localhost:5000/exc-wallet-service

jobs:
  - name: build-test-deploy
    plan:
      - get: exc-repo
        trigger: true
      - task: build
        config:
          platform: linux
          image_resource:
            type: docker-image
            source:
              repository: node
              tag: "18"
          inputs:
            - name: exc-repo
          run:
            path: sh
            args:
              - -c
              - |
                cd exc-repo
                make build
                make test
                make sbom
```

## 6. Drone CI

### Ưu điểm:
- **Lightweight**: Container-native, minimal overhead
- **Simple**: YAML-based configuration
- **Kubernetes**: Native K8s support
- **Security**: Pod security policies
- **Fast**: Parallel execution

### .drone.yml cho dự án:
```yaml
kind: pipeline
type: kubernetes
name: exc-pipeline

steps:
  - name: build
    image: node:18
    commands:
      - cd apps/bff-web
      - npm install
      - npm run build
      - npm run test

  - name: build-wallet
    image: golang:1.21
    commands:
      - cd services/wallet
      - go mod tidy
      - go build -o wallet-service cmd/main.go

  - name: security-scan
    image: aquasec/trivy
    commands:
      - trivy image localhost:5000/exc-wallet-service

  - name: deploy
    image: alpine/helm
    commands:
      - helm upgrade --install exc ./infrastructure/kubernetes/helm/exc
    environment:
      KUBECONFIG:
        from_secret: kubeconfig
```

## Khuyến nghị cho dự án

### Giai đoạn 1: Jenkins + ArgoCD
- **Jenkins**: Build, test, security scanning
- **ArgoCD**: GitOps deployment to Kubernetes
- **Lý do**: Stable, mature, có nhiều plugins và community support

### Giai đoạn 2: GitLab CI/CD
- **Migration**: Chuyển từ Jenkins sang GitLab nếu cần integrated solution
- **Lý do**: All-in-one platform, built-in security features

### Giai đoạn 3: Tekton
- **Advanced**: Khi cần cloud-native, event-driven pipelines
- **Lý do**: Kubernetes native, highly scalable

## Cài đặt và Setup

### 1. Jenkins Setup
```bash
# Tạo namespace
kubectl create namespace jenkins

# Cài đặt Jenkins
helm repo add jenkins https://charts.jenkins.io
helm install jenkins jenkins/jenkins \
  --namespace jenkins \
  --set controller.serviceType=LoadBalancer \
  --set controller.resources.requests.memory=512Mi \
  --set controller.resources.requests.cpu=250m

# Lấy admin password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password
```

### 2. ArgoCD Setup
```bash
# Cài đặt ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Lấy admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 3. GitLab Setup
```bash
# Cài đặt GitLab
helm repo add gitlab https://charts.gitlab.io/
helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=gitlab.local \
  --set global.hosts.https=false
```

## Security Considerations

### 1. Secrets Management
- Sử dụng Kubernetes Secrets hoặc External Secrets Operator
- Rotate credentials regularly
- Audit access logs

### 2. Network Security
- Network policies cho CI/CD pods
- TLS cho tất cả communications
- VPN access cho on-premise

### 3. Container Security
- Image scanning với Trivy/Clair
- Sign images với Cosign
- Runtime security monitoring

## Monitoring và Observability

### 1. CI/CD Metrics
- Build success/failure rates
- Build duration trends
- Resource utilization

### 2. Integration với Prometheus/Grafana
```yaml
# Prometheus scrape config
scrape_configs:
  - job_name: 'jenkins'
    static_configs:
      - targets: ['jenkins:8080']
    metrics_path: /prometheus
```

## Kết luận

Cho dự án crypto exchange với yêu cầu bảo mật cao và kiến trúc microservices:

1. **Jenkins + ArgoCD**: Lựa chọn an toàn, mature
2. **GitLab CI/CD**: Nếu cần integrated solution
3. **Tekton**: Cho cloud-native, event-driven workflows

Tất cả đều hỗ trợ:
- Kubernetes native deployment
- Security scanning và compliance
- GitOps practices
- Multi-environment management
