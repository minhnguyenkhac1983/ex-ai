const express = require('express');
const mongoose = require('mongoose');
const morgan = require('morgan');
const pino = require('pino');
const swaggerUi = require('swagger-ui-express');
const { swaggerDoc } = require('./swagger');

const logger = pino({ level: process.env.LOG_LEVEL || 'info' });

const app = express();
app.use(express.json());
app.use(morgan('dev'));
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDoc));

const PORT = process.env.PORT || 8090;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://admin:password@mongodb:27017/notification?authSource=admin';

const notificationSchema = new mongoose.Schema(
  {
    userId: { type: String, index: true },
    title: { type: String, required: true },
    body: { type: String, required: true },
    read: { type: Boolean, default: false },
  },
  { timestamps: true }
);

const Notification = mongoose.model('Notification', notificationSchema);

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.post('/notifications', async (req, res) => {
  try {
    const notification = await Notification.create(req.body);
    res.status(201).json(notification);
  } catch (err) {
    logger.error({ err }, 'Failed to create notification');
    res.status(400).json({ error: err.message });
  }
});

app.get('/notifications/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const items = await Notification.find({ userId }).sort({ createdAt: -1 }).limit(50);
    res.json(items);
  } catch (err) {
    logger.error({ err }, 'Failed to list notifications');
    res.status(500).json({ error: 'Internal error' });
  }
});

// Seed route to create a sample notification quickly
app.get('/test/seed', async (req, res) => {
  try {
    const sample = await Notification.create({
      userId: 'demo-user',
      title: 'Welcome to notification-service',
      body: 'This is a sample notification created by /test/seed',
      read: false,
    });
    res.json(sample);
  } catch (err) {
    logger.error({ err }, 'Failed to seed sample notification');
    res.status(500).json({ error: 'Internal error' });
  }
});

async function start() {
  try {
    logger.info({ MONGODB_URI }, 'Connecting to MongoDB');
    await mongoose.connect(MONGODB_URI, { dbName: 'notification' });
    logger.info('MongoDB connected');
    app.listen(PORT, () => logger.info(`notification-service listening on ${PORT}`));
  } catch (err) {
    logger.error({ err }, 'Failed to start service');
    process.exit(1);
  }
}

start();


