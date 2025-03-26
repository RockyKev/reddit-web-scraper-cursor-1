import { logger } from '../utils/logger.ts';
import { RedditScraper } from './reddit-scraper.ts';
import { MockRedditScraper } from '../../tests/mocks/reddit-scraper.mock.ts';
import { RedditStorage } from './reddit-storage.ts';
import { IRedditScraper, RedditSortType, RedditTimeFilter } from '../types/reddit.ts';

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

      // Store each post and optionally its comments
      for (const post of posts) {
        const postId = await this.storage.storePost(subredditId, post);
        logger.info(`Stored post: ${post.id}`);

        // Only fetch comments if explicitly requested
        if (fetchComments) {
          // Get and store comments
          const comments = await this.scraper.getComments(post.id);
          logger.info(`Found ${comments.length} comments for post ${post.id}`);

          for (const comment of comments) {
            await this.storage.storeComment(postId, comment);
          }
        }
      }

      logger.info('Collection and storage completed successfully');
    } catch (error) {
      logger.error('Error in collection and storage operation:', error);
      throw error;
    }
  }
} 