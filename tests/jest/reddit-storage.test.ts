import { RedditStorage } from '../../src/services/reddit-storage';
import { RedditPost, RedditComment } from '../../src/types/reddit';
import { getPool } from '../../src/config/database';

describe('RedditStorage', () => {
  let storage: RedditStorage;
  let pool: any;

  beforeAll(async () => {
    pool = getPool();
  });

  beforeEach(async () => {
    storage = new RedditStorage();
    // Clean up the database before each test
    await pool.query('DELETE FROM comments');
    await pool.query('DELETE FROM posts');
    await pool.query('DELETE FROM subreddits');
  });

  afterAll(async () => {
    await pool.end();
  });

  describe('storeSubreddit', () => {
    it('should store a new subreddit', async () => {
      const subredditId = await storage.storeSubreddit('Portland', 'Portland, Oregon subreddit');
      expect(subredditId).toBeDefined();
      expect(typeof subredditId).toBe('string');

      // Verify the subreddit was stored correctly
      const result = await pool.query('SELECT * FROM subreddits WHERE id = $1', [subredditId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].name).toBe('Portland');
      expect(result.rows[0].description).toBe('Portland, Oregon subreddit');
    });

    it('should update existing subreddit', async () => {
      const name = 'Portland';
      const firstId = await storage.storeSubreddit(name, 'First description');
      const secondId = await storage.storeSubreddit(name, 'Updated description');
      
      expect(firstId).toBe(secondId); // Should return same ID for same name

      // Verify the subreddit was updated correctly
      const result = await pool.query('SELECT * FROM subreddits WHERE id = $1', [firstId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].description).toBe('Updated description');
    });

    it('should handle database connection errors', async () => {
      // Temporarily close the pool to simulate a connection error
      await pool.end();
      
      await expect(storage.storeSubreddit('Portland')).rejects.toThrow();
      
      // Reconnect the pool for other tests
      pool = getPool();
    });
  });

  describe('storePost', () => {
    it('should store a new post', async () => {
      // First store the subreddit
      const subredditId = await storage.storeSubreddit('Portland');

      // Create a test post
      const post: RedditPost = {
        id: 'test-post-1',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-1',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };

      const postId = await storage.storePost(subredditId, post);
      expect(postId).toBeDefined();
      expect(typeof postId).toBe('string');

      // Verify the post was stored correctly
      const result = await pool.query('SELECT * FROM posts WHERE id = $1', [postId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].reddit_id).toBe(post.id);
      expect(result.rows[0].title).toBe(post.title);
      expect(result.rows[0].content).toBe(post.content);
      expect(result.rows[0].author).toBe(post.author);
      expect(result.rows[0].score).toBe(post.score);
      expect(result.rows[0].comment_count).toBe(post.commentCount);
      expect(result.rows[0].url).toBe(post.url);
      expect(result.rows[0].permalink).toBe(post.permalink);
      expect(result.rows[0].post_type).toBe(post.post_type);
      expect(result.rows[0].is_archived).toBe(post.isArchived);
      expect(result.rows[0].is_locked).toBe(post.isLocked);
    });

    it('should update existing post', async () => {
      // First store the subreddit and post
      const subredditId = await storage.storeSubreddit('Portland');
      const post: RedditPost = {
        id: 'test-post-2',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-2',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };

      const firstId = await storage.storePost(subredditId, post);
      post.score = 200; // Update the score
      const secondId = await storage.storePost(subredditId, post);

      expect(firstId).toBe(secondId); // Should return same ID for same post

      // Verify the post was updated correctly
      const result = await pool.query('SELECT * FROM posts WHERE id = $1', [firstId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].score).toBe(200);
    });

    it('should handle concurrent post updates', async () => {
      const subredditId = await storage.storeSubreddit('Portland');
      const post: RedditPost = {
        id: 'test-post-3',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-3',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };

      // Simulate concurrent updates
      const promises = [
        storage.storePost(subredditId, post),
        storage.storePost(subredditId, { ...post, score: 200 }),
        storage.storePost(subredditId, { ...post, score: 300 })
      ];

      const results = await Promise.all(promises);
      
      // All updates should succeed and return the same ID
      expect(new Set(results).size).toBe(1);
      
      // Verify the final state
      const result = await pool.query('SELECT * FROM posts WHERE id = $1', [results[0]]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].score).toBe(300);
    });
  });

  describe('storeComment', () => {
    it('should store a new comment', async () => {
      // First store the subreddit and post
      const subredditId = await storage.storeSubreddit('Portland');
      const post: RedditPost = {
        id: 'test-post-3',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-3',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };
      const postId = await storage.storePost(subredditId, post);

      // Create a test comment
      const comment: RedditComment = {
        id: 'test-comment-1',
        content: 'Test comment',
        author: 'testuser',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      };

      const commentId = await storage.storeComment(postId, comment);
      expect(commentId).toBeDefined();
      expect(typeof commentId).toBe('string');

      // Verify the comment was stored correctly
      const result = await pool.query('SELECT * FROM comments WHERE id = $1', [commentId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].reddit_id).toBe(comment.id);
      expect(result.rows[0].content).toBe(comment.content);
      expect(result.rows[0].author).toBe(comment.author);
      expect(result.rows[0].score).toBe(comment.score);
      expect(result.rows[0].parent_id).toBeNull();
      expect(result.rows[0].is_archived).toBe(comment.isArchived);
    });

    it('should update existing comment', async () => {
      // First store the subreddit, post, and comment
      const subredditId = await storage.storeSubreddit('Portland');
      const post: RedditPost = {
        id: 'test-post-4',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-4',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };
      const postId = await storage.storePost(subredditId, post);

      const comment: RedditComment = {
        id: 'test-comment-2',
        content: 'Test comment',
        author: 'testuser',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      };

      const firstId = await storage.storeComment(postId, comment);
      comment.score = 75; // Update the score
      const secondId = await storage.storeComment(postId, comment);

      expect(firstId).toBe(secondId); // Should return same ID for same comment

      // Verify the comment was updated correctly
      const result = await pool.query('SELECT * FROM comments WHERE id = $1', [firstId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].score).toBe(75);
    });

    it('should handle comment with parent', async () => {
      const subredditId = await storage.storeSubreddit('Portland');
      const post: RedditPost = {
        id: 'test-post-5',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-5',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };
      const postId = await storage.storePost(subredditId, post);

      // Create parent comment
      const parentComment: RedditComment = {
        id: 'test-comment-3',
        content: 'Parent comment',
        author: 'testuser',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      };
      const parentId = await storage.storeComment(postId, parentComment);

      // Create child comment
      const childComment: RedditComment = {
        id: 'test-comment-4',
        content: 'Child comment',
        author: 'testuser',
        score: 25,
        createdAt: new Date(),
        isArchived: false,
        parentId: parentComment.id,
        contribution_score: 2
      };
      const childId = await storage.storeComment(postId, childComment);

      // Verify the child comment was stored with correct parent
      const result = await pool.query('SELECT * FROM comments WHERE id = $1', [childId]);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].parent_id).toBe(parentId);
    });
  });

  describe('getSubredditByName', () => {
    it('should return subreddit ID for existing subreddit', async () => {
      const name = 'Portland';
      const storedId = await storage.storeSubreddit(name);
      const retrieved = await storage.getSubredditByName(name);

      expect(retrieved).toBeDefined();
      expect(retrieved?.id).toBe(storedId);
    });

    it('should return null for non-existent subreddit', async () => {
      const retrieved = await storage.getSubredditByName('NonExistentSubreddit');
      expect(retrieved).toBeNull();
    });
  });

  describe('getPostByRedditId', () => {
    it('should return post ID for existing post', async () => {
      // First store the subreddit and post
      const subredditId = await storage.storeSubreddit('Portland');
      const post: RedditPost = {
        id: 'test-post-5',
        title: 'Test Post',
        content: 'Test content',
        url: 'https://reddit.com/test',
        author: 'testuser',
        score: 100,
        commentCount: 5,
        createdAt: new Date(),
        isArchived: false,
        isLocked: false,
        permalink: '/r/Portland/test-post-5',
        post_type: 'text',
        keywords: ['test', 'content'],
        author_score: 2,
        top_commenters: [],
        summary: null,
        sentiment: null
      };
      const storedId = await storage.storePost(subredditId, post);

      const retrieved = await storage.getPostByRedditId(post.id);
      expect(retrieved).toBeDefined();
      expect(retrieved?.id).toBe(storedId);
    });

    it('should return null for non-existent post', async () => {
      const retrieved = await storage.getPostByRedditId('NonExistentPost');
      expect(retrieved).toBeNull();
    });
  });
}); 