import { readFileSync } from 'fs';
import { join } from 'path';

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
  title: string;
  subreddit: string;
  author: string;
  contribution_score: number;
  content: string;
  score: number;
  score_ratio: number;
  permalink: string;
  keywords: string[];
  daily_rank: number;
}

interface DigestData {
  date: string;
  total_posts: number;
  total_comments: number;
  subreddits: string[];
  posts: Post[];
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
  return {
    title: post.data.title,
    subreddit: post.data.subreddit,
    author: post.data.author,
    contribution_score: post.data.score + (post.data.num_comments * 2), // Simple scoring
    content: post.data.selftext,
    score: post.data.score,
    score_ratio: post.data.upvote_ratio,
    permalink: post.data.permalink,
    keywords: generateMockKeywords(),
    daily_rank: rank
  };
}

export function getMockDigest(): DigestData {
  // Read mock data from file
  const mockDataPath = join(process.cwd(), 'data', 'testdata-reddit-portland-output.json');
  const mockData: RedditResponse = JSON.parse(readFileSync(mockDataPath, 'utf-8'));

  // Transform posts and sort by score
  const posts = mockData.data.children
    .map((post, index) => transformRedditPost(post, index + 1))
    .sort((a, b) => b.score - a.score);

  // Get unique subreddits
  const subreddits = [...new Set(posts.map(post => post.subreddit))];

  // Calculate total comments
  const totalComments = posts.reduce((sum, post) => sum + (post.score * 2), 0);

  return {
    date: new Date().toISOString(),
    total_posts: posts.length,
    total_comments: totalComments,
    subreddits,
    posts: posts.slice(0, 20) // Limit to 20 posts for now
  };
} 