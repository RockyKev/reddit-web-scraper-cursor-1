import pkg from 'pg';
const { Pool } = pkg;
import { logger } from '../utils/logger.ts';
import { getPool } from '../config/database.ts';
import { RedditPost, RedditComment } from '../types/reddit.ts';

export class RedditStorage {
  private readonly pool: InstanceType<typeof Pool>;

  constructor() {
    this.pool = getPool();
  }

  public async storeSubreddit(name: string, description?: string): Promise<string> {
    try {
      const result = await this.pool.query(
        `INSERT INTO subreddits (name, description)
         VALUES ($1, $2)
         ON CONFLICT (name) DO UPDATE
         SET description = EXCLUDED.description
         RETURNING id`,
        [name, description]
      );

      return result.rows[0].id;
    } catch (error) {
      logger.error('Error storing subreddit:', error);
      throw error;
    }
  }

  public async storePost(subredditId: string, post: RedditPost): Promise<string> {
    try {
      const result = await this.pool.query(
        `INSERT INTO posts (
          subreddit_id, reddit_id, title, content, author,
          score, comment_count, url, permalink, post_type,
          reddit_created_at, is_archived, is_locked,
          keywords, author_score, top_commenters,
          summary, sentiment
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14::text[], $15, $16::jsonb, $17, $18::jsonb)
        ON CONFLICT (reddit_id) DO UPDATE
        SET
          title = EXCLUDED.title,
          content = EXCLUDED.content,
          score = EXCLUDED.score,
          comment_count = EXCLUDED.comment_count,
          permalink = EXCLUDED.permalink,
          post_type = EXCLUDED.post_type,
          is_archived = EXCLUDED.is_archived,
          is_locked = EXCLUDED.is_locked,
          keywords = EXCLUDED.keywords,
          author_score = EXCLUDED.author_score,
          top_commenters = EXCLUDED.top_commenters,
          summary = EXCLUDED.summary,
          sentiment = EXCLUDED.sentiment,
          updated_at = CURRENT_TIMESTAMP
        RETURNING id`,
        [
          subredditId,
          post.id,
          post.title,
          post.content,
          post.author,
          post.score,
          post.commentCount,
          post.url,
          post.permalink,
          post.post_type,
          post.createdAt,
          post.isArchived,
          post.isLocked,
          post.keywords,
          post.author_score,
          JSON.stringify(post.top_commenters),
          post.summary,
          post.sentiment ? JSON.stringify(post.sentiment) : null
        ]
      );

      return result.rows[0].id;
    } catch (error) {
      logger.error('Error storing post:', error);
      throw error;
    }
  }

  public async storeComment(postId: string, comment: RedditComment): Promise<string> {
    try {
      const result = await this.pool.query(
        `INSERT INTO comments (
          post_id, reddit_id, content, author,
          score, parent_id, reddit_created_at, is_archived,
          contribution_score
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        ON CONFLICT (reddit_id) DO UPDATE
        SET
          content = EXCLUDED.content,
          score = EXCLUDED.score,
          is_archived = EXCLUDED.is_archived,
          contribution_score = EXCLUDED.contribution_score,
          updated_at = CURRENT_TIMESTAMP
        RETURNING id`,
        [
          postId,
          comment.id,
          comment.content,
          comment.author,
          comment.score,
          comment.parentId,
          comment.createdAt,
          comment.isArchived,
          comment.contribution_score
        ]
      );

      return result.rows[0].id;
    } catch (error) {
      logger.error('Error storing comment:', error);
      throw error;
    }
  }

  public async getSubredditByName(name: string): Promise<{ id: string } | null> {
    try {
      const result = await this.pool.query(
        'SELECT id FROM subreddits WHERE name = $1',
        [name]
      );

      return result.rows[0] || null;
    } catch (error) {
      logger.error('Error getting subreddit:', error);
      throw error;
    }
  }

  public async getPostByRedditId(redditId: string): Promise<{ id: string } | null> {
    try {
      const result = await this.pool.query(
        'SELECT id FROM posts WHERE reddit_id = $1',
        [redditId]
      );

      return result.rows[0] || null;
    } catch (error) {
      logger.error('Error getting post:', error);
      throw error;
    }
  }
} 