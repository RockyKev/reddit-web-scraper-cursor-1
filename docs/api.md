# API Documentation

This document provides comprehensive documentation for the Reddit PDX Scraper API.

## Overview

The API provides endpoints for accessing the daily digest of top Reddit content from Portland-related subreddits. The API is RESTful and returns JSON responses.

## Base URL

```
http://localhost:3000/api
```

## Authentication

Currently, the API is open and does not require authentication. Future versions may implement API key authentication.

## Endpoints

### GET /api/digest

Returns the daily digest of top posts and comments.

#### Query Parameters

| Parameter | Type   | Required | Description                                    |
|-----------|--------|----------|------------------------------------------------|
| date      | string | No       | Date in YYYY-MM-DD format. Defaults to today.  |

#### Response

```json
{
  "date": "2024-03-20",
  "summary": {
    "total_posts": 150,
    "total_comments": 1200,
    "top_subreddits": ["r/Portland", "r/askportland"]
  },
  "top_posts": [
    {
      "id": "abc123",
      "subreddit_id": "t5_2qh49",
      "reddit_id": "t3_abc123",
      "title": "Post Title",
      "selftext": "This is the content of the post",
      "url": "https://reddit.com/...",
      "score": 100,
      "num_comments": 50,
      "created_at": "2024-03-20T08:00:00Z",
      "updated_at": "2024-03-20T12:00:00Z",
      "reddit_created_at": "2024-03-20T08:00:00Z",
      "is_archived": false,
      "is_locked": false,
      "post_type": "text",
      "daily_rank": 3,
      "daily_score": 120,
      "author": {
        "username": "CatLadySarah",
        "reddit_id": "t2_123abc",
        "contribution_score": 5
      },
      "keywords": ["keyword1", "keyword2", "keyword3"],
      "top_commenters": [
        {
          "username": "Zesty Steve",
          "contribution_score": 7
        },
        {
          "username": "Banana123",
          "contribution_score": 10
        }
      ],
      "summary": null,
      "sentiment": null
    }
  ]
}
```

#### Response Fields

| Field           | Type    | Description                                    |
|-----------------|---------|------------------------------------------------|
| date            | string  | The date of the digest in YYYY-MM-DD format    |
| summary         | object  | Summary statistics for the day                 |
| total_posts     | integer | Total number of posts collected                |
| total_comments  | integer | Total number of comments collected             |
| top_subreddits  | array   | List of subreddits with most activity          |
| top_posts       | array   | List of top posts for the day                  |

#### Post Object Fields

| Field            | Type    | Description                                    |
|------------------|---------|------------------------------------------------|
| id               | string  | Unique identifier for the post                 |
| subreddit_id     | string  | ID of the subreddit                           |
| reddit_id        | string  | Reddit's unique identifier                     |
| title            | string  | Post title                                     |
| content          | string  | Main post content (derived from selftext for text posts, url for link posts) |
| selftext         | string  | Raw text content (used when post_type is 'text') |
| url              | string  | Raw URL (used when post_type is 'link')        |
| post_type        | string  | Type of post ('text' uses selftext, 'link' uses url) |
| score            | integer | Post score (upvotes)                           |
| num_comments     | integer | Number of comments                             |
| created_at       | string  | When the post was created in our database      |
| updated_at       | string  | When the post was last updated                 |
| reddit_created_at| string  | When the post was created on Reddit            |
| is_archived      | boolean | Whether the post is archived on Reddit         |
| is_locked        | boolean | Whether the post is locked                     |
| daily_rank       | integer | Post's rank for the day                        |
| daily_score      | integer | Post's calculated score for the day            |
| author           | object  | Post author information                        |
| keywords         | array   | Extracted keywords from post and top comments  |
| top_commenters   | array   | List of top commenters on the post             |
| summary          | string  | AI-generated summary (if available)            |
| sentiment        | object  | Sentiment analysis results (if available)      |

#### Author Object Fields

| Field              | Type    | Description                                    |
|-------------------|---------|------------------------------------------------|
| username          | string  | Clean, human-readable username                 |
| reddit_id         | string  | Reddit's database ID (t2_...)                  |
| contribution_score| integer | Score based on frequency in our database       |

#### Top Commenter Object Fields

| Field              | Type    | Description                                    |
|-------------------|---------|------------------------------------------------|
| username          | string  | Reddit username                                |
| contribution_score| integer | User's contribution score                      |

## Rate Limiting

The API implements rate limiting to prevent abuse. Current limits:
- 100 requests per minute per IP address
- 1000 requests per hour per IP address

Rate limit headers are included in responses:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1616284800
```

## Error Responses

The API uses standard HTTP status codes and returns error details in the response body:

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Please try again later.",
    "details": {
      "limit": 100,
      "reset": 1616284800
    }
  }
}
```

Common error codes:
- `400` - Bad Request
- `404` - Not Found
- `429` - Too Many Requests
- `500` - Internal Server Error

## Example Usage

```bash
# Get today's digest
curl http://localhost:3000/api/digest

# Get digest for a specific date
curl http://localhost:3000/api/digest?date=2024-03-20
```
