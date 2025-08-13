# Wallet Service

Theo dõi số dư, chuyển khoản nội bộ, nạp/rút. On-chain qua adapter (HSM/KMS ký), off-chain nội bộ.

Khuyến nghị:
- Sổ cái kép (double-entry), bất biến; event sourcing tùy chọn để audit
- Outbox + CDC cho sự kiện số dư, idempotency cho giao dịch


