-- =====================================================
-- EXC DATABASE SCHEMA V2 (Modular, Namespaced, Single File)
-- Design goals: Multi-tenant, secure, auditable, scalable, microservice-aligned
-- =====================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- SCHEMAS (namespaces)
-- =====================================================
CREATE SCHEMA IF NOT EXISTS shared;
CREATE SCHEMA IF NOT EXISTS tenant;
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS kyc;
CREATE SCHEMA IF NOT EXISTS accounts;
CREATE SCHEMA IF NOT EXISTS wallet;
CREATE SCHEMA IF NOT EXISTS trading;
CREATE SCHEMA IF NOT EXISTS market_data;
CREATE SCHEMA IF NOT EXISTS payments;
CREATE SCHEMA IF NOT EXISTS fees;
CREATE SCHEMA IF NOT EXISTS risk;
CREATE SCHEMA IF NOT EXISTS notifications;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS admin;
CREATE SCHEMA IF NOT EXISTS settlement;
CREATE SCHEMA IF NOT EXISTS algo;
CREATE SCHEMA IF NOT EXISTS institutional;
CREATE SCHEMA IF NOT EXISTS reporting;
CREATE SCHEMA IF NOT EXISTS blockchain;
CREATE SCHEMA IF NOT EXISTS custody;
CREATE SCHEMA IF NOT EXISTS liquidity;
CREATE SCHEMA IF NOT EXISTS margin;
CREATE SCHEMA IF NOT EXISTS social;
CREATE SCHEMA IF NOT EXISTS defi;
CREATE SCHEMA IF NOT EXISTS nft;
CREATE SCHEMA IF NOT EXISTS monitoring;
CREATE SCHEMA IF NOT EXISTS integrations;
CREATE SCHEMA IF NOT EXISTS accounting;
CREATE SCHEMA IF NOT EXISTS compliance;
CREATE SCHEMA IF NOT EXISTS ops;
CREATE SCHEMA IF NOT EXISTS api;

-- Optional default search path for interactive sessions
-- SET search_path = shared, public, auth, trading;

-- =====================================================
-- SHARED: types, utilities, triggers
-- =====================================================
CREATE OR REPLACE FUNCTION shared.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

-- =====================================================
-- TENANT (multi-tenant orgs; optional for B2B/institutional)
-- =====================================================
CREATE TABLE IF NOT EXISTS tenant.organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(150) UNIQUE NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tenant.members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES tenant.organizations(id) ON DELETE CASCADE,
  user_id UUID, -- references auth.users after creation
  role VARCHAR(50) DEFAULT 'member',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- AUTH & USERS
-- =====================================================
CREATE TABLE IF NOT EXISTS auth.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES tenant.organizations(id),
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  salt VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  country_code VARCHAR(3),
  date_of_birth DATE,
  gender VARCHAR(10),
  profile_image_url TEXT,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  is_locked BOOLEAN DEFAULT false,
  last_login_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS auth.roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES tenant.organizations(id),
  name VARCHAR(50) NOT NULL,
  description TEXT,
  permissions JSONB,
  UNIQUE(organization_id, name),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS auth.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role_id UUID REFERENCES auth.roles(id) ON DELETE CASCADE,
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  assigned_by UUID REFERENCES auth.users(id),
  UNIQUE(user_id, role_id)
);

