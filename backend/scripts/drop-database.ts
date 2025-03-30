import pkg from 'pg';
const { Pool } = pkg;
import { getPool } from '../config/database.ts';
import { logger } from '../utils/logger.ts';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

async function dropDatabase() {
  // Connect to default postgres database with superuser credentials
  const defaultPool = new Pool({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || '5432'),
    database: 'postgres',
    user: 'reddit_scraper',  // This is our superuser from docker-compose
    password: 'reddit_scraper_password',
  });
  
  try {
    // Check if we're in production
    const isProduction = process.env.NODE_ENV === 'production';
    if (isProduction) {
      logger.error('⚠️  WARNING: Attempting to drop database in production environment!');
      logger.error('This operation will delete all data and cannot be undone.');
      logger.error('If you are sure you want to proceed, set NODE_ENV=development');
      process.exit(1);
    }

    // Terminate all connections to the database
    await defaultPool.query(`
      SELECT pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE pg_stat_activity.datname = '${process.env.DB_NAME}'
      AND pid <> pg_backend_pid();
    `);

    // Drop the database if it exists
    await defaultPool.query(`
      DROP DATABASE IF EXISTS ${process.env.DB_NAME};
    `);

    // Recreate the database
    await defaultPool.query(`
      CREATE DATABASE ${process.env.DB_NAME}
      WITH OWNER = '${process.env.DB_USER}'
      ENCODING = 'UTF8'
      LC_COLLATE = 'en_US.utf8'
      LC_CTYPE = 'en_US.utf8';
    `);

    logger.info('✅ Database dropped and recreated successfully');
  } catch (error) {
    logger.error('Error dropping database:', error);
    process.exit(1);
  } finally {
    await defaultPool.end();
  }
}

// Run the script
dropDatabase(); 