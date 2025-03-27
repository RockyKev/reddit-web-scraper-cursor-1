# Testing Guide

## Test Types

### Jest Tests
- Located in `tests/services/`
- Used for unit testing of services
- Run with `npm test`
- Example: `keyword-extractor.test.ts`

### Direct Test Scripts
- Located in `tests/`
- Used for testing Reddit API integration and database operations
- Run with specific npm scripts:
  - `npm run test:unit` - Tests Reddit scraper functionality
  - `npm run test:db` - Tests database operations
- Examples:
  - `test-reddit-scraper.ts`
  - `test-reddit-collector.ts`
  - `test-reddit-db-storage.ts`

## Running Tests

### Jest Tests
```bash
npm test
```
This will run all Jest tests in the `tests/services/` directory.

### Reddit Scraper Tests
```bash
npm run test:unit
```
This runs the Reddit scraper test script directly with ts-node. It tests:
- Post fetching from subreddits
- Comment fetching from posts
- Rate limiting behavior

### Database Tests
```bash
npm run test:db
```
This runs the database test script directly with ts-node. It tests:
- Database connection
- Post storage
- Comment storage
- Data retrieval

## Test Organization

### Directory Structure
```
tests/
├── services/           # Jest tests for services
│   └── keyword-extractor.test.ts
├── test-reddit-scraper.ts
├── test-reddit-collector.ts
├── test-reddit-db-storage.ts
└── mocks/             # Mock data for testing
```

### Naming Conventions
- Jest tests: `*.test.ts`
- Direct test scripts: `test-*.ts`

## Future Improvements
- Standardize all tests to use Jest
- Implement proper test fixtures
- Add more comprehensive test coverage
- Add integration tests
- Add end-to-end tests 