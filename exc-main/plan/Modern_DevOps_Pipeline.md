# Modern DevOps Pipeline Workflow 2024

## 🚀 Tổng Quan Pipeline Hiện Đại

### 1.1 Cloud-Native DevOps Stack
- **GitOps**: ArgoCD, Flux
- **CI/CD**: GitHub Actions, Tekton, Argo Workflows
- **Security**: SLSA, Sigstore, OPA/Gatekeeper
- **Monitoring**: Prometheus + Thanos, Grafana
- **Observability**: OpenTelemetry, Jaeger, ELK
- **Infrastructure**: Crossplane, Pulumi, Terraform

### 1.2 Modern Pipeline Flow
```
Developer → Dev Container → Local Testing → Git Push → 
GitHub Actions → Security Scan → Build & Test → 
ArgoCD Sync → Kubernetes Deploy → Monitoring → Observability
```

## 🔧 Modern CI/CD Tools & Practices

### 2.1 GitOps Workflow
```yaml
# .github/workflows/gitops-pipeline.yml
name: Modern GitOps Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'

  build-and-test:
    runs-on: ubuntu-latest
    needs: security
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Dev Container
        uses: devcontainers/ci@v0.3
        with:
          imageName: ghcr.io/${{ github.repository }}/devcontainer
      
      - name: Run tests with coverage
        run: |
          make test
          make coverage
      
      - name: Build multi-platform image
        uses: docker/build-push-action@v4
        with:
          platforms: linux/amd64,linux/arm64
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    runs-on: ubuntu-latest
    needs: build-and-test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Update ArgoCD manifests
        run: |
          kustomize edit set image ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          git config user.name github-actions
          git config user.email github-actions@github.com
          git add .
          git commit -m "Update image to ${{ github.sha }}"
          git push
```

### 2.2 ArgoCD Application Configuration
```yaml
# argocd/applications/exc-platform.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: exc-platform
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/exc-platform
    targetRevision: main
    path: k8s/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: exc-production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - PruneLast=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

## 🔐 Modern Security Practices

### 3.1 Supply Chain Security (SLSA)
```yaml
# .github/workflows/slsa-pipeline.yml
name: SLSA Build Pipeline

on:
  push:
    branches: [main]
  release:
    types: [published]

permissions:
  contents: read
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build with SLSA
        uses: slsa-framework/slsa-github-actions/.github/workflows/builder_go_slsa3@main
        with:
          go-version: "1.21"
          upload-assets: true
          slsa-version: v1.0
      
      - name: Sign with Sigstore
        uses: sigstore/cosign-installer@v3
        with:
          cosign-release: v2.1.1
      
      - name: Sign the published release
        run: cosign sign --key env://COSIGN_PRIVATE_KEY ${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}
        env:
          COSIGN_PRIVATE_KEY: ${{ secrets.COSIGN_PRIVATE_KEY }}
```

### 3.2 Policy as Code (OPA/Gatekeeper)
```rego
# policies/security-policies.rego
package kubernetes.admission

deny[msg] {
    input.request.kind.kind == "Pod"
    not input.request.object.spec.securityContext.runAsNonRoot
    
    msg := "Pods must not run as root"
}

deny[msg] {
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.containers[_]
    not container.securityContext.readOnlyRootFilesystem
    
    msg := sprintf("Container %v must have a read-only root filesystem", [container.name])
}
```

## 📊 Modern Observability Stack

### 4.1 OpenTelemetry Configuration
```yaml
# otel/collector-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-config
data:
  config.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    
    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024
      memory_limiter:
        check_interval: 1s
        limit_mib: 1500
      resource:
        attributes:
          - key: environment
            value: "production"
            action: upsert
    
    exporters:
      otlp:
        endpoint: "tempo:4317"
        tls:
          insecure: true
      prometheus:
        endpoint: "0.0.0.0:9464"
        namespace: "exc"
        const_labels:
          label1: value1
      logging:
        loglevel: debug
    
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch, memory_limiter, resource]
          exporters: [otlp, logging]
        metrics:
          receivers: [otlp]
          processors: [batch, memory_limiter, resource]
          exporters: [prometheus, logging]
```

### 4.2 Distributed Tracing with Jaeger
```yaml
# jaeger/jaeger-config.yaml
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: exc-jaeger
spec:
  strategy: production
  storage:
    type: elasticsearch
    options:
      es:
        server-urls: http://elasticsearch:9200
  ingress:
    enabled: true
    hosts:
      - jaeger.exc.local
  agent:
    strategy: DaemonSet
  collector:
    replicas: 3
  query:
    replicas: 2
```

## 🚀 Modern Deployment Strategies

### 5.1 Progressive Delivery with Argo Rollouts
```yaml
# rollouts/progressive-deployment.yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: exc-wallet-service
spec:
  replicas: 5
  strategy:
    canary:
      steps:
        - setWeight: 20
        - pause: {duration: 30s}
        - setWeight: 40
        - pause: {duration: 30s}
        - setWeight: 60
        - pause: {duration: 30s}
        - setWeight: 80
        - pause: {duration: 30s}
        - setWeight: 100
      analysis:
        templates:
        - templateName: success-rate
        args:
        - name: service-name
          value: exc-wallet-service
        startingStep: 2
        rollbackOnFailure: true
  selector:
    matchLabels:
      app: exc-wallet-service
  template:
    metadata:
      labels:
        app: exc-wallet-service
    spec:
      containers:
      - name: wallet-service
        image: exc-wallet-service:latest
        ports:
        - containerPort: 8080
