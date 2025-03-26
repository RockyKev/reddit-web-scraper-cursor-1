import axios from 'axios';
import axiosRetry from 'axios-retry';
import * as cheerio from 'cheerio';
import { logger } from '../utils/logger.ts';
import { RedditPost, RedditComment, IRedditScraper } from '../types/reddit.ts';
import { MockRedditScraper } from '../../tests/mocks/reddit-scraper.mock.ts';

// Configure axios with retry logic
// We keep this configuration in this file since it's specific to Reddit scraping
// and currently only used by this service. If we add more services that need
// similar HTTP client behavior, we should consider moving this to a shared client file.
const client = axios.create({
  headers: {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Language': 'en-US,en;q=0.9',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'none',
    'Sec-Fetch-User': '?1',
    'Cache-Control': 'max-age=0'
  }
});

axiosRetry(client, {
  retries: 3,
  retryDelay: (retryCount) => {
    return retryCount * 2000; // Progressive delay: 2s, 4s, 6s
  },
  retryCondition: (error) => {
    // Retry on network errors or 5xx responses
    return axiosRetry.isNetworkOrIdempotentRequestError(error) ||
           (error.response?.status ?? 0) >= 500;
  }
});

export class RedditScraper implements IRedditScraper {
  private lastRequestTime: number = 0;
  private readonly minRequestInterval: number = 2000; // 2 seconds between requests
  private readonly _subreddit: string;

  constructor(subreddit: string) {
    this._subreddit = subreddit;
  }

  public get subreddit(): string {
    return this._subreddit;
  }

  private async rateLimit(): Promise<void> {
    const now = Date.now();
    const timeSinceLastRequest = now - this.lastRequestTime;
    
    if (timeSinceLastRequest < this.minRequestInterval) {
      const delay = this.minRequestInterval - timeSinceLastRequest;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
    
    this.lastRequestTime = Date.now();
  }

  public async getPosts(limit: number = 25): Promise<RedditPost[]> {
    try {
      await this.rateLimit();
      const url = `https://www.reddit.com/r/${this._subreddit}.json`;
      
      const response = await client.get(url);
      const data = response.data;
      const posts: RedditPost[] = [];

      // Parse posts from the JSON response
      if (data.data?.children) {
        for (const child of data.data.children) {
          if (posts.length >= limit) break;
          
          const post = child.data;
          posts.push({
            id: post.id,
            title: post.title,
            content: post.selftext,
            url: post.url,
            author: post.author,
            score: post.score,
            commentCount: post.num_comments,
            createdAt: new Date(post.created_utc * 1000),
            isArchived: post.archived,
            isLocked: post.locked
          });
        }
      }

      return posts;
    } catch (error) {
      logger.error('Error fetching posts:', error);
      throw error;
    }
  }

  public async getComments(postId: string): Promise<RedditComment[]> {
    try {
      await this.rateLimit();
      const url = `https://www.reddit.com/r/${this._subreddit}/comments/${postId}.json`;
      
      const response = await client.get(url);
      const data = response.data;
      const comments: RedditComment[] = [];

      // Parse comments from the JSON response
      if (data[1]?.data?.children) {
        for (const child of data[1].data.children) {
          const comment = child.data;
          if (comment.kind === 'more' || !comment.created_utc) continue;
          
          // Ensure we have a valid timestamp
          const timestamp = Number(comment.created_utc);
          if (isNaN(timestamp)) continue;
          
          comments.push({
            id: comment.id,
            content: comment.body,
            author: comment.author,
            score: comment.score,
            createdAt: new Date(timestamp * 1000),
            isArchived: comment.archived,
            parentId: comment.parent_id?.replace('t1_', '')
          });
        }
      }

      return comments;
    } catch (error) {
      logger.error('Error fetching comments:', error);
      throw error;
    }
  }
}

export function createRedditScraper(subreddit: string, useMock: boolean = false): IRedditScraper {
  return useMock ? new MockRedditScraper(subreddit) : new RedditScraper(subreddit);
} 