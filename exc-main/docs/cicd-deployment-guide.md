# Hướng dẫn triển khai CI/CD cho Crypto Exchange Platform

## Tổng quan

Hướng dẫn này mô tả cách triển khai các giải pháp CI/CD open source on-premise cho dự án crypto exchange platform.

## Lựa chọn giải pháp

### 1. Jenkins + ArgoCD (Khuyến nghị)

**Ưu điểm:**
- Mature và stable
- Plugin ecosystem phong phú
- Tích hợp tốt với Kubernetes
- Community support lớn

**Nhược điểm:**
- Phức tạp setup ban đầu
- Resource intensive

### 2. GitLab CI/CD

**Ưu điểm:**
- All-in-one solution
- Built-in security features
- Auto DevOps
- Dễ sử dụng

**Nhược điểm:**
- Resource intensive
- License cost cho enterprise features

### 3. Tekton

**Ưu điểm:**
- Kubernetes native
- Cloud-native architecture
- Highly scalable
- Event-driven

**Nhược điểm:**
- Learning curve cao
- Community nhỏ hơn

## Triển khai Jenkins + ArgoCD

### Bước 1: Cài đặt Jenkins

```bash
# Tạo namespace
kubectl create namespace jenkins

# Thêm Helm repository
helm repo add jenkins https://charts.jenkins.io
helm repo update

# Cài đặt Jenkins
helm install jenkins jenkins/jenkins \
  --namespace jenkins \
  --set controller.serviceType=LoadBalancer \
  --set controller.resources.requests.memory=512Mi \
  --set controller.resources.requests.cpu=250m \
  --set controller.resources.limits.memory=1Gi \
  --set controller.resources.limits.cpu=500m \
  --set agent.resources.requests.memory=256Mi \
  --set agent.resources.requests.cpu=100m \
  --set agent.resources.limits.memory=512Mi \
  --set agent.resources.limits.cpu=200m

# Lấy admin password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password
```

### Bước 2: Cài đặt ArgoCD

```bash
# Tạo namespace
kubectl create namespace argocd

# Cài đặt ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Lấy admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward để truy cập UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Bước 3: Cấu hình Jenkins

1. **Cài đặt plugins cần thiết:**
   - Kubernetes Plugin
   - Docker Pipeline Plugin
   - Git Plugin
   - Credentials Plugin
   - Pipeline Plugin

2. **Cấu hình Kubernetes Cloud:**
   - Vào Manage Jenkins > Configure System
   - Thêm Kubernetes Cloud
   - Cấu hình kubeconfig

3. **Tạo credentials:**
   - Docker registry credentials
   - Kubernetes kubeconfig
   - Git credentials

### Bước 4: Tạo Jenkins Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        KUBECONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
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

## Triển khai GitLab CI/CD

### Bước 1: Cài đặt GitLab

```bash
# Tạo namespace
kubectl create namespace gitlab

# Thêm Helm repository
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# Cài đặt GitLab
helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=gitlab.local \
  --set global.hosts.https=false \
  --set gitlab-runner.install=true \
  --set gitlab-runner.runners.kubernetes.namespace=gitlab-runner
```

### Bước 2: Cấu hình GitLab Runner

```yaml
# gitlab-runner-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: gitlab-runner-config
  namespace: gitlab-runner
data:
  config.toml: |
    concurrent = 10
    check_interval = 30
    
    [session_server]
      session_timeout = 1800
    
    [[runners]]
      name = "kubernetes-runner"
      url = "http://gitlab-webservice-default.gitlab.svc.cluster.local"
      token = "your-runner-token"
      executor = "kubernetes"
      [runners.kubernetes]
        namespace = "gitlab-runner"
        image = "ubuntu:20.04"
        privileged = true
        service_account = "gitlab-runner"
        service_account_overwrite_allowed = ".*"
        [runners.kubernetes.pod_security_context]
          run_as_non_root = true
          run_as_user = 1000
        [runners.kubernetes.container_security_context]
          run_as_non_root = true
          run_as_user = 1000
```

### Bước 3: Tạo .gitlab-ci.yml

```yaml
# .gitlab-ci.yml
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

## Triển khai Tekton

### Bước 1: Cài đặt Tekton

```bash
# Cài đặt Tekton Pipelines
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# Cài đặt Tekton Triggers
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml

# Cài đặt Tekton Dashboard
kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml

# Cài đặt Tekton CLI
# macOS
brew install tektoncd-cli

# Linux
curl -LO https://github.com/tektoncd/cli/releases/download/v0.31.0/tkn_0.31.0_Linux_x86_64.tar.gz
tar xvzf tkn_0.31.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn
```

### Bước 2: Cài đặt Tasks

```bash
# Cài đặt common tasks
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.8/git-clone.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/buildah/0.7/buildah.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/helm-upgrade-from-source/0.3/helm-upgrade-from-source.yaml
```

### Bước 3: Tạo Pipeline

