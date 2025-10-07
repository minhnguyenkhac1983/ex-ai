# Solvency II Compliance Service

## 🎯 Overview
This service implements Solvency II requirements for insurance companies operating in the EU.

## 📊 Key Components

### 1. Pillar 1 - Quantitative Requirements
- Solvency Capital Requirement (SCR) calculation
- Minimum Capital Requirement (MCR) calculation
- Own funds calculation and classification
- Standard formula implementation

### 2. Pillar 2 - Qualitative Requirements
- Own Risk and Solvency Assessment (ORSA)
- Governance framework implementation
- Risk management system
- Internal controls framework

### 3. Pillar 3 - Disclosure Requirements
- Public disclosure (SFCR) generation
- Regulatory reporting (QRT) preparation
- Supervisory reporting automation

## 🔧 Technical Implementation

### Database Schema
```sql
-- Solvency II Own Funds
CREATE TABLE solvency2_own_funds (
    id UUID PRIMARY KEY,
    reporting_date DATE NOT NULL,
    basic_own_funds DECIMAL(15,2) NOT NULL,
    ancillary_own_funds DECIMAL(15,2) DEFAULT 0,
    total_own_funds DECIMAL(15,2) NOT NULL,
    tier_1_capital DECIMAL(15,2) NOT NULL,
    tier_2_capital DECIMAL(15,2) DEFAULT 0,
    tier_3_capital DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SCR Calculations
CREATE TABLE solvency2_scr_calculations (
    id UUID PRIMARY KEY,
    reporting_date DATE NOT NULL,
    market_risk_scr DECIMAL(15,2) NOT NULL,
    credit_risk_scr DECIMAL(15,2) NOT NULL,
    life_underwriting_scr DECIMAL(15,2) NOT NULL,
    health_underwriting_scr DECIMAL(15,2) NOT NULL,
    operational_risk_scr DECIMAL(15,2) NOT NULL,
    total_scr DECIMAL(15,2) NOT NULL,
    diversification_benefit DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### API Endpoints
- `POST /solvency2/scr/calculate` - Calculate SCR
- `POST /solvency2/mcr/calculate` - Calculate MCR
- `POST /solvency2/orsa/assess` - Perform ORSA assessment
- `GET /solvency2/reports/sfcr` - Generate SFCR
- `GET /solvency2/reports/qrt` - Generate QRT reports
