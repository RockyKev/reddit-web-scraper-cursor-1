import { getPool } from '../config/database.js';
import { DbPost, DbComment, DbUser, DbSubredditStats, DbCommenterStats } from '../types/database.js';
import { ScoreCalculator } from './score-calculator.js';
import { logger } from '../utils/logger.js';

interface DigestSummary {
  total_posts: number;
  total_comments: number;
  top_subreddits: Array<{
    name: string;
    post_count: number;
  }>;
}

interface Author {
  username: string;
  reddit_id: string;
  contribution_score: number;
}

interface TopCommenter {
  username: string;
  contribution_score: number;
}

interface Post {
  id: string;
  title: string;
  content: string;
  permalink: string;
  score: number;
  num_comments: number;
  created_at: Date;
  is_archived: boolean;
  is_locked: boolean;
  post_type: string;
  daily_rank: number;
  daily_score: number;
  author: Author;
  keywords: string[];
  top_commenters: TopCommenter[];
  summary: string | null;
  sentiment: any | null;
  subreddit: string;
}

interface DigestResponse {
  date: string;
  summary: DigestSummary;
  top_posts: Post[];
  top_commenters: TopCommenter[];
}

export class DigestService {
  private readonly scoreCalculator: ScoreCalculator;

  constructor() {
    this.scoreCalculator = new ScoreCalculator();
  }

  private getPostContent(post: DbPost): string {
    // For text posts and self posts, check both selftext and content_url
    if (post.post_type === 'text' || post.post_type === 'self') {
      if (post.selftext) {
        return post.selftext;
      }
      if (post.content_url) {
        return post.content_url;
      }
    }

    // For link posts, image posts, and video posts, always use content_url if available
    if ((post.post_type === 'link' || post.post_type === 'image' || post.post_type === 'hosted:video') && post.content_url) {
      return post.content_url;
    }

    // For other post types or if no content_url, use permalink
    return post.permalink;
  }

  async getDigest(date?: string): Promise<DigestResponse> {
    const targetDate = date || new Date().toISOString().split('T')[0];
    
    // Update scores and ranks for the date
    await this.scoreCalculator.calculateScoresForDate(targetDate);
    
    // Get posts for the date, ordered by daily rank
    const postsResult = await getPool().query<DbPost>(
      `SELECT 
        p.id, p.title, p.selftext, p.permalink, p.score, p.num_comments,
        p.created_at, p.is_archived, p.is_locked, p.post_type,
        p.daily_rank, p.daily_score, p.author_id, p.keywords,
        p.author_score, p.summary, p.sentiment, p.content_url,
        s.name as subreddit_name 
       FROM posts p 
       JOIN subreddits s ON p.subreddit_id = s.id 
       WHERE DATE(p.created_at) = $1 
       ORDER BY p.daily_rank ASC`,
      [targetDate]
    );

    if (postsResult.rows.length === 0) {
      throw new Error('No data found for the specified date');
    }

    // Get comments for the date
    const commentsResult = await getPool().query<DbComment>(
      'SELECT c.* FROM comments c JOIN posts p ON c.post_id = p.id WHERE DATE(p.created_at) = $1',
      [targetDate]
    );

    // Get top subreddits with post counts
    const subredditsResult = await getPool().query<DbSubredditStats>(
      `SELECT s.name, COUNT(p.id) as post_count 
       FROM subreddits s 
       JOIN posts p ON s.id = p.subreddit_id 
       WHERE DATE(p.created_at) = $1 
       GROUP BY s.name 
       ORDER BY post_count DESC 
       LIMIT 5`,
      [targetDate]
    );

    // Get top commenters for the day
    const topCommentersResult = await getPool().query<DbCommenterStats>(
      `SELECT u.username, COUNT(*) as comment_count 
       FROM comments c 
       JOIN users u ON c.author_id = u.id 
       JOIN posts p ON c.post_id = p.id 
       WHERE DATE(p.created_at) = $1 
       GROUP BY u.username 
       ORDER BY comment_count DESC 
       LIMIT 5`,
      [targetDate]
    );

    // Process posts to include additional data
    const processedPosts = await Promise.all(
      postsResult.rows.map(async (post: DbPost) => {
        // Get post author
        const authorResult = await getPool().query<DbUser>(
          'SELECT * FROM users WHERE id = $1',
          [post.author_id]
        );

        // Get top commenters for this post
        const postTopCommentersResult = await getPool().query<DbCommenterStats>(
          `SELECT u.username, COUNT(*) as comment_count 
           FROM comments c 
           JOIN users u ON c.author_id = u.id 
           WHERE c.post_id = $1 
           GROUP BY u.username 
           ORDER BY comment_count DESC 
           LIMIT 3`,
          [post.id]
        );

        return {
          id: post.id,
          title: post.title,
          content: this.getPostContent(post),
          permalink: post.permalink,
          score: post.score,
          num_comments: post.num_comments,
          created_at: post.created_at,
          is_archived: post.is_archived,
          is_locked: post.is_locked,
          post_type: post.post_type,
          daily_rank: post.daily_rank || 0,
          daily_score: post.daily_score || 0,
          subreddit: post.subreddit_name || 'unknown',
          author: {
            username: authorResult.rows[0]?.username || 'unknown',
            reddit_id: post.author_id,
            contribution_score: post.author_score || 0
          },
          keywords: post.keywords || [],
          top_commenters: postTopCommentersResult.rows.map((row: DbCommenterStats) => ({
            username: row.username,
            contribution_score: 0
          })),
          summary: post.summary,
          sentiment: post.sentiment
        };
      })
    );

    return {
      date: targetDate,
      summary: {
        total_posts: postsResult.rows.length,
        total_comments: commentsResult.rows.length,
        top_subreddits: subredditsResult.rows.map((row: DbSubredditStats) => ({
          name: row.name,
          post_count: parseInt(row.post_count.toString())
        }))
      },
      top_posts: processedPosts,
      top_commenters: topCommentersResult.rows.map((row: DbCommenterStats) => ({
        username: row.username,
        contribution_score: 0
      }))
    };
  }

