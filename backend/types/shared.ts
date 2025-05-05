import pkg from 'pg';
const { Pool } = pkg;
export type DbPool = InstanceType<typeof Pool>;

// Common interfaces
export interface BaseEntity {
  id: string;
  created_at: Date;
  updated_at?: Date;
}

export interface Author {
  username: string;
  contribution_score: number;
}

export interface TopCommenter {
  username: string;
  contribution_score: number;
}

// Common types
export const PostType = {
  TEXT: 'text',
  LINK: 'link',
  IMAGE: 'image',
  VIDEO: 'video',
  GALLERY: 'gallery',
  POLL: 'poll',
  RICH_VIDEO: 'rich_video',
  CROSSPOST: 'crosspost'
} as const;

export type PostType = typeof PostType[keyof typeof PostType];

// Common constants
export const TOP_COMMENTERS_PER_POST = 5;
export const MAX_POSTS_PER_SUBREDDIT = 20; 