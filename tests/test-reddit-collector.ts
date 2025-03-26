import 'dotenv/config';
import { RedditCollector } from '../src/services/reddit-collector.ts';
import { createRedditScraper } from '../src/services/reddit-scraper.ts';
import { logger } from '../src/utils/logger.ts';

async function main() {
  try {
    const subreddit = 'Portland';
    const collector = new RedditCollector(createRedditScraper(subreddit, true)); // Use mock scraper

    // Test basic collection and storage
    logger.info(`Testing collection for subreddit: ${subreddit}`);
    await collector.collectAndStore(5); // Limit to 5 posts for testing

    logger.info('Test completed successfully');
  } catch (error) {
    logger.error('Test failed:', error);
    process.exit(1);
  }
}

// Run the test
main(); 