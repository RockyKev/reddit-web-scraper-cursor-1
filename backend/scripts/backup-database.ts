import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';
import { logger } from '../utils/logger.js';

// Load environment variables
dotenv.config();

const execAsync = promisify(exec);
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function createBackup() {
  try {
    // Get database connection details from environment variables
    const {
      POSTGRES_USER = 'reddit_scraper',
      POSTGRES_PASSWORD = 'reddit_scraper_password',
      POSTGRES_DB = 'reddit_scraper',
      POSTGRES_HOST = 'localhost',
      POSTGRES_PORT = '5432'
    } = process.env;

    // Create backup directory if it doesn't exist
    const projectRoot = path.resolve(__dirname, '../../');
    const backupDir = path.join(projectRoot, 'mock-data', 'postgres-backup');
    
    // Validate the backup directory is within the project
    const expectedPath = path.join(process.cwd(), 'mock-data', 'postgres-backup');
    if (backupDir !== expectedPath) {
      throw new Error(`Backup directory path is incorrect! 
		Expected: ${expectedPath}, 
		Got: ${backupDir}`);
    }

    if (!fs.existsSync(backupDir)) {
      logger.info(`Creating backup directory: ${backupDir}`);
      fs.mkdirSync(backupDir, { recursive: true });
    }

    // Generate timestamp for backup file
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupFile = path.join(backupDir, `backup-${timestamp}.sql`);

    logger.info(`Backup will be saved to: ${backupFile}`);

    // Use Docker to run pg_dump
    const dockerCmd = `docker exec reddit_scraper_db pg_dump -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -d ${POSTGRES_DB} -F p > "${backupFile}"`;

    logger.info('Starting database backup...');
    await execAsync(dockerCmd);
    
    // Verify the backup file was created
    if (!fs.existsSync(backupFile)) {
      throw new Error(`Backup file was not created at: ${backupFile}`);
    }
    
    logger.info(`Backup completed successfully: ${backupFile}`);

  } catch (error) {
    // Log error without exposing sensitive data
    logger.error('Error creating database backup:', error instanceof Error ? error.message : 'Unknown error');
    process.exit(1);
  }
}

// Run if this file is executed directly
if (process.argv[1]?.endsWith('backup-database.ts')) {
  createBackup();
} 