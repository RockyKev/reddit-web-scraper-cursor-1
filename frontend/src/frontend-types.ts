export interface Post {
  id: string;
  subreddit_id: string;
  reddit_id: string;
  title: string;
  content: string;
  permalink: string;
  score: number;
  num_comments: number;
  created_at: string;
  updated_at: string;
  reddit_created_at: string;
  is_archived: boolean;
  is_locked: boolean;
  post_type: string;
  daily_rank: number;
  daily_score: number;
  author: {
    username: string;
    reddit_id: string;
    contribution_score: number;
  };
  keywords: string[];
  top_commenters: Array<{
    username: string;
    contribution_score: number;
  }>;
  summary: string | null;
  sentiment: any | null;
  subreddit: string;
}

export interface DigestData {
  date: string;
  summary: {
    total_posts: number;
    total_comments: number;
    top_subreddits: Array<{
      name: string;
      post_count: number;
    }>;
  };
  top_posts: Post[];
} 