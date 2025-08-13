### Luồng nghiệp vụ: Order → Trade → Clearing → Settlement

Các bước chính
- OMS nhận lệnh, check pre-trade qua Risk, phát OrderPlaced
- Matching Engine khớp, phát ExecutionReport và TradeCreated
- Clearing thực hiện affirmation/novation/netting, phát SettlementInstructionCreated
- Settlement điều phối DvP/PvP, gọi Payments/Treasury, phản hồi SettlementCompleted

Xem sequence diagram (Mermaid) đã nhúng trong cuộc trò chuyện để trực quan.


