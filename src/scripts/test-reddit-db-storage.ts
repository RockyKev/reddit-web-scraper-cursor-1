import 'dotenv/config';
import { RedditService } from '../services/reddit-service.ts';
import { createRedditScraper } from '../services/reddit-scraper.ts';
import { logger } from '../utils/logger.ts';

async function main() {
  try {
    const subreddit = 'Portland';
    const service = new RedditService(createRedditScraper(subreddit, true)); // Use mock scraper

    // Test basic scraping and storage
    logger.info(`Processing subreddit: ${subreddit}`);
    await service.scrapeAndStore();

    // Test search functionality
    const searchQuery = 'housing';
    logger.info(`Searching subreddit: ${subreddit} for: ${searchQuery}`);
    await service.searchAndStore(searchQuery);

    logger.info('Test completed successfully');
  } catch (error) {
    logger.error('Test failed:', error);
    process.exit(1);
  }
}

// Run the test
main(); 