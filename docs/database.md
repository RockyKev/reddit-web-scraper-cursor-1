# Database Documentation

This document provides detailed information about the database setup and management for the Reddit PDX Scraper project.

## Prerequisites

- Node.js v23
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
npm run migrate:create -- migration_name
```
This will create a new migration file in the `src/db/migrations` directory.

#### Apply Pending Migrations
```bash
npm run migrate:up
```
This will run all pending migrations in order.

#### Rollback Last Migration
```bash
npm run migrate:down
```
This will undo the most recent migration.

#### Check Migration Status
```bash
npm run migrate:status
```
This will show which migrations have been applied and which are pending.

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

### Comments
- `id`: UUID (Primary Key)
- `post_id`: UUID (Foreign Key)
- `reddit_id`: VARCHAR(255)
- `body`: TEXT
- `score`: INTEGER
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

## Indexes and Performance

The database includes several indexes to optimize query performance:
- `subreddits_name_idx`: Index on subreddit name
- `posts_subreddit_id_idx`: Index on post's subreddit ID
- `posts_reddit_id_idx`: Index on post's Reddit ID
- `comments_post_id_idx`: Index on comment's post ID
- `comments_reddit_id_idx`: Index on comment's Reddit ID

## Troubleshooting

### Common Issues

1. **Database Connection Issues**
   - Ensure Docker is running
   - Check if the database container is up: `docker-compose ps`
   - Verify environment variables in `.env`

2. **Migration Failures**
   - Check migration logs for specific errors
   - Ensure all previous migrations are applied
   - Verify database credentials are correct

3. **Performance Issues**
   - Check if indexes are being used: `EXPLAIN ANALYZE`
   - Monitor database size and growth
   - Review query patterns and optimize as needed

For additional support, please refer to the project's issue tracker or contact the development team. 