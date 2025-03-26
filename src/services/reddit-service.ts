import { logger } from '../utils/logger.ts';
import { RedditScraper, MockRedditScraper } from './reddit-scraper.ts';
import { RedditStorage } from './reddit-storage.ts';

export class RedditService {
  private scraper: RedditScraper | MockRedditScraper;
  private storage: RedditStorage;

  constructor(scraper: RedditScraper | MockRedditScraper) {
    this.scraper = scraper;
    this.storage = new RedditStorage();
  }

  public async scrapeAndStore(limit: number = 25): Promise<void> {
    try {
      // Get or create subreddit
      const subredditId = await this.storage.storeSubreddit(this.scraper.subreddit);
      logger.info(`Processing subreddit: ${this.scraper.subreddit}`);

      // Get posts
      const posts = await this.scraper.getPosts(limit);
      logger.info(`Found ${posts.length} posts`);

      // Store each post and its comments
      for (const post of posts) {
        const postId = await this.storage.storePost(subredditId, post);
        logger.info(`Stored post: ${post.id}`);

        // Get and store comments
        const comments = await this.scraper.getComments(post.id);
        logger.info(`Found ${comments.length} comments for post ${post.id}`);

        for (const comment of comments) {
          await this.storage.storeComment(postId, comment);
        }
      }

      logger.info('Scraping and storage completed successfully');
    } catch (error) {
      logger.error('Error in scrape and store operation:', error);
      throw error;
    }
  }

  public async searchAndStore(query: string, limit: number = 25): Promise<void> {
    try {
      // Get or create subreddit
      const subredditId = await this.storage.storeSubreddit(this.scraper.subreddit);
      logger.info(`Searching subreddit: ${this.scraper.subreddit} for: ${query}`);

      // Search posts
      const posts = await this.scraper.searchSubreddit(query, limit);
      logger.info(`Found ${posts.length} posts matching query`);

      // Store each post and its comments
      for (const post of posts) {
        const postId = await this.storage.storePost(subredditId, post);
        logger.info(`Stored post: ${post.id}`);

        // Get and store comments
        const comments = await this.scraper.getComments(post.id);
        logger.info(`Found ${comments.length} comments for post ${post.id}`);

        for (const comment of comments) {
          await this.storage.storeComment(postId, comment);
        }
      }

      logger.info('Search and storage completed successfully');
    } catch (error) {
      logger.error('Error in search and store operation:', error);
      throw error;
    }
  }
} 