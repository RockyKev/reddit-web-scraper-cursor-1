import { getPool } from '../config/database.js';
import type { QueryResult, QueryResultRow } from 'pg';

// Export the pool from config
export const db = getPool();

// Test the connection
getPool().connect((err, client, release) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Successfully connected to database');
  release();
}); 