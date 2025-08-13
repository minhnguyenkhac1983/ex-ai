# Repository Structure - Financial Exchange System

## Overview
Cấu trúc repository theo Domain-Driven Design (DDD) và Microservices Architecture, tổ chức theo bounded contexts và cross-cutting concerns.

## Root Structure

```
exf/
├── README.md                    # Project overview, architecture summary
├── docker-compose.yml           # Local development setup
├── .github/                     # GitHub workflows, CODEOWNERS
├── plan/                        # Original planning documents
├── docs/                        # Documentation
├── services/                    # Microservices (bounded contexts)
├── platform/                    # Shared platform services
├── gateways/                    # API gateways
├── bff/                         # Backend-for-Frontend services
├── contracts/                   # API and event contracts
├── infra/                       # Infrastructure as Code
├── apps/                        # Client applications
├── libs/                        # Shared libraries
├── scripts/                     # Automation scripts
├── tools/                       # Development and operational tools
└── frontend/                    # Frontend applications (legacy)
```

## Services Directory (Microservices)

### Core Trading Services
```
services/
├── trading-oms/                 # Order Management System
├── matching-engine/             # Matching Engine
├── execution-reports/           # Execution Reports
├── market-data/                 # Market Data Service
├── market-data-distribution/    # Market Data Distribution
├── risk-service/                # Risk Management
├── pre-trade-risk/              # Pre-Trade Risk Controls
└── post-trade-risk/             # Post-Trade Risk Management
```

### Post-Trade Services
```
services/
├── clearing-service/            # Clearing Service
├── ccp-operations/              # CCP Operations
├── settlement-service/          # Settlement Service
├── custody-service/             # Custody Service
├── payments-treasury/           # Payments & Treasury
└── cash-management/             # Cash Management
```

### Regulatory & Compliance Services
```
services/
├── compliance-service/          # Compliance Service
├── market-surveillance/         # Market Surveillance
├── regulatory-reporting/        # Regulatory Reporting
└── transaction-reporting/       # Transaction Reporting
```

### Participant & Member Services
```
services/
├── member-management/           # Member Management
├── member-billing/              # Member Billing
├── connectivity-gateway/        # Connectivity Gateway
└── fix-gateway/                 # FIX Gateway
```

### Market Infrastructure Services
```
services/
├── listing-corporate/           # Listing & Corporate Actions
├── corporate-actions/           # Corporate Actions
├── reference-data/              # Reference Data
└── master-data/                 # Master Data
```

### Analytics & Intelligence Services
```
services/
├── portfolio-analytics/         # Portfolio Analytics
├── performance-analytics/       # Performance Analytics
├── ai-platform/                 # AI Platform
├── ml-trading/                  # ML Trading
└── ml-risk/                     # ML Risk
```

### Security & Operations Services
```
services/
├── iam-security/                # IAM & Security
├── security-operations/         # Security Operations
├── ops-sre/                     # Operations & SRE
├── monitoring/                  # Monitoring
└── incident-management/         # Incident Management
```

### Data & Platform Services
```
services/
├── data-platform/               # Data Platform
├── data-lake/                   # Data Lake
├── stream-processing/           # Stream Processing
├── external-integration/        # External Integration
└── third-party-connectors/      # Third-Party Connectors
```

### Banking & Financial Services
```
services/
├── banking-services/            # Banking Services
├── core-banking/                # Core Banking
├── insurance-services/          # Insurance Services
├── policy-management/           # Policy Management
├── payment-systems/             # Payment Systems
└── payment-processing/          # Payment Processing
```

### Advanced Trading Services
```
services/
├── derivatives-trading/         # Derivatives Trading
├── options-trading/             # Options Trading
├── futures-trading/             # Futures Trading
├── algo-trading/                # Algorithmic Trading
├── hft-platform/                # HFT Platform
├── dark-pool-trading/           # Dark Pool Trading
└── block-trading/               # Block Trading
```

## Platform Directory (Shared Services)

```
platform/
├── observability/               # Monitoring, tracing, logging
├── security/                    # Authentication, authorization, encryption
└── data/                        # Data governance, catalog, lineage
```

## Gateways Directory (API Gateways)

```
gateways/
└── api-gateway/                 # Main API Gateway
```

## BFF Directory (Backend-for-Frontend)

