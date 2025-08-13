### Context Map (quan hệ giữa các bounded contexts)

- Trading — upstream events → Market Data (published), Risk (consumed), Clearing (consumed)
- Market Data — upstream for Trading (reference), Risk, Portfolio
- Risk — policy enforcer (pre/post-trade), publishes LimitBreached → Trading throttles
- Clearing & Settlement — consumes TradeCreated, orchestrates with Payments
- Compliance — side-effect consumer (surveillance), reporting anti-corruption layer với Regulators
- Connectivity — anti-corruption layer cho FIX/Native/REST bên ngoài vào Trading
- Member & Billing — conforms contract với Trading (entitlements) và Connectivity (sessions)
- Reference Data — published language, mọi context tiêu thụ qua versioned events/Read API
- IAM & Security — shared kernel (token, identity claims), mỗi context áp dụng policy cục bộ
- Data Platform — separate flow (CDC/outbox), không coupling transaction; data mesh contracts cho downstream BI/AI

Mẫu tích hợp
- Event choreography đầu tiên, Saga/Process Manager cho quy trình dài (clearing/settlement)
- Anti-Corruption Layer tại các biên FIX, Regulator, SWIFT, Market Data Vendors
- Outbox + CDC để đảm bảo delivery chính xác


