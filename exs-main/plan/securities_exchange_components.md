# TẤT CẢ CÁC THÀNH PHẦN HỆ THỐNG SECURITIES EXCHANGE

## 🏛️ **CORE EXCHANGE INFRASTRUCTURE**

### Trading Engine & Order Management
- **Order Book Management**: Lưu trữ và quản lý lệnh mua/bán
- **Matching Engine**: CEP engine xử lý sự kiện đến dựa trên quy tắc CEP
- **Order Routing System (ORS)**: Định tuyến lệnh tối ưu
- **Trade Execution Engine**: Thực hiện giao dịch
- **Price Discovery Mechanism**: Cơ chế khám phá giá
- **Market Making System**: Hệ thống tạo lập thị trường

### Market Data Distribution
- **Real-time Market Data Feed**: Nguồn cấp dữ liệu thời gian thực
- **Level I Data**: Giá tốt nhất bid/ask
- **Level II Data**: Market depth toàn bộ
- **Time & Sales Data**: Lịch sử giao dịch theo thời gian
- **Market Statistics**: Thống kê thị trường (volume, volatility)
- **Index Calculation Engine**: Tính toán chỉ số

## 📊 **TRADING SYSTEMS**

### Pre-Trade Services
- **Order Validation**: Kiểm tra tính hợp lệ lệnh
- **Credit Check System**: Kiểm tra tín dụng
- **Position Monitoring**: Giám sát vị thế
- **Pre-Trade Risk Management**: Quản lý rủi ro trước giao dịch
- **Compliance Screening**: Kiểm tra tuân thủ
- **Best Execution Analysis**: Phân tích thực thi tốt nhất

### Order Types & Management
- **Market Orders**: Lệnh thị trường
- **Limit Orders**: Lệnh giới hạn
- **Stop Orders**: Lệnh dừng
- **Iceberg Orders**: Lệnh tảng băng trôi
- **Fill-or-Kill (FOK)**: Lệnh thực hiện hoặc hủy
- **Immediate-or-Cancel (IOC)**: Lệnh tức thì hoặc hủy
- **Good-Till-Cancelled (GTC)**: Lệnh có hiệu lực đến khi hủy
- **Auction Orders**: Lệnh đấu giá

### Trading Protocols
- **FIX Protocol Implementation**: Giao thức FIX chuẩn
- **FAST Protocol**: Financial Information eXchange Protocol
- **OUCH Protocol**: Order execution protocol
- **DROP Protocol**: Direct market data feed
- **Binary Protocol**: Giao thức nhị phân tốc độ cao

## 🔄 **CLEARING & SETTLEMENT**

### Trade Processing
- **Trade Capture**: Thu thập giao dịch
- **Trade Validation**: Xác thực giao dịch
- **Trade Matching**: Đối chiếu giao dịch
- **Trade Reporting**: Báo cáo giao dịch cho các cơ quan quản lý
- **Trade Confirmation**: Xác nhận giao dịch
- **Trade Amendment**: Sửa đổi giao dịch

### Clearing Operations
- **Central Counterparty (CCP)**: CCP hỗ trợ thị trường chứng khoán và phái sinh hiện đại
- **Netting System**: Bù trừ các giao dịch thành vị thế đơn
- **Margin Management**: Quản lý ký quỹ
- **Risk Management**: Quản lý rủi ro và margining
- **Collateral Management**: Quản lý tài sản thế chấp
- **Default Management**: Quản lý vỡ nợ

### Settlement Services
- **T+1 Settlement**: Thanh toán trong 1 ngày giao dịch
- **T+0 Settlement**: Thanh toán tức thì
- **Securities Transfer**: Chuyển giao chứng khoán
- **Cash Settlement**: Thanh toán bằng tiền mặt
- **Corporate Actions Processing**: Xử lý quyền cổ đông
- **Failed Trade Management**: Quản lý giao dịch thất bại

## 🏦 **CUSTODY & DEPOSITORY**

### Securities Custody
- **Central Securities Depository (CSD)**: Lưu ký tập trung chứng khoán
- **Sub-Custody Services**: Dịch vụ lưu ký phụ
- **Asset Servicing**: Dịch vụ tài sản
- **Dematerialization**: Chuyển đổi chứng khoán giấy thành điện tử
- **Immobilization**: Bất động hóa chứng khoán vật lý
- **Nominee Services**: Dịch vụ đại diện sở hữu

