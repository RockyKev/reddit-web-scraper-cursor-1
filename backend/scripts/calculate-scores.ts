import 'dotenv/config';
import { getPool } from '../config/database.js';
import { ScoringService } from '../services/scoring-service.js';
import { logger } from '../utils/logger.js';

async function calculateScores(date: string) {
  try {
    logger.info(`Calculating scores for date: ${date}`);
    
    // Initialize services
    const pool = getPool();
    const scoringService = new ScoringService(pool);

    // First, update user statistics
    logger.info('Updating user statistics...');
    await pool.query(`
      WITH user_stats AS (
        SELECT 
          author_id,
          COUNT(*) as post_count,
          SUM(score) as total_score
        FROM posts
        WHERE DATE(created_at) = $1
        GROUP BY author_id
      )
      UPDATE users u
      SET 
        total_posts = COALESCE(u.total_posts, 0) + us.post_count,
        total_posts_score = COALESCE(u.total_posts_score, 0) + us.total_score,
        updated_at = CURRENT_TIMESTAMP
      FROM user_stats us
      WHERE u.id = us.author_id
    `, [date]);

    // Then calculate daily scores and ranks
    logger.info('Calculating daily scores and ranks...');
    await scoringService.updateDailyScores(new Date(date));

    logger.info('Score calculation completed successfully');
  } catch (error) {
    logger.error('Error calculating scores:', error);
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

// Get date from command line argument or use today's date
const date = process.argv[2] || new Date().toISOString().split('T')[0];
calculateScores(date); 