import { Express } from 'express';
import digestRoutes from './digest.routes.ts';

export function setupRoutes(app: Express) {
  // API routes
  app.use('/api', digestRoutes);
} 