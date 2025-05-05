import { getPool } from '../backend/config/database.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { logger } from '../backend/utils/logger.js';
import dotenv from 'dotenv';

// Load environment variables first
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export async function setupDatabase(isTestDb: boolean = false) {
  try {
    // Read the schema file
    const schemaPath = path.join(__dirname, 'schema.sql');
    const schema = fs.readFileSync(schemaPath, 'utf8');

    logger.info(`Setting up ${isTestDb ? 'test ' : ''}database...`);

    // Split into individual statements, handling dollar-quoted strings
    const statements = schema
      .split(/;\s*$/)
      .map(statement => statement.trim())
      .filter(statement => statement.length > 0);

    // Execute each statement
    for (const statement of statements) {
      try {
        await getPool().query(statement);
      } catch (error: any) {
        // Ignore "relation already exists" errors
        if (error.code === '42P07') {
          logger.info('Table already exists, skipping...');
          continue;
        }
        throw error;
      }
    }

    logger.info(`Database ${isTestDb ? 'test ' : ''}setup completed successfully`);
  } catch (error) {
    logger.error(`Error setting up ${isTestDb ? 'test ' : ''}database:`, error);
    throw error;
  }
}

// Run if this file is executed directly
const isDirectExecution = process.argv[1]?.endsWith('setup.ts');

if (isDirectExecution) {
  const isTestDb = process.argv.includes('--test');
  setupDatabase(isTestDb)
    .then(() => {
      logger.info('Database setup complete');
      process.exit(0);
    })
    .catch((error) => {
      logger.error('Failed to setup database:', error);
      process.exit(1);
    });
} 