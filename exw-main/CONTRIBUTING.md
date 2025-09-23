# Hướng dẫn đóng góp cho Vietnam E-Wallet Exchange

Cảm ơn bạn đã quan tâm đến việc đóng góp cho dự án Vietnam E-Wallet Exchange! Tài liệu này sẽ hướng dẫn bạn cách đóng góp một cách hiệu quả.

## Mục lục

- [Quy tắc ứng xử](#quy-tắc-ứng-xử)
- [Bắt đầu](#bắt-đầu)
- [Quy trình phát triển](#quy-trình-phát-triển)
- [Quy tắc code](#quy-tắc-code)
- [Commit Messages](#commit-messages)
- [Pull Request](#pull-request)
- [Báo cáo lỗi](#báo-cáo-lỗi)
- [Đề xuất tính năng](#đề-xuất-tính-năng)
- [Tài liệu](#tài-liệu)

## Quy tắc ứng xử

Dự án này tuân theo [Quy tắc ứng xử của Contributor Covenant](CODE_OF_CONDUCT.md). Bằng cách tham gia, bạn đồng ý tuân thủ quy tắc này.

## Bắt đầu

### 1. Fork và Clone

```bash
# Fork repository trên GitHub
# Sau đó clone fork của bạn
git clone https://github.com/YOUR_USERNAME/exw.git
cd exw

# Thêm upstream remote
git remote add upstream https://github.com/minhnguyenkhac1983/exw.git
```

### 2. Cài đặt môi trường phát triển

```bash
# Cài đặt dependencies
npm run setup

# Khởi động services cần thiết
npm run docker:up

# Chạy tests để đảm bảo mọi thứ hoạt động
npm test
```

### 3. Tạo branch mới

```bash
# Luôn tạo branch từ develop
git checkout develop
git pull upstream develop
git checkout -b feature/your-feature-name
```

## Quy trình phát triển

### 1. Lập kế hoạch

Trước khi bắt đầu code:
- [ ] Tạo issue mô tả vấn đề hoặc tính năng
- [ ] Thảo luận với maintainers nếu cần
- [ ] Đảm bảo không có ai khác đang làm việc tương tự

### 2. Phát triển

- [ ] Viết code theo quy tắc đã định
- [ ] Viết tests cho code mới
- [ ] Đảm bảo tất cả tests pass
- [ ] Cập nhật tài liệu nếu cần

### 3. Testing

```bash
# Chạy tất cả tests
npm test

# Chạy linting
npm run lint

# Chạy formatting check
npm run format:check

# Chạy security scan
npm run security:scan
```

### 4. Commit và Push

```bash
# Add changes
git add .

# Commit với message rõ ràng
git commit -m "feat: add user authentication service"

# Push to your fork
git push origin feature/your-feature-name
```

## Quy tắc code

### 1. Naming Conventions

- **Files**: kebab-case (`user-service.ts`)
- **Directories**: kebab-case (`auth-service/`)
- **Classes**: PascalCase (`UserService`)
- **Functions**: camelCase (`getUserById`)
- **Constants**: UPPER_SNAKE_CASE (`API_BASE_URL`)
- **Environment variables**: UPPER_SNAKE_CASE (`DATABASE_URL`)

### 2. TypeScript

- Sử dụng TypeScript strict mode
- Định nghĩa types rõ ràng
- Sử dụng interfaces cho object shapes
- Tránh `any` type

```typescript
// ✅ Good
interface User {
  id: string;
  email: string;
  createdAt: Date;
}

function getUserById(id: string): Promise<User> {
  // implementation
}

// ❌ Bad
function getUserById(id: any): any {
  // implementation
}
```

### 3. Error Handling

```typescript
// ✅ Good
try {
  const result = await someAsyncOperation();
  return result;
} catch (error) {
  logger.error('Failed to perform operation', { error });
  throw new AppError('Operation failed', 500);
}

// ❌ Bad
const result = await someAsyncOperation(); // No error handling
```

### 4. Testing

- Viết unit tests cho mọi function
- Viết integration tests cho API endpoints
- Đảm bảo test coverage > 80%
- Sử dụng descriptive test names

```typescript
// ✅ Good
describe('UserService', () => {
  describe('getUserById', () => {
    it('should return user when valid id is provided', async () => {
      // test implementation
    });

    it('should throw error when user not found', async () => {
      // test implementation
    });
  });
});
```

### 5. Documentation

- Viết JSDoc cho public functions
- Cập nhật README khi thêm tính năng mới
- Viết API documentation
- Thêm comments cho logic phức tạp

```typescript
/**
 * Retrieves a user by their unique identifier
 * @param id - The unique identifier of the user
 * @returns Promise that resolves to the user object
 * @throws {AppError} When user is not found
 */
async getUserById(id: string): Promise<User> {
  // implementation
}
```

## Commit Messages

Sử dụng [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: Tính năng mới
- `fix`: Sửa lỗi
- `docs`: Cập nhật tài liệu
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Refactoring code
- `test`: Thêm hoặc sửa tests
- `chore`: Maintenance tasks

### Examples

```
feat(auth): add two-factor authentication

Add support for TOTP-based 2FA using Google Authenticator.
Includes backend validation and frontend QR code generation.

Closes #123
```

```
fix(payment): resolve VNPay integration timeout

Increase timeout from 30s to 60s for VNPay API calls.
Add retry mechanism for failed requests.

Fixes #456
```

## Pull Request

### 1. Tạo Pull Request

- Tạo PR từ feature branch của bạn đến `develop`
- Sử dụng template PR có sẵn
- Mô tả rõ ràng những thay đổi
- Link đến related issues

### 2. PR Template

```markdown
## Mô tả
Mô tả ngắn gọn về những thay đổi trong PR này.

## Loại thay đổi
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Checklist
- [ ] Code đã được test
- [ ] Tests đã được thêm/cập nhật
- [ ] Documentation đã được cập nhật
- [ ] Không có breaking changes
- [ ] Code tuân thủ style guide

## Screenshots (nếu có)
Thêm screenshots cho UI changes.

## Related Issues
Closes #123
```

### 3. Review Process

- Maintainers sẽ review code
- Có thể yêu cầu thay đổi
- Tất cả CI checks phải pass
- Cần ít nhất 2 approvals

## Báo cáo lỗi

### 1. Tạo Bug Report

Sử dụng template bug report:

```markdown
## Mô tả lỗi
Mô tả rõ ràng về lỗi.

## Các bước tái tạo
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Kết quả mong đợi
Mô tả kết quả mong đợi.

## Screenshots
Thêm screenshots nếu có.

## Environment
- OS: [e.g. Windows 10]
- Browser: [e.g. Chrome 91]
- Version: [e.g. 1.0.0]

## Additional context
Thêm thông tin khác nếu cần.
```

### 2. Security Issues

**KHÔNG** tạo public issue cho security vulnerabilities. Thay vào đó:

- Email: security@ewallet.vn
- Sử dụng GPG encryption nếu có thể
- Mô tả chi tiết vulnerability
- Cung cấp steps để reproduce

## Đề xuất tính năng

### 1. Tạo Feature Request

```markdown
## Tính năng mong muốn
Mô tả rõ ràng tính năng bạn muốn.

## Vấn đề cần giải quyết
Mô tả vấn đề mà tính năng này sẽ giải quyết.

## Giải pháp đề xuất
Mô tả giải pháp bạn muốn.

## Alternatives
Mô tả các giải pháp thay thế khác.

## Additional context
Thêm thông tin khác nếu cần.
```

### 2. Discussion

- Thảo luận trên GitHub Discussions
- Tham gia community meetings
- Liên hệ maintainers qua email

## Tài liệu

### 1. Cập nhật Documentation

- README.md cho setup instructions
- API docs cho endpoints mới
- Architecture docs cho design decisions
- User guides cho end users

### 2. Translation

Chúng tôi hoan nghênh translations:
- Vietnamese (primary)
- English
- Other languages

## Community

### 1. Communication Channels

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: General discussions
- **Email**: contact@ewallet.vn
- **Discord**: [Join our server](https://discord.gg/ewallet)

### 2. Meetings

- **Weekly Community Call**: Thứ 3 hàng tuần, 2:00 PM ICT
- **Monthly Planning**: Ngày 1 hàng tháng
- **Quarterly Review**: Cuối mỗi quý

## Recognition

Contributors sẽ được:
- Liệt kê trong CONTRIBUTORS.md
- Nhận contributor badge
- Được mời tham gia core team (nếu phù hợp)
- Nhận swag và certificates

## Questions?

Nếu bạn có câu hỏi:
- Tạo GitHub Discussion
- Email: contributors@ewallet.vn
- Join Discord server

---

Cảm ơn bạn đã đóng góp cho Vietnam E-Wallet Exchange! 🚀
