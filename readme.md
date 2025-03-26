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

[To be added: Setup instructions]

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