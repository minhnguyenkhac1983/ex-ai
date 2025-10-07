# IFRS 9 Financial Instruments Service

## 🎯 Overview
This service implements IFRS 9 requirements for financial instruments classification, measurement, and impairment.

## 📊 Key Components

### 1. Classification and Measurement Engine
- Amortized cost classification
- Fair value through profit or loss (FVTPL)
- Fair value through other comprehensive income (FVOCI)
- Reclassification rules and triggers

### 2. Expected Credit Loss (ECL) Model
- 12-month expected credit losses
- Lifetime expected credit losses
- Stage 1, 2, 3 classification
- ECL calculation algorithms

### 3. Hedge Accounting Framework
- Fair value hedge accounting
- Cash flow hedge accounting
- Net investment hedge accounting
- Hedge effectiveness testing

## 🔧 Technical Implementation

### Database Schema
```sql
-- IFRS 9 Financial Instruments
CREATE TABLE ifrs9_financial_instruments (
    id UUID PRIMARY KEY,
    instrument_id VARCHAR(100) NOT NULL,
    classification VARCHAR(50) NOT NULL, -- AC, FVTPL, FVOCI
    measurement_basis VARCHAR(50) NOT NULL,
    initial_measurement_date DATE NOT NULL,
    amortized_cost DECIMAL(15,2),
    fair_value DECIMAL(15,2),
    carrying_amount DECIMAL(15,2),
    effective_interest_rate DECIMAL(8,6),
    maturity_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ECL Calculations
CREATE TABLE ifrs9_ecl_calculations (
    id UUID PRIMARY KEY,
    instrument_id UUID REFERENCES ifrs9_financial_instruments(id),
    reporting_date DATE NOT NULL,
    stage INTEGER NOT NULL CHECK (stage IN (1, 2, 3)),
    ecl_amount DECIMAL(15,2) NOT NULL,
    probability_of_default DECIMAL(8,6),
    loss_given_default DECIMAL(8,6),
    exposure_at_default DECIMAL(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### API Endpoints
- `POST /ifrs9/classification/classify` - Classify financial instruments
- `POST /ifrs9/measurement/calculate` - Calculate measurements
- `POST /ifrs9/ecl/calculate` - Calculate ECL
- `GET /ifrs9/reports/balance-sheet` - Generate balance sheet data
