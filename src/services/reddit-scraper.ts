import axios from 'axios';
import axiosRetry from 'axios-retry';
import cheerio from 'cheerio';
import { logger } from '../utils/logger';

// Types for scraped data
interface RedditPost {
  id: string;
  title: string;
  content: string;
  url: string;
  author: string;
  score: number;
  commentCount: number;
  createdAt: Date;
  isArchived: boolean;
  isLocked: boolean;
}

interface RedditComment {
  id: string;
  content: string;
  author: string;
  score: number;
  createdAt: Date;
  isArchived: boolean;
  parentId?: string;
}

// Configure axios with retry logic
const client = axios.create({
  headers: {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
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

export class RedditScraper {
  private lastRequestTime: number = 0;
  private readonly minRequestInterval: number = 2000; // 2 seconds between requests

  constructor(private readonly _subreddit: string) {}

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
      const url = `https://old.reddit.com/r/${this._subreddit}/.json?limit=${limit}`;
      
      const response = await client.get(url);
      const posts = response.data.data.children;

      return posts.map((post: any) => ({
        id: post.data.id,
        title: post.data.title,
        content: post.data.selftext,
        url: post.data.url,
        author: post.data.author,
        score: post.data.score,
        commentCount: post.data.num_comments,
        createdAt: new Date(post.data.created_utc * 1000),
        isArchived: post.data.archived,
        isLocked: post.data.locked
      }));
    } catch (error) {
      logger.error('Error fetching posts:', error);
      throw error;
    }
  }

  public async getComments(postId: string): Promise<RedditComment[]> {
    try {
      await this.rateLimit();
      const url = `https://old.reddit.com/r/${this._subreddit}/comments/${postId}/.json`;
      
      const response = await client.get(url);
      const comments = response.data[1].data.children;

      return this.parseComments(comments);
    } catch (error) {
      logger.error('Error fetching comments:', error);
      throw error;
    }
  }

  private parseComments(comments: any[]): RedditComment[] {
    const parsedComments: RedditComment[] = [];

    const parseComment = (comment: any) => {
      if (comment.kind !== 't1') return; // Skip non-comment items

      parsedComments.push({
        id: comment.data.id,
        content: comment.data.body,
        author: comment.data.author,
        score: comment.data.score,
        createdAt: new Date(comment.data.created_utc * 1000),
        isArchived: comment.data.archived,
        parentId: comment.data.parent_id
      });

      // Recursively parse replies
      if (comment.data.replies && comment.data.replies.data) {
        comment.data.replies.data.children.forEach(parseComment);
      }
    };

    comments.forEach(parseComment);
    return parsedComments;
  }

  public async searchSubreddit(query: string, limit: number = 25): Promise<RedditPost[]> {
    try {
      await this.rateLimit();
      const url = `https://old.reddit.com/r/${this._subreddit}/search.json?q=${encodeURIComponent(query)}&restrict_sr=on&limit=${limit}`;
      
      const response = await client.get(url);
      const posts = response.data.data.children;

      return posts.map((post: any) => ({
        id: post.data.id,
        title: post.data.title,
        content: post.data.selftext,
        url: post.data.url,
        author: post.data.author,
        score: post.data.score,
        commentCount: post.data.num_comments,
        createdAt: new Date(post.data.created_utc * 1000),
        isArchived: post.data.archived,
        isLocked: post.data.locked
      }));
    } catch (error) {
      logger.error('Error searching subreddit:', error);
      throw error;
    }
  }
} 