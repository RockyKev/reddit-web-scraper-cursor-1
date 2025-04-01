import { readFileSync } from 'fs';
import { join } from 'path';
import { Author, TopCommenter, PostType } from '../types/shared.js';

interface RedditPost {
  data: {
    title: string;
    subreddit: string;
    author: string;
    selftext: string;
    score: number;
    upvote_ratio: number;
    permalink: string;
    num_comments: number;
    created_utc: number;
  };
}

interface RedditResponse {
  data: {
    children: RedditPost[];
  };
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
  top_commenters: Array<{
    username: string;
    contribution_score: number;
  }>;
  summary: string | null;
  sentiment: any | null;
}

interface DigestData {
  date: string;
  summary: {
    total_posts: number;
    total_comments: number;
    top_subreddits: string[];
  };
  top_posts: Post[];
}

// Mock keywords for testing
const MOCK_KEYWORDS = [
  'portland', 'oregon', 'city', 'local', 'news', 'events', 'community',
  'food', 'restaurants', 'parks', 'transportation', 'housing', 'weather',
  'business', 'culture', 'art', 'music', 'sports', 'education', 'health'
];

function generateMockKeywords(): string[] {
  const numKeywords = Math.floor(Math.random() * 5) + 3; // 3-7 keywords
  const shuffled = [...MOCK_KEYWORDS].sort(() => 0.5 - Math.random());
  return shuffled.slice(0, numKeywords);
}

function transformRedditPost(post: RedditPost, rank: number): Post {
  const now = new Date();
  const redditCreatedAt = new Date(post.data.created_utc * 1000);
  
  return {
    id: `mock-${post.data.permalink.split('/').pop()}`,
    subreddit_id: `t5_${post.data.subreddit.toLowerCase()}`,
    reddit_id: `t3_${post.data.permalink.split('/')[4]}`,
    title: post.data.title,
    selftext: post.data.selftext,
    url: `https://reddit.com${post.data.permalink}`,
    score: post.data.score,
    num_comments: post.data.num_comments,
    created_at: now,
    updated_at: now,
    reddit_created_at: redditCreatedAt,
    is_archived: false,
    is_locked: false,
    post_type: 'text',
    daily_rank: rank,
    daily_score: post.data.score + (post.data.num_comments * 2),
    author_id: `t2_${post.data.author.toLowerCase()}`,
    keywords: generateMockKeywords(),
    author_score: post.data.score + (post.data.num_comments * 2),
    top_commenters: [],
    summary: null,
    sentiment: null
  };
}

export function getMockDigest(): DigestData {
  // Read mock data from file
  const mockDataPath = join(process.cwd(), 'mock-data', 'reddit', 'testdata-reddit-portland-output.json');
  const mockData: RedditResponse = JSON.parse(readFileSync(mockDataPath, 'utf-8'));

  // Transform posts and sort by score
  const posts = mockData.data.children
    .map((post, index) => transformRedditPost(post, index + 1))
    .sort((a, b) => b.score - a.score)
    .slice(0, 20); // Limit to 20 posts

  // Get unique subreddits
  const subreddits = [...new Set(posts.map(post => post.subreddit_id))];

  return {
    date: new Date().toISOString(),
    summary: {
      total_posts: posts.length,
      total_comments: posts.reduce((sum, post) => sum + post.num_comments, 0),
      top_subreddits: subreddits
    },
    top_posts: posts
  };
} 