# Reddit Data Collection Architecture

## Overview
This document outlines the architecture for collecting and storing Reddit data from Portland-related subreddits. The system is designed to run daily at 4:30 AM EST, fetching posts and comments from specified subreddits and storing them in PostgreSQL.

## Core Components

### 1. Data Fetching (`src/services/reddit/reddit-fetch.ts`)
**Purpose**: Handle all Reddit API interactions
- Fetch posts and comments from specified subreddits
- Implement rate limiting and retry logic
- Handle API authentication and error cases
- Return raw Reddit API responses

**Key Methods**:
```typescript
async fetchSubredditPosts(subreddit: string, limit: number): Promise<RawRedditPost[]>
async fetchPostComments(postId: string): Promise<RawRedditComment[]>
```

### 2. Data Processing (`src/services/reddit/reddit-scraper.ts`)
**Purpose**: Transform raw Reddit API data into our domain models
- Convert raw API responses into strongly-typed models
- Extract relevant fields and normalize data
- Handle data validation and cleaning

**Key Models**:
```typescript
interface RedditPost {
  id: string;
  title: string;
  content: string;
  author: string;
  subreddit: string;
  created: Date;
  // ... other fields
}

interface RedditComment {
  id: string;
  postId: string;
  content: string;
  author: string;
  created: Date;
  // ... other fields
}
```

### 3. Data Storage (`src/services/reddit/reddit-storage.ts`)
**Purpose**: Manage database operations for Reddit data
- Store posts and comments in PostgreSQL
- Handle data deduplication
- Manage database connections and transactions

**Key Methods**:
```typescript
async storePost(post: RedditPost): Promise<void>
async storeComment(comment: RedditComment): Promise<void>
```

### 4. Data Collection (`src/services/reddit/reddit-collector.ts`)
**Purpose**: Coordinate the data collection process
- Orchestrate the fetching, processing, and storage of data
- Handle scheduling (4:30 AM EST daily)
- Manage error handling and logging
- Track collection status and metrics

**Key Methods**:
```typescript
async collectSubredditData(subreddit: string): Promise<void>
async startCollectionSchedule(): Promise<void>
```

## Data Flow
1. `reddit-collector.ts` initiates the collection process
2. `reddit-fetch.ts` retrieves data from Reddit API
3. `reddit-scraper.ts` processes the raw data into domain models
4. `reddit-storage.ts` persists the data to PostgreSQL

## Testing Guidelines
- Unit tests for each component
- Integration tests for the complete data flow
- Mock Reddit API responses for testing
- Database transaction rollback in tests

## Best Practices
- Implement proper error handling and logging
- Use TypeScript for type safety
- Follow the single responsibility principle
- Maintain clear separation of concerns
- Document all public methods and interfaces 