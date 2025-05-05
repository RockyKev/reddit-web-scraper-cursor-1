import 'dotenv/config';
import { RedditSortType, RedditTimeFilter } from '../types/reddit.js';
import { logger } from '../utils/logger.js';
import { RedditCollector } from '../services/reddit-collector.js';
import { getPool } from '../config/database.js';

// Configuration types and interfaces
interface ScrapingConfig {
  subreddits: string[];
  postLimit: number;
  sort: RedditSortType;
  time: RedditTimeFilter;
}

// Configuration functions
function loadConfiguration(): ScrapingConfig {
  const subreddits = process.env.TARGET_SUBREDDITS?.split(',') || ['Portland'];
  const postLimit = parseInt(process.env.POSTS_PER_SUBREDDIT || '1');
  const sort = (process.env.REDDIT_SORT as RedditSortType) || 'top';
  const time = (process.env.REDDIT_TIME as RedditTimeFilter) || 'day';

  logger.info('Loaded configuration:', {
    subreddits,
    postLimit,
    sort,
    time
  });

  return { subreddits, postLimit, sort, time };
}

// Database functions
async function testDatabaseConnection(): Promise<void> {
  const pool = getPool();
  const client = await pool.connect();
  logger.info('Database connection successful');
  client.release();
}

// Main execution
async function main() {
  try {
    // Load configuration
    const config = loadConfiguration();

    // Test database connection
    await testDatabaseConnection();

    // Create collector and run collection
    const collector = new RedditCollector();
    await collector.collectAndStore(
      config.subreddits,
      config.postLimit,
      config.sort,
      config.time
    );
    
    logger.info('Scraping process completed successfully');
  } catch (error) {
    logger.error('Scraping process failed:', error);
    if (error instanceof Error) {
      logger.error('Error details:', {
        message: error.message,
        stack: error.stack,
        name: error.name
      });
    }
    process.exit(1);
  }
}

// Run the main function
main().catch(error => {
  logger.error('Unhandled error in main:', error);
  if (error instanceof Error) {
    logger.error('Error details:', {
      message: error.message,
      stack: error.stack,
      name: error.name
    });
  }
  process.exit(1);
}); 