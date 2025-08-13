# Runbook: Market Data

- Check health: GET http://market-data-service:8080/health
- WebSocket: ws://market-data-service:8080/ws
- If down: restart container, check logs, verify Redpanda/Kafka if integrated later.

