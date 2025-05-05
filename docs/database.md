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
- `description`: TEXT
- `created_at`: TIMESTAMP WITH TIME ZONE
- `updated_at`: TIMESTAMP WITH TIME ZONE

#### Posts
- `id`: UUID (Primary Key)
- `subreddit_id`: UUID (Foreign Key)
- `author_id`: VARCHAR(255) (Foreign Key to Users)
- `title`: TEXT
- `content_url`: TEXT (Post content or URL)
- `score`: INTEGER
- `num_comments`: INTEGER
- `permalink`: TEXT
- `created_at`: TIMESTAMP WITH TIME ZONE
- `updated_at`: TIMESTAMP WITH TIME ZONE
- `reddit_created_at`: TIMESTAMP WITH TIME ZONE
- `is_archived`: BOOLEAN
- `is_locked`: BOOLEAN
- `post_type`: VARCHAR(50) ('text', 'link', 'image', 'hosted:video')
- `daily_rank`: INTEGER
- `daily_score`: FLOAT
- `keywords`: TEXT[]
- `author_score`: FLOAT
- `top_commenters`: JSONB
- `summary`: TEXT
- `sentiment`: JSONB

#### Comments
- `id`: UUID (Primary Key)
- `post_id`: UUID (Foreign Key)
- `author_id`: VARCHAR(255) (Foreign Key to Users)
- `content`: TEXT
- `score`: INTEGER
- `contribution_score`: FLOAT
- `created_at`: TIMESTAMP WITH TIME ZONE
- `updated_at`: TIMESTAMP WITH TIME ZONE
- `reddit_created_at`: TIMESTAMP WITH TIME ZONE
- `is_archived`: BOOLEAN
- `reddit_id`: VARCHAR(255)

#### Users
- `id`: VARCHAR(255) (Primary Key)
- `username`: VARCHAR(255)
- `total_posts`: INTEGER
- `total_comments`: INTEGER
- `total_posts_score`: INTEGER
- `total_comments_score`: INTEGER
- `contributor_score`: FLOAT
- `first_seen`: TIMESTAMP WITH TIME ZONE
- `last_seen`: TIMESTAMP WITH TIME ZONE
- `created_at`: TIMESTAMP WITH TIME ZONE
- `updated_at`: TIMESTAMP WITH TIME ZONE

### Indexes

The database includes several indexes to optimize query performance:
- `idx_posts_subreddit_id`: Index on post's subreddit ID
- `idx_posts_author_id`: Index on post's author ID
- `idx_posts_created_at`: Index on post's creation date
- `idx_posts_reddit_created_at`: Index on post's Reddit creation date
- `idx_posts_daily_rank`: Index on post's daily rank
- `idx_posts_keywords`: GIN index on post keywords
- `idx_posts_sentiment`: GIN index on post sentiment
- `idx_posts_top_commenters`: GIN index on top commenters
- `idx_comments_post_id`: Index on comment's post ID
- `idx_comments_author_id`: Index on comment's author ID
- `idx_comments_created_at`: Index on comment's creation date
- `idx_comments_reddit_created_at`: Index on comment's Reddit creation date
- `idx_comments_contribution_score`: Index on contribution score
- `idx_users_username`: Index on username

## Database Migrations

The project uses `node-pg-migrate` to manage database schema changes. This system provides a robust way to track and apply database changes across all environments.

### Migration Structure

Migrations are stored in `database/migrations` and follow a timestamp-based naming convention:
```
YYYYMMDDHHMMSS_migration_name.sql
```

Each migration file contains SQL statements for both up and down migrations.

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

### Best Practices

1. Always include a down migration to support rollbacks
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