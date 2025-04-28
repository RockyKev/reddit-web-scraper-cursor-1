import pkg from 'pg';
const { Pool } = pkg;
import { logger } from '../utils/logger.js';
import { getPool } from '../config/database.js';
import { RedditPost, RedditComment } from '../types/reddit.js';
import { KeywordAnalysisService } from './keyword-analysis-service.js';
import type { DbPool } from '../types/shared.js';
import { ScoringService } from './scoring-service.js';

export class RedditStorage {
  private readonly pool: DbPool;
  private readonly keywordAnalyzer: KeywordAnalysisService;
  private readonly scoringService: ScoringService;

  constructor() {
    this.pool = getPool();
    this.keywordAnalyzer = new KeywordAnalysisService();
    this.scoringService = new ScoringService(this.pool);
  }

  public async storeUser(authorId: string, username: string): Promise<string> {
    try {
      const result = await this.pool.query(
        `INSERT INTO users (
          id, username, total_posts, total_comments,
          total_posts_score, total_comments_score,
          contributor_score, first_seen, last_seen
        )
        VALUES ($1, $2, 0, 0, 0, 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        ON CONFLICT (id) DO UPDATE
        SET 
          username = EXCLUDED.username,
          last_seen = CURRENT_TIMESTAMP,
          updated_at = CURRENT_TIMESTAMP
        RETURNING id`,
        [authorId, username]
      );

      return result.rows[0].id;
    } catch (error) {
      logger.error('Error storing user:', error);
      throw error;
    }
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
      // Calculate daily score
      const dailyScore = (post.score * 1.0) + (post.commentCount * 2.0);

      // First check if this post already exists
      const existingPost = await this.pool.query(
        'SELECT id, score FROM posts WHERE author_id = $1 AND permalink = $2',
        [post.author_fullname, post.permalink]
      );

      const result = await this.pool.query(
        `INSERT INTO posts (
          subreddit_id, author_id, title, selftext, url,
          score, num_comments, permalink, post_type,
          reddit_created_at, is_archived, is_locked,
          keywords, author_score, top_commenters,
          summary, sentiment, daily_score
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13::text[], $14, $15::jsonb, $16, $17::jsonb, $18)
        ON CONFLICT (author_id, permalink) DO UPDATE
        SET
          title = EXCLUDED.title,
          selftext = EXCLUDED.selftext,
          url = EXCLUDED.url,
          score = EXCLUDED.score,
          num_comments = EXCLUDED.num_comments,
          post_type = EXCLUDED.post_type,
          is_archived = EXCLUDED.is_archived,
          is_locked = EXCLUDED.is_locked,
          keywords = EXCLUDED.keywords,
          author_score = EXCLUDED.author_score,
          top_commenters = EXCLUDED.top_commenters,
          summary = EXCLUDED.summary,
          sentiment = EXCLUDED.sentiment,
          daily_score = EXCLUDED.daily_score,
          updated_at = CURRENT_TIMESTAMP
        RETURNING id`,
        [
          subredditId,
          post.author_fullname,
          post.title,
          post.content,
          post.url,
          post.score,
          post.commentCount,
          post.permalink,
          post.post_type,
          post.createdAt,
          post.isArchived,
          post.isLocked,
          post.keywords,
          post.author_score,
          JSON.stringify(post.top_commenters),
          post.summary,
          post.sentiment ? JSON.stringify(post.sentiment) : null,
          dailyScore
        ]
      );

      // Update user statistics
      if (existingPost.rows.length === 0) {
        // New post - increment total_posts
        await this.pool.query(
          `UPDATE users 
           SET 
             total_posts = total_posts + 1,
             total_posts_score = total_posts_score + $1,
             updated_at = CURRENT_TIMESTAMP
           WHERE id = $2`,
          [post.score, post.author_fullname]
        );
      } else {
        // Existing post - update score difference
        const oldScore = existingPost.rows[0].score;
        const scoreDiff = post.score - oldScore;
        if (scoreDiff !== 0) {
          await this.pool.query(
            `UPDATE users 
             SET 
               total_posts_score = total_posts_score + $1,
               updated_at = CURRENT_TIMESTAMP
             WHERE id = $2`,
            [scoreDiff, post.author_fullname]
          );
        }
      }

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
          post_id, reddit_id, content, author_id,
          score, reddit_created_at, is_archived,
          contribution_score
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
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
          comment.author_fullname,
          comment.score,
          comment.createdAt,
          comment.isArchived,
          comment.contribution_score
        ]
      );

      // Update user statistics
      await this.pool.query(
        `UPDATE users 
         SET 
           total_comments = total_comments + 1,
           total_comments_score = total_comments_score + $1,
           updated_at = CURRENT_TIMESTAMP
         WHERE id = $2`,
        [comment.score, comment.author_fullname]
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

  /**
   * Store a post with its comments and extracted keywords
   * @param subredditId The ID of the subreddit
   * @param post The Reddit post
   * @param comments Array of comments on the post
   * @returns The stored post ID
   */
  public async storePostWithComments(
    subredditId: string,
    post: RedditPost,
    comments: RedditComment[]
  ): Promise<string> {
    try {
      // Store the post author
      await this.storeUser(post.author_fullname, post.author);

      // Store comment authors
      for (const comment of comments) {
        if (comment.author_fullname !== '[deleted]' && comment.author_fullname !== '[removed]') {
          await this.storeUser(comment.author_fullname, comment.author);
        }
      }

      // Extract keywords from post and comments
      const keywords = this.keywordAnalyzer.extractKeywordsFromPost(post, comments);
      
      // Update post with extracted keywords
      const postWithKeywords = {
        ...post,
        keywords
      };

      // Store the post
      const postId = await this.storePost(subredditId, postWithKeywords);

      // Store all comments
      for (const comment of comments) {
        await this.storeComment(postId, comment);
      }

      // Update daily ranks for all posts from this date
      await this.scoringService.updateDailyScores(new Date(post.createdAt));

      return postId;
    } catch (error) {
      logger.error('Error storing post with comments:', error);
      throw error;
    }
  }
} 