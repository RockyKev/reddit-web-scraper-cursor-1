import axios from 'axios';
import axiosRetry from 'axios-retry';
import * as cheerio from 'cheerio';
import { logger } from '../utils/logger.js';
import { RedditPost, RedditComment, IRedditScraper, RedditSortType, RedditTimeFilter } from '../types/reddit.js';

// Configure axios with retry logic
// We keep this configuration in this file since it's specific to Reddit scraping
// and currently only used by this service. If we add more services that need
// similar HTTP client behavior, we should consider moving this to a shared client file.
const client = axios.create({
  headers: {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'application/json',
    'Accept-Language': 'en-US,en;q=0.9',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive'
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
  private readonly minRequestInterval: number; // 5 seconds between requests
  private readonly commentRequestInterval: number; // 8 seconds between comment requests


  private readonly _subreddit: string;

  constructor(subreddit: string) {
    const rawRate = process.env.API_RATE_WAIT_TIME;
    const parsedRate = parseInt(rawRate || '', 10);

    // Fallback to 5000 if the env var is missing or invalid
    const rate = Number.isNaN(parsedRate) ? 5000 : parsedRate;

    this.minRequestInterval = rate;
    this.commentRequestInterval = rate + 3000; // add delay for comment fetches
 
    this._subreddit = subreddit;
  }

  public get subreddit(): string {
    return this._subreddit;
  }

  private async rateLimit(isCommentRequest: boolean = false): Promise<void> {
    const now = Date.now();
    const timeSinceLastRequest = now - this.lastRequestTime;
    const requiredDelay = isCommentRequest ? this.commentRequestInterval : this.minRequestInterval;
    
    if (timeSinceLastRequest < requiredDelay) {
      const delay = requiredDelay - timeSinceLastRequest;
      logger.info(`Rate limiting: waiting ${Math.round(delay/1000)} seconds...`);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
    
    this.lastRequestTime = Date.now();
  }

  public async getPosts(
    limit: number = 10,
    sort: RedditSortType = 'top',
    time: RedditTimeFilter = 'day'
  ): Promise<RedditPost[]> {
    try {
      await this.rateLimit();
      const url = `https://www.reddit.com/r/${this._subreddit}/${sort}.json`;
      
      logger.info(`Fetching posts from ${url}`);
      const response = await client.get(url, {
        params: {
          t: time,
          limit: Math.min(limit, 100) // Reddit's max limit is 100
        }
      });
      
      if (!response.data || !response.data.data || !response.data.data.children) {
        logger.error('Invalid response format from Reddit API');
        throw new Error('Invalid response format from Reddit API');
      }

      const data = response.data;
      const posts: RedditPost[] = [];

      // Parse posts from the JSON response
      for (const child of data.data.children) {
        if (posts.length >= limit) break;
        
        const post = child.data;
        
        // Skip deleted or removed posts
        if (!post || post.author === '[deleted]' || post.author === '[removed]') {
          logger.info(`Skipping deleted/removed post: ${post?.id || 'unknown'}`);
          continue;
        }

        try {
          // Ensure we have a valid timestamp
          const timestamp = Number(post.created_utc);
          if (isNaN(timestamp)) {
            logger.warn(`Invalid timestamp for post ${post.id}`);
            continue;
          }

          posts.push({
            id: post.id,
            title: post.title || '',
            content: post.selftext || '',
            url: post.url || '',
            permalink: post.permalink || '',
            post_type: post.post_hint || 'text',
            author_fullname: post.author_fullname || `t2_${post.id}`,
            author: post.author || '[unknown]',
            score: post.score || 0,
            commentCount: post.num_comments || 0,
            createdAt: new Date(timestamp * 1000),
            isArchived: post.archived || false,
            isLocked: post.locked || false
          });
          logger.info(`Successfully parsed post: ${post.id}`);
        } catch (error) {
          logger.error(`Error parsing post ${post.id}:`, error);
          continue;
        }
      }

      logger.info(`Successfully fetched ${posts.length} posts`);
      return posts;
    } catch (error) {
      logger.error('Error fetching posts:', error);
      if (axios.isAxiosError(error)) {
        logger.error('Axios error details:', {
          status: error.response?.status,
          statusText: error.response?.statusText,
          data: error.response?.data
        });
      }
      throw error;
    }
  }

  public async getComments(postId: string): Promise<RedditComment[]> {
    try {
      await this.rateLimit(true); // Use longer delay for comment requests
      const url = `https://www.reddit.com/r/${this._subreddit}/comments/${postId}.json`;
      
      logger.info(`Fetching comments from ${url}`);
      const response = await client.get(url);

      if (!response.data || !Array.isArray(response.data) || response.data.length < 2) {
        logger.error('Invalid response format from Reddit API');
        throw new Error('Invalid response format from Reddit API');
      }

      const data = response.data;
      const comments: RedditComment[] = [];

      // Parse comments from the JSON response
      if (data[1]?.data?.children) {
        for (const child of data[1].data.children) {
          const comment = child.data;
          
          // Skip deleted, removed, or "more" comments
          if (!comment || comment.kind === 'more' || !comment.created_utc || 
              comment.author === '[deleted]' || comment.author === '[removed]') {
            continue;
          }
          
          // Ensure we have a valid timestamp
          const timestamp = Number(comment.created_utc);
          if (isNaN(timestamp)) {
            logger.warn(`Invalid timestamp for comment ${comment.id}`);
            continue;
          }
          
          try {
            comments.push({
              id: comment.id,
              content: comment.body || '',
              author_fullname: comment.author_fullname || '[unknown]',
              author: comment.author || '[unknown]',
              score: comment.score || 0,
              createdAt: new Date(timestamp * 1000),
              isArchived: comment.archived || false,
              parentId: comment.parent_id?.replace('t1_', '')
            });
          } catch (error) {
            logger.error(`Error parsing comment ${comment.id}:`, error);
            continue;
          }
        }
      }

      logger.info(`Successfully fetched ${comments.length} comments for post ${postId}`);
      return comments;
    } catch (error) {
      logger.error('Error fetching comments:', error);
      if (axios.isAxiosError(error)) {
        logger.error('Axios error details:', {
          status: error.response?.status,
          statusText: error.response?.statusText,
          data: error.response?.data
        });
      }
      throw error;
    }
  }
} 