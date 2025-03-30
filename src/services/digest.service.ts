import { db } from '../db';
import { DbPost, DbComment, DbUser, DbSubredditStats, DbCommenterStats } from '../types/database';

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
  subreddit: string;
  title: string;
  type: string;
  upvotes: number;
  comment_count: number;
  permalink: string;
  keywords: string[];
  author: PostAuthor;
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
  async getDigest(date?: string): Promise<DigestResponse> {
    const targetDate = date || new Date().toISOString().split('T')[0];
    
    // Get posts for the date
    const postsResult = await db.query<DbPost>(
      'SELECT * FROM posts WHERE DATE(created_at) = $1 ORDER BY upvotes DESC',
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
          ...post,
          keywords: [], // Will be populated in Phase 2
          author: {
            username: authorResult.rows[0]?.username || 'unknown',
            contribution_score: 0 // Will be calculated in Phase 2
          },
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