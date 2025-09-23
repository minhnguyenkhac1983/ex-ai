# Tổng hợp API Endpoints

## 📋 Tổng quan

Hệ thống Vietnam E-Wallet Exchange cung cấp hơn 100 API endpoints được phân bố trên 10 microservices, mỗi service có chức năng chuyên biệt và API riêng.

## 🔐 Auth Service (Port 3001)

### Authentication Endpoints
```
POST   /api/v1/auth/register          # Đăng ký tài khoản
POST   /api/v1/auth/login             # Đăng nhập
POST   /api/v1/auth/logout            # Đăng xuất
POST   /api/v1/auth/refresh           # Làm mới token
POST   /api/v1/auth/forgot-password   # Quên mật khẩu
POST   /api/v1/auth/reset-password    # Đặt lại mật khẩu
POST   /api/v1/auth/verify-email      # Xác thực email
POST   /api/v1/auth/verify-phone      # Xác thực số điện thoại
```

### MFA Endpoints
```
POST   /api/v1/auth/mfa/setup         # Thiết lập MFA
POST   /api/v1/auth/mfa/verify        # Xác thực MFA
POST   /api/v1/auth/mfa/disable       # Tắt MFA
GET    /api/v1/auth/mfa/backup-codes  # Lấy mã dự phòng
```

## 👤 User Service (Port 3002)

### User Management
```
GET    /api/v1/users/profile          # Lấy thông tin profile
PUT    /api/v1/users/profile          # Cập nhật profile
GET    /api/v1/users/:id              # Lấy thông tin user
PUT    /api/v1/users/:id              # Cập nhật thông tin user
DELETE /api/v1/users/:id              # Xóa user
```

### KYC Endpoints
```
POST   /api/v1/users/kyc/upload       # Upload KYC documents
GET    /api/v1/users/kyc/status       # Kiểm tra trạng thái KYC
POST   /api/v1/users/kyc/verify       # Xác thực KYC
```

## 💰 Wallet Service (Port 3003)

### Wallet Management
```
GET    /api/v1/wallets                # Lấy danh sách ví
POST   /api/v1/wallets                # Tạo ví mới
GET    /api/v1/wallets/:id            # Lấy thông tin ví
PUT    /api/v1/wallets/:id            # Cập nhật ví
DELETE /api/v1/wallets/:id            # Xóa ví
```

### Balance Management
```
GET    /api/v1/wallets/:id/balance    # Lấy số dư
GET    /api/v1/wallets/:id/history    # Lịch sử số dư
POST   /api/v1/wallets/:id/freeze     # Đóng băng ví
POST   /api/v1/wallets/:id/unfreeze   # Mở khóa ví
```

## 💳 Transaction Service (Port 3004)

### Transaction Processing
```
POST   /api/v1/transactions           # Tạo giao dịch
GET    /api/v1/transactions           # Lấy danh sách giao dịch
GET    /api/v1/transactions/:id       # Lấy thông tin giao dịch
PUT    /api/v1/transactions/:id       # Cập nhật giao dịch
PATCH  /api/v1/transactions/:id/status # Cập nhật trạng thái
```

### Transaction Analytics
```
GET    /api/v1/transactions/stats     # Thống kê giao dịch
GET    /api/v1/transactions/export    # Xuất báo cáo
GET    /api/v1/transactions/search    # Tìm kiếm giao dịch
```

## 💸 Payment Service (Port 3005)

### Payment Processing
```
POST   /api/v1/payments               # Tạo thanh toán
GET    /api/v1/payments/:id           # Lấy thông tin thanh toán
POST   /api/v1/payments/:id/verify    # Xác thực thanh toán
POST   /api/v1/payments/:id/refund    # Hoàn tiền
```

### Payment Gateway Integration
```
POST   /api/v1/payments/vnpay         # VNPay integration
POST   /api/v1/payments/momo          # MoMo integration
POST   /api/v1/payments/zalopay       # ZaloPay integration
POST   /api/v1/payments/napas         # NAPAS integration
```

### QR Code & NFC
```
POST   /api/v1/payments/qr/generate   # Tạo QR code
POST   /api/v1/payments/qr/scan       # Quét QR code
POST   /api/v1/payments/nfc/pay       # Thanh toán NFC
```

## 📱 Notification Service (Port 3006)

### Notification Management
```
POST   /api/v1/notifications/send     # Gửi thông báo
GET    /api/v1/notifications          # Lấy danh sách thông báo
GET    /api/v1/notifications/:id      # Lấy thông báo
PUT    /api/v1/notifications/:id/read # Đánh dấu đã đọc
DELETE /api/v1/notifications/:id      # Xóa thông báo
```

