# Development Guide

This document provides comprehensive information for developers working on the Reddit PDX Scraper project.

## Available Scripts

### Test Scripts
- `npm test` - Run all tests
- `npm run test:all` - Run all tests with database setup
- `npm run test:unit` - Run unit tests for the Reddit scraper
- `npm run test:storage` - Run tests for database storage operations
- `npm run test:collector` - Run tests for the Reddit collector service
- `npm run test:keywords` - Run tests for keyword extraction
- `npm run test:setup` - Set up test database
- `npm run test:watch` - Run tests in watch mode
- `npm run test:coverage` - Generate test coverage report

### Database Scripts
- `npm run db:setup` - Set up the main database
- `npm run db:setup:test` - Set up the test database
- `npm run db:drop` - Drop the database
- `npm run db:reset` - Reset database (drops and recreates)
- `npm run db:migrate:create` - Create a new migration
- `npm run db:migrate:up` - Apply pending migrations
- `npm run db:migrate:down` - Roll back the last migration
- `npm run db:migrate:status` - Check migration status
- `npm run db:backup` - Create a database backup

### API Scripts
- `npm run api:start` - Start the API server (development mode with hot reloading)
- `npm run api:build` - Build the TypeScript code for production
- `npm run api:test` - Start the API server in test mode
- `npm run api:collect:live` - Collect live data from Reddit
- `npm run api:calculate:scores` - Calculate scores for posts

### Frontend Scripts
- `npm run frontend:dev` - Start frontend development server
- `npm run frontend:build` - Build frontend for production
- `npm run frontend:preview` - Preview production build locally

## Core Services

### 1. Reddit Scraper (`backend/services/reddit-scraper.ts`)
**Purpose**: Handle all Reddit API interactions and data transformation
- Fetch posts and comments from specified subreddits
- Implement rate limiting and retry logic
- Transform raw API responses into domain models
- Handle API authentication and error cases

**Key Methods**:
```typescript
async getPosts(limit: number, sort: RedditSortType, time: RedditTimeFilter): Promise<RedditPost[]>
async getComments(postId: string): Promise<RedditComment[]>
```

**Data Models**:
```typescript
interface RedditPost {
  id: string;
  title: string;
  content: string;
  author: string;
  subreddit: string;
  created: Date;
  score: number;
  numComments: number;
  url: string;
  permalink: string;
  postType: string;
  isArchived: boolean;
  isLocked: boolean;
}

interface RedditComment {
  id: string;
  postId: string;
  content: string;
  author: string;
  created: Date;
  score: number;
  parentId: string;
  isArchived: boolean;
}
```

### 2. Reddit Storage (`backend/services/reddit-storage.ts`)
**Purpose**: Manage database operations for Reddit data
- Store posts, comments, and related data in PostgreSQL
- Handle data deduplication
- Manage database connections and transactions
- Track user statistics and contributions

**Key Methods**:
```typescript
async storePost(subredditId: string, post: RedditPost): Promise<string>
async storeComment(postId: string, comment: RedditComment): Promise<string>
async storeUser(authorId: string, username: string): Promise<string>
async storePostWithComments(subredditId: string, post: RedditPost, comments: RedditComment[]): Promise<string>
```

### 3. Score Calculator (`backend/services/score-calculator.ts`)
**Purpose**: Calculate post rankings and scores
- Calculate daily scores for posts
- Update user statistics
- Assign daily ranks based on scores
- Provide verification of calculations

**Key Methods**:
```typescript
async calculateScoresForDate(date: string | Date): Promise<void>
```

### 4. Keyword Analysis (`backend/services/keyword-analysis-service.ts`)
**Purpose**: Extract and analyze keywords from content
- Extract keywords from posts and comments
- Apply frequency-based weighting
- Filter common words
- Store keywords in database

**Key Methods**:
```typescript
async extractKeywordsFromPost(post: RedditPost, comments: RedditComment[]): Promise<string[]>
```

### 5. Reddit Collector (`backend/services/reddit-collector.ts`)
**Purpose**: Coordinate the data collection process
- Orchestrate the fetching, processing, and storage of data
- Manage subreddit processing
- Handle error recovery and retries
- Trigger scoring calculations after collection

**Key Methods**:
```typescript
async collectAndStore(subreddits: string[], limit: number, sort: RedditSortType, time: RedditTimeFilter): Promise<void>
async processSubreddit(scraper: IRedditScraper, subreddit: string, limit: number, sort: RedditSortType, time: RedditTimeFilter): Promise<CollectionResult>
```

### 6. Digest Service (`backend/services/digest-service.ts`)
**Purpose**: Generate daily digests
- Generate daily summaries
- Aggregate statistics
- Create trend analysis
- Manage digest scheduling

**Key Methods**:
```typescript
async getDigest(date?: string): Promise<DigestResponse>
```

## Data Flow

### Collection Process
1. `reddit-collector.ts` initiates the collection process
2. `reddit-scraper.ts` retrieves and transforms data from Reddit API
3. `reddit-storage.ts` persists the data to PostgreSQL
4. `score-calculator.ts` calculates scores and ranks
5. `keyword-analysis-service.ts` extracts and analyzes keywords
6. `digest-service.ts` generates the daily digest

### Daily Schedule
The system runs on a schedule (default: daily at 4:30 AM EST) and can be triggered manually using:
```bash
npm run collect:live
```

## Code Style Guide

### TypeScript

- Use TypeScript's strict mode
- Prefer interfaces over type aliases
- Use meaningful type names
- Document complex types

### Naming Conventions

- Use PascalCase for classes and interfaces
- Use camelCase for variables and functions
- Use UPPER_SNAKE_CASE for constants
- Use descriptive names that indicate purpose

### File Organization

- One class/interface per file
- Group related functionality
- Keep files focused and small
- Use index files for exports

### Comments and Documentation

- Document public APIs
- Explain complex logic
- Use JSDoc for function documentation
- Keep comments up to date

## Testing Guidelines

### Unit Tests

- Test each component in isolation
- Use mocks for external dependencies
- Follow the Arrange-Act-Assert pattern
- Aim for high test coverage

### Integration Tests

- Test component interactions
- Use test database
- Clean up after tests
- Test error scenarios

### Test Files

- Place test files next to source files
- Use `.test.ts` suffix
- Group related tests
- Use descriptive test names