CREATE TABLE IF NOT EXISTS auth.api_keys (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  api_key VARCHAR(255) UNIQUE NOT NULL,
  secret_key_hash VARCHAR(255) NOT NULL,
  permissions JSONB NOT NULL,
  ip_whitelist TEXT[],
  is_active BOOLEAN DEFAULT true,
  last_used_at TIMESTAMP,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS auth.two_factor_auth (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  secret_key VARCHAR(255) NOT NULL,
  backup_codes TEXT[],
  is_enabled BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- KYC & COMPLIANCE (identity; AML controls in compliance.*)
-- =====================================================
CREATE TABLE IF NOT EXISTS kyc.levels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES tenant.organizations(id),
  name VARCHAR(50) NOT NULL,
  daily_limit DECIMAL(20,8),
  monthly_limit DECIMAL(20,8),
  withdrawal_limit DECIMAL(20,8),
  requirements JSONB,
  UNIQUE(organization_id, name),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS kyc.user_kyc (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  level_id UUID REFERENCES kyc.levels(id),
  status VARCHAR(20) DEFAULT 'pending',
  verification_data JSONB,
  documents JSONB,
  verified_at TIMESTAMP,
  verified_by UUID REFERENCES auth.users(id),
  rejection_reason TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS kyc.identity_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  document_type VARCHAR(50) NOT NULL,
  document_number VARCHAR(100),
  issuing_country VARCHAR(3),
  expiry_date DATE,
  document_front_url TEXT,
  document_back_url TEXT,
  selfie_url TEXT,
  verification_status VARCHAR(20) DEFAULT 'pending',
  verified_at TIMESTAMP,
  verified_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Compliance add-ons (AML/CTF)
CREATE TABLE IF NOT EXISTS compliance.aml_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  flag_type VARCHAR(50) NOT NULL,
  details JSONB,
  status VARCHAR(20) DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS compliance.sanctions_screenings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  provider VARCHAR(50),
  result VARCHAR(20),
  raw_response JSONB,
  screened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS compliance.sar_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  case_reference VARCHAR(100),
  summary TEXT,
  status VARCHAR(20) DEFAULT 'draft',
  submitted_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ASSETS & ACCOUNTS
-- =====================================================
CREATE TABLE IF NOT EXISTS accounts.account_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES tenant.organizations(id),
  name VARCHAR(50) NOT NULL,
  description TEXT,
  features JSONB,
  UNIQUE(organization_id, name),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounts.user_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  account_type_id UUID REFERENCES accounts.account_types(id),
  account_number VARCHAR(50) UNIQUE NOT NULL,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sub-accounts (parent → child account linking)
CREATE TABLE IF NOT EXISTS accounts.sub_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  sub_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  label VARCHAR(100),
  permissions JSONB,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(parent_user_id, sub_user_id)
);

-- =====================================================
-- WALLET (crypto & fiat)
-- =====================================================
CREATE TABLE IF NOT EXISTS wallet.cryptocurrencies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol VARCHAR(10) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  network VARCHAR(50),
  contract_address VARCHAR(255),
  decimals INTEGER DEFAULT 8,
  is_active BOOLEAN DEFAULT true,
  is_deposit_enabled BOOLEAN DEFAULT true,
  is_withdrawal_enabled BOOLEAN DEFAULT true,
  min_deposit DECIMAL(20,8),
  min_withdrawal DECIMAL(20,8),
  withdrawal_fee DECIMAL(20,8),
  confirmation_blocks INTEGER DEFAULT 1,
  icon_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS wallet.user_wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  address VARCHAR(255),
  balance DECIMAL(20,8) DEFAULT 0,
  locked_balance DECIMAL(20,8) DEFAULT 0,
  total_deposited DECIMAL(20,8) DEFAULT 0,
  total_withdrawn DECIMAL(20,8) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, cryptocurrency_id)
);

CREATE TABLE IF NOT EXISTS wallet.fiat_currencies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(3) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  symbol VARCHAR(5) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS wallet.fiat_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  fiat_currency_id UUID REFERENCES wallet.fiat_currencies(id),
  account_number VARCHAR(50),
  balance DECIMAL(20,2) DEFAULT 0,
  locked_balance DECIMAL(20,2) DEFAULT 0,
  total_deposited DECIMAL(20,2) DEFAULT 0,
  total_withdrawn DECIMAL(20,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, fiat_currency_id)
);

-- Custody & keys
CREATE TABLE IF NOT EXISTS custody.hot_wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  wallet_address VARCHAR(255) NOT NULL,
  private_key_encrypted TEXT,
  balance DECIMAL(20,8) DEFAULT 0,
  max_balance DECIMAL(20,8),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS custody.cold_wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  wallet_address VARCHAR(255) NOT NULL,
  wallet_type VARCHAR(50) NOT NULL,
  balance DECIMAL(20,8) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS custody.multi_sig_wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  wallet_address VARCHAR(255) NOT NULL,
  required_signatures INTEGER NOT NULL,
  total_signers INTEGER NOT NULL,
  signer_addresses TEXT[],
  balance DECIMAL(20,8) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional HSM/Key mgmt registry
