### risk-service

Trách nhiệm
- Limits (position/order/credit), exposure, margin calc
- Real-time risk metrics; cảnh báo LimitBreached

Giao tiếp
- Consumes: orders, trades, market-data
- Publishes: LimitBreached, PositionUpdated, MarginCallIssued

Dữ liệu sở hữu
- Limits, Exposures, Positions, MarginAccounts (PostgreSQL)


