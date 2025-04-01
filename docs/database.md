# Database Guide

This document provides comprehensive information about the database setup, schema, and management for the Reddit PDX Scraper project.

## Quick Start

### Prerequisites
- Node.js v23.10.0 or higher
- Docker Desktop
- PostgreSQL (provided via Docker)

### Initial Setup
1. Start the database:
   ```bash
   docker-compose up -d
   ```

2. Run migrations:
   ```bash
   npm run migrate:up
   ```

## Database Configuration

The project uses PostgreSQL running in a Docker container with the following default credentials:
- Host: localhost
- Port: 5432
- Database: reddit_scraper
- Username: reddit_scraper
- Password: reddit_scraper_password

## Docker Commands

Common Docker commands for managing the database:

### Starting the Database
```bash
docker-compose up -d
```

### Stopping the Database
```bash
docker-compose down
```

### Viewing Database Logs
```bash
docker-compose logs postgres
```

### Restarting the Database
```bash
docker-compose restart postgres
```

## Database Schema

### Core Tables

#### Subreddits
- `id`: UUID (Primary Key)
- `name`: VARCHAR(255)
- `display_name`: VARCHAR(255)
- `description`: TEXT
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

#### Posts
- `id`: UUID (Primary Key)
- `subreddit_id`: UUID (Foreign Key)
- `reddit_id`: VARCHAR(255)
- `title`: VARCHAR(500)
- `selftext`: TEXT (Post content for text posts)
- `url`: VARCHAR(1000) (Post URL for link posts)
- `score`: INTEGER
- `num_comments`: INTEGER
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP
- `reddit_created_at`: TIMESTAMP
- `is_archived`: BOOLEAN
- `is_locked`: BOOLEAN
- `post_type`: VARCHAR(50) (Determines which field contains the main content: 'text' uses selftext, 'link' uses url)
- `daily_rank`: FLOAT
- `daily_score`: FLOAT
- `author_id`: UUID (Foreign Key to Users)
- `keywords`: TEXT[]
- `author_score`: FLOAT
- `top_commenters`: JSONB
- `summary`: TEXT
- `sentiment`: JSONB

#### Comments
- `id`: UUID (Primary Key)
- `post_id`: UUID (Foreign Key)
- `reddit_id`: VARCHAR(255)
- `body`: TEXT
- `score`: INTEGER
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP
- `reddit_created_at`: TIMESTAMP
- `is_archived`: BOOLEAN
- `is_top_comment`: BOOLEAN
- `author_id`: UUID (Foreign Key to Users)
- `contribution_score`: FLOAT

#### Users
- `id`: UUID (Primary Key)
- `username`: VARCHAR(255)
- `total_posts`: INTEGER
- `total_comments`: INTEGER
- `total_posts_score`: INTEGER
- `total_comments_score`: INTEGER
- `contributor_score`: INTEGER
- `first_seen`: TIMESTAMP
- `last_seen`: TIMESTAMP
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

### Supporting Tables

#### User Contributions
- `id`: UUID (Primary Key)
- `user_id`: UUID (Foreign Key to Users)
- `post_id`: UUID (Foreign Key to Posts)
- `comment_id`: UUID (Foreign Key to Comments)
- `contribution_type`: VARCHAR(50)
- `score`: INTEGER
- `created_at`: TIMESTAMP

### Indexes

The database includes several indexes to optimize query performance:
- `subreddits_name_idx`: Index on subreddit name
- `posts_subreddit_id_idx`: Index on post's subreddit ID
- `posts_reddit_id_idx`: Index on post's Reddit ID
- `posts_author_id_idx`: Index on post's author ID
- `posts_daily_rank_idx`: Index on post's daily rank
- `posts_keywords_idx`: GIN index on post keywords
- `posts_sentiment_idx`: GIN index on post sentiment
- `posts_top_commenters_idx`: GIN index on top commenters
- `comments_post_id_idx`: Index on comment's post ID
- `comments_reddit_id_idx`: Index on comment's Reddit ID
- `comments_author_id_idx`: Index on comment's author ID
- `comments_contribution_score_idx`: Index on contribution score
- `users_username_idx`: Index on username
- `user_contributions_user_id_idx`: Index on user contributions

## Database Migrations

The project uses a custom migration system built with TypeScript to manage database schema changes. This system provides a robust way to track and apply database changes across all environments.

### Migration Structure

Migrations are stored in `src/db/migrations` and follow a timestamp-based naming convention:
```
YYYYMMDDHHMMSS_migration_name.sql
```

Each migration file can contain two sections:
1. Up Migration: Contains the changes to apply
2. Down Migration: Contains the rollback changes (optional)

Example migration file:
```sql
-- Up Migration
ALTER TABLE posts ADD COLUMN new_column TEXT;

-- Down Migration
ALTER TABLE posts DROP COLUMN new_column;
```

### Available Commands

#### Apply Migrations
```bash
npm run migrate:up
```
Runs any pending migrations to update the database schema.

#### Rollback Migrations
```bash
npm run migrate:down [n]
```
Rolls back the specified number of migrations (default: 1). Useful for fixing mistakes.

#### Check Migration Status
```bash
npm run migrate:status
```
Shows which migrations have been run and which are pending.

#### Reset Database
```bash
npm run db:reset
```
Drops and recreates the database, then runs all migrations. Useful for development and testing.

### Migration Tracking

The system maintains a `migrations` table in the database to track which migrations have been applied:
```sql
CREATE TABLE migrations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### Best Practices

1. Always include a down migration when possible to support rollbacks
2. Use transactions in migrations to ensure atomic changes
3. Test migrations in a development environment before applying to production
4. Keep migrations focused and atomic - one logical change per migration
5. Use meaningful names for migration files that describe the changes

### Error Handling

The migration system includes built-in error handling:
- Each migration runs in a transaction
- If a migration fails, all changes are rolled back
- The migration status is only updated after successful completion
- Detailed error messages are provided for troubleshooting

## Development Workflow

1. Start the database:
   ```bash
   docker-compose up -d
   ```

2. Reset the database (if needed):
   ```bash
   npm run db:reset
   ```

3. Run database tests:
   ```bash
   npm run test:db
   ```

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Ensure Docker is running
   - Check if the database container is up: `docker ps`
   - Verify environment variables in `.env`

2. **Migration Errors**
   - Check migration file syntax
   - Ensure all required tables exist
   - Verify foreign key constraints

3. **Permission Issues**
   - Ensure correct database user permissions
   - Check Docker volume permissions

For additional support, please refer to the project's issue tracker or contact the development team. 