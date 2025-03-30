# Development Roadmap

## Version 1: Core Data Collection (Completed)
**Outcome**: A working system that collects and stores Reddit posts and comments from Portland subreddits.

### Completed Features
- [x] PostgreSQL database setup with Docker
- [x] Reddit API integration with rate limiting
- [x] Daily data collection (4:30 AM EST)
- [x] Basic post and comment storage
- [x] Daily digest API endpoint
- [x] Test framework with Jest
- [x] Database management scripts

## Version 2: Data Analysis Foundation
**Outcome**: A system that can analyze and score posts based on engagement metrics.

### Features
- [x] Post Scoring System
  - [x] Implement scoring formula: `score = (upvotes * 1.0) + (comments * 2.0)`
  - [x] Add configurable weights in database
  - [x] Create scoring service with unit tests
  - [x] Add scoring to daily digest API response

- [x] Keyword Analysis
  - [x] Implement keyword extraction using natural library
    - [x] Create KeywordExtractor service
    - [x] Add unit tests for basic functionality
    - [x] Use TF-IDF for keyword extraction
  - [x] Integrate with data collection
    - [x] Get top comments based on upvotes (using TOP_COMMENTERS_PER_POST)
    - [x] Extract keywords from post title, content, and top comments
    - [x] Store keywords array in posts table
  - [x] Include keywords in daily digest API response

## Version 3: User Analytics
**Outcome**: Track and analyze user contributions across subreddits.

### Features
- [x] User Tracking
  - [x] Create users table with contribution metrics
  - [x] Track post authors and commenters
  - [x] Calculate user scores based on contributions
  - [x] Add user statistics to daily digest

## Version 4: Web Interface with Mock Data
**Outcome**: A functional web interface for viewing daily digests using mock data, with a clean and simple layout.

### Features
- [x] Mock Data Integration
  - [x] Set up mock data structure based on testdata-reddit-portland-output.json
  - [x] Create mock data service for development
  - [x] Implement mock data endpoints matching live API structure
  - [x] Add mock keyword extraction for posts

- [x] Daily Digest API Endpoint
  - [x] Create /api/digest endpoint
  - [x] Return mock data in required format:
    - Date
    - Summary statistics (total_posts, total_comments, subreddits)
    - Posts ordered by daily_rank
    - Each post with:
      - Title
      - Subreddit
      - Author and contribution score
      - Content
      - Score and score ratio
      - Permalink
      - Keywords

- [x] Frontend Development
  - [x] Set up development environment:
    - [x] Configure Vite for frontend development
    - [x] Set up proxy to API in Vite config
    - [x] Add hot module replacement
    - [x] Configure TypeScript support
  - [x] Create clean, simple layout using Tailwind CSS
  - [x] Add components:
    - [x] Date header (h1)
    - [x] Summary statistics paragraph
    - [x] Post cards with all required information
    - [x] Links to Reddit posts
  - [x] Implement responsive grid layout
  - [x] Add basic styling for readability
  - [x] Set up development scripts:
    - [x] `npm run dev` for Vite development server
    - [x] `npm run build` for production build
    - [x] `npm run preview` for production preview

- [x] Data Display
  - [x] Show posts up to POSTS_PER_SUBREDDIT * number of subreddits
  - [x] Display post cards in order of daily_rank
  - [x] Show keywords for each post
  - [x] Include all required post metadata
  - [x] Add links to original Reddit posts

- [x] Development Workflow
  - [x] Set up hot reloading for development
  - [x] Add basic error handling
  - [x] Implement logging for debugging
  - [x] Create development scripts

### Technical Requirements
- [x] Use mock data from testdata-reddit-portland-output.json
- [x] Implement simple, clean UI with Tailwind CSS
- [x] Focus on functionality over fancy design
- [x] Mobile responsiveness (implemented despite not being required)
- [x] Use environment variables for configuration
- [x] Follow existing project structure and conventions

