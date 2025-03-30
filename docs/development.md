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

1. **Reddit Collector** (`src/services/reddit-collector.ts`)
   - Coordinates the data collection process
   - Manages scheduling and error handling
   - Orchestrates scraping and storage operations

2. **Reddit Scraper** (`src/services/reddit-scraper.ts`)
   - Handles Reddit API interactions
   - Implements rate limiting and retry logic
   - Transforms API responses into domain models

3. **Reddit Storage** (`src/services/reddit-storage.ts`)
   - Manages database operations
   - Handles data persistence
   - Implements data deduplication

4. **Keyword Extractor** (`src/services/keyword-extractor.ts`)
   - Analyzes comments for relevant keywords
   - Implements frequency-based weighting
   - Excludes common words and noise

5. **User Tracker** (`src/services/user-tracker.ts`)
   - Tracks post authors and top commenters
   - Maintains contribution scores
   - Identifies key community members

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