```bash
# Apply pipeline
kubectl apply -f infrastructure/tekton/pipeline.yaml

# Tạo PipelineRun
kubectl create -f - <<EOF
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: exc-pipeline-run
spec:
  pipelineRef:
    name: exc-pipeline
  params:
    - name: git-url
      value: "https://github.com/your-org/exc"
    - name: git-revision
      value: "main"
    - name: docker-registry
      value: "localhost:5000"
    - name: image-tag
      value: "latest"
    - name: environment
      value: "staging"
  workspaces:
    - name: shared-workspace
      volumeClaimTemplate:
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 1Gi
    - name: docker-config
      secret:
        secretName: docker-config
EOF
```

## Monitoring và Observability

### 1. Jenkins Metrics

```yaml
# prometheus-jenkins.yml
scrape_configs:
  - job_name: 'jenkins'
    static_configs:
      - targets: ['jenkins:8080']
    metrics_path: /prometheus
    scrape_interval: 30s
```

### 2. ArgoCD Metrics

```yaml
# prometheus-argocd.yml
scrape_configs:
  - job_name: 'argocd-server'
    static_configs:
      - targets: ['argocd-server:8080']
    metrics_path: /metrics
    scrape_interval: 30s
```

### 3. Tekton Metrics

```yaml
# prometheus-tekton.yml
scrape_configs:
  - job_name: 'tekton-pipelines'
    static_configs:
      - targets: ['tekton-pipelines:9090']
    metrics_path: /metrics
    scrape_interval: 30s
```

## Security Best Practices

### 1. Secrets Management

```bash
# Tạo Kubernetes secrets
kubectl create secret generic docker-registry \
  --from-file=.dockerconfigjson=~/.docker/config.json \
  --type=kubernetes.io/dockerconfigjson

kubectl create secret generic git-credentials \
  --from-literal=username=your-username \
  --from-literal=password=your-token

kubectl create secret generic cosign-key \
  --from-file=cosign.key
```

### 2. Network Policies

```yaml
# network-policy-cicd.yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: cicd-network-policy
  namespace: jenkins
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: kube-system
      ports:
        - protocol: TCP
          port: 8080
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              name: kube-system
      ports:
        - protocol: TCP
          port: 443
        - protocol: TCP
          port: 53
```

### 3. RBAC Configuration

```yaml
# rbac-cicd.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cicd-role
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "configmaps", "secrets"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
  - apiGroups: ["apps"]
    resources: ["deployments", "replicasets"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
  - apiGroups: ["networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cicd-role-binding
subjects:
  - kind: ServiceAccount
    name: jenkins
    namespace: jenkins
roleRef:
  kind: ClusterRole
  name: cicd-role
  apiGroup: rbac.authorization.k8s.io
```

## Troubleshooting

### 1. Jenkins Issues

```bash
# Kiểm tra Jenkins logs
kubectl logs -f deployment/jenkins -n jenkins

# Kiểm tra Jenkins pods
kubectl get pods -n jenkins

# Restart Jenkins
kubectl rollout restart deployment/jenkins -n jenkins
```

### 2. ArgoCD Issues

```bash
# Kiểm tra ArgoCD logs
kubectl logs -f deployment/argocd-server -n argocd

# Kiểm tra ArgoCD applications
argocd app list

# Sync application
argocd app sync exc-platform
```

### 3. Tekton Issues

```bash
# Kiểm tra Tekton pods
kubectl get pods -n tekton-pipelines

# Kiểm tra pipeline runs
tkn pipelinerun list

# Kiểm tra task runs
tkn taskrun list
```

## Performance Optimization

### 1. Resource Limits

```yaml
# resource-limits.yml
apiVersion: v1
kind: LimitRange
metadata:
  name: cicd-limits
  namespace: jenkins
spec:
  limits:
    - default:
        memory: 1Gi
        cpu: 500m
      defaultRequest:
        memory: 512Mi
        cpu: 250m
      type: Container
```

### 2. Horizontal Pod Autoscaler

```yaml
# hpa-jenkins.yml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: jenkins-hpa
  namespace: jenkins
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: jenkins
  minReplicas: 1
  maxReplicas: 5
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
```

## Backup và Recovery

### 1. Jenkins Backup

```bash
# Backup Jenkins configuration
kubectl exec -n jenkins deployment/jenkins -- tar czf /tmp/jenkins-backup.tar.gz /var/jenkins_home

# Restore Jenkins configuration
kubectl cp jenkins/jenkins-0:/tmp/jenkins-backup.tar.gz ./jenkins-backup.tar.gz
```

### 2. ArgoCD Backup

```bash
# Backup ArgoCD applications
argocd app list -o yaml > argocd-apps-backup.yaml

# Restore ArgoCD applications
kubectl apply -f argocd-apps-backup.yaml
```

## Kết luận

Việc triển khai CI/CD cho crypto exchange platform cần:

1. **Security First**: Implement security scanning, image signing, và secrets management
2. **Observability**: Monitor pipeline performance và application health
3. **Scalability**: Design for horizontal scaling và resource optimization
4. **Reliability**: Implement proper backup, recovery, và disaster recovery procedures

Lựa chọn giải pháp phù hợp với:
- **Jenkins + ArgoCD**: Cho enterprise với yêu cầu bảo mật cao
- **GitLab CI/CD**: Cho teams cần integrated solution
- **Tekton**: Cho cloud-native, event-driven architectures
