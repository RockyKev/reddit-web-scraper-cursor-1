import express from 'express';
import dotenv from 'dotenv';
import { setupRoutes } from './api/routes';
import { setupDatabase } from './config/database';
import { logger } from './utils/logger';

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Setup routes
setupRoutes(app);

// Initialize database and start server
setupDatabase()
  .then(() => {
    app.listen(port, () => {
      logger.info(`Server is running on port ${port}`);
    });
  })
  .catch((error) => {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }); 