### Depository Operations
- **Account Management**: Quản lý tài khoản
- **Holdings Management**: Quản lý nắm giữ
- **Movement Processing**: Xử lý di chuyển chứng khoán
- **Safekeeping Services**: Dịch vụ bảo quản an toàn
- **Registry Maintenance**: Duy trì sổ đăng ký
- **Reconciliation Services**: Dịch vụ đối soát

## 💰 **FINANCIAL SERVICES**

### Payment Systems
- **Real-Time Gross Settlement (RTGS)**: Thanh toán gộp thời gian thực
- **Automated Clearing House (ACH)**: Phòng thanh toán tự động
- **Wire Transfer System**: Hệ thống chuyển tiền điện tử
- **Multi-Currency Settlement**: Thanh toán đa tiền tệ
- **Cross-Border Payments**: Thanh toán xuyên biên giới
- **Central Bank Money**: Tiền ngân hàng trung ương

### Treasury Operations
- **Liquidity Management**: Quản lý thanh khoản
- **Cash Management**: Quản lý tiền mặt
- **Foreign Exchange**: Ngoại hối
- **Money Market Operations**: Hoạt động thị trường tiền tệ
- **Securities Lending**: Cho vay chứng khoán
- **Repo Operations**: Hoạt động repo

## 🛡️ **RISK MANAGEMENT**

### Market Risk
- **Value at Risk (VaR)**: Giá trị có rủi ro
- **Stress Testing**: Kiểm tra căng thẳng
- **Scenario Analysis**: Phân tích kịch bản
- **Portfolio Risk Assessment**: Đánh giá rủi ro danh mục
- **Concentration Risk**: Rủi ro tập trung
- **Market Risk Limits**: Giới hạn rủi ro thị trường

### Credit Risk
- **Counterparty Risk Assessment**: Đánh giá rủi ro đối tác
- **Credit Rating Integration**: Tích hợp xếp hạng tín dụng
- **Exposure Monitoring**: Giám sát rủi ro
- **Credit Limits Management**: Quản lý hạn mức tín dụng
- **Default Probability Modeling**: Mô hình xác suất vỡ nợ

### Operational Risk
- **System Monitoring**: Giám sát hệ thống
- **Disaster Recovery**: Khôi phục thảm họa
- **Business Continuity**: Liên tục kinh doanh
- **Incident Management**: Quản lý sự cố
- **Operational Risk Assessment**: Đánh giá rủi ro hoạt động

## 📋 **REGULATORY & COMPLIANCE**

### Market Surveillance
- **Trade Surveillance**: Giám sát giao dịch
- **Market Manipulation Detection**: Phát hiện thao túng thị trường
- **Insider Trading Monitoring**: Giám sát giao dịch nội bộ
- **Unusual Activity Detection**: Phát hiện hoạt động bất thường
- **Cross-Market Surveillance**: Giám sát xuyên thị trường
- **Alert Management**: Quản lý cảnh báo

### Regulatory Reporting
- **MiFID II Reporting**: Báo cáo MiFID II
- **EMIR Reporting**: Báo cáo EMIR
- **Dodd-Frank Reporting**: Báo cáo Dodd-Frank
- **CFTC Reporting**: Báo cáo CFTC
- **SEC Reporting**: Báo cáo SEC
- **Local Regulatory Reports**: Báo cáo cơ quan quản lý địa phương

### Compliance Management
- **Know Your Customer (KYC)**: Hiểu biết khách hàng
- **Anti-Money Laundering (AML)**: Chống rửa tiền
- **Sanctions Screening**: Kiểm tra lệnh trừng phạt
- **Best Execution Monitoring**: Giám sát thực thi tốt nhất
- **Record Keeping**: Lưu trữ hồ sơ
- **Audit Trail**: Dấu vết kiểm toán

## 🖥️ **TECHNOLOGY INFRASTRUCTURE**

### Core Systems
- **High-Performance Computing (HPC)**: Máy tính hiệu năng cao
- **Low-Latency Networks**: Mạng độ trễ thấp
- **Memory Databases**: Cơ sở dữ liệu trong bộ nhớ
- **Message Queuing**: Hàng đợi tin nhắn
- **Load Balancing**: Cân bằng tải
- **Caching Systems**: Hệ thống cache

