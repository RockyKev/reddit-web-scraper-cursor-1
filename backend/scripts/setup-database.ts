import { Pool } from 'pg';
import { logger } from '../utils/logger.ts';

const setupDatabase = async () => {
  // Connect to default postgres database first
  const defaultPool = new Pool({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || '5432'),
    database: 'postgres',
    user: 'postgres',
    password: 'postgres', // Default Docker PostgreSQL password
  });

  try {
    // Create user if not exists
    await defaultPool.query(`
      DO
      $do$
      BEGIN
        IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles
          WHERE rolname = '${process.env.DB_USER}'
        ) THEN
          CREATE USER ${process.env.DB_USER} WITH PASSWORD '${process.env.DB_PASSWORD}';
        END IF;
      END
      $do$;
    `);

    // Create database if not exists
    await defaultPool.query(`
      SELECT 'CREATE DATABASE ${process.env.DB_NAME}'
      WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${process.env.DB_NAME}');
    `);

    // Grant privileges
    await defaultPool.query(`
      GRANT ALL PRIVILEGES ON DATABASE ${process.env.DB_NAME} TO ${process.env.DB_USER};
    `);

    logger.info('Database setup completed successfully');
  } catch (error) {
    logger.error('Error setting up database:', error);
    throw error;
  } finally {
    await defaultPool.end();
  }
};

// Run if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  setupDatabase()
    .then(() => process.exit(0))
    .catch((error) => {
      logger.error('Failed to setup database:', error);
      process.exit(1);
    });
}

export { setupDatabase }; 