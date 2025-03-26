# Database Schema Design

## Entity Relationship Diagram

```mermaid
erDiagram
    SUBREDDIT ||--o{ POST : contains
    POST ||--o{ COMMENT : has
    POST ||--o{ POST_CATEGORY : has
    POST ||--o{ POST_KEYWORD : has
    COMMENT ||--o{ COMMENT_KEYWORD : has
    COMMENT ||--o{ COMMENT_SENTIMENT : has
    POST ||--o{ POST_SENTIMENT : has

    SUBREDDIT {
        string id PK
        string name
        string description
        timestamp created_at
        timestamp updated_at
    }

    POST {
        string id PK
        string subreddit_id FK
        string reddit_id
        string title
        text content
        string author
        integer score
        integer comment_count
        string url
        string permalink
        timestamp created_at
        timestamp updated_at
        timestamp reddit_created_at
        boolean is_archived
        boolean is_locked
        string post_type
    }

    COMMENT {
        string id PK
        string post_id FK
        string reddit_id
        text content
        string author
        integer score
        string parent_id
        timestamp created_at
        timestamp updated_at
        timestamp reddit_created_at
        boolean is_archived
    }

    POST_CATEGORY {
        string id PK
        string post_id FK
        string category
        float confidence
        timestamp created_at
    }

    POST_KEYWORD {
        string id PK
        string post_id FK
        string keyword
        float relevance
        timestamp created_at
    }

    COMMENT_KEYWORD {
        string id PK
        string comment_id FK
        string keyword
        float relevance
        timestamp created_at
    }

    POST_SENTIMENT {
        string id PK
        string post_id FK
        float sentiment_score
        string sentiment_label
        timestamp created_at
    }

    COMMENT_SENTIMENT {
        string id PK
        string comment_id FK
        float sentiment_score
        string sentiment_label
        timestamp created_at
    }
```

## Schema Details

### Tables

#### 1. subreddits
- Primary tracking table for Portland-related subreddits
- Stores basic subreddit information
- Used for managing which subreddits to scrape

#### 2. posts
- Stores all Reddit posts from tracked subreddits
- Includes metadata like scores, comment counts, and URLs
- Links to subreddit through foreign key
- Tracks both Reddit's creation time and our record creation time

#### 3. comments
- Stores all comments from tracked posts
- Links to parent post through foreign key
- Includes metadata like scores and parent comment references
- Tracks both Reddit's creation time and our record creation time

#### 4. post_categories
- Stores post categorization data
- Used for Phase 2's post type tracking feature
- Includes confidence scores for categorization

#### 5. post_keywords
- Stores extracted keywords from posts
- Used for Phase 3's keyword extraction feature
- Includes relevance scores for each keyword

#### 6. comment_keywords
- Stores extracted keywords from comments
- Similar to post_keywords but for comment content
- Used for comment analysis and tracking

#### 7. post_sentiment
- Stores sentiment analysis results for posts
- Used for Phase 3's sentiment analysis feature
- Includes both numerical scores and human-readable labels

#### 8. comment_sentiment
- Stores sentiment analysis results for comments
- Similar to post_sentiment but for comment content
- Used for comment sentiment tracking

## Notes

1. **Timestamps**:
   - `created_at`: When we first stored the record
   - `updated_at`: When we last updated the record
   - `reddit_created_at`: When the content was created on Reddit

2. **IDs**:
   - `id`: Our internal UUID
   - `reddit_id`: Reddit's unique identifier
   - `parent_id`: For comments, references parent comment or post

3. **Scoring**:
   - `score`: Reddit's upvote count
   - `confidence`: For categorization accuracy
   - `relevance`: For keyword importance
   - `sentiment_score`: For sentiment analysis results

4. **Future Considerations**:
   - Indexes on frequently queried fields
   - Partitioning for large tables
   - Archival strategy for old data 