CREATE TABLE IF NOT EXISTS custody.key_material (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key_alias VARCHAR(100) UNIQUE NOT NULL,
  hsm_locator TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TRADING
-- =====================================================
CREATE TABLE IF NOT EXISTS trading.trading_pairs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  base_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  quote_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  symbol VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  is_trading_enabled BOOLEAN DEFAULT true,
  min_order_size DECIMAL(20,8),
  max_order_size DECIMAL(20,8),
  price_precision INTEGER DEFAULT 8,
  quantity_precision INTEGER DEFAULT 8,
  maker_fee DECIMAL(10,8) DEFAULT 0.001,
  taker_fee DECIMAL(10,8) DEFAULT 0.001,
  min_notional DECIMAL(20,8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(base_currency_id, quote_currency_id)
);

CREATE TABLE IF NOT EXISTS trading.order_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  parameters JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS trading.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  order_type_id UUID REFERENCES trading.order_types(id),
  side VARCHAR(4) NOT NULL,
  price DECIMAL(20,8),
  quantity DECIMAL(20,8) NOT NULL,
  filled_quantity DECIMAL(20,8) DEFAULT 0,
  remaining_quantity DECIMAL(20,8) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  time_in_force VARCHAR(10) DEFAULT 'GTC',
  stop_price DECIMAL(20,8),
  trigger_price DECIMAL(20,8),
  client_order_id VARCHAR(100),
  api_key_id UUID REFERENCES auth.api_keys(id),
  ip_address INET,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  filled_at TIMESTAMP,
  cancelled_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS trading.trades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES trading.orders(id),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  maker_order_id UUID REFERENCES trading.orders(id),
  taker_order_id UUID REFERENCES trading.orders(id),
  maker_user_id UUID REFERENCES auth.users(id),
  taker_user_id UUID REFERENCES auth.users(id),
  price DECIMAL(20,8) NOT NULL,
  quantity DECIMAL(20,8) NOT NULL,
  quote_quantity DECIMAL(20,8) NOT NULL,
  maker_fee DECIMAL(20,8) DEFAULT 0,
  taker_fee DECIMAL(20,8) DEFAULT 0,
  fee_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS trading.order_book_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  bids JSONB NOT NULL,
  asks JSONB NOT NULL,
  last_price DECIMAL(20,8),
  volume_24h DECIMAL(20,8),
  high_24h DECIMAL(20,8),
  low_24h DECIMAL(20,8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- DEPOSITS & WITHDRAWALS (crypto + fiat)
-- =====================================================
CREATE TABLE IF NOT EXISTS wallet.deposits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  transaction_hash VARCHAR(255),
  address VARCHAR(255),
  amount DECIMAL(20,8) NOT NULL,
  fee DECIMAL(20,8) DEFAULT 0,
  net_amount DECIMAL(20,8) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  confirmations INTEGER DEFAULT 0,
  required_confirmations INTEGER DEFAULT 1,
  block_height BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  confirmed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS wallet.withdrawals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  transaction_hash VARCHAR(255),
  address VARCHAR(255) NOT NULL,
  amount DECIMAL(20,8) NOT NULL,
  fee DECIMAL(20,8) NOT NULL,
  net_amount DECIMAL(20,8) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  confirmations INTEGER DEFAULT 0,
  required_confirmations INTEGER DEFAULT 1,
  block_height BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  processed_at TIMESTAMP,
  completed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payments.payment_methods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  type VARCHAR(50) NOT NULL,
  provider VARCHAR(100),
  is_active BOOLEAN DEFAULT true,
  supported_currencies TEXT[],
  fees JSONB,
  limits JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payments.payment_gateways (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  provider VARCHAR(100) NOT NULL,
  api_key VARCHAR(255),
  secret_key VARCHAR(255),
  webhook_url TEXT,
  is_active BOOLEAN DEFAULT true,
  supported_methods TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payments.fiat_deposits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  fiat_currency_id UUID REFERENCES wallet.fiat_currencies(id),
  payment_method_id UUID REFERENCES payments.payment_methods(id),
  amount DECIMAL(20,2) NOT NULL,
  fee DECIMAL(20,2) DEFAULT 0,
  net_amount DECIMAL(20,2) NOT NULL,
  reference_number VARCHAR(100),
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payments.fiat_withdrawals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  fiat_currency_id UUID REFERENCES wallet.fiat_currencies(id),
  payment_method_id UUID REFERENCES payments.payment_methods(id),
  amount DECIMAL(20,2) NOT NULL,
  fee DECIMAL(20,2) NOT NULL,
  net_amount DECIMAL(20,2) NOT NULL,
  bank_account_details JSONB,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP
);

-- Payment reconciliation & failures
CREATE TABLE IF NOT EXISTS payments.reconciliations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source VARCHAR(50) NOT NULL, -- bank, processor
  reference VARCHAR(150) NOT NULL,
  amount DECIMAL(20,2) NOT NULL,
  currency_code VARCHAR(10) NOT NULL,
  status VARCHAR(20) DEFAULT 'unmatched', -- unmatched, matched, error
  matched_at TIMESTAMP,
  data JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- FEES
-- =====================================================
CREATE TABLE IF NOT EXISTS fees.tiers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  min_volume_30d DECIMAL(20,8),
  maker_fee DECIMAL(10,8),
  taker_fee DECIMAL(10,8),
  withdrawal_fee_multiplier DECIMAL(5,2) DEFAULT 1.0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(name)
);

CREATE TABLE IF NOT EXISTS fees.user_tiers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  tier_id UUID REFERENCES fees.tiers(id),
  volume_30d DECIMAL(20,8) DEFAULT 0,
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fees.transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  trade_id UUID REFERENCES trading.trades(id),
  order_id UUID REFERENCES trading.orders(id),
  fee_type VARCHAR(50) NOT NULL,
  fee_amount DECIMAL(20,8) NOT NULL,
  fee_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Market maker rebates / special rates
CREATE TABLE IF NOT EXISTS fees.rebates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  rebate_type VARCHAR(50) NOT NULL, -- maker_rebate, vip_rate
  amount DECIMAL(20,8) NOT NULL,
  currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  period VARCHAR(20), -- daily, monthly
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- RISK & MARGIN
-- =====================================================
CREATE TABLE IF NOT EXISTS risk.limits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  max_position_size DECIMAL(20,8),
  max_daily_loss DECIMAL(20,8),
  max_order_size DECIMAL(20,8),
  leverage_limit DECIMAL(5,2),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS risk.alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  alert_type VARCHAR(50) NOT NULL,
  message TEXT NOT NULL,
  severity VARCHAR(20) DEFAULT 'medium',
  is_resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP
);

