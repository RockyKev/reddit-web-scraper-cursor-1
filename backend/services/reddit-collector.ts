import { logger } from '../utils/logger.js';
import { RedditScraper } from './reddit-scraper.js';
import { RedditStorage } from './reddit-storage.js';
import { IRedditScraper, RedditSortType, RedditTimeFilter } from '../types/reddit.js';
import { getPool } from '../config/database.js';
import { ScoreCalculator } from './score-calculator.js';

interface CollectionResult {
  success: boolean;
  subreddit: string;
  postsProcessed: number;
  error?: Error;
}

export class RedditCollector {
  private storage: RedditStorage;
  private scoreCalculator: ScoreCalculator;
  private pool: any;

  constructor() {
    this.storage = new RedditStorage();
    this.scoreCalculator = new ScoreCalculator();
    this.pool = getPool();
  }

  private async processPost(
    scraper: IRedditScraper,
    subredditId: string,
    post: any,
    isLastPost: boolean
  ): Promise<void> {
    // Fetch comments for the post
    const comments = await scraper.getComments(post.id);
    logger.info(`Found ${comments.length} comments for post: ${post.title}`);

    // Store post with comments
    await this.storage.storePostWithComments(subredditId, post, comments);

    // Add delay between posts to be nice to Reddit's servers
    if (!isLastPost) {
      logger.info('Waiting 8 seconds before next post...');
      await new Promise(resolve => setTimeout(resolve, 8000));
    }
  }

  private async processSubreddit(
    scraper: IRedditScraper,
    subreddit: string,
    postLimit: number,
    sort: RedditSortType,
    time: RedditTimeFilter
  ): Promise<CollectionResult> {
    logger.info(`Processing subreddit: r/${subreddit}`);
    
    // Fetch posts
    const posts = await scraper.getPosts(postLimit, sort, time);
    if (!posts || posts.length === 0) {
      logger.warn(`No posts found for r/${subreddit}`);
      return { success: true, subreddit, postsProcessed: 0 };
    }

    // Store subreddit and get its ID
    const subredditId = await this.storage.storeSubreddit(subreddit.trim());

    // Process each post
    for (let i = 0; i < posts.length; i++) {
      const post = posts[i];
      const isLastPost = i === posts.length - 1;
      await this.processPost(scraper, subredditId, post, isLastPost);
    }

    return { success: true, subreddit, postsProcessed: posts.length };
  }

  private logResults(results: CollectionResult[]): void {
    const successful = results.filter(r => r.success).length;
    const total = results.length;
    logger.info(`Collection completed. Successfully processed ${successful}/${total} subreddits`);
    
    results.forEach(result => {
      if (result.success) {
        logger.info(`r/${result.subreddit}: Successfully processed ${result.postsProcessed} posts`);
      } else {
        logger.error(`r/${result.subreddit}: Failed to process posts`, result.error);
      }
    });
  }

  private checkForFailures(results: CollectionResult[]): void {
    if (results.some(r => !r.success)) {
      throw new Error('Some subreddits failed to process');
    }
  }

  public async collectAndStore(
    subreddits: string[],
    limit: number = 25,
    sort: RedditSortType = 'hot',
    time: RedditTimeFilter = 'day'
  ): Promise<void> {
    const results: CollectionResult[] = [];
    let earliestPostDate: Date | null = null;

    for (const subreddit of subreddits) {
      try {
        const scraper = new RedditScraper(subreddit.trim());
        const result = await this.processSubreddit(
          scraper,
          subreddit,
          limit,
          sort,
          time
        );
        results.push(result);

        // Add delay between subreddits
        if (subreddit !== subreddits[subreddits.length - 1]) {
          logger.info('Waiting 5 seconds before next subreddit...');
          await new Promise(resolve => setTimeout(resolve, 5000));
        }
      } catch (error) {
        logger.error(`Failed to process subreddit r/${subreddit}:`, error);
        results.push({
          success: false,
          subreddit,
          postsProcessed: 0,
          error: error instanceof Error ? error : new Error('Unknown error')
        });
      }
    }

    // Get the earliest post date from today's posts
    const earliestPost = await this.pool.query(
      `SELECT created_at 
       FROM posts 
       WHERE DATE(created_at) = CURRENT_DATE 
       ORDER BY created_at ASC 
       LIMIT 1`
    );

    if (earliestPost.rows.length > 0) {
      earliestPostDate = new Date(earliestPost.rows[0].created_at);
    }

    // Run scoring calculations after collecting all data
    if (earliestPostDate) {
      logger.info('Running scoring calculations for date:', earliestPostDate);
      try {
        await this.scoreCalculator.calculateScoresForDate(earliestPostDate);
      } catch (error) {
        logger.error('Error calculating scores and ranks:', error);
        throw error;
      }
    } else {
      logger.warn('No posts found for today, skipping scoring calculations');
    }

    // Log results and check for failures
    this.logResults(results);
    this.checkForFailures(results);
  }
} 