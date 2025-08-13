# Create Complete Project Structure - Securities Exchange System
# PowerShell script to recreate the monorepo structure

Write-Host "🏗️ Creating Securities Exchange System Project Structure..." -ForegroundColor Green

# Root directories
$directories = @(
    # Core application directories
    "apps/admin-ui/src/components",
    "apps/admin-ui/src/pages",
    "apps/admin-ui/src/hooks",
    "apps/admin-ui/src/services",
    "apps/admin-ui/src/store",
    "apps/admin-ui/src/utils",
    "apps/admin-ui/src/types",
    "apps/admin-ui/src/styles",
    "apps/admin-ui/public",
    
    "apps/trader-ui/src/components",
    "apps/trader-ui/src/pages",
    "apps/trader-ui/src/hooks",
    "apps/trader-ui/src/services",
    "apps/trader-ui/src/store",
    "apps/trader-ui/src/utils",
    "apps/trader-ui/src/types",
    "apps/trader-ui/src/styles",
    "apps/trader-ui/public",
    
    # Services directories with proper structure
    "services/matching-engine/src/main/java/com/exs/trading/domain/order",
    "services/matching-engine/src/main/java/com/exs/trading/domain/trade",
    "services/matching-engine/src/main/java/com/exs/trading/domain/market",
    "services/matching-engine/src/main/java/com/exs/trading/application/commands",
    "services/matching-engine/src/main/java/com/exs/trading/application/queries",
    "services/matching-engine/src/main/java/com/exs/trading/application/events",
    "services/matching-engine/src/main/java/com/exs/trading/infrastructure/persistence",
    "services/matching-engine/src/main/java/com/exs/trading/infrastructure/messaging",
    "services/matching-engine/src/main/java/com/exs/trading/infrastructure/observability",
    "services/matching-engine/src/main/java/com/exs/trading/infrastructure/external",
    "services/matching-engine/src/main/java/com/exs/trading/interfaces/rest",
    "services/matching-engine/src/main/java/com/exs/trading/interfaces/websocket",
    "services/matching-engine/src/main/java/com/exs/trading/interfaces/grpc",
    "services/matching-engine/src/main/resources",
    "services/matching-engine/src/test/java",
    "services/matching-engine/src/test/resources",
    
    # Other services with similar structure
    "services/order-gateway/src/main/java/com/exs/order",
    "services/order-gateway/src/main/resources",
    "services/order-gateway/src/test/java",
    
    "services/market-data-gateway/src/main/java/com/exs/marketdata",
    "services/market-data-gateway/src/main/resources",
    "services/market-data-gateway/src/test/java",
    
    "services/risk-engine/src/main/java/com/exs/risk",
    "services/risk-engine/src/main/resources",
    "services/risk-engine/src/test/java",
    
    "services/clearing/src/main/java/com/exs/clearing",
    "services/clearing/src/main/resources",
    "services/clearing/src/test/java",
    
    "services/settlement-service/src/main/java/com/exs/settlement",
    "services/settlement-service/src/main/resources",
    "services/settlement-service/src/test/java",
    
    "services/custody-service/src/main/java/com/exs/custody",
    "services/custody-service/src/main/resources",
    "services/custody-service/src/test/java",
    
    "services/compliance-service/src/main/java/com/exs/compliance",
    "services/compliance-service/src/main/resources",
    "services/compliance-service/src/test/java",
    
    "services/surveillance-service/src/main/java/com/exs/surveillance",
    "services/surveillance-service/src/main/resources",
    "services/surveillance-service/src/test/java",
    
    "services/member-service/src/main/java/com/exs/member",
    "services/member-service/src/main/resources",
    "services/member-service/src/test/java",
    
    "services/reporting-service/src/main/java/com/exs/reporting",
    "services/reporting-service/src/main/resources",
    "services/reporting-service/src/test/java",
    
    "services/api-gateway/src/main/java/com/exs/gateway",
    "services/api-gateway/src/main/resources",
    "services/api-gateway/src/test/java",
    
    "services/data-pipeline/src/main/java/com/exs/pipeline",
    "services/data-pipeline/src/main/resources",
    "services/data-pipeline/src/test/java",
    
    # Packages directories
    "packages/clients/go/trading/v1",
    "packages/clients/java/src/main/java/com/exs/client/trading/v1",
    "packages/clients/typescript/src",
    
    "packages/shared-domain/src/main/java/com/exs/shared/domain/trading",
    "packages/shared-domain/src/main/java/com/exs/shared/domain/user",
    "packages/shared-domain/src/main/java/com/exs/shared/domain/market",
    "packages/shared-domain/src/test/java",
    
    "packages/shared-utils/src/main/java/com/exs/shared/utils/datetime",
    "packages/shared-utils/src/main/java/com/exs/shared/utils/price",
    "packages/shared-utils/src/main/java/com/exs/shared/utils/validation",
    "packages/shared-utils/src/main/java/com/exs/shared/utils/security",
    "packages/shared-utils/src/test/java",
    
    # Proto directories
    "proto/exs/marketdata/v1",
    "proto/exs/user/v1",
    "proto/exs/risk/v1",
    "proto/exs/clearing/v1",
    "proto/exs/settlement/v1",
    "proto/exs/custody/v1",
    "proto/exs/compliance/v1",
    "proto/exs/surveillance/v1",
    "proto/exs/member/v1",
    "proto/exs/reporting/v1",
    
    # Schema directories
    "schemas/trading",
    "schemas/marketdata",
    "schemas/user",
    "schemas/system",
    "schemas/compliance",
    
    # Platform directories
    "platform/kubernetes/namespaces",
    "platform/kubernetes/deployments/trading-engine",
    "platform/kubernetes/deployments/order-management",
    "platform/kubernetes/deployments/market-data",
    "platform/kubernetes/databases",
    "platform/kubernetes/monitoring",
    "platform/kubernetes/storage",
    
    "platform/argo/applications",
    "platform/argo/projects",
    "platform/argo/repositories",
    
    "platform/observability/prometheus",
    "platform/observability/grafana/dashboards/trading",
    "platform/observability/grafana/dashboards/infrastructure",
    "platform/observability/grafana/dashboards/compliance",
    "platform/observability/jaeger",
    "platform/observability/elasticsearch",
    
    "platform/security/policies",
    "platform/security/opa",
    "platform/security/vault",
    "platform/security/keycloak",
    
    "platform/terraform/environments/dev",
    "platform/terraform/environments/staging",
    "platform/terraform/environments/prod",
    "platform/terraform/modules/kubernetes",
    "platform/terraform/modules/databases",
    "platform/terraform/modules/monitoring",
    
    # Ops directories
    "ops/runbooks/trading",
    "ops/runbooks/infrastructure",
    "ops/runbooks/security",
    "ops/runbooks/compliance",
    
    "ops/sre/playbooks",
    "ops/sre/alerts",
    "ops/sre/oncall",
    
    # Documentation directories
    "docs/architecture",
    "docs/api",
    "docs/deployment",
    "docs/compliance",
    "docs/development",
    "docs/operations",
    
    # Database directories
    "databases/postgresql/schemas/trading",
    "databases/postgresql/schemas/users",
    "databases/postgresql/schemas/compliance",
    "databases/postgresql/schemas/analytics",
    "databases/postgresql/migrations",
    "databases/postgresql/functions",
    "databases/postgresql/views",
    
    # Scripts directories
    "scripts/setup",
    "scripts/deployment",
    "scripts/monitoring",
    "scripts/backup",
    "scripts/migration",
    
    # Other directories
    "shared/standards",
    "shared/templates",
    "shared/configs",
    
    "thirdparty/integrations",
    "thirdparty/feeds",
    "thirdparty/apis",
    
    "tools/development",
    "tools/testing",
    "tools/analysis",
    "tools/security"
)

