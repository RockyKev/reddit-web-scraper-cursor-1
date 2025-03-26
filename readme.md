# Reddit PDX Scraper

A TypeScript + Node.js web application that tracks daily Reddit posts and comments from Portland-related subreddits. The application stores post and comment data in PostgreSQL, providing a frontend dashboard to view and filter the collected data.

## Project Overview

The project consists of two main components:
1. A Core API service for data collection and management
2. A Frontend web interface for data visualization

## Development Phases

### Phase 1: Core API Development
- [x] API service setup with PostgreSQL
- [x] Reddit scraping implementation with retry logic
- [x] Database schema and data storage
- [x] Logging system
- [ ] Basic API endpoints with OpenAPI specification
- [x] Data collection scheduling (4:30 AM EST daily)

### Phase 2: Frontend Implementation
- [ ] Basic authentication system
- [ ] Data display and filtering interface
- [ ] Post type tracking and categorization
- [ ] Basic data export functionality (CSV/JSON)
- [ ] User-friendly dashboard

### Phase 3: Enhanced Features
- [ ] Keyword extraction from posts and comments
- [ ] Basic sentiment analysis
- [ ] Data visualization and trends
- [ ] Advanced API features
- [ ] Multi-subreddit support

## Technical Stack

- **Backend**: Node.js + TypeScript
- **Database**: PostgreSQL
- **API Documentation**: OpenAPI/Swagger
- **Frontend**: Server-rendered approach
- **Deployment**: Digital Ocean

## Getting Started

### Prerequisites

1. **Node.js and npm**
   - Install Node.js v23 from [nodejs.org](https://nodejs.org/)
   - npm comes bundled with Node.js

2. **Docker Desktop**
   - Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/)
   - Required for running PostgreSQL locally

3. **Reddit API Credentials**
   - Create a Reddit application at [reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
   - Note down the client ID and client secret

### Initial Setup

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your Reddit API credentials and other configuration values.

3. **Start the database and run migrations**
   ```bash
   docker-compose up -d
   npm run migrate:up
   ```

4. **Start the development server**
   ```bash
   npm run dev
   ```

For detailed database setup and management instructions, see [Database Documentation](docs/database.md).

## Development

### Project Structure

```
reddit-web-scraper/
├── src/                    # Source code
│   ├── api/               # API routes and controllers
│   ├── config/            # Configuration files
│   │   ├── database.ts    # Database configuration
│   │   └── migrations.ts  # Migration configuration
│   ├── db/               # Database related files
│   │   └── migrations/   # Database migrations
│   ├── services/         # Core business logic
│   │   ├── reddit-collector.ts  # Main data collection service
│   │   ├── reddit-scraper.ts    # Reddit API interaction
│   │   └── reddit-storage.ts    # Database operations
│   ├── types/            # TypeScript type definitions
│   └── utils/            # Shared utilities
│       └── logger.ts     # Logging utility
├── tests/                # Test files
│   ├── mocks/           # Mock implementations for testing
│   └── *.ts             # Test files
├── docs/                # Documentation
│   ├── architecture.md  # System architecture
│   └── reddit-data-collection.md  # Data collection details
└── package.json         # Project configuration
```

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build the project
- `npm start` - Start production server
- `npm test` - Run tests
- `npm run test:scraper` - Test Reddit scraper functionality
- `npm run test:db` - Test database operations
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier
- `npm run migrate:*` - Database migration commands

### Key Components

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

4. **Database Migrations** (`src/db/migrations/`)
   - Manages database schema changes
   - Handles version control of database structure
   - Provides rollback capabilities

## API Documentation

[To be added: API endpoint documentation]

## License

[To be added: License information] 