import pkg from 'pg';
const { Pool } = pkg;
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

let pool: InstanceType<typeof Pool> | null = null;

export const getPool = (): InstanceType<typeof Pool> => {
  if (!pool) {
    // Ensure password is a string and exists
    const password = process.env.DB_PASSWORD;
    if (!password) {
      throw new Error('Database password is required but not provided');
    }

    // Create connection config
    const dbConfig = {
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432'),
      database: process.env.DB_NAME || 'reddit_scraper',
      user: process.env.DB_USER || 'reddit_scraper',
      password: password,
      ssl: false,
    };

    // Log the config (with password redacted)
    console.log('Database config:', {
      ...dbConfig,
      password: '[REDACTED]',
      passwordType: typeof password,
      passwordLength: password.length
    });

    pool = new Pool(dbConfig);
    
    pool.on('error', (err: Error) => {
      console.error('Unexpected error on idle client', err);
      // Don't exit process, just log the error
      pool = null;
    });
  }
  return pool;
};

// Export the pool for direct use
export const db = getPool();

// Export a function to test the connection
export async function testConnection() {
  const client = await db.connect();
  console.log('Successfully connected to database');
  client.release();
} 