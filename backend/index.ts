import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import { setupRoutes } from './routes.js';
import { getPool } from './config/database.js';
import { logger } from './utils/logger.js';

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;
const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5173';
const allowedOrigins = [frontendUrl, 'http://localhost:4173'];

// Security headers middleware
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  next();
});

// Middleware
app.use(express.json());
app.use(cors({
  origin: allowedOrigins,
  methods: ['GET'], // Only allow GET since we're only reading data
  allowedHeaders: ['Content-Type']
}));

// Setup routes
setupRoutes(app);

// Test database connection and start server
const server = getPool()
  .query('SELECT NOW()')
  .then(() => {
    return app.listen(port, () => {
      logger.info(`Server is running on port ${port}`);
      logger.info(`CORS enabled for origins: ${allowedOrigins.join(', ')}`);
    });
  })
  .catch((error) => {
    logger.error('Failed to connect to database:', error);
    process.exit(1);
  });

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received. Starting graceful shutdown...');
  server.then(s => {
    s.close(() => {
      logger.info('Server closed');
      process.exit(0);
    });
  });
});

process.on('SIGINT', () => {
  logger.info('SIGINT received. Starting graceful shutdown...');
  server.then(s => {
    s.close(() => {
      logger.info('Server closed');
      process.exit(0);
    });
  });
}); 