### Notification Channels
```
POST   /api/v1/notifications/sms      # Gửi SMS
POST   /api/v1/notifications/email    # Gửi email
POST   /api/v1/notifications/push     # Gửi push notification
POST   /api/v1/notifications/in-app   # Thông báo trong app
```

## 🛡️ Fraud Detection Service (Port 3007)

### Risk Assessment
```
POST   /api/v1/fraud/assess           # Đánh giá rủi ro
GET    /api/v1/fraud/risk/:id         # Lấy thông tin rủi ro
POST   /api/v1/fraud/whitelist        # Thêm vào whitelist
POST   /api/v1/fraud/blacklist        # Thêm vào blacklist
```

### Fraud Analytics
```
GET    /api/v1/fraud/stats            # Thống kê gian lận
GET    /api/v1/fraud/patterns         # Phân tích mẫu gian lận
GET    /api/v1/fraud/alerts           # Cảnh báo gian lận
```

### ML Models
```
POST   /api/v1/fraud/models/train     # Huấn luyện model
GET    /api/v1/fraud/models           # Lấy danh sách models
POST   /api/v1/fraud/models/predict   # Dự đoán gian lận
```

## 📊 Analytics Service (Port 3008)

### Real-time Analytics
```
GET    /api/v1/analytics/realtime     # Metrics thời gian thực
GET    /api/v1/analytics/users        # Phân tích người dùng
GET    /api/v1/analytics/transactions # Phân tích giao dịch
GET    /api/v1/analytics/financial    # Phân tích tài chính
```

### Business Intelligence
```
GET    /api/v1/analytics/dashboard    # Dashboard tổng quan
GET    /api/v1/analytics/reports      # Báo cáo chi tiết
POST   /api/v1/analytics/custom       # Báo cáo tùy chỉnh
GET    /api/v1/analytics/export       # Xuất dữ liệu
```

### Predictive Analytics
```
GET    /api/v1/analytics/forecast     # Dự báo xu hướng
GET    /api/v1/analytics/predictions  # Dự đoán tương lai
POST   /api/v1/analytics/insights     # Phân tích insights
```

## 🤖 AI/ML Service (Port 3009)

### Machine Learning
```
POST   /api/v1/ai/models/train        # Huấn luyện model
GET    /api/v1/ai/models              # Lấy danh sách models
POST   /api/v1/ai/models/predict      # Dự đoán
POST   /api/v1/ai/models/evaluate     # Đánh giá model
```

### Natural Language Processing
```
POST   /api/v1/ai/nlp/analyze         # Phân tích văn bản
POST   /api/v1/ai/nlp/sentiment       # Phân tích cảm xúc
POST   /api/v1/ai/nlp/entities        # Trích xuất thực thể
POST   /api/v1/ai/nlp/classify        # Phân loại văn bản
```

### Chatbot
```
POST   /api/v1/ai/chatbot/message     # Gửi tin nhắn chatbot
GET    /api/v1/ai/chatbot/history     # Lịch sử chat
POST   /api/v1/ai/chatbot/feedback    # Đánh giá chatbot
```

### User Behavior Analysis
```
GET    /api/v1/ai/behavior/:userId    # Phân tích hành vi user
POST   /api/v1/ai/behavior/analyze    # Phân tích hành vi
GET    /api/v1/ai/behavior/patterns   # Mẫu hành vi
```

## 🔗 Blockchain Service (Port 3010)

### Wallet Management
```
POST   /api/v1/blockchain/wallet/create    # Tạo ví blockchain
GET    /api/v1/blockchain/wallet/:address  # Lấy thông tin ví
GET    /api/v1/blockchain/wallet/:address/balance # Số dư ví
```

### Transaction Management
```
POST   /api/v1/blockchain/transaction/send # Gửi giao dịch
GET    /api/v1/blockchain/transaction/:hash # Lấy giao dịch
GET    /api/v1/blockchain/transaction/status # Trạng thái giao dịch
```

### Digital Assets
```
POST   /api/v1/blockchain/assets/create    # Tạo tài sản số
GET    /api/v1/blockchain/assets           # Lấy danh sách tài sản
POST   /api/v1/blockchain/assets/transfer  # Chuyển tài sản
```

### NFT Management
```
POST   /api/v1/blockchain/nft/mint         # Mint NFT
GET    /api/v1/blockchain/nft/:tokenId     # Lấy thông tin NFT
POST   /api/v1/blockchain/nft/transfer     # Chuyển NFT
```