  public async getDailyDigest(targetDate: Date): Promise<any> {
    // Update scores and ranks for the date
    await this.scoreCalculator.calculateScoresForDate(targetDate);
    
    // Get posts for the date, ordered by daily rank
    const postsResult = await getPool().query<DbPost>(
      `SELECT 
        p.id, p.title, p.selftext, p.permalink, p.score, p.num_comments,
        p.created_at, p.is_archived, p.is_locked, p.post_type,
        p.daily_rank, p.daily_score, p.author_id, p.keywords,
        p.author_score, p.summary, p.sentiment, p.content_url,
        s.name as subreddit_name 
       FROM posts p 
       JOIN subreddits s ON p.subreddit_id = s.id 
       WHERE DATE(p.created_at) = $1 
       ORDER BY p.daily_rank ASC`,
      [targetDate]
    );

    // Debug log for raw query results
    console.log('Raw query results:', postsResult.rows.map(row => ({
      id: row.id,
      daily_rank: row.daily_rank,
      daily_score: row.daily_score,
      score: row.score,
      num_comments: row.num_comments
    })));

    // Get comments for the date
    const commentsResult = await getPool().query<DbComment>(
      'SELECT c.* FROM comments c JOIN posts p ON c.post_id = p.id WHERE DATE(p.created_at) = $1',
      [targetDate]
    );

    // Get top subreddits with post counts
    const subredditsResult = await getPool().query<DbSubredditStats>(
      `SELECT s.name, COUNT(p.id) as post_count 
       FROM subreddits s 
       JOIN posts p ON s.id = p.subreddit_id 
       WHERE DATE(p.created_at) = $1 
       GROUP BY s.name 
       ORDER BY post_count DESC 
       LIMIT 5`,
      [targetDate]
    );

    // Get top commenters for the day
    const topCommentersResult = await getPool().query<DbCommenterStats>(
      `SELECT u.username, COUNT(*) as comment_count 
       FROM comments c 
       JOIN users u ON c.author_id = u.id 
       JOIN posts p ON c.post_id = p.id 
       WHERE DATE(p.created_at) = $1 
       GROUP BY u.username 
       ORDER BY comment_count DESC 
       LIMIT 5`,
      [targetDate]
    );

    // Enrich posts with author and top commenters
    const enrichedPosts = await Promise.all(
      postsResult.rows.map(async (post: DbPost) => {
        // Get post author
        const authorResult = await getPool().query<DbUser>(
          'SELECT * FROM users WHERE id = $1',
          [post.author_id]
        );

        // Get top commenters for this post
        const postTopCommentersResult = await getPool().query<DbCommenterStats>(
          `SELECT u.username, COUNT(*) as comment_count 
           FROM comments c 
           JOIN users u ON c.author_id = u.id 
           WHERE c.post_id = $1 
           GROUP BY u.username 
           ORDER BY comment_count DESC 
           LIMIT 3`,
          [post.id]
        );

        return {
          id: post.id,
          title: post.title,
          content: this.getPostContent(post),
          permalink: post.permalink,
          score: post.score,
          num_comments: post.num_comments,
          created_at: post.created_at,
          is_archived: post.is_archived,
          is_locked: post.is_locked,
          post_type: post.post_type,
          daily_rank: post.daily_rank || 0,
          daily_score: post.daily_score || 0,
          subreddit: post.subreddit_name || 'unknown',
          author: {
            username: authorResult.rows[0]?.username || 'unknown',
            reddit_id: post.author_id,
            contribution_score: post.author_score || 0
          },
          keywords: post.keywords || [],
          top_commenters: postTopCommentersResult.rows.map((row: DbCommenterStats) => ({
            username: row.username,
            contribution_score: 0
          })),
          summary: post.summary,
          sentiment: post.sentiment
        };
      })
    );

    return {
      date: targetDate,
      summary: {
        total_posts: postsResult.rows.length,
        total_comments: commentsResult.rows.length,
        top_subreddits: subredditsResult.rows.map((row: DbSubredditStats) => ({
          name: row.name,
          post_count: parseInt(row.post_count.toString())
        }))
      },
      top_posts: enrichedPosts,
      top_commenters: topCommentersResult.rows.map((row: DbCommenterStats) => ({
        username: row.username,
        contribution_score: 0
      }))
    };
  }
} 