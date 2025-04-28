export interface DbPost {
  id: string;
  subreddit_id: string;
  subreddit_name?: string;
  author_id: string;
  title: string;
  selftext: string | null;
  content_url: string | null;
  score: number;
  num_comments: number;
  permalink: string;
  created_at: Date;
  updated_at: Date;
  reddit_created_at: Date;
  is_archived: boolean;
  is_locked: boolean;
  post_type: string;
  daily_rank: number;
  daily_score: number;
  keywords: string[];
  author_score: number;
  top_commenters: {
    username: string;
    contribution_score: number;
  }[];
  summary: string | null;
  sentiment: {
    score: number;
    label: string;
  } | null;
}

export interface DbComment {
  id: string;
  post_id: string;
  author_id: string;
  content: string;
  score: number;
  contribution_score: number;
  created_at: Date;
  updated_at: Date;
  reddit_created_at: Date;
  is_archived: boolean;
}

export interface DbUser {
  id: string;
  username: string;
  created_at: Date;
}

export interface DbSubredditStats {
  name: string;
  post_count: number;
}

export interface DbCommenterStats {
  username: string;
  comment_count: number;
} 