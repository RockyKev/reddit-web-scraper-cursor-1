# Testing Documentation

## Overview
This project uses Jest as its testing framework with TypeScript support via `ts-jest`. Tests are organized in two main directories:
- `/tests` - For standalone test files and test utilities
- `/src/**/__tests__` - For tests that are co-located with their source files

## Test Setup

### Database Configuration
Tests use a separate test database (`reddit_scraper_test`) to avoid interfering with development or production data. The test database configuration is managed through:
- `.env.test` - Test-specific environment variables
- `scripts/setup-test-db.ts` - Script to create and initialize the test database
- `tests/jest/setup.ts` - Jest setup file that configures the test environment

To run the test database setup:
```bash
npm run test:setup
```

### Available Test Commands
- `npm test` - Run all tests
- `npm run test:watch` - Run tests in watch mode
- `npm run test:coverage` - Run tests with coverage reporting
- `npm run test:unit` - Run Reddit scraper unit tests
- `npm run test:storage` - Run storage tests
- `npm run test:collector` - Run collector tests
- `npm run test:keywords` - Run keyword extractor tests
- `npm run test:all` - Set up test database and run all tests

## Test Suites

### RedditStorage Tests (`src/services/__tests__/reddit-storage.test.ts`)

#### Subreddit Storage Tests
1. `should store a new subreddit`
   - Purpose: Verifies that a new subreddit can be stored in the database
   - Expected: Returns a valid UUID and successfully stores the subreddit

2. `should update existing subreddit`
   - Purpose: Verifies the upsert functionality for subreddits
   - Expected: Updates description of existing subreddit without creating a duplicate

#### Post Storage Tests
1. `should store a new post`
   - Purpose: Verifies that a new post with all fields (including arrays and JSON) can be stored
   - Expected: Successfully stores post with complex data types (keywords array, top commenters JSON, sentiment analysis)

2. `should update existing post`
   - Purpose: Verifies the upsert functionality for posts
   - Expected: Updates all fields of an existing post while maintaining data integrity

#### Comment Storage Tests
1. `should store a new comment`
   - Purpose: Verifies that a new comment can be stored with proper parent post reference
   - Expected: Successfully stores comment with all fields and maintains referential integrity

2. `should update existing comment`
   - Purpose: Verifies the upsert functionality for comments
   - Expected: Updates comment fields while maintaining parent relationships

#### Retrieval Tests
1. `should return subreddit by name`
   - Purpose: Verifies subreddit lookup functionality
   - Expected: Returns correct subreddit ID for existing subreddit

2. `should return null for non-existent subreddit`
   - Purpose: Verifies proper handling of missing subreddits
   - Expected: Returns null for non-existent subreddit name

3. `should return post by Reddit ID`
   - Purpose: Verifies post lookup functionality
   - Expected: Returns correct post ID for existing Reddit post ID

4. `should return null for non-existent post`
   - Purpose: Verifies proper handling of missing posts
   - Expected: Returns null for non-existent Reddit post ID

## Test Coverage
Current test coverage is monitored for:
- Statements
- Branches
- Functions
- Lines

Coverage reports are generated in:
- Text format (console output)
- LCOV format (for integration with coverage tools)

## Best Practices
1. Each test file should focus on testing a single module or functionality
2. Use descriptive test names that explain the expected behavior
3. Tests should be independent and not rely on the state from other tests
4. Use the test database for integration tests
5. Mock external dependencies when appropriate
6. Clean up test data in the `beforeEach` hooks 