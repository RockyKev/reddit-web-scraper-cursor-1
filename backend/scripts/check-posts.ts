import 'dotenv/config';
import { getPool } from '../config/database.js';
import { logger } from '../utils/logger.js';

async function checkPosts() {
  try {
    const pool = getPool();
    const result = await pool.query(
      'SELECT reddit_id, title, permalink, post_type FROM posts LIMIT 5'
    );
    
    logger.info('Posts in database:');
    result.rows.forEach((row, index) => {
      logger.info(`\nPost ${index + 1}:`);
      logger.info(`  ID: ${row.reddit_id}`);
      logger.info(`  Title: ${row.title}`);
      logger.info(`  Permalink: ${row.permalink}`);
      logger.info(`  Type: ${row.post_type}`);
    });
  } catch (error) {
    logger.error('Error checking posts:', error);
  }
}

checkPosts(); 