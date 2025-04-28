import { getPool } from '../config/database.js';
import { logger } from '../utils/logger.js';

export class ScoreCalculator {
  private readonly pool: any;

  constructor() {
    this.pool = getPool();
  }

  /**
   * Calculate scores and ranks for posts from a specific date
   */
  public async calculateScoresForDate(date: string | Date): Promise<void> {
    const targetDate = typeof date === 'string' ? date : date.toISOString().split('T')[0];
    
    try {
      logger.info(`Calculating scores for date: ${targetDate}`);

      // First, update user statistics
      logger.info('Updating user statistics...');
      await this.pool.query(`
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
      `, [targetDate]);

      // Then, calculate daily scores
      logger.info('Calculating daily scores...');
      await this.pool.query(
        `UPDATE posts 
         SET daily_score = (score * 1.0) + (num_comments * 2.0)
         WHERE DATE(created_at) = $1`,
        [targetDate]
      );

      // Finally, update daily ranks based on daily_score
      logger.info('Updating daily ranks...');
      await this.pool.query(
        `WITH ranked_posts AS (
          SELECT id, ROW_NUMBER() OVER (ORDER BY daily_score DESC) as rank
          FROM posts
          WHERE DATE(created_at) = $1
        )
        UPDATE posts p
        SET daily_rank = r.rank
        FROM ranked_posts r
        WHERE p.id = r.id`,
        [targetDate]
      );

      // Verify the updates
      const verification = await this.pool.query(
        `SELECT id, title, score, num_comments, daily_score, daily_rank
         FROM posts
         WHERE DATE(created_at) = $1
         ORDER BY daily_rank ASC`,
        [targetDate]
      );

      logger.info('Score calculation completed successfully');
      logger.info('Verification results:', verification.rows);
    } catch (error) {
      logger.error('Error calculating scores:', error);
      if (error instanceof Error) {
        logger.error('Error details:', {
          message: error.message,
          stack: error.stack,
          name: error.name
        });
      }
      throw error;
    }
  }
} 