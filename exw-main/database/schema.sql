-- =====================================================
-- VIETNAM E-WALLET EXCHANGE SYSTEM DATABASE SCHEMA
-- =====================================================
-- Tạo bởi: AI Assistant
-- Ngày: 2025
-- Mô tả: Cấu trúc database cho hệ thống ví điện tử Việt Nam
-- =====================================================

-- Tạo database chính
CREATE DATABASE IF NOT EXISTS vietnam_ewallet_exchange
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE vietnam_ewallet_exchange;

-- =====================================================
-- 1. BẢNG NGƯỜI DÙNG VÀ XÁC THỰC
-- =====================================================

-- Bảng người dùng chính
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    national_id VARCHAR(20) UNIQUE,
    address TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(10),
    country VARCHAR(2) DEFAULT 'VN',
    status ENUM('active', 'inactive', 'suspended', 'pending_verification') DEFAULT 'pending_verification',
    kyc_status ENUM('not_verified', 'pending', 'verified', 'rejected') DEFAULT 'not_verified',
    kyc_level ENUM('basic', 'standard', 'premium') DEFAULT 'basic',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    INDEX idx_phone (phone_number),
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_kyc_status (kyc_status)
);

-- Bảng xác thực và bảo mật
CREATE TABLE user_authentication (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    password_hash VARCHAR(255),
    salt VARCHAR(255),
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(255),
    biometric_enabled BOOLEAN DEFAULT FALSE,
    biometric_data TEXT,
    failed_login_attempts INT DEFAULT 0,
    locked_until TIMESTAMP NULL,
    password_changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- Bảng session và token
CREATE TABLE user_sessions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    refresh_token VARCHAR(255) UNIQUE,
    device_info TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_session_token (session_token),
    INDEX idx_expires_at (expires_at)
);

-- =====================================================
-- 2. BẢNG VÍ ĐIỆN TỬ VÀ TÀI KHOẢN
-- =====================================================

-- Bảng ví điện tử chính
CREATE TABLE wallets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    wallet_uuid VARCHAR(36) UNIQUE NOT NULL,
    wallet_name VARCHAR(100) NOT NULL,
    currency_code VARCHAR(3) DEFAULT 'VND',
    balance DECIMAL(20,2) DEFAULT 0.00,
    frozen_balance DECIMAL(20,2) DEFAULT 0.00,
    status ENUM('active', 'inactive', 'frozen', 'closed') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_wallet_uuid (wallet_uuid),
    INDEX idx_status (status)
);

-- Bảng lịch sử số dư
CREATE TABLE wallet_balance_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    wallet_id BIGINT NOT NULL,
    previous_balance DECIMAL(20,2) NOT NULL,
    new_balance DECIMAL(20,2) NOT NULL,
    change_amount DECIMAL(20,2) NOT NULL,
    transaction_id BIGINT,
    change_reason VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(id) ON DELETE CASCADE,
    INDEX idx_wallet_id (wallet_id),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- 3. BẢNG GIAO DỊCH VÀ THANH TOÁN
-- =====================================================

-- Bảng giao dịch chính
CREATE TABLE transactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    transaction_uuid VARCHAR(36) UNIQUE NOT NULL,
    from_wallet_id BIGINT,
    to_wallet_id BIGINT,
    amount DECIMAL(20,2) NOT NULL,
    currency_code VARCHAR(3) DEFAULT 'VND',
    transaction_type ENUM('transfer', 'payment', 'deposit', 'withdrawal', 'refund', 'fee') NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'failed', 'cancelled', 'reversed') DEFAULT 'pending',
    description TEXT,
    reference_number VARCHAR(100),
    external_reference VARCHAR(100),
    fee_amount DECIMAL(20,2) DEFAULT 0.00,
    exchange_rate DECIMAL(20,8) DEFAULT 1.00000000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (from_wallet_id) REFERENCES wallets(id),
    FOREIGN KEY (to_wallet_id) REFERENCES wallets(id),
    INDEX idx_transaction_uuid (transaction_uuid),
    INDEX idx_from_wallet (from_wallet_id),
    INDEX idx_to_wallet (to_wallet_id),
    INDEX idx_status (status),
    INDEX idx_type (transaction_type),
    INDEX idx_created_at (created_at)
);

