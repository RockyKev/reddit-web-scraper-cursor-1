import { Express, Request, Response, NextFunction } from 'express';
import swaggerUi from 'swagger-ui-express';
import { logger } from '../utils/logger';

export const setupRoutes = (app: Express): void => {
  // Health check endpoint
  app.get('/health', (req: Request, res: Response) => {
    res.json({ status: 'ok' });
  });

  // API documentation
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup({
    openapi: '3.0.0',
    info: {
      title: 'Reddit PDX Scraper API',
      version: '1.0.0',
      description: 'API documentation for the Reddit PDX Scraper',
    },
    paths: {
      '/health': {
        get: {
          summary: 'Health check endpoint',
          responses: {
            '200': {
              description: 'Server is healthy',
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      status: {
                        type: 'string',
                        example: 'ok',
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
  }));

  // Error handling middleware
  app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    logger.error('Unhandled error:', err);
    res.status(500).json({
      error: 'Internal Server Error',
      message: process.env.NODE_ENV === 'development' ? err.message : undefined,
    });
  });
}; 