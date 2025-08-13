# Analytics BFF (Backend-for-Frontend)

## Overview
Backend-for-Frontend service cho analytics và reporting interface, tối ưu hóa data aggregation cho analytics UI.

## Responsibilities
- Aggregates analytics data từ multiple services
- Optimizes queries cho analytics dashboards
- Handles analytics-specific data permissions
- Provides pre-computed analytics views
- Manages analytics session state

## APIs
- Portfolio analytics aggregation
- Performance attribution
- Risk analytics
- Market analytics
- Custom report generation

## Dependencies
- portfolio-analytics
- performance-analytics
- risk-service
- market-data
- data-platform
- iam-security

## Technology Stack
- Node.js/TypeScript hoặc Python
- GraphQL Federation
- Data caching strategies
- Batch processing integration
- gRPC cho service communication
