import { RedditService } from '../services/reddit-service';
import { logger } from '../utils/logger';

async function main() {
  try {
    // Initialize service with Portland subreddit
    const service = new RedditService('Portland');

    // Scrape and store the latest 10 posts with their comments
    await service.scrapeAndStore(10);

    // Test search functionality
    await service.searchAndStore('housing', 5);

    logger.info('Test completed successfully');
  } catch (error) {
    logger.error('Test failed:', error);
    process.exit(1);
  }
}

// Run the test
main(); 