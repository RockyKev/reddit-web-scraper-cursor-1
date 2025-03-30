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
  - [ ] Add keyword extraction to data collection pipeline
  - [ ] Include top keywords in daily digest
  - [ ] Add keyword filtering to API

## Version 3: User Analytics
**Outcome**: Track and analyze user contributions across subreddits.

### Features
- [x] User Tracking
  - [x] Create users table with contribution metrics
  - [x] Track post authors and commenters
  - [x] Calculate user scores based on contributions
  - [x] Add user statistics to daily digest

## Version 4: Web Interface
**Outcome**: A functional web interface for viewing daily digests and analytics.

### Features
- [ ] Basic Authentication
  - [ ] User registration and login
  - [ ] JWT token authentication
  - [ ] Protected API routes

- [ ] Daily Digest View
  - [ ] Post list with sorting/filtering
  - [ ] Direct links to Reddit posts

## Version 5: Database Optimization
**Outcome**: A clean, efficient, and well-organized database structure ready for production.

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

## Version 6: Production Deployment
**Outcome**: A production-ready system running on a server with automated data collection.

### Features
- [ ] Server Setup
  - [ ] Set up Digital Ocean droplet
  - [ ] Configure Nginx as reverse proxy
  - [ ] Set up SSL certificates
  - [ ] Configure firewall rules

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