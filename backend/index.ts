import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import { setupRoutes } from './routes.js';
import { setupDatabase } from '../database/setup.js';
import { logger } from './utils/logger.js';

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;
const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5173';

// Middleware
app.use(express.json());
app.use(cors({
  origin: frontendUrl,
  methods: ['GET'], // Only allow GET since we're only reading data
  allowedHeaders: ['Content-Type']
}));

// Setup routes
setupRoutes(app);

// Initialize database and start server
setupDatabase()
  .then(() => {
    app.listen(port, () => {
      logger.info(`Server is running on port ${port}`);
      logger.info(`CORS enabled for frontend at ${frontendUrl}`);
    });
  })
  .catch((error) => {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }); 