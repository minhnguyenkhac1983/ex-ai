### Domain Events (mẫu tên và schema khung)

- Trading
  - OrderPlaced {orderId, memberId, instrumentId, side, qty, tif, ts}
  - OrderMatched {matchId, buyOrderId, sellOrderId, price, qty, ts}
  - TradeCreated {tradeId, instrumentId, price, qty, buyMemberId, sellMemberId, ts}

- Risk
  - LimitBreached {memberId, limitType, value, threshold, ts}
  - PositionUpdated {memberId, instrumentId, netQty, pnl, ts}

- Clearing
  - TradeAffirmed {tradeId, ccpId, ts}
  - SettlementInstructionCreated {instructionId, legs[], ts}
  - SettlementCompleted {instructionId, status, ts}

Nguyên tắc
- Bất biến, hướng domain, có version, idempotent key
- Hợp đồng hóa qua Avro/JSON Schema; phát qua Kafka topics per-domain
- Outbox pattern tại nguồn ghi; consumer dùng exactly-once semantics nơi cần


