# Testing Documentation

## Overview
This project uses Jest as its testing framework with TypeScript support via `ts-jest`. Tests are organized in the `/tests` directory, with test files mirroring the structure of the source files.

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
- `npm run test:scraper` - Test Reddit scraper functionality
- `npm run test:db` - Test database operations
- `npm run test:collector` - Test collector functionality
- `npm run test:scoring` - Test scoring and ranking functionality
- `npm run test:keywords` - Test keyword extraction functionality

## Test Suites

### RedditStorage Tests (`tests/services/reddit-storage.test.ts`)

#### Subreddit Storage Tests
1. `should store a new subreddit`
   - Purpose: Verifies that a new subreddit can be stored in the database
   - Expected: Returns a valid UUID and successfully stores the subreddit

2. `should update existing subreddit`
   - Purpose: Verifies the upsert functionality for subreddits
   - Expected: Updates description of existing subreddit without creating a duplicate

#### Post Storage Tests
1. `should store a new post`
   - Purpose: Verifies that a new post with all fields can be stored
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

### ScoreCalculator Tests (`tests/services/score-calculator.test.ts`)

#### Score Calculation Tests
1. `should calculate daily scores correctly`
   - Purpose: Verifies the scoring formula implementation
   - Expected: Calculates scores based on post score and comment count

2. `should assign daily ranks correctly`
   - Purpose: Verifies the ranking assignment
   - Expected: Assigns ranks based on daily scores in descending order

3. `should update user statistics`
   - Purpose: Verifies user statistics updates
   - Expected: Updates user contribution scores and totals

### RedditCollector Tests (`tests/services/reddit-collector.test.ts`)

#### Collection Process Tests
1. `should collect and store posts`
   - Purpose: Verifies the complete collection process
   - Expected: Successfully collects and stores posts with comments

2. `should handle rate limiting`
   - Purpose: Verifies rate limiting implementation
   - Expected: Respects Reddit API rate limits

3. `should trigger scoring after collection`
   - Purpose: Verifies scoring integration
   - Expected: Triggers score calculation after successful collection

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
7. Test both success and error cases
8. Verify database state after operations 