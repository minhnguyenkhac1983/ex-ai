# Identity Service

Chức năng: Đăng ký/đăng nhập, quyền hạn (RBAC), 2FA (TOTP), WebAuthn/passkeys, OIDC provider hoặc OIDC client (tùy kiến trúc).

Khuyến nghị:
- Lưu token/secret an toàn (Vault/KMS), rotate keys
- Phát sự kiện domain qua outbox + Debezium
- Expose gRPC nội bộ + REST public


