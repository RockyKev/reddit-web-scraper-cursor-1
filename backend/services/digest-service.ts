import { db } from '../db/index.js';
import { DbPost, DbComment, DbUser, DbSubredditStats, DbCommenterStats } from '../types/database.js';
import { ScoringService } from './scoring-service.js';

interface DigestSummary {
  total_posts: number;
  total_comments: number;
  top_subreddits: string[];
}

interface PostAuthor {
  username: string;
  contribution_score: number;
}

interface TopCommenter {
  username: string;
  contribution_score: number;
}

interface Post {
  id: string;
  subreddit_id: string;
  reddit_id: string;
  title: string;
  selftext: string;
  url: string;
  score: number;
  num_comments: number;
  created_at: Date;
  updated_at: Date;
  reddit_created_at: Date;
  is_archived: boolean;
  is_locked: boolean;
  post_type: string;
  daily_rank: number;
  daily_score: number;
  author_id: string;
  keywords: string[];
  author_score: number;
  top_commenters: TopCommenter[];
  summary: string | null;
  sentiment: any | null;
}

interface DigestResponse {
  date: string;
  summary: DigestSummary;
  top_posts: Post[];
}

export class DigestService {
  private scoringService: ScoringService;

  constructor() {
    this.scoringService = new ScoringService(db);
  }

  async getDigest(date?: string): Promise<DigestResponse> {
    const targetDate = date || new Date().toISOString().split('T')[0];
    
    // Update scores and ranks for the date
    await this.scoringService.updateDailyScores(new Date(targetDate));
    
    // Get posts for the date, ordered by daily rank
    const postsResult = await db.query<DbPost>(
      'SELECT * FROM posts WHERE DATE(created_at) = $1 ORDER BY daily_rank ASC',
      [targetDate]
    );

    if (postsResult.rows.length === 0) {
      throw new Error('No data found for the specified date');
    }

    // Get comments for the date
    const commentsResult = await db.query<DbComment>(
      'SELECT c.* FROM comments c JOIN posts p ON c.post_id = p.id WHERE DATE(p.created_at) = $1',
      [targetDate]
    );

    // Get top subreddits
    const subredditsResult = await db.query<DbSubredditStats>(
      'SELECT subreddit, COUNT(*) as post_count FROM posts WHERE DATE(created_at) = $1 GROUP BY subreddit ORDER BY post_count DESC LIMIT 5',
      [targetDate]
    );

    // Process posts to include additional data
    const processedPosts = await Promise.all(
      postsResult.rows.map(async (post: DbPost) => {
        // Get post author
        const authorResult = await db.query<DbUser>(
          'SELECT username FROM users WHERE id = $1',
          [post.author_id]
        );

        // Get top commenters for this post
        const topCommentersResult = await db.query<DbCommenterStats>(
          'SELECT u.username, COUNT(*) as comment_count FROM comments c JOIN users u ON c.author_id = u.id WHERE c.post_id = $1 GROUP BY u.username ORDER BY comment_count DESC LIMIT 3',
          [post.id]
        );

        return {
          id: post.id,
          subreddit_id: post.subreddit_id,
          reddit_id: post.reddit_id,
          title: post.title,
          selftext: post.selftext || '',
          url: post.url || '',
          score: post.score,
          num_comments: post.num_comments,
          created_at: post.created_at,
          updated_at: post.updated_at,
          reddit_created_at: post.reddit_created_at,
          is_archived: post.is_archived,
          is_locked: post.is_locked,
          post_type: post.post_type,
          daily_rank: post.daily_rank || 0,
          daily_score: post.daily_score || 0,
          author_id: post.author_id,
          keywords: [], // Will be populated in Phase 2
          author_score: 0, // Will be calculated in Phase 2
          top_commenters: topCommentersResult.rows.map((row: DbCommenterStats) => ({
            username: row.username,
            contribution_score: 0 // Will be calculated in Phase 2
          })),
          summary: null, // Will be populated in Phase 4
          sentiment: null // Will be populated in Phase 4
        };
      })
    );

    return {
      date: targetDate,
      summary: {
        total_posts: postsResult.rows.length,
        total_comments: commentsResult.rows.length,
        top_subreddits: subredditsResult.rows.map((row: DbSubredditStats) => row.subreddit)
      },
      top_posts: processedPosts
    };
  }
} 