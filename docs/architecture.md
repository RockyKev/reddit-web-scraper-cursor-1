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
- `storePostWithComments(subredditId, post, comments)`: Stores a post with its comments and extracted keywords
- `getPosts(subredditId)`: Retrieves posts from the database
- `getTopPosts(date)`: Gets top posts for a specific date
- `getUserStats(userId)`: Gets user contribution statistics

### 4. reddit-collector.ts
**Responsibility**: Data collection process
- Coordinates between fetch and storage components
- Manages the flow of collecting and storing data
- Handles collection-specific business logic
- No direct HTTP or database operations

**Key Methods**:
- `collectPosts(subreddit, limit)`: Collects and stores posts
- `collectComments(postId)`: Collects and stores comments for a post
- `collectAndStore(limit, sort, time, fetchComments)`: Main method that coordinates the entire collection process

### 5. post-ranker.ts
**Responsibility**: Post ranking and scoring
- Calculates daily scores for posts
- Implements configurable scoring algorithm
- Determines top posts per subreddit
- Updates post rankings in database

**Key Methods**:
- `calculatePostScore(post)`: Calculates score based on upvotes and comments
- `rankDailyPosts(date)`: Ranks posts for a specific date
- `getTopPostsPerSubreddit(date, limit)`: Gets top N posts per subreddit

### 6. keyword-extractor.ts
**Responsibility**: Keyword analysis
- Extracts keywords from posts and comments using TF-IDF
- Implements frequency-based weighting
- Filters common words and stop words
- Returns top keywords for content

**Key Methods**:
- `extractKeywords(post, comments)`: Extracts keywords from post and comments
- `combineText(post, comments)`: Combines text for analysis
- `countWordFrequencies(text)`: Counts word frequencies
- `getTopWords(wordFreq, n)`: Gets top N most frequent words

### 7. keyword-analysis-service.ts
**Responsibility**: Keyword analysis coordination
- Coordinates keyword extraction process
- Manages top comments selection
- Handles error cases and logging
- Provides high-level keyword analysis interface

**Key Methods**:
- `extractKeywordsFromPost(post, comments)`: Main method for keyword extraction
- `getTopComments(comments)`: Gets top comments based on score

### 8. user-tracker.ts
**Responsibility**: User tracking and statistics
- Tracks user contributions
- Calculates user scores
- Maintains user statistics
- Identifies key community members

**Key Methods**:
- `trackUserContribution(userId, contribution)`: Records a user contribution
- `updateUserStats(userId)`: Updates user statistics
- `getTopContributors(limit)`: Gets top N contributors

### 9. digest-generator.ts
**Responsibility**: Daily digest generation
- Generates daily digest of top content
- Combines posts, keywords, and user stats
- Formats data for API response
- Handles digest-specific business logic

**Key Methods**:
- `generateDailyDigest(date)`: Creates daily digest
- `formatDigestResponse(digest)`: Formats digest for API
- `getDigestStats(date)`: Gets digest statistics

## Data Flow

1. **Collection Flow**:
```
reddit-fetch.ts → reddit-scraper.ts → reddit-collector.ts → reddit-storage.ts
(coordinated by reddit-collector.ts)
```

2. **Keyword Analysis Flow**:
```
reddit-collector.ts → keyword-analysis-service.ts → keyword-extractor.ts → reddit-storage.ts
```

3. **Daily Processing Flow**:
```
reddit-storage.ts → post-ranker.ts → keyword-analysis-service.ts → user-tracker.ts → digest-generator.ts
```

4. **API Request Flow**:
```
API Request → digest-generator.ts → reddit-storage.ts → API Response
```

## Testing

Each component can be tested in isolation:
- `reddit-fetch.ts`: Mock HTTP responses
- `reddit-scraper.ts`: Test with raw data samples
- `reddit-storage.ts`: Use test database
- `reddit-collector.ts`: Mock fetch and storage
- `post-ranker.ts`: Test with sample posts
- `keyword-extractor.ts`: Test with sample text
- `keyword-analysis-service.ts`: Test with sample posts and comments
- `user-tracker.ts`: Test with sample contributions
- `digest-generator.ts`: Test with sample data

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