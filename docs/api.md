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
      "subreddit": "r/Portland",
      "title": "Post Title",
      "type": "text",
      "upvotes": 500,
      "comment_count": 100,
      "permalink": "https://reddit.com/...",
	  "selftext": "This is the content of the post"
      "keywords": ["keyword1", "keyword2", "keyword3"],
      "author": {
        "username": "PDX_Dave",
        "contribution_score": 2
      },
      "top_commenters": [
        {
          "username": "CatLadySarah",
          "contribution_score": 5
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
| subreddit        | string  | Name of the subreddit                          |
| title            | string  | Post title                                     |
| type             | string  | Type of post (text, link, image, etc.)         |
| upvotes          | integer | Number of upvotes                              |
| comment_count    | integer | Number of comments                             |
| permalink        | string  | Reddit permalink URL                           |
| keywords         | array   | Extracted keywords from the post               |
| author           | object  | Post author information                        |
| top_commenters   | array   | List of top commenters on the post             |
| summary          | string  | AI-generated summary (if available)            |
| sentiment        | object  | Sentiment analysis results (if available)      |

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
