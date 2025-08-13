### settlement-service

Trách nhiệm
- DvP/PvP, tạo và theo dõi SettlementInstruction, reconciliation với CSD/RTGS/SWIFT

Giao tiếp
- Consumes: NettingCompleted, TradeAffirmed
- Publishes: SettlementInstructionCreated, SettlementCompleted

Dữ liệu sở hữu
- SettlementInstructions, CashMovements, SecuritiesMovements (PostgreSQL)