-- Bảng chi tiết thanh toán
CREATE TABLE payment_details (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    transaction_id BIGINT NOT NULL,
    payment_method ENUM('wallet', 'bank_transfer', 'credit_card', 'debit_card', 'qr_code', 'nfc', 'cash') NOT NULL,
    payment_gateway VARCHAR(100),
    gateway_transaction_id VARCHAR(255),
    gateway_response TEXT,
    merchant_id BIGINT,
    merchant_reference VARCHAR(100),
    qr_code_data TEXT,
    nfc_data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_payment_method (payment_method),
    INDEX idx_gateway_transaction_id (gateway_transaction_id)
);

-- =====================================================
-- 4. BẢNG MERCHANT VÀ THƯƠNG MẠI
-- =====================================================

-- Bảng merchant
CREATE TABLE merchants (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    merchant_uuid VARCHAR(36) UNIQUE NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    business_type ENUM('retail', 'restaurant', 'service', 'ecommerce', 'utility', 'other') NOT NULL,
    contact_person VARCHAR(255),
    phone_number VARCHAR(15),
    email VARCHAR(255),
    business_license VARCHAR(100),
    tax_code VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    status ENUM('active', 'inactive', 'suspended', 'pending_approval') DEFAULT 'pending_approval',
    commission_rate DECIMAL(5,4) DEFAULT 0.0200,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_merchant_uuid (merchant_uuid),
    INDEX idx_business_name (business_name),
    INDEX idx_status (status)
);

-- Bảng merchant wallet
CREATE TABLE merchant_wallets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    merchant_id BIGINT NOT NULL,
    wallet_uuid VARCHAR(36) UNIQUE NOT NULL,
    currency_code VARCHAR(3) DEFAULT 'VND',
    balance DECIMAL(20,2) DEFAULT 0.00,
    frozen_balance DECIMAL(20,2) DEFAULT 0.00,
    status ENUM('active', 'inactive', 'frozen') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
    INDEX idx_merchant_id (merchant_id),
    INDEX idx_wallet_uuid (wallet_uuid)
);

-- =====================================================
-- 5. BẢNG BẢO MẬT VÀ FRAUD DETECTION
-- =====================================================

-- Bảng audit log
CREATE TABLE audit_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id VARCHAR(100),
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at)
);

-- Bảng fraud detection
CREATE TABLE fraud_attempts (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    transaction_id BIGINT,
    risk_score DECIMAL(5,2),
    risk_level ENUM('low', 'medium', 'high', 'critical') NOT NULL,
    fraud_type VARCHAR(100),
    detection_rules JSON,
    status ENUM('pending', 'reviewed', 'approved', 'rejected') DEFAULT 'pending',
    reviewer_id BIGINT,
    review_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_risk_level (risk_level),
    INDEX idx_status (status)
);

-- =====================================================
-- 6. BẢNG THÔNG BÁO VÀ COMMUNICATION
-- =====================================================

-- Bảng notifications
CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    notification_type ENUM('transaction', 'security', 'promotion', 'system', 'kyc') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSON,
    status ENUM('unread', 'read', 'archived') DEFAULT 'unread',
    sent_via ENUM('push', 'sms', 'email', 'in_app') DEFAULT 'in_app',
    sent_at TIMESTAMP NULL,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_type (notification_type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- 7. BẢNG CẤU HÌNH VÀ SETTINGS
-- =====================================================

-- Bảng system configuration
CREATE TABLE system_configurations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT,
    config_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
    description TEXT,
    is_encrypted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_config_key (config_key)
);

-- Bảng user preferences
CREATE TABLE user_preferences (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    preference_key VARCHAR(100) NOT NULL,
    preference_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_preference (user_id, preference_key),
    INDEX idx_user_id (user_id)
);