### DeFi Integration
```
POST   /api/v1/blockchain/defi/stake       # Staking
POST   /api/v1/blockchain/defi/liquidity   # Cung cấp thanh khoản
GET    /api/v1/blockchain/defi/rewards     # Lấy phần thưởng
```

### Cross-chain Bridge
```
POST   /api/v1/blockchain/bridge/transfer  # Chuyển cross-chain
GET    /api/v1/blockchain/bridge/status    # Trạng thái bridge
GET    /api/v1/blockchain/bridge/fees      # Phí bridge
```

## 🔧 System Endpoints

### Health Checks
```
GET    /health                         # Health check cho tất cả services
GET    /api/v1/health                  # Health check chi tiết
GET    /api/v1/metrics                 # Metrics endpoint
```

### Monitoring
```
GET    /api/v1/monitoring/status       # Trạng thái hệ thống
GET    /api/v1/monitoring/performance  # Hiệu suất hệ thống
GET    /api/v1/monitoring/alerts       # Cảnh báo hệ thống
```

## 📝 API Documentation

### Swagger/OpenAPI
- **Auth Service**: http://localhost:3001/api-docs
- **User Service**: http://localhost:3002/api-docs
- **Wallet Service**: http://localhost:3003/api-docs
- **Transaction Service**: http://localhost:3004/api-docs
- **Payment Service**: http://localhost:3005/api-docs
- **Notification Service**: http://localhost:3006/api-docs
- **Fraud Detection Service**: http://localhost:3007/api-docs
- **Analytics Service**: http://localhost:3008/api-docs
- **AI/ML Service**: http://localhost:3009/api-docs
- **Blockchain Service**: http://localhost:3010/api-docs

## 🔐 Authentication & Authorization

### JWT Token
```json
{
  "Authorization": "Bearer <jwt_token>"
}
```

### API Key
```json
{
  "X-API-Key": "<api_key>"
}
```

### Rate Limiting
- **Standard**: 1000 requests/hour
- **Premium**: 10000 requests/hour
- **Enterprise**: Unlimited

## 📊 Response Format

### Success Response
```json
{
  "success": true,
  "data": {},
  "message": "Success",
  "timestamp": "2025-01-27T10:00:00Z"
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error message",
    "details": {}
  },
  "timestamp": "2025-01-27T10:00:00Z"
}
```

## 🚀 Testing

### Test Endpoints
```bash
# Health check
curl http://localhost:3001/health

# Authentication
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber": "0123456789", "password": "password"}'

# Get user profile
curl http://localhost:3002/api/v1/users/profile \
  -H "Authorization: Bearer <token>"
```

---

### 11. Crypto Service (Port 3011) ⭐ NEW
- **Base URL**: `http://localhost:3011/api/v1/crypto`
- **Endpoints**:
  - `POST /wallets` - Create crypto wallet
  - `GET /wallets/:id` - Get wallet info
  - `POST /transactions/send` - Send crypto transaction
  - `GET /transactions/:id` - Get transaction status
  - `GET /prices/:symbol` - Get crypto price
  - `GET /portfolio/:userId` - Get user portfolio
  - `POST /orders` - Create trading order
  - `GET /orders/:id` - Get order status
  - `GET /exchanges` - Get supported exchanges
  - `GET /markets` - Get market data

### 12. KYC Service (Port 3012) ⭐ NEW
- **Base URL**: `http://localhost:3012/api/v1/kyc`
- **Endpoints**:
  - `POST /applications` - Create KYC application
  - `GET /applications/:id` - Get application status
  - `POST /documents/upload` - Upload KYC document
  - `GET /documents/:id` - Get document info
  - `POST /verification/:id` - Verify document
  - `GET /status/:userId` - Get KYC status
  - `POST /review/:id` - Review application
  - `GET /risk-assessment/:id` - Get risk assessment
  - `GET /compliance/report` - Get compliance report

### 13. Merchant Service (Port 3013) ⭐ NEW
- **Base URL**: `http://localhost:3013/api/v1/merchant`
- **Endpoints**:
  - `POST /applications` - Create merchant application
  - `GET /applications/:id` - Get application status
  - `POST /approve/:id` - Approve merchant
  - `POST /payments` - Create payment request
  - `GET /payments/:id` - Get payment status
  - `POST /payments/:id/status` - Update payment status
  - `GET /settlements` - Get settlements
  - `POST /settlements/process` - Process settlement
  - `GET /analytics` - Get merchant analytics
  - `GET /dashboard` - Get dashboard data
  - `POST /webhooks` - Configure webhooks

---

**Tổng kết**: Hệ thống cung cấp hơn 150 API endpoints được tổ chức thành 13 microservices, mỗi service có chức năng chuyên biệt và API documentation đầy đủ.