```

### 5.2 GitOps with Flux
```yaml
# flux/gotk-sync.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: exc-platform
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/your-org/exc-platform
  ref:
    branch: main
  secretRef:
    name: flux-system
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: exc-platform
  namespace: flux-system
spec:
  interval: 10m
  path: ./k8s/overlays/production
  prune: true
  sourceRef:
    kind: GitRepository
    name: exc-platform
  targetNamespace: exc-production
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: exc-wallet-service
      namespace: exc-production
```

## 🔄 Modern Infrastructure as Code

### 6.1 Crossplane for Multi-Cloud
```yaml
# crossplane/multi-cloud-infra.yaml
apiVersion: database.example.org/v1alpha1
kind: PostgreSQLInstance
metadata:
  name: exc-database
spec:
  forProvider:
    region: us-west-2
    version: "13.7"
    size: db.t3.micro
    storageGB: 20
  writeConnectionSecretToRef:
    name: exc-db-connection
    namespace: crossplane-system
---
apiVersion: cache.example.org/v1alpha1
kind: RedisCluster
metadata:
  name: exc-cache
spec:
  forProvider:
    region: us-west-2
    nodeType: cache.t3.micro
    numCacheNodes: 2
  writeConnectionSecretToRef:
    name: exc-cache-connection
    namespace: crossplane-system
```

### 6.2 Pulumi Infrastructure
```typescript
// infrastructure/pulumi/main.ts
import * as pulumi from "@pulumi/pulumi";
import * as eks from "@pulumi/eks";
import * as k8s from "@pulumi/kubernetes";

// Create EKS cluster
const cluster = new eks.Cluster("exc-cluster", {
    version: "1.28",
    nodeGroupIamRoleName: "exc-node-group-role",
    nodeGroupInstanceType: "t3.medium",
    nodeGroupDesiredCapacity: 3,
    nodeGroupMinSize: 1,
    nodeGroupMaxSize: 5,
});

// Deploy ArgoCD
const argocd = new k8s.helm.v3.Release("argocd", {
    chart: "argo-cd",
    version: "5.46.7",
    namespace: "argocd",
    createNamespace: true,
    values: {
        server: {
            ingress: {
                enabled: true,
                hosts: ["argocd.exc.local"],
            },
        },
    },
}, { provider: cluster.provider });

export const clusterName = cluster.eksCluster.name;
export const kubeconfig = cluster.kubeconfig;
```

## 🎯 Modern Quality Gates

### 7.1 Automated Quality Checks
```yaml
# quality-gates/quality-checks.yaml
apiVersion: tekton.dev/v1
kind: Task
metadata:
  name: quality-gates
spec:
  params:
    - name: code-coverage-threshold
      default: "80"
    - name: security-scan-threshold
      default: "0"
  steps:
    - name: code-coverage-check
      image: node:18
      script: |
        npm run test:coverage
        COVERAGE=$(cat coverage/cobertura-coverage.xml | grep -o 'line-rate="[^"]*"' | cut -d'"' -f2)
        if (( $(echo "$COVERAGE < $(params.code-coverage-threshold)" | bc -l) )); then
          echo "Code coverage $COVERAGE% is below threshold $(params.code-coverage-threshold)%"
          exit 1
        fi
        echo "Code coverage check passed: $COVERAGE%"
    
    - name: security-vulnerability-check
      image: aquasec/trivy:latest
      script: |
        trivy fs --severity HIGH,CRITICAL --exit-code 1 .
        echo "Security scan passed"
    
    - name: performance-test
      image: grafana/k6:latest
      script: |
        k6 run --out json=results.json tests/load/performance.js
        if [ $(jq '.metrics.http_req_duration.values.p95' results.json) -gt 200 ]; then
          echo "Performance test failed: P95 > 200ms"
          exit 1
        fi
        echo "Performance test passed"
```

## 🔮 Future-Ready Features

### 8.1 AI-Powered Operations
```yaml
# ai-ops/ai-monitoring.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: ai-anomaly-detection
spec:
  groups:
  - name: ai-ops
    rules:
    - alert: AnomalyDetected
      expr: |
        (
          rate(http_requests_total[5m]) > 
          avg_over_time(http_requests_total[1h]) * 2
        ) and
        (
          rate(http_request_duration_seconds_sum[5m]) /
          rate(http_requests_total[5m]) >
          avg_over_time(http_request_duration_seconds_sum[1h]) /
          avg_over_time(http_requests_total[1h]) * 1.5
        )
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: "AI detected anomalous traffic pattern"
        description: "Request rate and latency are significantly higher than normal"
```

### 8.2 Chaos Engineering
```yaml
# chaos/chaos-experiments.yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: network-latency-test
spec:
  action: delay
  mode: one
  selector:
    namespaces:
      - exc-production
    labelSelectors:
      app: exc-wallet-service
  delay:
    latency: "100ms"
    correlation: "100"
    jitter: "0ms"
  duration: "30s"
  scheduler:
    cron: "@every 1h"
```

---

## 🎉 Kết Luận

Pipeline DevOps hiện đại này tích hợp:

✅ **GitOps** - Infrastructure as Code với Git  
✅ **Cloud-Native** - Kubernetes-native tools  
✅ **Security-First** - SLSA, Sigstore, OPA  
✅ **Observability** - OpenTelemetry, distributed tracing  
✅ **Progressive Delivery** - Canary, blue-green deployments  
✅ **Multi-Cloud** - Crossplane, Pulumi  
✅ **AI-Powered** - Anomaly detection, predictive analytics  
✅ **Chaos Engineering** - Resilience testing  

Pipeline này được thiết kế để đáp ứng các yêu cầu của hệ thống tài chính hiện đại với khả năng mở rộng, bảo mật và độ tin cậy cao.
