# Development Guide

This document provides comprehensive information for developers working on the Reddit PDX Scraper project.

## Development Workflow

### 1. Setting Up Your Environment

1. **Fork and Clone**
   ```bash
   git clone https://github.com/yourusername/reddit-web-scraper.git
   cd reddit-web-scraper
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Set Up Environment Variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your configuration values.

4. **Start Development Services**
   ```bash
   docker-compose up -d
   npm run migrate:up
   ```

### 2. Development Process

1. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Write code following the project's style guide
   - Add tests for new functionality
   - Update documentation as needed

3. **Run Tests**
   ```bash
   npm test
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: description of your changes"
   ```

5. **Push Changes**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Go to GitHub and create a new PR
   - Fill in the PR template
   - Request review from team members

## Available Scripts

### Development
- `npm run dev` - Start development server with hot reload
- `npm run build` - Build the project for production
- `npm start` - Start production server
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

### Testing
- `npm test` - Run all tests
- `npm run test:scraper` - Test Reddit scraper functionality
- `npm run test:db` - Test database operations
- `npm run test:watch` - Run tests in watch mode
- `npm run test:coverage` - Generate test coverage report

### Database
- `npm run migrate:up` - Apply pending migrations
- `npm run migrate:down [n]` - Roll back n migrations
- `npm run migrate:status` - Check migration status
- `npm run db:reset` - Reset database (drops and recreates)

### Data Collection
- `npm run collect:live` - Collect data from Reddit
- `npm run calculate:scores` - Recalculate scores and ranks for a date

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
