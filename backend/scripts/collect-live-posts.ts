import 'dotenv/config';
// import { RedditCollector } from '../services/reddit-collector.js';
import { RedditScraper } from '../services/reddit-scraper.js';
import { RedditSortType, RedditTimeFilter } from '../types/reddit.js';
// import { testDatabaseConnection } from '../config/database.js';
import { logger } from '../utils/logger.js';
import { RedditStorage } from '../services/reddit-storage.js';
import { ScoringService } from '../services/scoring-service.js';
import { getPool } from '../config/database.js';

async function main() {
  try {
    // Log environment variables (without sensitive data)
    logger.info('Environment check:', {
      NODE_ENV: process.env.NODE_ENV,
      TARGET_SUBREDDITS: process.env.TARGET_SUBREDDITS,
      POSTS_PER_SUBREDDIT: process.env.POSTS_PER_SUBREDDIT,
      REDDIT_SORT: process.env.REDDIT_SORT,
      REDDIT_TIME: process.env.REDDIT_TIME
    });

    // Get target subreddits from environment variable
    const subreddits = process.env.TARGET_SUBREDDITS?.split(',') || ['Portland'];
    const postLimit = parseInt(process.env.POSTS_PER_SUBREDDIT || '1');
    
    // Get sort and time parameters from environment or use defaults
    const sort = (process.env.REDDIT_SORT as RedditSortType) || 'top';
    const time = (process.env.REDDIT_TIME as RedditTimeFilter) || 'day';

    logger.info(`Starting scraping test with parameters:
      Subreddits: ${subreddits.join(', ')}
      Post Limit: ${postLimit}
      Sort: ${sort}
      Time: ${time}`);

    // Test database connection first
    try {
      const pool = getPool();
      const client = await pool.connect();
      logger.info('Database connection successful');
      client.release();
    } catch (dbError) {
      logger.error('Failed to connect to database:', dbError);
      throw dbError;
    }

    const storage = new RedditStorage();
    const scoringService = new ScoringService(getPool());

    for (const subreddit of subreddits) {
      try {
        // Create real scraper instance (not mock)
        const scraper = new RedditScraper(subreddit.trim());

        logger.info(`Fetching ${sort}/${time} posts from r/${subreddit}`);

        

        const posts = await scraper.getPosts(postLimit, sort, time);
        
        if (!posts || posts.length === 0) {
          logger.warn(`No posts found for r/${subreddit}`);
          continue;
        }

        logger.info(`Found ${posts.length} posts`);
        logger.info('First post details:', {
          id: posts[0].id,
          title: posts[0].title,
          author: posts[0].author,
          score: posts[0].score,
          commentCount: posts[0].commentCount
        });

        // Store subreddit and get its ID
        const subredditId = await storage.storeSubreddit(subreddit.trim());

        // Store posts and their comments
        for (const post of posts) {
          try {
            // Fetch comments for the post
            const comments = await scraper.getComments(post.id);
            logger.info(`Found ${comments.length} comments for post: ${post.title}`);

            // Store post with comments
            await storage.storePostWithComments(subredditId, post, comments);

            // Add delay between posts to be nice to Reddit's servers
            if (posts.length > 1) {
              logger.info('Waiting 8 seconds before next post...');
              await new Promise(resolve => setTimeout(resolve, 8000));
            }
          } catch (postError) {
            logger.error(`Failed to process post ${post.id}:`, postError);
            continue;
          }
        }

        // Add delay between subreddits to be nice to Reddit's servers
        if (subreddits.length > 1) {
          logger.info('Waiting 5 seconds before next subreddit...');
          await new Promise(resolve => setTimeout(resolve, 5000));
        }
      } catch (subredditError) {
        logger.error(`Failed to scrape r/${subreddit}:`, subredditError);
        if (subredditError instanceof Error) {
          logger.error('Error details:', {
            message: subredditError.message,
            stack: subredditError.stack,
            name: subredditError.name
          });
        }
        // Continue with next subreddit even if one fails
        continue;
      }
    }

    // Run scoring calculations after collecting all data
    logger.info('Running scoring calculations...');
    await scoringService.updateDailyScores(new Date());
    logger.info('Scraping test completed successfully');
  } catch (error) {
    logger.error('Scraping test failed:', error);
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