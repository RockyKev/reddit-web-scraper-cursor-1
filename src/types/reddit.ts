// Types for Reddit data
export type RedditSortType = 'hot' | 'new' | 'top' | 'rising' | 'controversial';
export type RedditTimeFilter = 'hour' | 'day' | 'week' | 'month' | 'year' | 'all';

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
  getPosts(limit?: number, sort?: RedditSortType, time?: RedditTimeFilter): Promise<RedditPost[]>;
  getComments(postId: string): Promise<RedditComment[]>;
} 