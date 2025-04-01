import { db } from './index.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export async function setupDatabase(isTestDb: boolean = false) {
  try {
    // Read the schema file
    const schemaPath = path.join(__dirname, 'schema.sql');
    const schema = fs.readFileSync(schemaPath, 'utf8');

    // Split into individual statements, handling dollar-quoted strings
    const statements = schema
      .split(/;\s*$/)
      .map(statement => statement.trim())
      .filter(statement => statement.length > 0);

    // Execute each statement
    for (const statement of statements) {
      try {
        await db.query(statement);
      } catch (error: any) {
        // Ignore "relation already exists" errors
        if (error.code === '42P07') {
          console.log('Table already exists, skipping...');
          continue;
        }
        throw error;
      }
    }

    console.log(`Database ${isTestDb ? 'test ' : ''}setup completed successfully`);
  } catch (error) {
    console.error(`Error setting up ${isTestDb ? 'test ' : ''}database:`, error);
    throw error;
  }
}

// Run if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  const isTestDb = process.argv.includes('--test');
  
  setupDatabase(isTestDb)
    .then(() => {
      console.log('Database setup complete');
      process.exit(0);
    })
    .catch((error) => {
      console.error('Failed to setup database:', error);
      process.exit(1);
    });
} 