import { RedditPost, RedditComment, IRedditScraper } from '../../src/types/reddit.ts';

/**
 * Helper function to create a mock Reddit post
 * @param id - Unique identifier for the post
 * @param title - Post title
 * @param content - Post content
 * @param author - Post author
 * @param score - Post score
 * @param commentCount - Number of comments
 * @param createdAt - Creation timestamp
 * @returns A mock Reddit post
 */
export function createMockPost(
  id: string,
  title: string,
  content: string,
  author: string,
  score: number,
  commentCount: number,
  createdAt: Date
): RedditPost {
  return {
    id,
    title,
    content,
    url: `https://www.reddit.com/r/test/comments/${id}`,
    author,
    score,
    commentCount,
    createdAt,
    isArchived: false,
    isLocked: false
  };
}

/**
 * Helper function to create a mock Reddit comment
 * @param id - Unique identifier for the comment
 * @param content - Comment content
 * @param author - Comment author
 * @param score - Comment score
 * @param createdAt - Creation timestamp
 * @param parentId - Optional parent comment ID
 * @returns A mock Reddit comment
 */
export function createMockComment(
  id: string,
  content: string,
  author: string,
  score: number,
  createdAt: Date,
  parentId?: string
): RedditComment {
  return {
    id,
    content,
    author,
    score,
    createdAt,
    isArchived: false,
    parentId
  };
}

/**
 * Mock data for testing Reddit scraper functionality
 * Contains sample posts and comments that can be used in tests
 */
export const MOCK_POSTS: RedditPost[] = [
  createMockPost(
    'mock1',
    'Test Post 1',
    'This is a test post content',
    'testuser1',
    100,
    5,
    new Date('2024-03-26T00:00:00Z')
  ),
  createMockPost(
    'mock2',
    'Test Post 2',
    'Another test post with housing content',
    'testuser2',
    50,
    3,
    new Date('2024-03-26T01:00:00Z')
  )
];

export const MOCK_COMMENTS: Record<string, RedditComment[]> = {
  'mock1': [
    createMockComment(
      'comment1',
      'Test comment 1',
      'commenter1',
      10,
      new Date('2024-03-26T00:05:00Z')
    ),
    createMockComment(
      'comment2',
      'Test comment 2',
      'commenter2',
      5,
      new Date('2024-03-26T00:10:00Z'),
      'comment1'
    )
  ],
  'mock2': [
    createMockComment(
      'comment3',
      'Housing related comment',
      'commenter3',
      15,
      new Date('2024-03-26T01:05:00Z')
    )
  ]
};

/**
 * Mock implementation of the Reddit scraper for testing
 */
export class MockRedditScraper implements IRedditScraper {
  private readonly _subreddit: string;

  constructor(subreddit: string) {
    this._subreddit = subreddit;
  }

  public get subreddit(): string {
    return this._subreddit;
  }

  public async getPosts(limit: number = 25): Promise<RedditPost[]> {
    const posts: RedditPost[] = [];
    const now = new Date();

    for (let i = 0; i < limit; i++) {
      posts.push(createMockPost(
        `post-${i}`,
        `Test Post ${i}`,
        `This is test post content ${i}`,
        `user${i}`,
        Math.floor(Math.random() * 100),
        Math.floor(Math.random() * 50),
        new Date(now.getTime() - i * 3600000) // Each post is 1 hour older than the previous
      ));
    }

    return posts;
  }

  public async getComments(postId: string): Promise<RedditComment[]> {
    const comments: RedditComment[] = [];
    const now = new Date();

    for (let i = 0; i < 5; i++) {
      comments.push(createMockComment(
        `comment-${i}`,
        `This is test comment ${i}`,
        `user${i}`,
        Math.floor(Math.random() * 50),
        new Date(now.getTime() - i * 1800000), // Each comment is 30 minutes older than the previous
        i > 0 ? `comment-${i - 1}` : undefined
      ));
    }

    return comments;
  }
} 