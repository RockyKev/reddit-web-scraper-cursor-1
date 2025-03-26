// Types for Reddit data
export interface RedditPost {
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

export interface RedditComment {
  id: string;
  content: string;
  author: string;
  score: number;
  createdAt: Date;
  isArchived: boolean;
  parentId?: string;
}

// Base interface for Reddit scraper
export interface IRedditScraper {
  subreddit: string;
  getPosts(limit?: number): Promise<RedditPost[]>;
  getComments(postId: string): Promise<RedditComment[]>;
} 