### trading-oms

Trách nhiệm
- Order API (REST/gRPC), validate, enrich, route, lifecycle (new/amend/cancel)
- Pre-trade checks mỏng (delegates sang Risk cho policy)

API (draft)
- POST /orders, PATCH /orders/{id}, GET /orders/{id}
- Streams: order-updates, execution-reports

Dữ liệu sở hữu
- Orders, OrderStatus, RoutingRules (PostgreSQL)

Sự kiện phát hành
- OrderPlaced, OrderAmended, OrderCancelled, OrderRouted