### Data Management
- **Time Series Databases**: Cơ sở dữ liệu chuỗi thời gian
- **Data Warehousing**: Kho dữ liệu
- **Big Data Analytics**: Phân tích dữ liệu lớn
- **Real-Time Analytics**: Phân tích thời gian thực
- **Data Archiving**: Lưu trữ dữ liệu
- **Data Governance**: Quản trị dữ liệu

### Network & Connectivity
- **Market Data Distribution Networks**: Mạng phân phối dữ liệu thị trường
- **Private Networks**: Mạng riêng
- **Colocation Services**: Dịch vụ đồng vị trí
- **Cross-Connects**: Kết nối chéo
- **Microwave Networks**: Mạng vi ba
- **Submarine Cables**: Cáp ngầm

## 👥 **PARTICIPANT MANAGEMENT**

### Member Services
- **Membership Management**: Quản lý thành viên
- **Trading Permissions**: Quyền giao dịch
- **Fee Management**: Quản lý phí
- **Billing & Invoicing**: Hóa đơn và thanh toán
- **Performance Monitoring**: Giám sát hiệu suất
- **Member Support**: Hỗ trợ thành viên

### Access Management
- **Trading Access**: Quyền truy cập giao dịch
- **Market Data Access**: Quyền truy cập dữ liệu thị trường
- **API Management**: Quản lý API
- **Certification Management**: Quản lý chứng nhận
- **Testing Environment**: Môi trường thử nghiệm

## 📈 **MARKET SERVICES**

### Listing Services
- **IPO Management**: Quản lý IPO
- **Listing Requirements**: Yêu cầu niêm yết
- **Corporate Actions**: Hành động doanh nghiệp
- **Delisting Procedures**: Thủ tục hủy niêm yết
- **Issuer Services**: Dịch vụ tổ chức phát hành
- **Index Inclusion/Exclusion**: Đưa vào/loại khỏi chỉ số

### Market Making
- **Designated Market Makers**: Nhà tạo lập thị trường được chỉ định
- **Liquidity Provision**: Cung cấp thanh khoản
- **Spread Management**: Quản lý chênh lệch giá
- **Quote Management**: Quản lý báo giá
- **Incentive Programs**: Chương trình khuyến khích

## 🔐 **SECURITY SYSTEMS**

### Cybersecurity
- **Network Security**: Bảo mật mạng
- **Application Security**: Bảo mật ứng dụng
- **Data Encryption**: Mã hóa dữ liệu
- **Access Control**: Kiểm soát truy cập
- **Intrusion Detection**: Phát hiện xâm nhập
- **Security Monitoring**: Giám sát bảo mật

### Authentication & Authorization
- **Multi-Factor Authentication**: Xác thực đa yếu tố
- **Digital Certificates**: Chứng chỉ số
- **Single Sign-On (SSO)**: Đăng nhập một lần
- **Role-Based Access Control**: Kiểm soát truy cập dựa trên vai trò
- **Privilege Management**: Quản lý đặc quyền

## 📊 **ANALYTICS & REPORTING**

### Market Analytics
- **Trading Volume Analysis**: Phân tích khối lượng giao dịch
- **Price Movement Analysis**: Phân tích biến động giá
- **Volatility Analysis**: Phân tích biến động
- **Correlation Analysis**: Phân tích tương quan
- **Market Microstructure**: Vi cấu trúc thị trường
- **High-Frequency Trading Analytics**: Phân tích giao dịch tần số cao

### Performance Reporting
- **Trading Performance**: Hiệu suất giao dịch
- **System Performance**: Hiệu suất hệ thống
- **Market Quality Metrics**: Chỉ số chất lượng thị trường
- **Operational Metrics**: Chỉ số hoạt động
- **Financial Performance**: Hiệu suất tài chính

## 🌐 **INTEGRATION & CONNECTIVITY**

### External Connections
- **Other Exchanges**: Kết nối sàn giao dịch khác
- **ECNs (Electronic Communication Networks)**: Mạng giao tiếp điện tử
- **ATSs (Alternative Trading Systems)**: Hệ thống giao dịch thay thế
- **Central Banks**: Ngân hàng trung ương
- **Regulators**: Cơ quan quản lý
- **Data Vendors**: Nhà cung cấp dữ liệu

