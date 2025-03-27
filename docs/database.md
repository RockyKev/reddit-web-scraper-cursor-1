# Database Documentation

This document provides detailed information about the database setup and management for the Reddit PDX Scraper project.

## Prerequisites

- Node.js v23.10.0 or higher
- Docker Desktop
- PostgreSQL (provided via Docker)

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

## Database Migrations

The project uses `node-pg-migrate` for database migrations. This ensures consistent database schema across all environments.

### Available Commands

#### Create a New Migration
```bash
npm run db:migrate-create <migration-name>
```
Creates a new migration file in `src/db/migrations` with a timestamp prefix.

#### Apply Migrations
```bash
npm run db:migrate-up
```
Runs any pending migrations to update the database schema.

#### Rollback Last Migration
```bash
npm run db:migrate-down
```
Reverses the most recent migration. Useful for fixing mistakes.

#### Check Migration Status
```bash
npm run db:migrate-status
```
Shows which migrations have been run and which are pending.

#### Reset Database
```bash
npm run db:reset
```
Drops and recreates the database, then runs all migrations. Useful for development and testing.

### Migration Workflow

1. Create a new migration:
   ```bash
   npm run db:migrate-create add_new_column
   ```

2. Edit the generated migration file in `src/db/migrations`:
   ```sql
   -- Up migration
   ALTER TABLE posts ADD COLUMN new_column TEXT;

   -- Down migration
   ALTER TABLE posts DROP COLUMN new_column;
   ```

3. Apply the migration:
   ```bash
   npm run db:migrate-up
   ```

4. If needed, rollback:
   ```bash
   npm run db:migrate-down
   ```

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

## Database Schema

The database schema includes the following main tables:

### Subreddits
- `id`: UUID (Primary Key)
- `name`: VARCHAR(255)
- `display_name`: VARCHAR(255)
- `description`: TEXT
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

### Posts
- `id`: UUID (Primary Key)
- `subreddit_id`: UUID (Foreign Key)
- `reddit_id`: VARCHAR(255)
- `title`: VARCHAR(500)
- `selftext`: TEXT
- `url`: VARCHAR(1000)
- `score`: INTEGER
- `num_comments`: INTEGER
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP
- `reddit_created_at`: TIMESTAMP
- `is_archived`: BOOLEAN
- `is_locked`: BOOLEAN
- `post_type`: VARCHAR(50)
- `daily_rank`: FLOAT
- `daily_score`: FLOAT
- `author_id`: UUID (Foreign Key to Users)

### Comments
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

### Users
- `id`: UUID (Primary Key)
- `username`: VARCHAR(255)
- `total_posts`: INTEGER
- `total_comments`: INTEGER
- `top_posts_count`: INTEGER
- `top_comments_count`: INTEGER
- `first_seen`: TIMESTAMP
- `last_seen`: TIMESTAMP
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

### User Contributions
- `id`: UUID (Primary Key)
- `user_id`: UUID (Foreign Key to Users)
- `post_id`: UUID (Foreign Key to Posts)
- `comment_id`: UUID (Foreign Key to Comments)
- `contribution_type`: VARCHAR(50)
- `score`: INTEGER
- `created_at`: TIMESTAMP

### Post Keywords
- `id`: UUID (Primary Key)
- `post_id`: UUID (Foreign Key to Posts)
- `keyword`: VARCHAR(100)
- `relevance`: FLOAT
- `created_at`: TIMESTAMP

### Comment Keywords
- `id`: UUID (Primary Key)
- `comment_id`: UUID (Foreign Key to Comments)
- `keyword`: VARCHAR(100)
- `relevance`: FLOAT
- `created_at`: TIMESTAMP

## Indexes and Performance

The database includes several indexes to optimize query performance:
- `subreddits_name_idx`: Index on subreddit name
- `posts_subreddit_id_idx`: Index on post's subreddit ID
- `posts_reddit_id_idx`: Index on post's Reddit ID
- `posts_author_id_idx`: Index on post's author ID
- `posts_daily_rank_idx`: Index on post's daily rank
- `comments_post_id_idx`: Index on comment's post ID
- `comments_reddit_id_idx`: Index on comment's Reddit ID
- `comments_author_id_idx`: Index on comment's author ID
- `users_username_idx`: Index on username
- `user_contributions_user_id_idx`: Index on user contributions
- `post_keywords_post_id_idx`: Index on post keywords
- `comment_keywords_comment_id_idx`: Index on comment keywords

For additional support, please refer to the project's issue tracker or contact the development team. 