// Types for Reddit data
export type RedditSortType = 'hot' | 'new' | 'top' | 'rising' | 'controversial';
export type RedditTimeFilter = 'hour' | 'day' | 'week' | 'month' | 'year' | 'all';

export interface RedditAuthor {
  username: string;
  contribution_score: number;
}

export interface RedditSentiment {
  positive: number;
  negative: number;
}

export interface RedditPost {
  id: string;
  title: string;
  content: string;
  url: string;
  permalink: string;
  post_type: string;
  author: string;
  score: number;
  commentCount: number;
  createdAt: Date;
  isArchived: boolean;
  isLocked: boolean;
  keywords: string[];
  author_score: number;
  top_commenters: RedditAuthor[];
  summary: string | null;
  sentiment: RedditSentiment | null;
}

export interface RedditComment {
  id: string;
  content: string;
  author: string;
  score: number;
  createdAt: Date;
  isArchived: boolean;
  parentId?: string;
  contribution_score: number;
}

// Base interface for Reddit scraper
export interface IRedditScraper {
  subreddit: string;
  getPosts(limit?: number, sort?: RedditSortType, time?: RedditTimeFilter): Promise<RedditPost[]>;
  getComments(postId: string): Promise<RedditComment[]>;
} 