### Third-Party Services
- **Credit Rating Agencies**: Tổ chức xếp hạng tín dụng
- **Price Discovery Services**: Dịch vụ khám phá giá
- **Reference Data Providers**: Nhà cung cấp dữ liệu tham chiếu
- **Technology Vendors**: Nhà cung cấp công nghệ
- **Consulting Services**: Dịch vụ tư vấn

## 📱 **USER INTERFACES**

### Trading Interfaces
- **Professional Trading Terminals**: Thiết bị đầu cuối giao dịch chuyên nghiệp
- **Web-Based Trading**: Giao dịch trên web
- **Mobile Trading Apps**: Ứng dụng giao dịch di động
- **API Trading**: Giao dịch qua API
- **Algorithmic Trading Interfaces**: Giao diện giao dịch thuật toán

### Market Data Interfaces
- **Real-Time Data Feeds**: Nguồn cấp dữ liệu thời gian thực
- **Historical Data Access**: Truy cập dữ liệu lịch sử
- **Market Data Terminals**: Thiết bị đầu cuối dữ liệu thị trường
- **Custom Dashboards**: Bảng điều khiển tùy chỉnh
- **Mobile Market Data**: Dữ liệu thị trường di động

## 🏗️ **SPECIALIZED SYSTEMS**

### High-Frequency Trading (HFT)
- **Ultra-Low Latency Systems**: Hệ thống độ trễ cực thấp
- **Co-location Services**: Dịch vụ đặt cùng vị trí
- **Direct Market Access (DMA)**: Truy cập trực tiếp thị trường
- **Algorithmic Execution**: Thực thi thuật toán
- **Smart Order Routing**: Định tuyến lệnh thông minh

### Dark Pools
- **Anonymous Trading**: Giao dịch ẩn danh
- **Price Improvement**: Cải thiện giá
- **Order Interaction**: Tương tác lệnh
- **Liquidity Aggregation**: Tổng hợp thanh khoản
- **Block Trading**: Giao dịch khối lớn

### Derivatives Trading
- **Futures Trading**: Giao dịch hợp đồng tương lai
- **Options Trading**: Giao dịch quyền chọn
- **Swaps Processing**: Xử lý hoán đổi
- **Margin Calculation**: Tính toán ký quỹ
- **Position Monitoring**: Giám sát vị thế

---

## 📝 **GHI CHÚ QUAN TRỌNG**

### 🎯 **Thành phần cốt lõi không thể thiếu:**
1. **Trading Engine & Order Management**
2. **Clearing & Settlement Systems**
3. **Risk Management & Compliance**
4. **Market Data Distribution**
5. **Custody & Depository Services**

### ⚡ **Kiến trúc khuyên dùng (đã cập nhật):**
- **Microservices Architecture**: Linh hoạt tách dịch vụ theo bounded context (DDD)
- **Event-Driven Architecture & Streaming-first**: Dựa trên sự kiện, ưu tiên stream làm nguồn sự thật thứ cấp
- **CQRS & Event Sourcing**: Tách đọc/ghi, lưu trạng thái bằng sự kiện cho auditability và phục hồi
- **Hexagonal/Onion/Clean Architecture**: Cô lập domain khỏi hạ tầng, dễ kiểm thử và thay thế công nghệ
- **Service Mesh**: Quản trị mTLS, traffic shaping, observability (Istio/Linkerd)
- **Data Mesh & Lakehouse**: Quản trị domain data products, kết hợp batch/stream (Delta/Iceberg)
- **Modular Monolith where sensible**: Đơn khối mô-đun cho các nhóm nhỏ hoặc thành phần ít biến động
- **API-first (gRPC/REST) & Schema-first**: Hợp đồng qua `proto`/OpenAPI + Schema Registry
- **Zero Trust Architecture**: Xác thực liên dịch vụ, phân quyền theo nguyên tắc tối thiểu
- **High-Availability & Multi-Region**: Active-active/active-passive, RTO/RPO rõ ràng
- **Resilience by Design**: Circuit breaker, retry, idempotency, backpressure
- **Low-Latency Design**: Busy-poll, pin CPU/NUMA-aware, SBE/FIX binary, off-heap

### 🔒 **Ưu tiên bảo mật:**
- **Multi-layer Security**: Bảo mật đa lớp
- **Real-time Monitoring**: Giám sát thời gian thực
- **Encrypted Communications**: Truyền thông mã hóa
- **Access Controls**: Kiểm soát truy cập nghiêm ngặt
- **Audit Trails**: Dấu vết kiểm toán đầy đủ