-- =====================================================
-- 8. BẢNG EXCHANGE VÀ CRYPTO (CHO TƯƠNG LAI)
-- =====================================================

-- Bảng crypto assets
CREATE TABLE crypto_assets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    asset_code VARCHAR(10) UNIQUE NOT NULL,
    asset_name VARCHAR(100) NOT NULL,
    asset_type ENUM('cryptocurrency', 'token', 'nft') NOT NULL,
    blockchain VARCHAR(50),
    contract_address VARCHAR(255),
    decimals INT DEFAULT 18,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_asset_code (asset_code),
    INDEX idx_status (status)
);

-- Bảng crypto wallets
CREATE TABLE crypto_wallets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    asset_id BIGINT NOT NULL,
    wallet_address VARCHAR(255) UNIQUE NOT NULL,
    private_key_encrypted TEXT,
    balance DECIMAL(30,18) DEFAULT 0.000000000000000000,
    status ENUM('active', 'inactive', 'frozen') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES crypto_assets(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_asset_id (asset_id),
    INDEX idx_wallet_address (wallet_address)
);

-- =====================================================
-- 9. INSERT DỮ LIỆU MẪU
-- =====================================================

-- Insert system configurations
INSERT INTO system_configurations (config_key, config_value, config_type, description) VALUES
('app_name', 'Vietnam E-Wallet Exchange', 'string', 'Tên ứng dụng'),
('app_version', '1.0.0', 'string', 'Phiên bản ứng dụng'),
('max_transaction_amount', '100000000', 'number', 'Số tiền giao dịch tối đa (VND)'),
('min_transaction_amount', '1000', 'number', 'Số tiền giao dịch tối thiểu (VND)'),
('transaction_fee_rate', '0.002', 'number', 'Tỷ lệ phí giao dịch'),
('kyc_required_amount', '5000000', 'number', 'Số tiền yêu cầu KYC (VND)'),
('maintenance_mode', 'false', 'boolean', 'Chế độ bảo trì'),
('supported_currencies', '["VND", "USD", "EUR"]', 'json', 'Các loại tiền tệ được hỗ trợ');

-- Insert crypto assets (for future use)
INSERT INTO crypto_assets (asset_code, asset_name, asset_type, blockchain, status) VALUES
('BTC', 'Bitcoin', 'cryptocurrency', 'Bitcoin', 'active'),
('ETH', 'Ethereum', 'cryptocurrency', 'Ethereum', 'active'),
('USDT', 'Tether USD', 'token', 'Ethereum', 'active'),
('BNB', 'Binance Coin', 'cryptocurrency', 'Binance Smart Chain', 'active');

-- =====================================================
-- 10. TẠO VIEWS VÀ STORED PROCEDURES
-- =====================================================

-- View tổng quan ví người dùng
CREATE VIEW user_wallet_summary AS
SELECT 
    u.id as user_id,
    u.phone_number,
    u.full_name,
    u.status as user_status,
    w.id as wallet_id,
    w.wallet_uuid,
    w.balance,
    w.frozen_balance,
    w.status as wallet_status,
    w.created_at as wallet_created_at
FROM users u
LEFT JOIN wallets w ON u.id = w.user_id
WHERE u.status = 'active';

-- View thống kê giao dịch
CREATE VIEW transaction_summary AS
SELECT 
    DATE(created_at) as transaction_date,
    transaction_type,
    status,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount,
    AVG(amount) as average_amount
FROM transactions
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY DATE(created_at), transaction_type, status;

-- =====================================================
-- 11. TẠO INDEXES BỔ SUNG CHO PERFORMANCE
-- =====================================================

-- Composite indexes for better query performance
CREATE INDEX idx_transactions_user_date ON transactions(from_wallet_id, created_at);
CREATE INDEX idx_transactions_status_date ON transactions(status, created_at);
CREATE INDEX idx_users_kyc_status ON users(kyc_status, status);
CREATE INDEX idx_wallets_user_currency ON wallets(user_id, currency_code);

-- =====================================================
-- END OF SCHEMA
-- =====================================================
