import pkg from 'pg';
const { Pool } = pkg;
import { logger } from '../utils/logger.js';
import { getPool } from '../config/database.js';

const setupDatabase = async () => {
  const pool = getPool();

  try {
    // Test connection
    const client = await pool.connect();
    logger.info('Successfully connected to database');

    // Create initial tables and setup
    await client.query(`
      -- Add your table creation and setup queries here
      -- For example:
      -- CREATE TABLE IF NOT EXISTS users (...)
    `);

    client.release();
    logger.info('Database setup completed successfully');
  } catch (error) {
    logger.error('Error setting up database:', error);
    throw error;
  }
};

// Run if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  setupDatabase()
    .then(() => {
      logger.info('Database setup complete');
      process.exit(0);
    })
    .catch((error) => {
      logger.error('Failed to setup database:', error);
      process.exit(1);
    });
}

export { setupDatabase }; 