# Create directories
foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✅ Created directory: $dir" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Directory already exists: $dir" -ForegroundColor Yellow
    }
}

# Create .gitkeep files in empty directories
$emptyDirs = @(
    "apps/admin-ui/src/components",
    "apps/admin-ui/src/pages",
    "apps/admin-ui/src/hooks",
    "apps/admin-ui/src/services",
    "apps/admin-ui/src/store",
    "apps/admin-ui/src/utils",
    "apps/admin-ui/src/types",
    "apps/admin-ui/src/styles",
    "apps/admin-ui/public",
    
    "apps/trader-ui/src/components",
    "apps/trader-ui/src/pages",
    "apps/trader-ui/src/hooks",
    "apps/trader-ui/src/services",
    "apps/trader-ui/src/store",
    "apps/trader-ui/src/utils",
    "apps/trader-ui/src/types",
    "apps/trader-ui/src/styles",
    "apps/trader-ui/public",
    
    "packages/clients/go/trading/v1",
    "packages/clients/java/src/main/java/com/exs/client/trading/v1",
    "packages/clients/typescript/src",
    
    "schemas/trading",
    "schemas/marketdata",
    "schemas/user",
    "schemas/system",
    "schemas/compliance",
    
    "platform/argo/applications",
    "platform/argo/projects",
    "platform/argo/repositories",
    
    "platform/observability/grafana/dashboards/trading",
    "platform/observability/grafana/dashboards/infrastructure",
    "platform/observability/grafana/dashboards/compliance",
    
    "platform/security/policies",
    "platform/security/opa",
    "platform/security/vault",
    "platform/security/keycloak",
    
    "ops/runbooks/trading",
    "ops/runbooks/infrastructure",
    "ops/runbooks/security",
    "ops/runbooks/compliance",
    
    "ops/sre/playbooks",
    "ops/sre/alerts",
    "ops/sre/oncall",
    
    "docs/api",
    "docs/deployment",
    "docs/compliance",
    "docs/development",
    "docs/operations",
    
    "scripts/setup",
    "scripts/deployment",
    "scripts/monitoring",
    "scripts/backup",
    "scripts/migration",
    
    "shared/standards",
    "shared/templates",
    "shared/configs",
    
    "thirdparty/integrations",
    "thirdparty/feeds",
    "thirdparty/apis",
    
    "tools/development",
    "tools/testing",
    "tools/analysis",
    "tools/security"
)

foreach ($dir in $emptyDirs) {
    $gitkeepFile = Join-Path $dir ".gitkeep"
    if (!(Test-Path $gitkeepFile)) {
        New-Item -ItemType File -Path $gitkeepFile -Force | Out-Null
        Write-Host "✅ Created .gitkeep: $gitkeepFile" -ForegroundColor Green
    }
}

Write-Host "`n🎉 Project structure creation completed!" -ForegroundColor Green
Write-Host "📁 Total directories created: $($directories.Count)" -ForegroundColor Cyan
Write-Host "📄 Total .gitkeep files created: $($emptyDirs.Count)" -ForegroundColor Cyan

Write-Host "`n📋 Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the created structure" -ForegroundColor White
Write-Host "2. Update service-specific configurations" -ForegroundColor White
Write-Host "3. Generate client SDKs with: buf generate" -ForegroundColor White
Write-Host "4. Start implementing core services" -ForegroundColor White
Write-Host "5. Setup development environment" -ForegroundColor White