-- Real-time exposures aggregation (user or org level)
CREATE TABLE IF NOT EXISTS risk.exposures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  organization_id UUID REFERENCES tenant.organizations(id),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  exposure_value DECIMAL(20,8) NOT NULL,
  exposure_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Circuit breaker rules & events
CREATE TABLE IF NOT EXISTS risk.circuit_breakers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  rule_type VARCHAR(50) NOT NULL, -- price_drop_pct, volatility, volume_spike
  threshold DECIMAL(20,8) NOT NULL,
  status VARCHAR(20) DEFAULT 'enabled',
  triggered_at TIMESTAMP,
  reset_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS risk.circuit_breaker_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  circuit_breaker_id UUID REFERENCES risk.circuit_breakers(id) ON DELETE CASCADE,
  event_type VARCHAR(50) NOT NULL, -- trigger, reset
  details JSONB,
  occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS margin.accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  account_type VARCHAR(50) NOT NULL,
  leverage DECIMAL(5,2) NOT NULL,
  max_leverage DECIMAL(5,2) NOT NULL,
  margin_balance DECIMAL(20,8) DEFAULT 0,
  used_margin DECIMAL(20,8) DEFAULT 0,
  free_margin DECIMAL(20,8) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS margin.positions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  margin_account_id UUID REFERENCES margin.accounts(id) ON DELETE CASCADE,
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  side VARCHAR(4) NOT NULL,
  size DECIMAL(20,8) NOT NULL,
  entry_price DECIMAL(20,8) NOT NULL,
  current_price DECIMAL(20,8),
  unrealized_pnl DECIMAL(20,8) DEFAULT 0,
  realized_pnl DECIMAL(20,8) DEFAULT 0,
  liquidation_price DECIMAL(20,8),
  status VARCHAR(20) DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS margin.futures_contracts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol VARCHAR(20) UNIQUE NOT NULL,
  base_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  quote_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  contract_size DECIMAL(20,8) NOT NULL,
  tick_size DECIMAL(20,8) NOT NULL,
  min_order_size DECIMAL(20,8) NOT NULL,
  max_order_size DECIMAL(20,8) NOT NULL,
  expiry_date DATE,
  is_perpetual BOOLEAN DEFAULT false,
  funding_rate DECIMAL(10,8) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Liquidation records for leveraged positions
