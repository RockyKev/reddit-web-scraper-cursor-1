import { RedditStorage } from '../reddit-storage.ts';
import { getPool } from '../../config/database.ts';
import { RedditPost, RedditComment, RedditSentiment } from '../../types/reddit.ts';

describe('RedditStorage', () => {
  let storage: RedditStorage;
  let pool: ReturnType<typeof getPool>;

  beforeAll(() => {
    storage = new RedditStorage();
    pool = getPool();
  });

  afterAll(async () => {
    await pool.end();
  });

  beforeEach(async () => {
    // Clean up tables in correct order (comments -> posts -> subreddits)
    await pool.query('DELETE FROM comments');
    await pool.query('DELETE FROM posts');
    await pool.query('DELETE FROM subreddits');
  });

  describe('storeSubreddit', () => {
    it('should store a new subreddit', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit', 'Test Description');
      expect(subredditId).toBeDefined();
      expect(typeof subredditId).toBe('string');
      expect(subredditId.length).toBeGreaterThan(0);
    });

    it('should update existing subreddit', async () => {
      const name = 'test_subreddit';
      const initialId = await storage.storeSubreddit(name, 'Initial Description');
      const updatedId = await storage.storeSubreddit(name, 'Updated Description');
      
      expect(updatedId).toBe(initialId);
      
      const result = await pool.query(
        'SELECT description FROM subreddits WHERE name = $1',
        [name]
      );
      expect(result.rows[0].description).toBe('Updated Description');
    });
  });

  describe('storePost', () => {
    it('should store a new post', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit');
      
      const sentiment: RedditSentiment = {
        positive: 0.7,
        negative: 0.3
      };

      const post: RedditPost = {
        id: 'test_post_1',
        title: 'Test Post',
        content: 'Test Content',
        author: 'test_user',
        score: 100,
        commentCount: 10,
        url: 'https://reddit.com/test',
        permalink: '/r/test_subreddit/test_post_1',
        post_type: 'text',
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        keywords: ['test', 'post'],
        author_score: 0.8,
        top_commenters: [{ username: 'user1', contribution_score: 50 }],
        summary: 'Test post summary',
        sentiment
      };

      const postId = await storage.storePost(subredditId, post);
      expect(postId).toBeDefined();
      expect(typeof postId).toBe('string');
      expect(postId.length).toBeGreaterThan(0);
    });

    it('should update existing post', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit');
      
      const initialSentiment: RedditSentiment = {
        positive: 0.5,
        negative: 0.5
      };

      const post: RedditPost = {
        id: 'test_post_1',
        title: 'Initial Title',
        content: 'Initial Content',
        author: 'test_user',
        score: 100,
        commentCount: 10,
        url: 'https://reddit.com/test',
        permalink: '/r/test_subreddit/test_post_1',
        post_type: 'text',
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        keywords: ['test'],
        author_score: 0.5,
        top_commenters: [],
        summary: 'Initial summary',
        sentiment: initialSentiment
      };

      const initialId = await storage.storePost(subredditId, post);
      
      post.title = 'Updated Title';
      post.score = 200;
      post.keywords = ['test', 'updated'];
      post.author_score = 0.9;
      post.top_commenters = [{ username: 'user1', contribution_score: 100 }];
      post.summary = 'Updated summary';
      post.sentiment = {
        positive: 0.8,
        negative: 0.2
      };
      
      const updatedId = await storage.storePost(subredditId, post);
      
      expect(updatedId).toBe(initialId);
      
      const result = await pool.query(
        'SELECT title, score, keywords, author_score, top_commenters, summary, sentiment FROM posts WHERE reddit_id = $1',
        [post.id]
      );
      
      expect(result.rows[0].title).toBe('Updated Title');
      expect(result.rows[0].score).toBe(200);
      expect(result.rows[0].keywords).toEqual(['test', 'updated']);
      expect(result.rows[0].author_score).toBe(0.9);
      expect(result.rows[0].top_commenters).toEqual([{ username: 'user1', contribution_score: 100 }]);
      expect(result.rows[0].summary).toBe('Updated summary');
      expect(result.rows[0].sentiment).toEqual({ positive: 0.8, negative: 0.2 });
    });
  });

  describe('storeComment', () => {
    it('should store a new comment', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit');
      const post: RedditPost = {
        id: 'test_post_1',
        title: 'Test Post',
        content: 'Test Content',
        author: 'test_user',
        score: 100,
        commentCount: 10,
        url: 'https://reddit.com/test',
        permalink: '/r/test_subreddit/test_post_1',
        post_type: 'text',
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        keywords: ['test'],
        author_score: 0.5,
        top_commenters: [],
        summary: 'Test summary',
        sentiment: { positive: 0.5, negative: 0.5 }
      };
      const postId = await storage.storePost(subredditId, post);

      const comment: RedditComment = {
        id: 'test_comment_1',
        content: 'Test Comment',
        author: 'test_user',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: 'test_post_1',
        contribution_score: 0.7
      };

      const commentId = await storage.storeComment(postId, comment);
      expect(commentId).toBeDefined();
      expect(typeof commentId).toBe('string');
      expect(commentId.length).toBeGreaterThan(0);
    });

    it('should update existing comment', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit');
      const post: RedditPost = {
        id: 'test_post_1',
        title: 'Test Post',
        content: 'Test Content',
        author: 'test_user',
        score: 100,
        commentCount: 10,
        url: 'https://reddit.com/test',
        permalink: '/r/test_subreddit/test_post_1',
        post_type: 'text',
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        keywords: ['test'],
        author_score: 0.5,
        top_commenters: [],
        summary: 'Test summary',
        sentiment: { positive: 0.5, negative: 0.5 }
      };
      const postId = await storage.storePost(subredditId, post);

      const comment: RedditComment = {
        id: 'test_comment_1',
        content: 'Initial Comment',
        author: 'test_user',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: 'test_post_1',
        contribution_score: 0.5
      };

      const initialId = await storage.storeComment(postId, comment);
      
      comment.content = 'Updated Comment';
      comment.score = 100;
      comment.contribution_score = 0.9;
      
      const updatedId = await storage.storeComment(postId, comment);
      
      expect(updatedId).toBe(initialId);
      
      const result = await pool.query(
        'SELECT content, score, contribution_score FROM comments WHERE reddit_id = $1',
        [comment.id]
      );
      
      expect(result.rows[0].content).toBe('Updated Comment');
      expect(result.rows[0].score).toBe(100);
      expect(result.rows[0].contribution_score).toBe(0.9);
    });
  });

  describe('getSubredditByName', () => {
    it('should return subreddit by name', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit');
      const result = await storage.getSubredditByName('test_subreddit');
      
      expect(result).toBeDefined();
      expect(result?.id).toBe(subredditId);
    });

    it('should return null for non-existent subreddit', async () => {
      const result = await storage.getSubredditByName('non_existent');
      expect(result).toBeNull();
    });
  });

  describe('getPostByRedditId', () => {
    it('should return post by Reddit ID', async () => {
      const subredditId = await storage.storeSubreddit('test_subreddit');
      const post: RedditPost = {
        id: 'test_post_1',
        title: 'Test Post',
        content: 'Test Content',
        author: 'test_user',
        score: 100,
        commentCount: 10,
        url: 'https://reddit.com/test',
        permalink: '/r/test_subreddit/test_post_1',
        post_type: 'text',
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        keywords: ['test'],
        author_score: 0.5,
        top_commenters: [],
        summary: 'Test summary',
        sentiment: { positive: 0.5, negative: 0.5 }
      };
      const postId = await storage.storePost(subredditId, post);
      
      const result = await storage.getPostByRedditId('test_post_1');
      
      expect(result).toBeDefined();
      expect(result?.id).toBe(postId);
    });

    it('should return null for non-existent post', async () => {
      const result = await storage.getPostByRedditId('non_existent');
      expect(result).toBeNull();
    });
  });
}); 