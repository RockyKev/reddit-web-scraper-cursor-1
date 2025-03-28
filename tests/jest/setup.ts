import dotenv from 'dotenv';

// Load test environment variables
dotenv.config({ path: '.env.test' });

// Set default test database configuration if not provided
process.env.DB_HOST = process.env.DB_HOST || 'localhost';
process.env.DB_PORT = process.env.DB_PORT || '5432';
process.env.DB_NAME = process.env.DB_NAME || 'reddit_scraper_test';
process.env.DB_USER = process.env.DB_USER || 'postgres';
process.env.DB_PASSWORD = process.env.DB_PASSWORD || 'postgres';

// Increase Jest timeout for database operations
jest.setTimeout(10000);

// Increase timeout for all tests
jest.setTimeout(30000);

// Store original console methods
const originalConsole = { ...console };

// Suppress console logs during tests
beforeAll(() => {
  // Override console methods to do nothing during tests
  console.log = jest.fn();
  console.error = jest.fn();
  console.warn = jest.fn();
  console.info = jest.fn();
});

// Restore original console methods after all tests
afterAll(() => {
  console = originalConsole;
});

// Clear all mocks after each test
afterEach(() => {
  jest.clearAllMocks();
}); 