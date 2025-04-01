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

## Key Components

### Core Services

1. **Reddit Scraper** (`backend/services/reddit-scraper.ts`)
   - Fetches posts and comments from Reddit's JSON API
   - Implements rate limiting and retry logic
   - Handles error cases and network issues
   - Returns structured data for posts and comments

2. **Reddit Collector** (`backend/services/reddit-collector.ts`)
   - Orchestrates the data collection process
   - Coordinates between scraper and storage
   - Manages subreddit processing
   - Handles error recovery and retries

3. **Reddit Storage** (`backend/services/reddit-storage.ts`)
   - Manages all database operations
   - Handles upserts for posts and comments
   - Maintains relationships between entities
   - Implements efficient query patterns

4. **Keyword Analysis** (`backend/services/keyword-analysis-service.ts`)
   - Coordinates keyword extraction process
   - Processes post content and comments
   - Integrates with keyword extractor
   - Manages analysis results

5. **Keyword Extractor** (`backend/services/keyword-extractor.ts`)
   - Implements TF-IDF algorithm
   - Filters stop words and common terms
   - Identifies significant keywords
   - Processes text normalization

6. **Scoring Service** (`backend/services/scoring-service.ts`)
   - Calculates user contribution scores
   - Processes post and comment metrics
   - Handles ranking algorithms
   - Manages score updates

7. **Digest Service** (`backend/services/digest-service.ts`)
   - Generates daily summaries
   - Aggregates statistics
   - Creates trend analysis
   - Manages digest scheduling

8. **Mock Data Service** (`backend/services/mock-data.service.ts`)
   - Provides test data for development
   - Simulates Reddit API responses
   - Generates realistic sample data
   - Supports testing scenarios

Each service follows these principles:
- Single Responsibility Principle
- Clear interface definitions
- Comprehensive error handling
- Detailed logging
- Type safety with TypeScript
- ESM module system
- Unit test coverage

### Data Flow

The data collection process starts with the `collect:live` script (`backend/scripts/collect-live-posts.ts`), which orchestrates the entire flow:

1. **Initialization**
   - Script reads configuration from `.env` (subreddits, limits, etc.)
   - Tests database connection
   - Sets up logging

2. **Data Collection Process**
   ```
   collect:live
   └── RedditCollector
       ├── RedditScraper (for each subreddit)
       │   └── Fetches posts and comments from Reddit API
       └── RedditStorage
           ├── Stores subreddits
           ├── Stores posts
           └── Stores comments
   ```

3. **Data Processing Pipeline**
   ```
   Raw Data → Storage → Analysis → API
   ```
   - **Raw Data**: Posts and comments from Reddit
   - **Storage**: PostgreSQL database tables
   - **Analysis**: 
     - Keyword extraction from posts/comments
     - User scoring and rankings
     - Daily digest generation
   - **API**: REST endpoints serving processed data

4. **Database Schema**
   ```
   subreddits
   └── posts
       └── comments
   ```
   - Each subreddit has many posts
   - Each post has many comments
   - All entities have timestamps and metadata

5. **API Access**
   - Data becomes available through REST endpoints
   - Endpoints serve processed and analyzed data
   - Frontend consumes API for display

The process runs on a schedule (default: daily at 4:30 AM EST) and can be triggered manually using:
```bash
npm run collect:live
```

### Database Management

The project uses a custom migration system for database changes:

1. **Creating Migrations**
   - Create a new migration file in `src/db/migrations`
   - Follow the naming convention: `YYYYMMDDHHMMSS_migration_name.sql`
   - Include both up and down migrations

2. **Applying Migrations**
   ```bash
   npm run migrate:up
   ```

3. **Rolling Back**
   ```bash
   npm run migrate:down 1  # Roll back one migration
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
