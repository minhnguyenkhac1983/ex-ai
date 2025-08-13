const swaggerDoc = {
  openapi: '3.0.0',
  info: {
    title: 'Notification Service API',
    version: '1.0.0',
    description: 'API quản lý thông báo người dùng'
  },
  servers: [{ url: '/' }],
  tags: [
    { name: 'Health' },
    { name: 'Notifications' },
    { name: 'Test' }
  ],
  components: {
    schemas: {
      Notification: {
        type: 'object',
        properties: {
          _id: { type: 'string', description: 'Document ID' },
          userId: { type: 'string', description: 'ID người dùng' },
          title: { type: 'string', description: 'Tiêu đề' },
          body: { type: 'string', description: 'Nội dung' },
          read: { type: 'boolean', description: 'Đã đọc hay chưa', default: false },
          createdAt: { type: 'string', format: 'date-time' },
          updatedAt: { type: 'string', format: 'date-time' },
          __v: { type: 'integer' }
        },
        required: ['title', 'body'],
        example: {
          _id: '64f0c1a2b3c4d5e6f7a8b9c0',
          userId: 'demo-user',
          title: 'Welcome to notification-service',
          body: 'This is a sample notification',
          read: false,
          createdAt: '2025-08-08T08:56:06.306Z',
          updatedAt: '2025-08-08T08:56:06.306Z',
          __v: 0
        }
      },
      CreateNotificationRequest: {
        type: 'object',
        properties: {
          userId: { type: 'string', description: 'ID người dùng (tùy chọn)' },
          title: { type: 'string', description: 'Tiêu đề' },
          body: { type: 'string', description: 'Nội dung' },
          read: { type: 'boolean', description: 'Đã đọc hay chưa', default: false }
        },
        required: ['title', 'body'],
        example: {
          userId: 'user-123',
          title: 'KYC Approved',
          body: 'Your KYC verification has been approved.',
          read: false
        }
      },
      ErrorResponse: {
        type: 'object',
        properties: { error: { type: 'string' } },
        example: { error: 'Validation failed' }
      },
      HealthResponse: {
        type: 'object',
        properties: { status: { type: 'string', example: 'ok' } }
      }
    }
  },
  paths: {
    '/health': {
      get: {
        tags: ['Health'],
        summary: 'Health check',
        responses: {
          '200': {
            description: 'OK',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/HealthResponse' } } }
          }
        }
      }
    },
    '/notifications': {
      post: {
        tags: ['Notifications'],
        summary: 'Create notification',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/CreateNotificationRequest' }
            }
          }
        },
        responses: {
          '201': {
            description: 'Created',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Notification' } } }
          },
          '400': {
            description: 'Bad Request',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ErrorResponse' } } }
          }
        }
      }
    },
    '/notifications/{userId}': {
      get: {
        tags: ['Notifications'],
        summary: 'List notifications by userId',
        parameters: [
          { name: 'userId', in: 'path', required: true, schema: { type: 'string' } }
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Notification' } }
              }
            }
          },
          '500': {
            description: 'Internal Error',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ErrorResponse' } } }
          }
        }
      }
    },
    '/test/seed': {
      get: {
        tags: ['Test'],
        summary: 'Seed sample notification',
        responses: {
          '200': {
            description: 'OK',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Notification' } } }
          }
        }
      }
    }
  }
};

module.exports = { swaggerDoc };


