# Reddit PDX Scraper

A TypeScript + Node.js web application that creates a daily digest of the best Reddit content from Portland-related subreddits. The application collects, analyzes, and serves top posts and comments through a RESTful API, with plans for various output formats (web, RSS, Slack, email, mobile app).

## Project Overview

The project consists of two main components:
1. A Core API service for data collection, analysis, and delivery
2. A Frontend web interface for viewing the daily digest

### Key Features
- Daily collection of posts and comments from configured Portland subreddits
- Intelligent scoring system for identifying top content
- Keyword extraction from text using TF-IDF
- User contribution tracking
- Configurable thresholds and limits
- Future AI-powered summaries and sentiment analysis

### Future Roadmap
- RSS feed generation
- Slack bot integration
- Email digest delivery
- Mobile app development
- AI-powered post and comment summaries
- Sentiment analysis for posts and comments

For detailed information about the project's development phases and roadmap, see [Development Phases](docs/development-phases.md).

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
│   │   └── api.ts        # API routes and controllers
│   ├── config/            # Configuration files
│   │   ├── database.ts    # Database configuration
│   │   └── migrations.ts  # Migration configuration
│   ├── db/               # Database related files
│   │   └── migrations/   # Database migrations
│   ├── services/         # Core business logic
│   │   ├── reddit-collector.ts  # Main data collection service
│   │   ├── reddit-scraper.ts    # Reddit API interaction
│   │   ├── reddit-storage.ts    # Database operations
│   │   ├── keyword-extractor.ts # Comment keyword analysis
│   │   └── user-tracker.ts      # User contribution tracking
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

4. **Keyword Extractor** (`src/services/keyword-extractor.ts`)
   - Analyzes comments for relevant keywords
   - Implements frequency-based weighting
   - Excludes common words and noise

5. **User Tracker** (`src/services/user-tracker.ts`)
   - Tracks post authors and top commenters
   - Maintains contribution scores
   - Identifies key community members

6. **Database Migrations** (`src/db/migrations/`)
   - Manages database schema changes
   - Handles version control of database structure
   - Provides rollback capabilities

## API Documentation

The API provides endpoints for accessing the daily digest of top Reddit content:

### GET /api/digest
Returns the daily digest of top posts and comments.

Query Parameters:
- `date`: Optional date in YYYY-MM-DD format. If not provided, returns the current day's digest.

Example Response:
```json
{
  "date": "2024-03-20",
  "summary": {
    "total_posts": 150,
    "total_comments": 1200,
    "top_subreddits": ["r/Portland", "r/askportland"]
  },
  "top_posts": [
    {
      "id": "abc123",
      "subreddit": "r/Portland",
      "title": "Post Title",
      "type": "text",
      "upvotes": 500,
      "comment_count": 100,
      "permalink": "https://reddit.com/...",
      "keywords": ["keyword1", "keyword2", "keyword3"],
      "author": {
        "username": "PDX_Dave",
        "contribution_score": 2
      },
      "top_commenters": [
        {
          "username": "CatLadySarah",
          "contribution_score": 5
        }
      ],
      "summary": null,
      "sentiment": null
    }
  ]
}
```

## License

[To be added: License information] 