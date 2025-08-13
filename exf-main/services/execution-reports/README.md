### execution-reports

Trách nhiệm
- Thu thập và phân phối Execution Report/Drop Copy cho thành viên
- Chuẩn hoá báo cáo fills/trades theo chuẩn FIX/REST/WebSocket

Giao tiếp
- Consumes: execution-reports.v1, trades.v1 (Kafka)
- Publishes: drop-copy streams theo member/kênh

Dữ liệu sở hữu
- ExecutionReports, DropCopySessions (PostgreSQL/TSDB cho audit)


