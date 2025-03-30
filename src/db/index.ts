import { Pool, QueryResult } from 'pg';

// Create a new pool using environment variables
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: parseInt(process.env.DB_PORT || '5432'),
});

// Extend the Pool type to include our query method
interface DbPool extends Pool {
  query<T>(queryText: string, values?: any[]): Promise<QueryResult<T>>;
}

// Export the typed pool
export const db = pool as DbPool;

// Test the connection
pool.connect((err, client, release) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Successfully connected to database');
  release();
}); 