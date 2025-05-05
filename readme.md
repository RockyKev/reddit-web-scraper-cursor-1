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

### Local Development

1. **Prerequisites**
   - Node.js v20.x (LTS) or higher
   - Docker Desktop

2. **Setup**
   ```bash
   # Clone and install
   git clone <repository-url>
   cd reddit-web-scraper
   npm install
   cd frontend && npm install

   # Start services
   docker-compose up -d
   npm run db:migrate:up // any migration work
   npm run api:start // starts api server
   npm run frontend:dev // starts frontend server
   ```

3. **Access**
   - Frontend: http://localhost:5173
   - API: http://localhost:3000

### Server Deployment

1. **Initial Setup**
   ```bash
   # Clone repository
   git clone <repository-url>
   cd reddit-web-scraper

   # Install only production dependencies
   npm install --production

   # Build the application
   npm run api:build
   npm run frontend:build
   ```

2. **Database Setup**
   ```bash
   # Set up the database
   npm run db:setup
   npm run db:migrate:up
   ```

3. **Start Services**
   ```bash
   # Start the API server
   npm run api:prod

   # Start the frontend server (if needed)
   cd frontend
   npm install --production
   npm run build
   npm run preview
   ```

4. **Data Collection**
   ```bash
   # Collect initial data
   npm run api:collect:live

   # Set up automated collection (optional)
   # Add to crontab: 0 4 * * * cd /path/to/project && npm run api:collect:live
   ```

### Important Notes

- Local development uses `ts-node` for on-the-fly compilation
- Server deployment uses pre-compiled JavaScript for better performance
- Always use `--production` flag when installing dependencies on the server
- Keep your `.env` file secure and never commit it to version control
- Database backups are available via `npm run db:backup`. There's some placeholder databases from prior scraping. 

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