# GraphQL Contracts

## Overview
GraphQL schemas và federation configuration cho BFF services và client applications.

## Structure
```
graphql/
├── schemas/              # GraphQL schema definitions
│   ├── trading.graphql   # Trading domain schema
│   ├── analytics.graphql # Analytics domain schema
│   └── common.graphql    # Common types
├── federation/           # Federation configuration
│   ├── gateway.yaml      # Apollo Federation Gateway config
│   └── services/         # Service-specific federation configs
└── queries/              # Common query definitions
    ├── trading.queries   # Trading queries
    └── analytics.queries # Analytics queries
```

## Schema Design Principles
- Domain-driven schema organization
- Federation-ready type definitions
- Optimized cho BFF requirements
- Real-time subscriptions support
- Caching-friendly query patterns

## Federation Strategy
- Trading BFF: Aggregates trading domain services
- Analytics BFF: Aggregates analytics domain services
- Gateway: Routes và composes federated queries
- Service mesh integration cho performance

## Development Workflow
- Schema-first development
- Contract testing với GraphQL
- Federation composition testing
- Performance optimization


