import { getPool } from '../../backend/config/database.js';
import { logger } from '../../backend/utils/logger.js';

export async function testDatabaseConnection() {
  try {
    const pool = getPool();
    const client = await pool.connect();
    logger.info('Database connection test successful');
    client.release();
    return true;
  } catch (err) {
    logger.error('Failed to connect to database:', err);
    throw err;
  }
}

// Run if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  testDatabaseConnection()
    .then(() => {
      logger.info('Connection test complete');
      process.exit(0);
    })
    .catch((error) => {
      logger.error('Connection test failed:', error);
      process.exit(1);
    });
} 