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

### Technical Stack
- **Backend**: Node.js + TypeScript
- **Database**: PostgreSQL
- **API Documentation**: OpenAPI/Swagger
- **Frontend**: Vanilla JavaScript with TypeScript, Tailwind CSS
- **Development**: Vite
- **Deployment**: Digital Ocean

## Quick Start

1. **Prerequisites**
   - Node.js v20.x (LTS) or higher
   - Docker Desktop
   - Reddit API credentials

2. **Setup**
   ```bash
   # Clone and install
   git clone <repository-url>
   cd reddit-web-scraper
   npm install
   cd frontend && npm install

   # Start services
   docker-compose up -d
   npm run db:migrate:up // migrate
   npm run collect:live // get new data
   npm run api:start // start api
   npm run frontend:dev // start frontend
   ```

3. **Access**
   - Frontend: http://localhost:5173
   - API: http://localhost:3000

## Documentation

- [Architecture Overview](docs/architecture.md) - System design and components
- [Development Guide](docs/development.md) - Development workflow and guidelines
- [Database Guide](docs/database.md) - Database setup and management
- [Testing Guide](docs/testing.md) - Testing strategy and procedures
- [API Documentation](docs/api.md) - API endpoints and usage

## Project Structure

```
reddit-web-scraper/
├── frontend/                 # Frontend application
├── backend/                  # Backend application
├── database/                # Database migrations
├── tests/                   # Test files
├── docs/                    # Documentation
└── scripts/                 # Project-wide scripts
```

For detailed information about the project structure and components, see [Architecture Overview](docs/architecture.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 