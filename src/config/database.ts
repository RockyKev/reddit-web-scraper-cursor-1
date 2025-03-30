import pkg from 'pg';
const { Pool } = pkg;
import { logger } from '../utils/logger.ts';

const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

pool.on('error', (err) => {
  logger.error('Unexpected error on idle client', err);
  process.exit(-1);
});

export const getPool = (): InstanceType<typeof Pool> => pool;

export async function setupDatabase() {
  // For now, we'll just return a resolved promise since we're using mock data
  return Promise.resolve();
} 