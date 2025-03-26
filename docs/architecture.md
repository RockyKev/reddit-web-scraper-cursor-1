# Reddit Scraper Architecture

This document outlines the architecture and responsibilities of each component in the Reddit scraper system.

## Component Overview

### 1. reddit-fetch.ts
**Responsibility**: Raw data fetching from Reddit API
- Handles all HTTP concerns (axios, retries, rate limiting)
- Returns raw JSON data from Reddit endpoints
- Can be configured to use real API or mock data
- No data transformation or storage logic

**Key Methods**:
- `fetchPosts(subreddit, limit)`: Gets raw post data
- `fetchComments(subreddit, postId)`: Gets raw comment data
- `fetchSearch(subreddit, query, limit)`: Gets raw search results

### 2. reddit-scraper.ts
**Responsibility**: Data transformation
- Takes raw data from reddit-fetch.ts
- Transforms it into domain models (RedditPost, RedditComment)
- Handles data cleaning and normalization
- No HTTP or storage concerns

**Key Methods**:
- `transformPost(rawData)`: Converts raw post data to RedditPost
- `transformComment(rawData)`: Converts raw comment data to RedditComment

### 3. reddit-storage.ts
**Responsibility**: Database operations
- Handles all PostgreSQL interactions
- Manages database connections and transactions
- Provides CRUD operations for posts and comments
- No knowledge of Reddit API or data transformation

**Key Methods**:
- `storePost(subredditId, post)`: Stores a post in the database
- `storeComment(postId, comment)`: Stores a comment in the database
- `getPosts(subredditId)`: Retrieves posts from the database

### 4. reddit-collector.ts
**Responsibility**: Data collection process
- Coordinates between fetch and storage components
- Manages the flow of collecting and storing data
- Handles collection-specific business logic
- No direct HTTP or database operations

**Key Methods**:
- `collectPosts(subreddit, limit)`: Collects and stores posts
- `collectComments(postId)`: Collects and stores comments for a post

### 5. reddit-search.ts
**Responsibility**: Search operations
- Handles search-specific operations
- Uses fetch and scrape components
- Manages search result storage
- Separate from collection process

**Key Methods**:
- `searchAndStore(query, limit)`: Searches and stores results
- `searchPosts(query, limit)`: Searches posts without storing

## Data Flow

1. **Collection Flow**:
```
reddit-fetch.ts → reddit-scraper.ts → reddit-storage.ts
(coordinated by reddit-collector.ts)
```

2. **Search Flow**:
```
reddit-fetch.ts → reddit-scraper.ts → reddit-storage.ts
(coordinated by reddit-search.ts)
```

## Testing

Each component can be tested in isolation:
- `reddit-fetch.ts`: Mock HTTP responses
- `reddit-scraper.ts`: Test with raw data samples
- `reddit-storage.ts`: Use test database
- `reddit-collector.ts`: Mock fetch and storage
- `reddit-search.ts`: Mock fetch and storage

## Adding New Features

When adding new features:
1. Determine which component should handle the new functionality
2. Add new methods to the appropriate component
3. Update tests for the modified component
4. Update integration tests if needed

## Best Practices

1. Keep components focused on their single responsibility
2. Use interfaces to define component contracts
3. Maintain clear data flow between components
4. Write tests for each component
5. Document any new methods or significant changes 