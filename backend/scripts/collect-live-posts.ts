import 'dotenv/config';
import { RedditCollector } from '../services/reddit-collector.js';
import { RedditScraper } from '../services/reddit-scraper.js';
import { logger } from '../utils/logger.js';
import { RedditSortType, RedditTimeFilter } from '../types/reddit.js';

async function main() {
  try {
    // Get target subreddits from environment variable
    const subreddits = process.env.TARGET_SUBREDDITS?.split(',') || ['Portland'];
    const postLimit = parseInt(process.env.POSTS_PER_SUBREDDIT || '25');
    
    // Get sort and time parameters from environment or use defaults
    const sort = (process.env.REDDIT_SORT as RedditSortType) || 'top';
    const time = (process.env.REDDIT_TIME as RedditTimeFilter) || 'day';

    for (const subreddit of subreddits) {
      // Create real scraper instance (not mock)
      const scraper = new RedditScraper(subreddit.trim());
      const collector = new RedditCollector(scraper);

      logger.info(`Collecting ${sort}/${time} posts from r/${subreddit}`);
      await collector.collectAndStore(postLimit, sort, time);
      logger.info(`Completed collection for r/${subreddit}`);

      // Add delay between subreddits to be nice to Reddit's servers
      if (subreddits.length > 1) {
        logger.info('Waiting 5 seconds before next subreddit...');
        await new Promise(resolve => setTimeout(resolve, 5000));
      }
    }

    logger.info('Live data collection completed successfully');
  } catch (error) {
    logger.error('Live data collection failed:', error);
    process.exit(1);
  }
}

// Run the collection
main(); 