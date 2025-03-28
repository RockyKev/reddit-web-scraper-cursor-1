import { RedditPost, RedditComment, IRedditScraper, RedditSentiment } from '../../src/types/reddit';

/**
 * Helper function to create a mock Reddit post
 * @param id - Unique identifier for the post
 * @param title - Post title
 * @param content - Post content
 * @param author - Post author
 * @param score - Post score
 * @param commentCount - Number of comments
 * @param createdAt - Creation timestamp
 * @param postType - Type of post (text, image, link)
 * @param isArchived - Whether the post is archived
 * @param isLocked - Whether the post is locked
 * @param keywords - Array of keywords extracted from the post
 * @param authorScore - Author's contribution score
 * @param topCommenters - Array of top commenters with their scores
 * @param sentiment - Sentiment analysis results
 * @returns A mock Reddit post
 */
export function createMockPost(
  id: string,
  title: string,
  content: string,
  author: string,
  score: number,
  commentCount: number,
  createdAt: Date,
  postType: string = 'text',
  isArchived: boolean = false,
  isLocked: boolean = false,
  keywords: string[] = [],
  authorScore: number = 0,
  topCommenters: Array<{ username: string; contribution_score: number }> = [],
  sentiment: RedditSentiment | null = null
): RedditPost {
  return {
    id,
    title,
    content,
    url: `https://www.reddit.com/r/test/comments/${id}`,
    permalink: `/r/test/comments/${id}`,
    post_type: postType,
    author,
    score,
    commentCount,
    createdAt,
    isArchived,
    isLocked,
    keywords,
    author_score: authorScore,
    top_commenters: topCommenters,
    summary: null,
    sentiment
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
 * @param isArchived - Whether the comment is archived
 * @param contributionScore - Commenter's contribution score
 * @returns A mock Reddit comment
 */
export function createMockComment(
  id: string,
  content: string,
  author: string,
  score: number,
  createdAt: Date,
  parentId?: string,
  isArchived: boolean = false,
  contributionScore: number = 0
): RedditComment {
  return {
    id,
    content,
    author,
    score,
    createdAt,
    isArchived,
    parentId,
    contribution_score: contributionScore
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
    new Date('2024-03-26T00:00:00Z'),
    'text',
    false,
    false,
    ['test', 'content', 'portland'],
    2,
    [{ username: 'commenter1', contribution_score: 5 }]
  ),
  createMockPost(
    'mock2',
    'Test Post 2',
    'Another test post with housing content',
    'testuser2',
    50,
    3,
    new Date('2024-03-26T01:00:00Z'),
    'text',
    false,
    false,
    ['housing', 'portland', 'rent'],
    1,
    [{ username: 'commenter3', contribution_score: 3 }]
  ),
  createMockPost(
    'mock3',
    'Image Post',
    '',
    'testuser3',
    75,
    8,
    new Date('2024-03-26T02:00:00Z'),
    'image',
    false,
    false,
    ['image', 'portland'],
    3,
    [{ username: 'commenter2', contribution_score: 4 }]
  ),
  createMockPost(
    'mock4',
    'Archived Post',
    'This post is archived',
    'testuser4',
    25,
    2,
    new Date('2024-03-26T03:00:00Z'),
    'text',
    true,
    false,
    ['archived', 'portland'],
    1,
    []
  ),
  createMockPost(
    'mock5',
    'Locked Post',
    'This post is locked',
    'testuser5',
    150,
    12,
    new Date('2024-03-26T04:00:00Z'),
    'text',
    false,
    true,
    ['locked', 'portland'],
    4,
    [{ username: 'commenter4', contribution_score: 6 }]
  )
];

export const MOCK_COMMENTS: Record<string, RedditComment[]> = {
  'mock1': [
    createMockComment(
      'comment1',
      'Test comment 1',
      'commenter1',
      10,
      new Date('2024-03-26T00:05:00Z'),
      undefined,
      false,
      5
    ),
    createMockComment(
      'comment2',
      'Test comment 2',
      'commenter2',
      5,
      new Date('2024-03-26T00:10:00Z'),
      'comment1',
      false,
      3
    )
  ],
  'mock2': [
    createMockComment(
      'comment3',
      'Housing related comment',
      'commenter3',
      15,
      new Date('2024-03-26T01:05:00Z'),
      undefined,
      false,
      3
    ),
    createMockComment(
      'comment4',
      '[deleted]',
      '[deleted]',
      0,
      new Date('2024-03-26T01:10:00Z'),
      undefined,
      true,
      0
    )
  ]
};

/**
 * Mock implementation of the Reddit scraper for testing
 */
export class MockRedditScraper implements IRedditScraper {
  private readonly _subreddit: string;
  private lastRequestTime: number = 0;
  private readonly minRequestInterval: number = 5000; // 5 seconds between requests
  private readonly commentRequestInterval: number = 8000; // 8 seconds between comment requests
  public getPosts: jest.Mock;
  public getComments: jest.Mock;

  constructor(subreddit: string) {
    this._subreddit = subreddit;
    
    // Initialize Jest mocks
    this.getPosts = jest.fn().mockImplementation(this._getPosts);
    this.getComments = jest.fn().mockImplementation(this._getComments);
  }

  public get subreddit(): string {
    return this._subreddit;
  }

  private async rateLimit(isCommentRequest: boolean = false): Promise<void> {
    const now = Date.now();
    const timeSinceLastRequest = now - this.lastRequestTime;
    const requiredDelay = isCommentRequest ? this.commentRequestInterval : this.minRequestInterval;
    
    if (timeSinceLastRequest < requiredDelay) {
      const delay = requiredDelay - timeSinceLastRequest;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
    
    this.lastRequestTime = Date.now();
  }

  private async _getPosts(limit: number = 25): Promise<RedditPost[]> {
    await this.rateLimit();
    
    // Return mock posts up to the limit
    return MOCK_POSTS.slice(0, limit);
  }

  private async _getComments(postId: string): Promise<RedditComment[]> {
    await this.rateLimit(true);
    
    // Return mock comments for the post if they exist
    return MOCK_COMMENTS[postId] || [];
  }
} 