```
bff/
├── trading-bff/                 # Trading BFF
└── analytics-bff/               # Analytics BFF
```

## Contracts Directory (API & Event Contracts)

```
contracts/
├── api/                         # API contracts
│   ├── *.openapi.yaml          # OpenAPI specifications
│   └── grpc/                   # gRPC IDL files
├── events/                      # Event contracts
│   ├── asyncapi.yaml           # AsyncAPI specification
│   └── schemas/                # JSON Schema definitions
├── graphql/                     # GraphQL schemas
└── policies/                    # OPA policies
    ├── authz/                   # Authorization policies
    └── ratelimit/               # Rate limiting policies
```

## Infrastructure Directory (IaC)

```
infra/
├── kustomize/                   # Kustomize manifests
│   ├── dev/                     # Development environment
│   ├── staging/                 # Staging environment
│   └── prod/                    # Production environment
├── terraform/                   # Terraform configurations
└── helm/                        # Helm charts
```

## Applications Directory (Client Apps)

```
apps/
├── web/                         # Web applications
├── mobile/                      # Mobile applications
└── desktop/                     # Desktop applications
```

## Libraries Directory (Shared Code)

```
libs/
├── common/                      # Common utilities
├── trading/                     # Trading-specific libraries
├── risk/                        # Risk management libraries
└── data/                        # Data processing libraries
```

## Scripts Directory (Automation)

```
scripts/
├── codegen/                     # Code generation scripts
├── validation/                  # Contract validation scripts
└── deployment/                  # Deployment automation
```

## Tools Directory (Development & Operations)

```
tools/
├── development/                 # Development tools
├── operations/                  # Operational tools
└── security/                    # Security tools
```

## Documentation Directory