CREATE TABLE IF NOT EXISTS margin.liquidations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  position_id UUID REFERENCES margin.positions(id) ON DELETE CASCADE,
  triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reason VARCHAR(50), -- margin_call, breach_limit
  liquidation_price DECIMAL(20,8),
  amount_closed DECIMAL(20,8),
  pnl_realized DECIMAL(20,8),
  status VARCHAR(20) DEFAULT 'completed'
);

-- =====================================================
-- SOCIAL, DEFI, NFT
-- =====================================================
CREATE TABLE IF NOT EXISTS social.copy_trading_strategies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  strategy_name VARCHAR(100) NOT NULL,
  description TEXT,
  is_public BOOLEAN DEFAULT false,
  min_followers INTEGER DEFAULT 0,
  max_followers INTEGER,
  performance_fee DECIMAL(5,4) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  total_followers INTEGER DEFAULT 0,
  total_profit DECIMAL(20,8) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS social.copy_trading_followers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  strategy_id UUID REFERENCES social.copy_trading_strategies(id) ON DELETE CASCADE,
  follower_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  allocation_percentage DECIMAL(5,2) NOT NULL,
  max_allocation DECIMAL(20,8),
  is_active BOOLEAN DEFAULT true,
  total_profit DECIMAL(20,8) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(strategy_id, follower_id)
);

