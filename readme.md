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

### Technical Stack
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

## Documentation

- [Architecture Overview](docs/architecture.md) - System design and components
- [Development Guide](docs/development.md) - Development workflow and guidelines
- [Database Guide](docs/database.md) - Database setup and management
- [Testing Guide](docs/testing.md) - Testing strategy and procedures
- [API Documentation](docs/api.md) - API endpoints and usage
- [Data Collection](docs/data-collection.md) - Reddit data collection process

## Project Structure

```
reddit-web-scraper/
├── src/                    # Source code
│   ├── api/               # API routes and controllers
│   ├── config/            # Configuration files
│   ├── db/               # Database related files
│   ├── services/         # Core business logic
│   ├── types/            # TypeScript type definitions
│   └── utils/            # Shared utilities
├── tests/                # Test files
│   ├── mocks/           # Mock implementations for testing
│   └── *.ts             # Test files
├── docs/                # Documentation
└── package.json         # Project configuration
```

For detailed information about the project's development phases and roadmap, see [Development Phases](docs/development-phases.md).

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 