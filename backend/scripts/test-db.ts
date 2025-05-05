import { getPool } from '../config/database.js';
import { logger } from '../utils/logger.js';

async function testConnection() {
  try {
    logger.info('Testing database connection...');
    const pool = getPool();
    const client = await pool.connect();
    
    // Test query to list tables
    const result = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `);
    
    logger.info('Connected successfully! Tables found:', result.rows.map(row => row.table_name));
    client.release();
  } catch (error) {
    logger.error('Database connection failed:', error);
    if (error instanceof Error) {
      logger.error('Error details:', {
        message: error.message,
        stack: error.stack,
        name: error.name
      });
    }
  }
}

testConnection(); 