CREATE TABLE IF NOT EXISTS social.trading_signals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  signal_type VARCHAR(20) NOT NULL,
  price_target DECIMAL(20,8),
  stop_loss DECIMAL(20,8),
  take_profit DECIMAL(20,8),
  confidence_level INTEGER,
  reasoning TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS defi.staking_pools (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  pool_name VARCHAR(100) NOT NULL,
  apy DECIMAL(10,4),
  min_stake DECIMAL(20,8),
  max_stake DECIMAL(20,8),
  lock_period_days INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS defi.user_staking_positions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  staking_pool_id UUID REFERENCES defi.staking_pools(id) ON DELETE CASCADE,
  staked_amount DECIMAL(20,8) NOT NULL,
  rewards_earned DECIMAL(20,8) DEFAULT 0,
  lock_start_date TIMESTAMP,
  lock_end_date TIMESTAMP,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS defi.yield_farming_pools (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pool_name VARCHAR(100) NOT NULL,
  reward_token_id UUID REFERENCES wallet.cryptocurrencies(id),
  reward_rate DECIMAL(10,8),
  total_staked DECIMAL(20,8) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nft.collections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  blockchain_name VARCHAR(50) NOT NULL,
  contract_address VARCHAR(255),
  total_supply INTEGER,
  floor_price DECIMAL(20,8),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nft.items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collection_id UUID REFERENCES nft.collections(id) ON DELETE CASCADE,
  token_id VARCHAR(100) NOT NULL,
  name VARCHAR(100),
  description TEXT,
  image_url TEXT,
  metadata JSONB,
  owner_id UUID REFERENCES auth.users(id),
  current_price DECIMAL(20,8),
  is_listed BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nft.trades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_item_id UUID REFERENCES nft.items(id) ON DELETE CASCADE,
  seller_id UUID REFERENCES auth.users(id),
  buyer_id UUID REFERENCES auth.users(id),
  price DECIMAL(20,8) NOT NULL,
  currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  transaction_hash VARCHAR(255),
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- MARKET DATA & INTEGRATIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS integrations.external_api_integrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  provider_name VARCHAR(100) NOT NULL,
  api_type VARCHAR(50) NOT NULL,
  api_key VARCHAR(255),
  api_secret VARCHAR(255),
  base_url VARCHAR(255),
  rate_limit_per_minute INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS market_data.feeds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  provider_id UUID REFERENCES integrations.external_api_integrations(id),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  feed_type VARCHAR(50) NOT NULL,
  last_update TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Partitioned OHLCV (monthly range partitions)
CREATE TABLE IF NOT EXISTS market_data.price_history (
  id UUID DEFAULT gen_random_uuid(),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  open_price DECIMAL(20,8) NOT NULL,
  high_price DECIMAL(20,8) NOT NULL,
  low_price DECIMAL(20,8) NOT NULL,
  close_price DECIMAL(20,8) NOT NULL,
  volume DECIMAL(20,8) NOT NULL,
  quote_volume DECIMAL(20,8) NOT NULL,
  trade_count INTEGER DEFAULT 0,
  interval VARCHAR(10) NOT NULL,
  ts TIMESTAMP NOT NULL,
  PRIMARY KEY (id, ts)
) PARTITION BY RANGE (ts);

-- Template partition (create real ones per month via ops tooling)
-- Example: CREATE TABLE market_data.price_history_2025_01 PARTITION OF market_data.price_history
-- FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE IF NOT EXISTS market_data.statistics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  period VARCHAR(20) NOT NULL,
  price_change DECIMAL(20,8),
  price_change_percent DECIMAL(10,4),
  volume DECIMAL(20,8),
  high_price DECIMAL(20,8),
  low_price DECIMAL(20,8),
  ts TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional high-frequency ticks (partition suggested externally)
CREATE TABLE IF NOT EXISTS market_data.ticks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  price DECIMAL(20,8) NOT NULL,
  quantity DECIMAL(20,8) NOT NULL,
  side VARCHAR(4), -- buy/sell
  ts TIMESTAMP NOT NULL
);

-- =====================================================
-- NOTIFICATIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS notifications.templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  type VARCHAR(50) NOT NULL,
  subject VARCHAR(255),
  content TEXT NOT NULL,
  variables JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notifications.user_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  template_id UUID REFERENCES notifications.templates(id),
  type VARCHAR(50) NOT NULL,
  subject VARCHAR(255),
  content TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  is_sent BOOLEAN DEFAULT false,
  sent_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- AUDIT & ADMIN
-- =====================================================
CREATE TABLE IF NOT EXISTS audit.audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50),
  resource_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit.system_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  level VARCHAR(10) NOT NULL,
  service VARCHAR(50) NOT NULL,
  message TEXT NOT NULL,
  data JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin.system_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key VARCHAR(100) UNIQUE NOT NULL,
  value TEXT,
  description TEXT,
  category VARCHAR(50),
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin.maintenance_windows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  affected_services TEXT[],
  status VARCHAR(20) DEFAULT 'scheduled',
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- API governance
CREATE TABLE IF NOT EXISTS api.rate_limits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  api_key_id UUID REFERENCES auth.api_keys(id) ON DELETE CASCADE,
  endpoint VARCHAR(255) NOT NULL,
  period VARCHAR(20) NOT NULL, -- 1m, 1h, 1d
  max_requests INTEGER NOT NULL,
  used_count INTEGER DEFAULT 0,
  window_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SETTLEMENT & CLEARING
-- =====================================================
CREATE TABLE IF NOT EXISTS settlement.settlements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trade_id UUID REFERENCES trading.trades(id),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  trading_pair_id UUID REFERENCES trading.trading_pairs(id),
  settlement_type VARCHAR(50) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  settlement_amount DECIMAL(20,8) NOT NULL,
  settlement_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  settlement_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS settlement.clearing_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  settlement_id UUID REFERENCES settlement.settlements(id),
  clearing_type VARCHAR(50) NOT NULL,
  amount DECIMAL(20,8) NOT NULL,
  currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  status VARCHAR(20) DEFAULT 'pending',
  processed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Netting batches for efficient multi-party settlement
CREATE TABLE IF NOT EXISTS settlement.netting_batches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  batch_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'open' -- open, closed, settled
);

CREATE TABLE IF NOT EXISTS settlement.netting_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  batch_id UUID REFERENCES settlement.netting_batches(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  gross_amount DECIMAL(20,8) NOT NULL,
  net_amount DECIMAL(20,8) NOT NULL,
  fees_amount DECIMAL(20,8) DEFAULT 0
);

