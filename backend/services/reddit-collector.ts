import { logger } from '../utils/logger.js';
import { RedditScraper } from './reddit-scraper.js';
import { RedditStorage } from './reddit-storage.js';
import { IRedditScraper, RedditSortType, RedditTimeFilter } from '../types/reddit.js';

export class RedditCollector {
  private scraper: IRedditScraper;
  private storage: RedditStorage;

  constructor(scraper: IRedditScraper) {
    this.scraper = scraper;
    this.storage = new RedditStorage();
  }

  public async collectAndStore(
    limit: number = 25,
    sort: RedditSortType = 'hot',
    time: RedditTimeFilter = 'day',
    fetchComments: boolean = false
  ): Promise<void> {
    try {
      // Get or create subreddit
      const subredditId = await this.storage.storeSubreddit(this.scraper.subreddit);
      logger.info(`Processing subreddit: ${this.scraper.subreddit} (${sort}/${time})`);

      // Get posts
      const posts = await this.scraper.getPosts(limit, sort, time);
      logger.info(`Found ${posts.length} posts`);

      // Store each post and its comments
      for (const post of posts) {
        // Always fetch comments since we need them for keyword extraction
        const comments = await this.scraper.getComments(post.id);
        logger.info(`Found ${comments.length} comments for post ${post.id}`);

        // Store post with comments and extract keywords
        await this.storage.storePostWithComments(subredditId, post, comments);
        logger.info(`Stored post ${post.id} with ${comments.length} comments and keywords`);
      }

      logger.info('Collection and storage completed successfully');
    } catch (error) {
      logger.error('Error in collection and storage operation:', error);
      throw error;
    }
  }
} 