export interface DbPost {
  id: string;
  subreddit: string;
  title: string;
  type: string;
  upvotes: number;
  comment_count: number;
  permalink: string;
  selftext: string;
  url: string;
  author_id: string;
  created_at: Date;
  daily_score: number;
  daily_rank: number;
}

export interface DbComment {
  id: string;
  post_id: string;
  author_id: string;
  body: string;
  upvotes: number;
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