-- =====================================================
-- BLOCKCHAIN & LIQUIDITY
-- =====================================================
CREATE TABLE IF NOT EXISTS blockchain.nodes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blockchain_name VARCHAR(50) NOT NULL,
  node_type VARCHAR(20) NOT NULL,
  node_url VARCHAR(255) NOT NULL,
  api_key VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  last_sync_at TIMESTAMP,
  sync_status VARCHAR(20) DEFAULT 'syncing',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS blockchain.smart_contracts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blockchain_name VARCHAR(50) NOT NULL,
  contract_address VARCHAR(255) NOT NULL,
  contract_name VARCHAR(100) NOT NULL,
  contract_type VARCHAR(50) NOT NULL,
  abi JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS blockchain.cross_chain_bridges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_chain VARCHAR(50) NOT NULL,
  destination_chain VARCHAR(50) NOT NULL,
  bridge_name VARCHAR(100) NOT NULL,
  bridge_address VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS liquidity.pools (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pool_name VARCHAR(100) NOT NULL,
  base_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  quote_currency_id UUID REFERENCES wallet.cryptocurrencies(id),
  pool_address VARCHAR(255),
  total_liquidity DECIMAL(20,8) DEFAULT 0,
  apy DECIMAL(10,4),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS liquidity.treasury_operations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  operation_type VARCHAR(50) NOT NULL,
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  amount DECIMAL(20,8) NOT NULL,
  source_wallet_id UUID,
  destination_wallet_id UUID,
  status VARCHAR(20) DEFAULT 'pending',
  executed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Liquidity exposures by asset
CREATE TABLE IF NOT EXISTS liquidity.exposures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cryptocurrency_id UUID REFERENCES wallet.cryptocurrencies(id),
  total_assets DECIMAL(20,8) DEFAULT 0,
  total_liabilities DECIMAL(20,8) DEFAULT 0,
  net_exposure DECIMAL(20,8) GENERATED ALWAYS AS (total_assets - total_liabilities) STORED,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ACCOUNTING (double-entry ledger for reconciliation)
-- =====================================================
CREATE TABLE IF NOT EXISTS accounting.ledger_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(150) NOT NULL,
  currency_code VARCHAR(10),
  category VARCHAR(50) NOT NULL, -- assets, liabilities, equity, income, expense
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounting.journal_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ref_type VARCHAR(50), -- trade, deposit, withdrawal, fee, settlement
  ref_id UUID,
  description TEXT,
  entry_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounting.ledger_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  journal_entry_id UUID REFERENCES accounting.journal_entries(id) ON DELETE CASCADE,
  account_id UUID REFERENCES accounting.ledger_accounts(id),
  amount DECIMAL(20,8) NOT NULL, -- positive for debit, negative for credit (or use separate columns)
  currency_code VARCHAR(10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Daily reconciliation snapshot
CREATE TABLE IF NOT EXISTS accounting.daily_reconciliation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  as_of_date DATE NOT NULL,
  asset_code VARCHAR(20) NOT NULL,
  ledger_balance DECIMAL(20,8) NOT NULL,
  wallet_balance DECIMAL(20,8) NOT NULL,
  delta DECIMAL(20,8) NOT NULL,
  status VARCHAR(20) DEFAULT 'unreconciled',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(as_of_date, asset_code)
);

-- =====================================================
-- MONITORING & OPS
-- =====================================================
CREATE TABLE IF NOT EXISTS monitoring.system_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_type VARCHAR(50) NOT NULL,
  severity VARCHAR(20) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  data JSONB,
  is_resolved BOOLEAN DEFAULT false,
  resolved_at TIMESTAMP,
  resolved_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS monitoring.performance_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  metric_name VARCHAR(100) NOT NULL,
  metric_value DECIMAL(20,8) NOT NULL,
  metric_unit VARCHAR(20),
  category VARCHAR(50) NOT NULL,
  ts TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS monitoring.health_checks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_name VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL, -- up, down, degraded
  details JSONB,
  checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ops.incidents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  severity VARCHAR(20) NOT NULL,
  status VARCHAR(20) DEFAULT 'open',
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP
);

-- =====================================================
-- INDEXES (representative subset)
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_auth_users_email ON auth.users(email);
CREATE INDEX IF NOT EXISTS idx_trading_orders_user_id ON trading.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_trading_trades_pair_time ON trading.trades(trading_pair_id, executed_at);
CREATE INDEX IF NOT EXISTS idx_wallet_user_wallets_user ON wallet.user_wallets(user_id);
CREATE INDEX IF NOT EXISTS idx_price_history_pair_ts ON market_data.price_history(trading_pair_id, ts);

