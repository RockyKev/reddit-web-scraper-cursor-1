import dotenv from 'dotenv';
import { jest } from '@jest/globals';
import { getPool, testDatabaseConnection } from '../../backend/config/database.js';
import { setupDatabase } from '../../database/setup.js';

// Load test environment variables
dotenv.config({ path: '.env.test' });

// Increase timeouts for database operations
jest.setTimeout(30000);

// Suppress console logs during tests
const originalConsole = {
  log: console.log,
  error: console.error,
  warn: console.warn,
  info: console.info,
  debug: console.debug
};

beforeAll(async () => {
  // Override console methods
  console.log = jest.fn();
  console.error = jest.fn();
  console.warn = jest.fn();
  console.info = jest.fn();
  console.debug = jest.fn();

  // Test database connection
  await testDatabaseConnection();

  // Setup test database
  await setupDatabase(true);
});

afterAll(async () => {
  // Restore original console methods
  console.log = originalConsole.log;
  console.error = originalConsole.error;
  console.warn = originalConsole.warn;
  console.info = originalConsole.info;
  console.debug = originalConsole.debug;

  // Close database connection
  await getPool().end();
});

// Clear all mocks after each test
afterEach(() => {
  jest.clearAllMocks();
}); 