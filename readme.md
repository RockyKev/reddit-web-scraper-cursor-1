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
- **Frontend**: Vanilla JavaScript with TypeScript, Tailwind CSS
- **Development**: Vite
- **Deployment**: Digital Ocean

## Prerequisites
1. **Node.js and npm**
  - Install Node.js v23 from [nodejs.org](https://nodejs.org/)
   - npm comes bundled with Node.js

2. **Docker Desktop**
   - Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/)
   - Required for running PostgreSQL locally

3. **Reddit API Credentials**
   - Create a Reddit application at [reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
   - Note down the client ID and client secret

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd reddit-web-scraper
   ```

2. Install dependencies:
   ```bash
   # Install backend dependencies
   npm install

   # Install frontend dependencies
   cd frontend
   npm install
   ```

3. Set up environment variables:
   ```bash
   # Backend (.env)
   PORT=3000
   FRONTEND_URL=http://localhost:5173
   NODE_ENV=development
   
   # Reddit API Credentials
   REDDIT_CLIENT_ID=your_client_id_here
   REDDIT_CLIENT_SECRET=your_client_secret_here
   REDDIT_USER_AGENT=your_user_agent_here
   
   # Database Configuration
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=reddit_scraper
   DB_USER=reddit_scraper
   DB_PASSWORD=reddit_scraper_password
   DATABASE_URL=postgresql://reddit_scraper:reddit_scraper_password@localhost:5432/reddit_scraper

   # Frontend (frontend/.env)
   VITE_API_URL=http://localhost:3000
   ```

4. Start the development servers:
   ```bash
   # Start backend server (from project root)
   npm run api:start

   # Start frontend server (from frontend directory)
   cd frontend
   npm run dev
   ```

5. Open your browser and navigate to:
   ```
   http://localhost:5173
   ```

## Project Structure

```
reddit-web-scraper/
├── frontend/           # Frontend application
│   ├── src/           # Source files
│   ├── public/        # Static assets
│   └── index.html     # Main HTML file
├── src/               # Backend source files
│   ├── api/          # API routes and controllers
│   ├── config/       # Configuration files
│   ├── services/     # Business logic
│   └── utils/        # Utility functions
├── data/             # Mock data files
└── docs/             # Documentation
```

## Documentation

- [Architecture Overview](docs/architecture.md) - System design and components
- [Development Guide](docs/development.md) - Development workflow and guidelines
- [Database Guide](docs/database.md) - Database setup and management
- [Testing Guide](docs/testing.md) - Testing strategy and procedures
- [API Documentation](docs/api.md) - API endpoints and usage
- [Data Collection](docs/data-collection.md) - Reddit data collection process

For detailed information about the project's development phases and roadmap, see [Development Phases](docs/development-phases.md).

## Development

- Backend runs on `http://localhost:3000`
- Frontend runs on `http://localhost:5173`
- API endpoints are prefixed with `/api`
- Mock data is used for development

## API Endpoints

- `GET /api/digest` - Get the daily digest of Reddit posts
- `GET /api/digest/2025-03-20` - Get the March 3, 2025 post.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 