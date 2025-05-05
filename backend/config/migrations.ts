import dotenv from 'dotenv';
import path from 'path';
import pkg from 'pg';
const { Pool } = pkg;
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

export default {
  'migrations-table': 'pgmigrations',
  dir: path.join(__dirname, '../db/migrations'),
  driver: 'pg',
  databaseUrl: process.env.DATABASE_URL,
  pool,
}; 