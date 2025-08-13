# Trading BFF (Backend-for-Frontend)

## Overview
Backend-for-Frontend service cho trading interface, tối ưu hóa API calls và data aggregation cho trading UI.

## Responsibilities
- Aggregates data từ multiple trading services
- Optimizes API calls cho trading UI
- Handles trading-specific authentication và authorization
- Provides real-time trading data streams
- Manages trading session state

## APIs
- Order management aggregation
- Portfolio overview
- Market data streams
- Trading analytics
- Risk metrics

## Dependencies
- trading-oms
- market-data
- portfolio-analytics
- risk-service
- iam-security

## Technology Stack
- Node.js/TypeScript hoặc Go
- GraphQL Federation
- WebSocket cho real-time data
- Redis cho caching
- gRPC cho service communication
