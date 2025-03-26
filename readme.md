# Reddit PDX Scraper

A TypeScript + Node.js web application that tracks daily Reddit posts and comments from Portland-related subreddits. The application stores post and comment data in PostgreSQL, providing a frontend dashboard to view and filter the collected data.

## Project Overview

The project consists of two main components:
1. A Core API service for data collection and management
2. A Frontend web interface for data visualization

## Development Phases

### Phase 1: Core API Development
- [ ] API service setup with PostgreSQL
- [ ] Reddit scraping implementation with retry logic
- [ ] Database schema and data storage
- [ ] Logging system
- [ ] Basic API endpoints with OpenAPI specification
- [ ] Data collection scheduling (4:30 AM EST daily)

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

[To be added: Development guidelines]

## API Documentation

[To be added: API endpoint documentation]

## License

[To be added: License information]

## Project Structure

```
reddit-web-scraper/
├── .gitignore
├── package.json
├── tsconfig.json
├── src/
│   ├── api/
│   ├── config/
│   ├── models/
│   ├── services/
│   └── utils/
├── tests/
├── docs/
└── scripts/
``` 