# IFRS 15 Revenue from Contracts with Customers Service

## 🎯 Overview
This service implements IFRS 15 requirements for revenue recognition using the five-step model.

## 📊 Key Components

### 1. Five-Step Model Implementation
- Step 1: Identify the contract with a customer
- Step 2: Identify performance obligations in the contract
- Step 3: Determine the transaction price
- Step 4: Allocate transaction price to performance obligations
- Step 5: Recognize revenue when performance obligation is satisfied

### 2. Revenue Recognition Engine
- Point in time recognition
- Over time recognition
- Variable consideration handling
- Contract modifications processing

### 3. Contract Management
- Contract identification and validation
- Performance obligation tracking
- Contract modifications handling
- Revenue allocation algorithms

## 🔧 Technical Implementation

### Database Schema
```sql
-- IFRS 15 Revenue Contracts
CREATE TABLE ifrs15_revenue_contracts (
    id UUID PRIMARY KEY,
    contract_id VARCHAR(100) NOT NULL,
    customer_id VARCHAR(100) NOT NULL,
    contract_start_date DATE NOT NULL,
    contract_end_date DATE,
    transaction_price DECIMAL(15,2) NOT NULL,
    allocated_transaction_price DECIMAL(15,2) NOT NULL,
    contract_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance Obligations
CREATE TABLE ifrs15_performance_obligations (
    id UUID PRIMARY KEY,
    contract_id UUID REFERENCES ifrs15_revenue_contracts(id),
    obligation_id VARCHAR(100) NOT NULL,
    obligation_description TEXT,
    allocated_price DECIMAL(15,2) NOT NULL,
    satisfaction_type VARCHAR(50) NOT NULL, -- point_in_time, over_time
    satisfaction_date DATE,
    revenue_recognized DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### API Endpoints
- `POST /ifrs15/contracts/identify` - Identify revenue contracts
- `POST /ifrs15/obligations/identify` - Identify performance obligations
- `POST /ifrs15/price/allocate` - Allocate transaction price
- `POST /ifrs15/revenue/recognize` - Recognize revenue
- `GET /ifrs15/reports/revenue` - Generate revenue reports
