export interface DbPost {
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
  top_commenters: any;
  summary: string;
  sentiment: any;
}

export interface DbComment {
  id: string;
  post_id: string;
  author_id: string;
  body: string;
  score: number;
  created_at: Date;
}

export interface DbUser {
  id: string;
  username: string;
  created_at: Date;
}

export interface DbSubredditStats {
  subreddit: string;
  post_count: number;
}

export interface DbCommenterStats {
  username: string;
  comment_count: number;
} 