### Success Criteria
- [x] Home page loads and displays mock data correctly
- [x] All required post information is visible
- [x] Posts are properly ordered by daily_rank
- [x] Links to Reddit posts work correctly
- [x] Basic layout is clean and readable
- [x] Development workflow is smooth and efficient

## Version 5: Database Optimization
**Outcome**: A clean, efficient, and well-organized project ready for production.

### Features
- [ ] Database Cleanup
  - [ ] Review and remove redundant columns
  - [ ] Consolidate similar tables if needed
  - [ ] Standardize naming conventions
  - [ ] Add proper constraints and foreign keys

- [ ] Performance Optimization
  - [ ] Add indexes for common queries
  - [ ] Optimize table structures
  - [ ] Implement connection pooling
  - [ ] Add query caching where beneficial

- [ ] Data Management
  - [ ] Implement data retention policies
  - [ ] Add data cleanup routines
  - [ ] Create backup procedures
  - [ ] Add data validation rules

- [ ] Migration System
  - [ ] Review and clean up migration history
  - [ ] Consolidate migrations where possible
  - [ ] Add proper rollback procedures
  - [ ] Document migration process
  - [ ] Migration System Decision
    - [ ] Evaluate custom migration system vs node-pg-migrate
    - [ ] Document pros and cons of each approach
    - [ ] Make final decision and standardize on one system
    - [ ] Migrate existing migrations to chosen system
    - [ ] Update documentation and scripts

- [ ] Start fetching data from the internet
  - [ ] Testing that the endpoint works

- [ ] Review all the package.json scripts
  - [ ] tests start with "test:[action]"
  - [ ] database actions start with "db:[action]"
  - [ ] api endpoint actions start with "api:[action]"
  - [ ] frontend actions start with "frontend:[action]"
  - [ ] anything that's not related to any of them should be reviewed

## Version 6: Production Deployment
**Outcome**: A production-ready system running on a server with automated data collection.

### Features
- [ ] Server Setup
  - [ ] Set up Digital Ocean droplet
  - [ ] Configure Nginx as reverse proxy
  - [ ] Set up SSL certificates
  - [ ] Configure firewall rules

- [ ] Frontend Production Setup
  - [ ] Configure Express to serve static files
  - [ ] Set up build process for frontend
  - [ ] Configure proper routing
  - [ ] Set up environment variables for production
  - [ ] Configure CORS for production domain

- [ ] Database Deployment
  - [ ] Set up production PostgreSQL
  - [ ] Configure database backups
  - [ ] Set up monitoring
  - [ ] Implement connection pooling

- [ ] Automated Collection
  - [ ] Create collection script
  - [ ] Set up systemd service
  - [ ] Configure cron job (4:30 AM EST)
  - [ ] Add logging and monitoring
  - [ ] Set up error notifications

## Version 7: Export & Integration
**Outcome**: Multiple ways to access and export the data.

### Features
- [ ] Data Export
  - [ ] CSV export for posts and comments
  - [ ] JSON API for historical data
  - [ ] Custom date range selection
  - [ ] Batch export functionality

- [ ] External Integrations
  - [ ] RSS feed generation
  - [ ] Slack bot for daily updates
  - [ ] Email digest delivery
  - [ ] Webhook support for updates

## Version 8: AI Enhancement
**Outcome**: Intelligent content analysis and summarization.

### Features
- [ ] Content Analysis
  - [ ] Post summarization using AI
  - [ ] Sentiment analysis for posts/comments
  - [ ] Topic categorization
  - [ ] Content quality scoring

- [ ] Mobile Experience
  - [ ] Responsive web design
  - [ ] Progressive Web App support
  - [ ] Mobile-optimized views
  - [ ] Push notifications

## Future Considerations
- Advanced filtering and search
- Custom subreddit monitoring
- User preferences and customization
- API rate limiting and quotas
- Caching layer for performance
- Automated testing improvements 