### 💡 **Công nghệ khuyến nghị (đã cập nhật):**
    - 🔗 **Blockchain Infrastructure (tùy chọn theo use-case)**
        - Hyperledger Besu/Fabric cho mạng permissioned, tokenization, notarization
        - Lưu audit trail tamper-evident: Sigstore/Rekor, append-only store
    - ⚙️ **Backend Technologies**
        - Ngôn ngữ: Rust/C++ (matching engine & feed handler), Java/Kotlin (Spring Boot/Quarkus), Go (Gin/Fiber), .NET (ASP.NET Core) khi phù hợp
        - RPC & API: gRPC (binary, HTTP/2), REST (OpenAPI), GraphQL cho truy vấn phức tạp
        - Hiệu năng thấp trễ: LMAX Disruptor, Aeron, Chronicle Queue, Agrona
        - Hợp đồng: Protobuf/Avro + Schema Registry (Confluent/Apicurio)
    - 🎨 **Frontend Technologies**
        - Web: React + Next.js 14+, TypeScript, TailwindCSS, Radix UI, TanStack Query
        - Desktop: Tauri/Electron cho terminal giao dịch chuyên nghiệp
        - Realtime: WebSocket/gRPC-web, Web Workers cho tính toán cục bộ
    - 🗄️ **Database Systems**
        - OLTP: PostgreSQL 16 (Patroni, Citus), CockroachDB (NewSQL, multi-region)
        - Time-series: TimescaleDB, QuestDB
        - OLAP/Analytics: ClickHouse; Warehouse/Lakehouse: BigQuery/Snowflake, Delta/Iceberg
        - Search: OpenSearch/Elasticsearch
        - NoSQL: Cassandra/ScyllaDB; KV: FoundationDB
        - Cache: Redis (Cluster/Sentinel), Redis Streams khi phù hợp
    - 📬 **Message Queue & Streaming**
        - Kafka/Redpanda, NATS JetStream, Apache Pulsar
        - CDC & Outbox: Debezium + Outbox/Inbox pattern
        - Schema management: Confluent SR/Apicurio; chuẩn Avro/Protobuf/JSON Schema
    - 📊 **Monitoring & Observability**
        - OpenTelemetry (traces/metrics/logs), Prometheus, Grafana, Alertmanager
        - Tracing: Jaeger/Tempo; Logging: Loki/OpenSearch
        - SLO/SLA, RED/USE metrics, eBPF (Cilium/Hubble) cho network observability
    - ⚡ **Caching Solutions**
        - Redis, Memcached, CDN (Cloudflare/Fastly); local cache: Caffeine/Guava
    - 📝 **Logging & Audit**
        - ELK/OpenSearch, Loki; log chuẩn hóa (OTel), audit immutable (append-only)
    - 🔐 **Security Technologies**
        - Identity: OIDC/OAuth2 (Keycloak/Auth0), RBAC/ABAC
        - mTLS, JWT/PS256, KMS/HSM (AWS KMS, GCP KMS, Azure Key Vault)
        - Secrets: HashiCorp Vault, External Secrets Operator
        - Policy as Code: OPA/Gatekeeper, Kyverno
        - DevSecOps: SAST/DAST/IAST, SCA, SBOM (Syft), scan (Trivy/Grype), Sigstore/Cosign, SLSA
        - Zero Trust, WAF, DDoS protection
    - 💾 **Storage Solutions**
        - Object: S3/GCS/MinIO; Block/File: Ceph/Longhorn; Tiered storage cho stream
    - 📲 **Notification Systems**
        - Webhook, WebPush, Email/SMS (SES/Twilio), in-app notifications
    - ⚖️ **High Availability & Load Balancing**
        - Envoy/NGINX/HAProxy, Kubernetes HPA/VPA, PodDisruptionBudgets, PDB
    - 🔄 **Failover & Disaster Recovery**
        - Multi-region active-active/active-passive; chaos engineering (Litmus)
        - Postgres Patroni, Raft/Quorum cho dịch vụ stateful
    - 💾 **Backup & Recovery**
        - PITR, WAL archiving, snapshot, Velero cho Kubernetes
    - 🤖 **AI/Machine Learning & Agent AI**
        - Feature store: Feast; Model serving: BentoML/Seldon; Stream inference: Flink ML
        - RAG/agent cho hỗ trợ vận hành, triage sự cố
    - 🏗️ **Infrastructure & DevOps**
        - Kubernetes, Helm/Kustomize, Argo CD/Flux (GitOps), Argo Workflows/Temporal cho batch/Orchestration
        - IaC: Terraform/Crossplane/Pulumi; Platform Engineering & IDP
        - CI/CD: GitHub Actions/GitLab CI, Canary/Blue-Green (Argo Rollouts/Flagger)
    - ☁️ **Cloud Platforms**
        - AWS/GCP/Azure; Managed Kafka (MSK/Confluent Cloud), Managed DB (Aurora/Cloud SQL)
    - 📦 **Package Management & Dependencies**
        - Java (Gradle/Maven), Go (Go modules), Rust (Cargo), JS (pnpm)
        - Dependency update: Renovate/Dependabot, SBOM & license policy
    - 🔧 **Development Tools**
        - `buf` cho protobuf, OpenAPI Generator, Taskfile/Makefile, pre-commit
        - Testing: property-based (jqwik/QuickCheck/Hypothesis), k6/Locust, Gatling
    - 🌐 **Networking & CDN**
        - HTTP/3 (QUIC), gRPC, Service Mesh (Istio/Linkerd), CNI Cilium (eBPF), CDN Cloudflare/Fastly

