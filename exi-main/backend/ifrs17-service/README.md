# IFRS17 Measurement Service

## 🎯 Overview
This service implements the three IFRS17 measurement models for insurance contracts:
- **General Model (GM)**: For most insurance contracts
- **Premium Allocation Approach (PAA)**: For contracts with coverage period ≤ 1 year
- **Variable Fee Approach (VFA)**: For contracts with direct participation features

## 📊 Key Components

### 1. Contractual Service Margin (CSM) Engine
- Initial CSM calculation at contract inception
- CSM release over coverage period
- CSM adjustments for changes in estimates
- CSM amortization patterns

### 2. Risk Adjustment Engine
- Non-financial risk adjustment calculation
- Confidence level methodology
- Risk adjustment release patterns
- Sensitivity analysis

### 3. Discount Rate Management
- Risk-free rate curves
- Contract-specific discount rates
- Market-consistent valuation
- Yield curve construction

### 4. Liability Calculation
- Liability for Remaining Coverage (LRC)
- Liability for Incurred Claims (LIC)
- Present value of future cash flows
- Market value margins

## 🔧 Technical Implementation

### Database Schema
```sql
-- IFRS17 Contract Groups
CREATE TABLE ifrs17_contract_groups (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    measurement_model VARCHAR(50) NOT NULL, -- GM, PAA, VFA
    portfolio_segment VARCHAR(100),
    coverage_period_months INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CSM Tracking
CREATE TABLE ifrs17_csm_balances (
    id UUID PRIMARY KEY,
    contract_group_id UUID REFERENCES ifrs17_contract_groups(id),
    reporting_date DATE NOT NULL,
    opening_csm DECIMAL(15,2),
    csm_release DECIMAL(15,2),
    csm_adjustments DECIMAL(15,2),
    closing_csm DECIMAL(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### API Endpoints
- `POST /ifrs17/measurement/calculate` - Calculate IFRS17 measurements
- `GET /ifrs17/measurement/{contractGroupId}` - Get measurement results
- `POST /ifrs17/csm/update` - Update CSM balances
- `GET /ifrs17/reports/balance-sheet` - Generate balance sheet data