-- Apply updated_at triggers to common tables
CREATE TRIGGER trg_auth_users_updated_at BEFORE UPDATE ON auth.users
FOR EACH ROW EXECUTE FUNCTION shared.update_updated_at_column();

CREATE TRIGGER trg_trading_orders_updated_at BEFORE UPDATE ON trading.orders
FOR EACH ROW EXECUTE FUNCTION shared.update_updated_at_column();

CREATE TRIGGER trg_wallet_user_wallets_updated_at BEFORE UPDATE ON wallet.user_wallets
FOR EACH ROW EXECUTE FUNCTION shared.update_updated_at_column();

CREATE TRIGGER trg_admin_settings_updated_at BEFORE UPDATE ON admin.system_settings
FOR EACH ROW EXECUTE FUNCTION shared.update_updated_at_column();

-- =====================================================
-- VIEWS (examples)
-- =====================================================
CREATE OR REPLACE VIEW reporting.user_portfolio AS
SELECT 
  u.id AS user_id,
  u.email,
  uw.cryptocurrency_id,
  c.symbol,
  c.name AS crypto_name,
  uw.balance,
  uw.locked_balance,
  uw.total_deposited,
  uw.total_withdrawn
FROM auth.users u
JOIN wallet.user_wallets uw ON u.id = uw.user_id
JOIN wallet.cryptocurrencies c ON uw.cryptocurrency_id = c.id
WHERE u.deleted_at IS NULL;

CREATE OR REPLACE VIEW reporting.trading_pair_stats AS
SELECT 
  tp.id,
  tp.symbol,
  tp.name,
  tp.is_active,
  tp.is_trading_enabled,
  COUNT(o.id) AS total_orders,
  COUNT(t.id) AS total_trades,
  SUM(t.quantity) AS total_volume,
  AVG(t.price) AS avg_price
FROM trading.trading_pairs tp
LEFT JOIN trading.orders o ON tp.id = o.trading_pair_id
LEFT JOIN trading.trades t ON tp.id = t.trading_pair_id
GROUP BY tp.id, tp.symbol, tp.name, tp.is_active, tp.is_trading_enabled;

-- =====================================================
-- REPORTING (regulatory/financial)
-- =====================================================
CREATE TABLE IF NOT EXISTS reporting.financial_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  report_type VARCHAR(50) NOT NULL, -- pnl, balance_sheet, cash_flow
  period VARCHAR(20) NOT NULL, -- daily, monthly, quarterly
  report_data JSONB NOT NULL,
  generated_by UUID REFERENCES auth.users(id),
  generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reporting.regulatory_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  report_type VARCHAR(50) NOT NULL, -- trade_report, sar, compliance
  regulatory_body VARCHAR(100),
  period_start DATE,
  period_end DATE,
  report_data JSONB NOT NULL,
  submission_status VARCHAR(20) DEFAULT 'pending',
  submitted_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SEED (minimal)
-- =====================================================
INSERT INTO wallet.cryptocurrencies (symbol, name, network, decimals, is_active) VALUES
('BTC', 'Bitcoin', 'Bitcoin', 8, true),
('ETH', 'Ethereum', 'Ethereum', 18, true),
('USDT', 'Tether', 'Ethereum', 6, true)
ON CONFLICT (symbol) DO NOTHING;

INSERT INTO wallet.fiat_currencies (code, name, symbol) VALUES
('USD', 'US Dollar', '$'),
('EUR', 'Euro', '€'),
('VND', 'Vietnamese Dong', '₫')
ON CONFLICT (code) DO NOTHING;

INSERT INTO trading.order_types (name, description, parameters) VALUES
('market', 'Market Order', '{"time_in_force":["IOC"]}'),
('limit', 'Limit Order', '{"time_in_force":["GTC","IOC","FOK"]}')
ON CONFLICT (name) DO NOTHING;

INSERT INTO fees.tiers (name, min_volume_30d, maker_fee, taker_fee) VALUES
('Basic', 0, 0.001, 0.001),
('Silver', 10000, 0.0008, 0.0008)
ON CONFLICT (name) DO NOTHING;

-- Optional: default admin/system settings
INSERT INTO admin.system_settings (key, value, description, category, is_public) VALUES
('maintenance_mode', 'false', 'System maintenance mode', 'system', true)
ON CONFLICT (key) DO NOTHING;

-- =====================================================
-- END OF SCHEMA V2
-- =====================================================


