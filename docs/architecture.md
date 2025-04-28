# Reddit Scraper Architecture

This document outlines the architecture and responsibilities of each component in the Reddit scraper system.

## Component Overview

### 1. reddit-scraper.ts
**Responsibility**: Data fetching and transformation
- Handles HTTP requests to Reddit API
- Transforms raw data into domain models
- Manages rate limiting and retries
- No storage or business logic

**Key Methods**:
- `getPosts(limit, sort, time)`: Gets posts from a subreddit
- `getComments(postId)`: Gets comments for a post
- `transformPost(rawData)`: Converts raw post data to RedditPost
- `transformComment(rawData)`: Converts raw comment data to RedditComment

### 2. reddit-storage.ts
**Responsibility**: Database operations
- Handles all PostgreSQL interactions
- Manages database connections and transactions
- Provides CRUD operations for posts, comments, and users
- Tracks user statistics and contributions

**Key Methods**:
- `storePost(subredditId, post)`: Stores a post in the database
- `storeComment(postId, comment)`: Stores a comment in the database
- `storeUser(authorId, username)`: Stores or updates user information
- `storePostWithComments(subredditId, post, comments)`: Stores a post with its comments and extracted keywords

### 3. reddit-collector.ts
**Responsibility**: Data collection process
- Coordinates between scraper and storage components
- Manages the flow of collecting and storing data
- Handles collection-specific business logic
- Triggers scoring calculations after collection

**Key Methods**:
- `collectAndStore(subreddits, limit, sort, time)`: Main method that coordinates the entire collection process
- `processSubreddit(scraper, subreddit, limit, sort, time)`: Processes a single subreddit
- `processPost(scraper, subredditId, post, isLastPost)`: Processes a single post

### 4. score-calculator.ts
**Responsibility**: Post scoring and ranking
- Calculates daily scores for posts
- Updates user statistics
- Assigns daily ranks based on scores
- Provides verification of calculations

**Key Methods**:
- `calculateScoresForDate(date)`: Calculates scores and ranks for a specific date
- Updates user statistics based on post and comment activity

### 5. keyword-analysis-service.ts
**Responsibility**: Keyword analysis coordination
- Coordinates keyword extraction process
- Manages top comments selection
- Handles error cases and logging
- Provides high-level keyword analysis interface

**Key Methods**:
- `extractKeywordsFromPost(post, comments)`: Main method for keyword extraction
- `getTopComments(comments)`: Gets top comments based on score

### 6. digest-service.ts
**Responsibility**: Daily digest generation
- Generates daily digest of top content
- Combines posts, keywords, and user stats
- Formats data for API response
- Handles digest-specific business logic

**Key Methods**:
- `getDigest(date)`: Creates daily digest for a specific date
- `getPostContent(post)`: Determines the appropriate content to display

## Data Flow

1. **Collection Flow**:
```
reddit-scraper.ts → reddit-collector.ts → reddit-storage.ts → score-calculator.ts
(coordinated by reddit-collector.ts)
```

2. **Keyword Analysis Flow**:
```
reddit-collector.ts → keyword-analysis-service.ts → reddit-storage.ts
```

3. **Digest Generation Flow**:
```
API Request → digest-service.ts → score-calculator.ts → reddit-storage.ts → API Response
```

## Testing

Each component can be tested in isolation:
- `reddit-scraper.ts`: Mock HTTP responses
- `reddit-storage.ts`: Use test database
- `reddit-collector.ts`: Mock scraper and storage
- `score-calculator.ts`: Test with sample posts
- `keyword-analysis-service.ts`: Test with sample posts and comments
- `digest-service.ts`: Test with sample data

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
6. Use environment variables for configurable values
7. Implement proper error handling and logging
8. Cache frequently accessed data when appropriate 