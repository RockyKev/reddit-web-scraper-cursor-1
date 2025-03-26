import { Pool } from 'pg';
import { logger } from '../utils/logger';
import { getPool } from '../config/database';

interface RedditPost {
  id: string;
  title: string;
  content: string;
  url: string;
  author: string;
  score: number;
  commentCount: number;
  createdAt: Date;
  isArchived: boolean;
  isLocked: boolean;
}

interface RedditComment {
  id: string;
  content: string;
  author: string;
  score: number;
  createdAt: Date;
  isArchived: boolean;
  parentId?: string;
}

export class RedditStorage {
  private pool: Pool;

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
          score, comment_count, url, reddit_created_at,
          is_archived, is_locked
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        ON CONFLICT (reddit_id) DO UPDATE
        SET
          title = EXCLUDED.title,
          content = EXCLUDED.content,
          score = EXCLUDED.score,
          comment_count = EXCLUDED.comment_count,
          is_archived = EXCLUDED.is_archived,
          is_locked = EXCLUDED.is_locked,
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
          post.createdAt,
          post.isArchived,
          post.isLocked
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
          score, parent_id, reddit_created_at, is_archived
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        ON CONFLICT (reddit_id) DO UPDATE
        SET
          content = EXCLUDED.content,
          score = EXCLUDED.score,
          is_archived = EXCLUDED.is_archived,
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
          comment.isArchived
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