### 🏎️ **Low-latency & HFT kỹ thuật then chốt**
- Clock sync: PTP/NTP với hardware timestamping, GPS grandmaster
- Network: Kernel bypass (DPDK), RDMA/InfiniBand, busy-poll, io_uring
- CPU & Memory: CPU pinning, NUMA-aware allocation, off-heap, lock-free
- Serialization: FIX Binary, SBE, FlatBuffers/Cap'n Proto
- GC & Runtime: ZGC/Shenandoah, AOT/JIT tuning; Rust/C++ tránh GC cho hot-path
- Persistence: Commit log tuần tự, fsync chiến lược, batching & coalescing

---

## 📁 **CẤU TRÚC PROJECT (ENTERPRISE ARCHITECTURE)**

### 🏗️ **GitHub Repository Structure:**
Project theo DDD + Microservices, ưu tiên hợp đồng (proto/schema) và hạ tầng có thể lặp lại.

```
repo/
  plan/
  docs/
  proto/                  # gRPC protobuf, versioned với buf
  schemas/                # Avro/JSON Schema cho events
  apps/
    matching-engine/      # Rust/C++/Java, SBE/FIX, Disruptor/Aeron
    market-data-gateway/  # Feed handler, multicast/ITCH/FAST, fanout
    order-gateway/        # FIX/OUCH/REST vào hệ thống
    risk-engine/          # Pre-trade risk, limits, credit check
    clearing/             # Trade capture, novation, netting
    settlement-service/   # DVP, cash/securities legs
    custody-service/      # CSD/Custody ops
    compliance-service/   # KYC/AML/Surveillance hooks
    surveillance-service/ # Market surveillance real-time + batch
    member-service/       # Quản lý thành viên/quyền truy cập
    api-gateway/          # Envoy/Kong, authn/z, rate-limit
    admin-ui/             # Backoffice UI (Next.js)
    trader-ui/            # Trading UI (Next.js/Tauri)
    reporting-service/    # BI/Reports, ClickHouse/OLAP
    data-pipeline/        # Flink/Kafka Streams, CDC, materialized views
  packages/
    shared-domain/        # DTO, domain events, value objects
    shared-utils/         # Thư viện chung
    clients/              # SDK (Java/Go/TS)
  platform/
    terraform/            # IaC cloud
    kubernetes/           # Helm/Kustomize manifests
    argo/                 # Argo CD/Rollouts/Workflows
    observability/        # OTEL collector, Grafana, Prometheus, Loki
    security/             # OPA policies, External Secrets
  ops/
    runbooks/             # SOP, playbooks, incident response
    sre/                  # SLOs, alerts
  scripts/
  .github/                # CI/CD pipelines, security scans
```

Nguyên tắc:
- API/Schema trước, code sinh từ hợp đồng; backward compatibility kiểm tra tự động.
- Mỗi dịch vụ độc lập build/deploy, shared libs tối thiểu; giao tiếp qua gRPC/Kafka.
- Observability bắt buộc (traces/metrics/logs); bảo mật mTLS và OIDC bắt buộc.