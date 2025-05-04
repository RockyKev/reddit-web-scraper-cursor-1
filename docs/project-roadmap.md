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
- [x] /api/digest 
  - [x] You can test mock data
  - [x] You can set the api to get from the database

- [x] Database Cleanup
  - [x] Review and remove redundant columns
  - [x] Consolidate similar tables if needed
  - [x] Standardize naming conventions
  - [x] Add proper constraints and foreign keys

- [x] Performance Optimization
  - [x] Add indexes for common queries
  - [x] Optimize table structures
  - [x] Implement connection pooling
  - [x] Add query caching where beneficial

- [x] Data Management
  - [x] Implement data retention policies
  - [x] Add data cleanup routines
  - [x] Create backup procedures
  - [x] Add data validation rules

- [x] Migration System
  - [x] Review and clean up migration history
  - [x] Consolidate migrations where possible
  - [x] Add proper rollback procedures
  - [x] Document migration process
  - [x] Migration System Decision
    - [x] Evaluate custom migration system vs node-pg-migrate
    - [x] Document pros and cons of each approach
    - [x] Make final decision and standardize on one system
    - [x] Migrate existing migrations to chosen system
    - [x] Update documentation and scripts

- [x] Start fetching data from the internet
  - [x] Have "npm run collect:live" fetch data
  - [x] That data then gets saved to postgres
  - [x] The other services get ran on that data for scoring/ranking
  - [x] Testing that the endpoint is pulling data from postgres
  - [x] Clean up the "backend/services" code and figure out what to do with all the debugging code

## Version 6: Production Deployment
**Outcome**: A production-ready system running on a server with basic monitoring.

### Features
- [x] Script Management
  - [x] Review and standardize package.json scripts
    - [x] Tests: "test:[action]"
    - [x] Database: "db:[action]"
    - [x] API: "api:[action]"
    - [x] Frontend: "frontend:[action]"
  - [x] Document all script purposes and usage
  - [x] Update development.md with script documentation


- [ ] Basic Security
  - [ ] Set up security headers
  - [ ] Configure basic rate limiting
  - [ ] Implement basic input validation

- [ ] Server Setup
  - [ ] Basic Infrastructure
    - [ ] Set up Digital Ocean droplet
    - [ ] Configure Nginx as reverse proxy
    - [ ] Set up SSL certificates
  - [ ] Basic Monitoring
    - [ ] Set up application logging
    - [ ] Configure basic error tracking
    - [ ] Implement health check endpoint

- [ ] Frontend Production Setup
  - [ ] Basic Build
  - [ ] Environment


- [ ] Database Deployment
  - [ ] Basic Setup
    - [ ] Set up production PostgreSQL
    - [ ] Configure basic database backups
    - [ ] Set up basic monitoring
  - [ ] Basic Security
    - [ ] Set up database access controls
    - [ ] Configure SSL for database connections

- [ ] Automated Collection
  - [ ] Basic Setup
    - [ ] Create collection script
    - [ ] Set up systemd service
    - [ ] Configure cron job (4:30 AM EST)
  - [ ] Basic Monitoring
    - [ ] Set up basic logging
    - [ ] Configure error notifications


## Version 7: Enhanced Monitoring & Security
**Outcome**: Improved monitoring, security, and maintenance capabilities.

### Features
- [ ] Advanced Monitoring
  - [ ] Set up detailed application monitoring
  - [ ] Configure performance tracking
  - [ ] Implement detailed error tracking
  - [ ] Set up alerting system

- [ ] Enhanced Security
  - [ ] Implement advanced rate limiting
  - [ ] Set up intrusion detection
  - [ ] Configure advanced access controls
  - [ ] Implement security logging

- [ ] Maintenance
  - [ ] Create cleanup procedures
  - [ ] Set up data retention policies
  - [ ] Implement backup verification
  - [ ] Configure maintenance windows

- [ ] Frontend Enhancements
  - [ ] Implement asset optimization
  - [ ] Configure cache control headers
  - [ ] Set up CDN integration
  - [ ] Configure performance monitoring

- [ ] Database Management
  - [ ] Create migration strategy for production
  - [ ] Set up data validation
  - [ ] Configure performance monitoring
  - [ ] Implement disaster recovery plan

## Version 8: Export & Integration
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

## Version 9: AI Enhancement
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