import 'express-async-errors';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import { createProxyMiddleware } from 'http-proxy-middleware';
import swaggerUi from 'swagger-ui-express';
import swaggerJsdoc from 'swagger-jsdoc';
import dotenv from 'dotenv';
import { logger } from './utils/logger';
import { errorHandler } from './middleware/errorHandler';
import { authMiddleware } from './middleware/auth';
import { requestLogger } from './middleware/requestLogger';
import { healthCheck } from './routes/health';
import { swaggerOptions } from './config/swagger';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.'
});
app.use('/api/', limiter);

// Compression
app.use(compression());

// Logging
app.use(morgan('combined', { stream: { write: (message) => logger.info(message.trim()) } }));
app.use(requestLogger);

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Swagger documentation
const specs = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));

// Health check
app.use('/health', healthCheck);

// Service URLs
const USER_SERVICE_URL = process.env.USER_SERVICE_URL || 'http://localhost:3001';
const POLICY_SERVICE_URL = process.env.POLICY_SERVICE_URL || 'http://localhost:3002';
const QUOTE_SERVICE_URL = process.env.QUOTE_SERVICE_URL || 'http://localhost:3003';
const PAYMENT_SERVICE_URL = process.env.PAYMENT_SERVICE_URL || 'http://localhost:3004';
const CLAIMS_SERVICE_URL = process.env.CLAIMS_SERVICE_URL || 'http://localhost:3005';
const NOTIFICATION_SERVICE_URL = process.env.NOTIFICATION_SERVICE_URL || 'http://localhost:3006';
const DOCUMENT_SERVICE_URL = process.env.DOCUMENT_SERVICE_URL || 'http://localhost:3007';

// Proxy middleware configuration
const createServiceProxy = (target: string, pathRewrite?: Record<string, string>) => {
  return createProxyMiddleware({
    target,
    changeOrigin: true,
    pathRewrite,
    onError: (err, req, res) => {
      logger.error(`Proxy error for ${target}:`, err);
      res.status(503).json({ error: 'Service temporarily unavailable' });
    },
    onProxyReq: (proxyReq, req) => {
      logger.info(`${req.method} ${req.path} -> ${target}`);
    }
  });
};

// Public routes (no authentication required)
app.use('/api/auth', createServiceProxy(USER_SERVICE_URL, { '^/api/auth': '/auth' }));
app.use('/api/quotes', createServiceProxy(QUOTE_SERVICE_URL, { '^/api/quotes': '/quotes' }));

// Protected routes (authentication required)
app.use('/api/users', authMiddleware, createServiceProxy(USER_SERVICE_URL, { '^/api/users': '/users' }));
app.use('/api/policies', authMiddleware, createServiceProxy(POLICY_SERVICE_URL, { '^/api/policies': '/policies' }));
app.use('/api/payments', authMiddleware, createServiceProxy(PAYMENT_SERVICE_URL, { '^/api/payments': '/payments' }));
app.use('/api/claims', authMiddleware, createServiceProxy(CLAIMS_SERVICE_URL, { '^/api/claims': '/claims' }));
app.use('/api/notifications', authMiddleware, createServiceProxy(NOTIFICATION_SERVICE_URL, { '^/api/notifications': '/notifications' }));
app.use('/api/documents', authMiddleware, createServiceProxy(DOCUMENT_SERVICE_URL, { '^/api/documents': '/documents' }));

// Admin routes (admin authentication required)
app.use('/api/admin', authMiddleware, createServiceProxy(USER_SERVICE_URL, { '^/api/admin': '/admin' }));

// Error handling
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Start server
app.listen(PORT, () => {
  logger.info(`🚀 API Gateway running on port ${PORT}`);
  logger.info(`📚 API Documentation available at http://localhost:${PORT}/api-docs`);
  logger.info(`🏥 Health check available at http://localhost:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  logger.info('SIGINT received, shutting down gracefully');
  process.exit(0);
});

export default app;