```
docs/
├── architecture/                # Architecture documentation
│   ├── overview.md             # High-level architecture
│   ├── bounded-contexts.md     # Bounded contexts definition
│   ├── context-map.md          # Context map and integration
│   ├── events.md               # Domain events
│   ├── technology.md           # Technology choices
│   ├── repo-structure.md       # This file
│   ├── topology.md             # Deployment topology
│   ├── flows/                  # Business flows
│   ├── patterns/               # Architectural patterns
│   ├── security/               # Security architecture
│   ├── performance/            # Performance considerations
│   └── scalability/            # Scalability patterns
├── adr/                        # Architecture Decision Records
├── api/                        # API documentation
├── events/                     # Event documentation
├── deployment/                 # Deployment guides
├── operations/                 # Operational procedures
├── security/                   # Security documentation
├── compliance/                 # Compliance documentation
├── testing/                    # Testing strategies
├── monitoring/                 # Monitoring setup
├── incident-response/          # Incident response procedures
├── disaster-recovery/          # Disaster recovery plans
├── business-continuity/        # Business continuity plans
├── regulatory/                 # Regulatory compliance
├── audit/                      # Audit procedures
├── risk-management/            # Risk management
├── data-governance/            # Data governance
├── ai-ml/                      # AI/ML documentation
├── blockchain/                 # Blockchain integration
├── quantum/                    # Quantum computing
├── sustainability/             # Sustainability
├── esg/                        # ESG considerations
├── green-finance/              # Green finance
├── fintech/                    # Fintech integration
├── digital-banking/            # Digital banking
├── insurance/                  # Insurance services
├── payments/                   # Payment systems
├── derivatives/                # Derivatives trading
├── algorithmic-trading/        # Algorithmic trading
├── hft/                        # High-frequency trading
├── dark-pools/                 # Dark pools
├── block-trading/              # Block trading
├── alternative-trading/        # Alternative trading
├── market-microstructure/      # Market microstructure
├── liquidity/                  # Liquidity analysis
├── volatility/                 # Volatility analysis
├── correlation/                # Correlation analysis
├── flow-analysis/              # Flow analysis
├── sentiment-analysis/         # Sentiment analysis
├── news-analytics/             # News analytics
├── social-media-analytics/     # Social media analytics
├── fundamental-analysis/       # Fundamental analysis
├── technical-analysis/         # Technical analysis
├── quantitative-research/      # Quantitative research
├── macroeconomic-analysis/     # Macroeconomic analysis
├── sector-analysis/            # Sector analysis
├── credit-research/            # Credit research
├── alternative-data/           # Alternative data
├── performance-attribution/    # Performance attribution
├── risk-adjusted-returns/      # Risk-adjusted returns
├── benchmark-analysis/         # Benchmark analysis
├── tracking-error-analysis/    # Tracking error analysis
├── information-ratio/          # Information ratio
├── sharpe-ratio/               # Sharpe ratio
├── maximum-drawdown/           # Maximum drawdown
├── value-added-analysis/       # Value added analysis
├── market-analytics/           # Market analytics
├── portfolio-construction/     # Portfolio construction
├── asset-allocation/           # Asset allocation
├── risk-budgeting/             # Risk budgeting
├── rebalancing-systems/        # Rebalancing systems
├── model-portfolio-management/ # Model portfolio management
├── multi-manager-platforms/    # Multi-manager platforms
├── investment-management/      # Investment management
├── wealth-management/          # Wealth management
├── private-banking/            # Private banking
├── family-office-systems/      # Family office systems
├── trust-estate-services/      # Trust & estate services
├── tax-optimized-investing/    # Tax-optimized investing
├── estate-planning/            # Estate planning
├── philanthropic-services/     # Philanthropic services
├── next-generation-services/   # Next generation services
├── mutual-fund-administration/ # Mutual fund administration
├── hedge-fund-operations/      # Hedge fund operations
├── private-equity-systems/     # Private equity systems
├── real-estate-investment/     # Real estate investment
├── alternative-investments/    # Alternative investments
├── pension-fund-management/    # Pension fund management
├── insurance-asset-management/ # Insurance asset management
├── sovereign-wealth-funds/     # Sovereign wealth funds
├── life-insurance/             # Life insurance
├── general-insurance/          # General insurance
├── specialized-insurance/      # Specialized insurance
├── reinsurance/                # Reinsurance
├── primary-markets/            # Primary markets
├── secondary-markets/          # Secondary markets
├── market-infrastructure/      # Market infrastructure
├── asset-management/           # Asset management
├── brokerage-services/         # Brokerage services
├── investment-banking/         # Investment banking
├── electronic-payment-systems/ # Electronic payment systems
├── traditional-payment-methods/ # Traditional payment methods
├── international-payment-systems/ # International payment systems
├── money-markets/              # Money markets
├── bond-markets/               # Bond markets
├── equity-markets/             # Equity markets
├── exchange-traded-derivatives/ # Exchange-traded derivatives
├── otc-derivatives/            # OTC derivatives
├── commodity-markets/          # Commodity markets
├── foreign-exchange/           # Foreign exchange
├── trade-finance/              # Trade finance
├── development-finance/        # Development finance
├── digital-banking/            # Digital banking
├── payment-technology/         # Payment technology
├── blockchain-cryptocurrency/  # Blockchain & cryptocurrency
├── lending-technology/         # Lending technology
├── financial-regulators/       # Financial regulators
├── market-infrastructure/      # Market infrastructure
├── risk-management-infrastructure/ # Risk management infrastructure
├── core-technology-systems/    # Core technology systems
├── security-authentication/    # Security & authentication
└── analytics-intelligence/     # Analytics & intelligence
```

## Service Structure Template

Mỗi service trong thư mục `services/` tuân theo cấu trúc chuẩn:

```
services/{service-name}/
├── README.md                    # Service documentation
├── src/                         # Source code
│   ├── main/                    # Main application code
│   ├── test/                    # Test code
│   └── resources/               # Configuration files
├── Dockerfile                   # Container definition
├── docker-compose.yml           # Service-specific compose
├── k8s/                         # Kubernetes manifests
├── scripts/                     # Service-specific scripts
└── docs/                        # Service documentation
```

## Key Principles

### Domain-Driven Design
- Mỗi service đại diện cho một bounded context
- Services độc lập với database riêng
- Giao tiếp qua events và APIs có hợp đồng

### Microservices Architecture
- Services nhỏ, tập trung vào một domain
- Database-per-service pattern
- Event-driven communication
- Independent deployment

### Cross-Cutting Concerns
- Platform services cho observability, security, data
- Shared libraries cho common functionality
- Centralized contracts cho APIs và events
- Infrastructure as Code cho deployment

### Development Workflow
- Contract-first development
- API versioning và backward compatibility
- Automated testing và validation
- GitOps deployment workflow


