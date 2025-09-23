import { Injectable, Logger } from '@nestjs/common';
import { Redis } from 'ioredis';
import * as crypto from 'crypto';
import * as bcrypt from 'bcrypt';
import * as speakeasy from 'speakeasy';
import * as QRCode from 'qrcode';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AdvancedSecurityService {
  private readonly logger = new Logger(AdvancedSecurityService.name);
  private redis: Redis;

  constructor(private jwtService: JwtService) {
    this.redis = new Redis({
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT) || 6379,
    });
  }

  // Multi-Factor Authentication (MFA)
  async setupMFA(userId: number): Promise<{
    secret: string;
    qrCode: string;
    backupCodes: string[];
  }> {
    try {
      const secret = speakeasy.generateSecret({
        name: `Vietnam E-Wallet (${userId})`,
        issuer: 'Vietnam E-Wallet Exchange',
        length: 32,
      });

      const qrCode = await QRCode.toDataURL(secret.otpauth_url!);
      const backupCodes = this.generateBackupCodes();

      // Store MFA secret and backup codes
      await this.redis.hset(`mfa:${userId}`, {
        secret: secret.base32,
        backupCodes: JSON.stringify(backupCodes),
        isEnabled: 'false',
      });

      return {
        secret: secret.base32,
        qrCode,
        backupCodes,
      };
    } catch (error) {
      this.logger.error('Error setting up MFA:', error);
      throw error;
    }
  }

  async verifyMFA(userId: number, token: string): Promise<boolean> {
    try {
      const mfaData = await this.redis.hgetall(`mfa:${userId}`);
      
      if (!mfaData.secret) {
        throw new Error('MFA not set up for user');
      }

      const verified = speakeasy.totp.verify({
        secret: mfaData.secret,
        encoding: 'base32',
        token,
        window: 2, // Allow 2 time steps before and after
      });

      if (verified) {
        // Log successful MFA verification
        await this.logSecurityEvent(userId, 'MFA_VERIFICATION_SUCCESS', {
          timestamp: new Date().toISOString(),
        });
      } else {
        // Log failed MFA verification
        await this.logSecurityEvent(userId, 'MFA_VERIFICATION_FAILED', {
          timestamp: new Date().toISOString(),
          token: token.substring(0, 3) + '***',
        });
      }

      return verified;
    } catch (error) {
      this.logger.error('Error verifying MFA:', error);
      return false;
    }
  }

  async verifyBackupCode(userId: number, backupCode: string): Promise<boolean> {
    try {
      const mfaData = await this.redis.hgetall(`mfa:${userId}`);
      const backupCodes = JSON.parse(mfaData.backupCodes || '[]');

      const index = backupCodes.indexOf(backupCode);
      if (index === -1) {
        await this.logSecurityEvent(userId, 'BACKUP_CODE_VERIFICATION_FAILED', {
          timestamp: new Date().toISOString(),
        });
        return false;
      }

      // Remove used backup code
      backupCodes.splice(index, 1);
      await this.redis.hset(`mfa:${userId}`, 'backupCodes', JSON.stringify(backupCodes));

      await this.logSecurityEvent(userId, 'BACKUP_CODE_VERIFICATION_SUCCESS', {
        timestamp: new Date().toISOString(),
      });

      return true;
    } catch (error) {
      this.logger.error('Error verifying backup code:', error);
      return false;
    }
  }

  // Biometric Authentication
  async storeBiometricTemplate(userId: number, biometricData: string, type: 'fingerprint' | 'face' | 'voice'): Promise<void> {
    try {
      const hashedBiometric = await this.hashBiometricData(biometricData);
      
      await this.redis.hset(`biometric:${userId}`, {
        [type]: hashedBiometric,
        [`${type}_created_at`]: new Date().toISOString(),
      });

      await this.logSecurityEvent(userId, 'BIOMETRIC_TEMPLATE_STORED', {
        type,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      this.logger.error('Error storing biometric template:', error);
      throw error;
    }
  }

  async verifyBiometric(userId: number, biometricData: string, type: 'fingerprint' | 'face' | 'voice'): Promise<boolean> {
    try {
      const storedTemplate = await this.redis.hget(`biometric:${userId}`, type);
      
      if (!storedTemplate) {
        return false;
      }

      const isMatch = await this.compareBiometricData(biometricData, storedTemplate);
      
      if (isMatch) {
        await this.logSecurityEvent(userId, 'BIOMETRIC_VERIFICATION_SUCCESS', {
          type,
          timestamp: new Date().toISOString(),
        });
      } else {
        await this.logSecurityEvent(userId, 'BIOMETRIC_VERIFICATION_FAILED', {
          type,
          timestamp: new Date().toISOString(),
        });
      }

      return isMatch;
    } catch (error) {
      this.logger.error('Error verifying biometric:', error);
      return false;
    }
  }

  // Advanced Password Security
  async validatePasswordStrength(password: string): Promise<{
    isValid: boolean;
    score: number;
    feedback: string[];
  }> {
    const feedback: string[] = [];
    let score = 0;

    // Length check
    if (password.length >= 12) {
      score += 25;
    } else if (password.length >= 8) {
      score += 15;
      feedback.push('Consider using a longer password (12+ characters)');
    } else {
      feedback.push('Password should be at least 8 characters long');
    }

    // Character variety checks
    if (/[a-z]/.test(password)) score += 10;
    else feedback.push('Add lowercase letters');

    if (/[A-Z]/.test(password)) score += 10;
    else feedback.push('Add uppercase letters');

    if (/[0-9]/.test(password)) score += 10;
    else feedback.push('Add numbers');

    if (/[^a-zA-Z0-9]/.test(password)) score += 15;
    else feedback.push('Add special characters');

    // Common patterns check
    if (this.checkCommonPatterns(password)) {
      score -= 20;
      feedback.push('Avoid common patterns and sequences');
    }

    // Dictionary check
    if (this.checkDictionaryWords(password)) {
      score -= 15;
      feedback.push('Avoid common dictionary words');
    }

    // Entropy check
    const entropy = this.calculateEntropy(password);
    if (entropy >= 4) {
      score += 20;
    } else if (entropy >= 3) {
      score += 10;
      feedback.push('Increase password complexity');
    } else {
      feedback.push('Password is too predictable');
    }

    return {
      isValid: score >= 70,
      score: Math.max(0, Math.min(100, score)),
      feedback,
    };
  }

  async hashPassword(password: string): Promise<string> {
    const saltRounds = 12;
    return bcrypt.hash(password, saltRounds);
  }

  async verifyPassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  // Device Fingerprinting
  async createDeviceFingerprint(deviceInfo: any): Promise<string> {
    try {
      const fingerprintData = {
        userAgent: deviceInfo.userAgent,
        screenResolution: deviceInfo.screenResolution,
        timezone: deviceInfo.timezone,
        language: deviceInfo.language,
        platform: deviceInfo.platform,
        hardwareConcurrency: deviceInfo.hardwareConcurrency,
        deviceMemory: deviceInfo.deviceMemory,
        canvas: deviceInfo.canvas,
        webgl: deviceInfo.webgl,
      };

      const fingerprint = crypto
        .createHash('sha256')
        .update(JSON.stringify(fingerprintData))
        .digest('hex');

      return fingerprint;
    } catch (error) {
      this.logger.error('Error creating device fingerprint:', error);
      throw error;
    }
  }

  async verifyDeviceFingerprint(userId: number, deviceFingerprint: string): Promise<{
    isTrusted: boolean;
    riskScore: number;
    deviceInfo: any;
  }> {
    try {
      const trustedDevices = await this.redis.smembers(`trusted_devices:${userId}`);
      const isTrusted = trustedDevices.includes(deviceFingerprint);

      let riskScore = 0;
      if (!isTrusted) {
        riskScore += 30;
      }

      // Check for suspicious patterns
      const deviceHistory = await this.redis.lrange(`device_history:${deviceFingerprint}`, 0, 9);
      if (deviceHistory.length > 5) {
        riskScore += 20;
      }

      const deviceInfo = {
        isTrusted,
        firstSeen: deviceHistory[deviceHistory.length - 1] || new Date().toISOString(),
        lastSeen: deviceHistory[0] || new Date().toISOString(),
        usageCount: deviceHistory.length,
      };

      // Log device verification
      await this.logSecurityEvent(userId, 'DEVICE_VERIFICATION', {
        deviceFingerprint,
        isTrusted,
        riskScore,
        timestamp: new Date().toISOString(),
      });

      return {
        isTrusted,
        riskScore,
        deviceInfo,
      };
    } catch (error) {
      this.logger.error('Error verifying device fingerprint:', error);
      throw error;
    }
  }

  // Risk Assessment
  async assessRisk(userId: number, action: string, context: any): Promise<{
    riskScore: number;
    riskLevel: string;
    factors: string[];
    recommendation: string;
  }> {
    try {
      let riskScore = 0;
      const factors: string[] = [];

      // Check user's risk history
      const riskHistory = await this.getUserRiskHistory(userId);
      if (riskHistory.length > 0) {
        riskScore += 20;
        factors.push('Previous risk events detected');
      }

      // Check for unusual patterns
      const isUnusualTime = this.isUnusualTime(context.timestamp);
      if (isUnusualTime) {
        riskScore += 15;
        factors.push('Unusual time of activity');
      }

      // Check for new device
      if (!context.deviceTrusted) {
        riskScore += 25;
        factors.push('Untrusted device');
      }

      // Check for new location
      if (context.isNewLocation) {
        riskScore += 20;
        factors.push('New location detected');
      }

      // Check transaction amount
      if (context.amount && context.amount > 10000000) { // 10M VND
        riskScore += 30;
        factors.push('Large transaction amount');
      }

      // Check frequency
      const recentActions = await this.getRecentUserActions(userId, 1); // Last hour
      if (recentActions.length > 10) {
        riskScore += 20;
        factors.push('High frequency of actions');
      }

      // Determine risk level
      let riskLevel: string;
      let recommendation: string;

      if (riskScore >= 80) {
        riskLevel = 'HIGH';
        recommendation = 'BLOCK';
      } else if (riskScore >= 60) {
        riskLevel = 'MEDIUM';
        recommendation = 'REQUIRE_ADDITIONAL_VERIFICATION';
      } else if (riskScore >= 40) {
        riskLevel = 'LOW';
        recommendation = 'MONITOR';
      } else {
        riskLevel = 'MINIMAL';
        recommendation = 'ALLOW';
      }

      // Log risk assessment
      await this.logSecurityEvent(userId, 'RISK_ASSESSMENT', {
        action,
        riskScore,
        riskLevel,
        factors,
        recommendation,
        context,
        timestamp: new Date().toISOString(),
      });

      return {
        riskScore,
        riskLevel,
        factors,
        recommendation,
      };
    } catch (error) {
      this.logger.error('Error assessing risk:', error);
      throw error;
    }
  }

  // Security Event Logging
  async logSecurityEvent(userId: number, eventType: string, details: any): Promise<void> {
    try {
      const event = {
        userId,
        eventType,
        details,
        timestamp: new Date().toISOString(),
        ipAddress: details.ipAddress,
        userAgent: details.userAgent,
      };

      // Store in Redis for real-time monitoring
      await this.redis.lpush(`security_events:${userId}`, JSON.stringify(event));
      await this.redis.expire(`security_events:${userId}`, 86400 * 30); // Keep for 30 days

      // Store in database for long-term storage
      // This would integrate with your database logging system

      // Check for security alerts
      await this.checkSecurityAlerts(userId, eventType, details);
    } catch (error) {
      this.logger.error('Error logging security event:', error);
    }
  }

  // Session Management
  async createSecureSession(userId: number, deviceInfo: any): Promise<{
    sessionId: string;
    accessToken: string;
    refreshToken: string;
    expiresAt: Date;
  }> {
    try {
      const sessionId = crypto.randomUUID();
      const deviceFingerprint = await this.createDeviceFingerprint(deviceInfo);
      
      const payload = {
        sub: userId,
        sessionId,
        deviceFingerprint,
        type: 'access',
      };

      const accessToken = this.jwtService.sign(payload, { expiresIn: '15m' });
      const refreshToken = this.jwtService.sign(
        { ...payload, type: 'refresh' },
        { expiresIn: '7d' }
      );

      const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days

      // Store session data
      await this.redis.hset(`session:${sessionId}`, {
        userId: userId.toString(),
        deviceFingerprint,
        createdAt: new Date().toISOString(),
        expiresAt: expiresAt.toISOString(),
        isActive: 'true',
      });

      // Store user's active sessions
      await this.redis.sadd(`user_sessions:${userId}`, sessionId);

      return {
        sessionId,
        accessToken,
        refreshToken,
        expiresAt,
      };
    } catch (error) {
      this.logger.error('Error creating secure session:', error);
      throw error;
    }
  }

  async validateSession(sessionId: string): Promise<{
    isValid: boolean;
    userId?: number;
    deviceFingerprint?: string;
  }> {
    try {
      const sessionData = await this.redis.hgetall(`session:${sessionId}`);
      
      if (!sessionData.userId || sessionData.isActive !== 'true') {
        return { isValid: false };
      }

      const expiresAt = new Date(sessionData.expiresAt);
      if (expiresAt < new Date()) {
        await this.invalidateSession(sessionId);
        return { isValid: false };
      }

      return {
        isValid: true,
        userId: parseInt(sessionData.userId),
        deviceFingerprint: sessionData.deviceFingerprint,
      };
    } catch (error) {
      this.logger.error('Error validating session:', error);
      return { isValid: false };
    }
  }

  async invalidateSession(sessionId: string): Promise<void> {
    try {
      const sessionData = await this.redis.hgetall(`session:${sessionId}`);
      
      if (sessionData.userId) {
        await this.redis.srem(`user_sessions:${sessionData.userId}`, sessionId);
      }

      await this.redis.del(`session:${sessionId}`);
    } catch (error) {
      this.logger.error('Error invalidating session:', error);
    }
  }

  // Helper methods
  private generateBackupCodes(): string[] {
    const codes: string[] = [];
    for (let i = 0; i < 10; i++) {
      codes.push(crypto.randomBytes(4).toString('hex').toUpperCase());
    }
    return codes;
  }

  private async hashBiometricData(biometricData: string): Promise<string> {
    return crypto.createHash('sha256').update(biometricData).digest('hex');
  }

  private async compareBiometricData(input: string, stored: string): Promise<boolean> {
    const hashedInput = await this.hashBiometricData(input);
    return hashedInput === stored;
  }

  private checkCommonPatterns(password: string): boolean {
    const commonPatterns = [
      /123456/,
      /password/i,
      /qwerty/i,
      /abc123/i,
      /admin/i,
      /letmein/i,
    ];

    return commonPatterns.some(pattern => pattern.test(password));
  }

  private checkDictionaryWords(password: string): boolean {
    const commonWords = [
      'password', 'admin', 'user', 'login', 'welcome',
      'hello', 'world', 'test', 'demo', 'sample',
    ];

    return commonWords.some(word => password.toLowerCase().includes(word));
  }

  private calculateEntropy(password: string): number {
    const charSet = new Set(password);
    const length = password.length;
    const charsetSize = charSet.size;
    
    return Math.log2(Math.pow(charsetSize, length));
  }

  private isUnusualTime(timestamp: string): boolean {
    const hour = new Date(timestamp).getHours();
    return hour < 6 || hour > 23;
  }

  private async getUserRiskHistory(userId: number): Promise<any[]> {
    const events = await this.redis.lrange(`security_events:${userId}`, 0, 99);
    return events
      .map(event => JSON.parse(event))
      .filter(event => event.eventType.includes('FAILED') || event.eventType.includes('RISK'));
  }

  private async getRecentUserActions(userId: number, hours: number): Promise<any[]> {
    const cutoff = new Date(Date.now() - hours * 60 * 60 * 1000);
    const events = await this.redis.lrange(`security_events:${userId}`, 0, 99);
    
    return events
      .map(event => JSON.parse(event))
      .filter(event => new Date(event.timestamp) > cutoff);
  }

  private async checkSecurityAlerts(userId: number, eventType: string, details: any): Promise<void> {
    // Check for suspicious patterns and trigger alerts
    if (eventType.includes('FAILED')) {
      const recentFailures = await this.getRecentUserActions(userId, 1);
      const failureCount = recentFailures.filter(event => event.eventType.includes('FAILED')).length;
      
      if (failureCount >= 5) {
        await this.triggerSecurityAlert(userId, 'MULTIPLE_FAILED_ATTEMPTS', {
          failureCount,
          timeWindow: '1 hour',
        });
      }
    }
  }

  private async triggerSecurityAlert(userId: number, alertType: string, details: any): Promise<void> {
    const alert = {
      userId,
      alertType,
      details,
      timestamp: new Date().toISOString(),
      severity: this.getAlertSeverity(alertType),
    };

    // Store alert
    await this.redis.lpush(`security_alerts:${userId}`, JSON.stringify(alert));
    
    // Send notification (integrate with your notification service)
    this.logger.warn(`Security alert triggered for user ${userId}: ${alertType}`);
  }

  private getAlertSeverity(alertType: string): string {
    const highSeverityAlerts = [
      'MULTIPLE_FAILED_ATTEMPTS',
      'SUSPICIOUS_TRANSACTION',
      'ACCOUNT_TAKEOVER_ATTEMPT',
    ];

    return highSeverityAlerts.includes(alertType) ? 'HIGH' : 'MEDIUM';
  }
}
