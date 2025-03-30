import { RedditScraper } from '../../backend/services/reddit-scraper.js';
import { RedditPost, RedditComment } from '../../backend/types/reddit.js';
import { MockRedditScraper } from '../mocks/reddit-scraper.mock.js';

describe('RedditScraper', () => {
  let scraper: MockRedditScraper;

  beforeEach(() => {
    scraper = new MockRedditScraper('Portland');
  });

  describe('getPosts', () => {
    it('should fetch latest posts from subreddit', async () => {
      const posts = await scraper.getPosts(5);
      
      expect(posts).toBeDefined();
      expect(Array.isArray(posts)).toBe(true);
      expect(posts.length).toBeLessThanOrEqual(5);
      
      // Check post structure
      posts.forEach((post: RedditPost) => {
        expect(post).toHaveProperty('id');
        expect(post).toHaveProperty('title');
        expect(post).toHaveProperty('score');
        expect(post).toHaveProperty('commentCount');
        expect(post).toHaveProperty('url');
        expect(post).toHaveProperty('permalink');
        expect(post).toHaveProperty('post_type');
        expect(post).toHaveProperty('author');
        expect(post).toHaveProperty('createdAt');
        expect(post).toHaveProperty('isArchived');
        expect(post).toHaveProperty('isLocked');
      });
    });

    it('should respect rate limiting between requests', async () => {
      const startTime = Date.now();
      
      // Make two requests
      await scraper.getPosts(5);
      await scraper.getPosts(5);
      
      const endTime = Date.now();
      const timeDiff = endTime - startTime;
      
      // Should have waited at least 5 seconds between requests
      expect(timeDiff).toBeGreaterThanOrEqual(5000);
    });

    it('should handle different post types', async () => {
      // Override the mock implementation to return different post types
      scraper.getPosts.mockImplementationOnce(async () => {
        const now = new Date();
        return [
          {
            id: 'post-1',
            title: 'Text Post',
            content: 'Text content',
            url: 'https://reddit.com/test',
            permalink: '/r/test/post-1',
            post_type: 'text',
            author: 'user1',
            score: 100,
            commentCount: 5,
            createdAt: now,
            isArchived: false,
            isLocked: false
          },
          {
            id: 'post-2',
            title: 'Image Post',
            content: '',
            url: 'https://i.imgur.com/test.jpg',
            permalink: '/r/test/post-2',
            post_type: 'image',
            author: 'user2',
            score: 200,
            commentCount: 10,
            createdAt: now,
            isArchived: false,
            isLocked: false
          },
          {
            id: 'post-3',
            title: 'Link Post',
            content: '',
            url: 'https://example.com',
            permalink: '/r/test/post-3',
            post_type: 'link',
            author: 'user3',
            score: 150,
            commentCount: 8,
            createdAt: now,
            isArchived: false,
            isLocked: false
          }
        ];
      });

      const posts = await scraper.getPosts(3);
      
      expect(posts).toHaveLength(3);
      expect(posts[0].post_type).toBe('text');
      expect(posts[1].post_type).toBe('image');
      expect(posts[2].post_type).toBe('link');
    });

    it('should handle archived and locked posts', async () => {
      // Override the mock implementation to return archived and locked posts
      scraper.getPosts.mockImplementationOnce(async () => {
        const now = new Date();
        return [
          {
            id: 'post-1',
            title: 'Archived Post',
            content: 'Archived content',
            url: 'https://reddit.com/test',
            permalink: '/r/test/post-1',
            post_type: 'text',
            author: 'user1',
            score: 100,
            commentCount: 5,
            createdAt: now,
            isArchived: true,
            isLocked: false
          },
          {
            id: 'post-2',
            title: 'Locked Post',
            content: 'Locked content',
            url: 'https://reddit.com/test',
            permalink: '/r/test/post-2',
            post_type: 'text',
            author: 'user2',
            score: 200,
            commentCount: 10,
            createdAt: now,
            isArchived: false,
            isLocked: true
          }
        ];
      });

      const posts = await scraper.getPosts(2);
      
      expect(posts).toHaveLength(2);
      expect(posts[0].isArchived).toBe(true);
      expect(posts[1].isLocked).toBe(true);
    });
  });

  describe('getComments', () => {
    it('should fetch comments for a post', async () => {
      // First get a post to test with
      const posts = await scraper.getPosts(1);
      expect(posts.length).toBeGreaterThan(0);

      const postId = posts[0].id;
      const comments = await scraper.getComments(postId);

      expect(comments).toBeDefined();
      expect(Array.isArray(comments)).toBe(true);

      // Check comment structure
      comments.slice(0, 3).forEach((comment: RedditComment) => {
        expect(comment).toHaveProperty('id');
        expect(comment).toHaveProperty('content');
        expect(comment).toHaveProperty('author');
        expect(comment).toHaveProperty('score');
        expect(comment).toHaveProperty('createdAt');
        expect(comment).toHaveProperty('isArchived');
        expect(comment).toHaveProperty('parentId');
      });
    });

    it('should respect rate limiting for comment requests', async () => {
      const startTime = Date.now();
      
      // Make two comment requests
      await scraper.getComments('post-1');
      await scraper.getComments('post-2');
      
      const endTime = Date.now();
      const timeDiff = endTime - startTime;
      
      // Should have waited at least 8 seconds between comment requests
      expect(timeDiff).toBeGreaterThanOrEqual(8000);
    });

    it('should handle archived and deleted comments', async () => {
      // Override the mock implementation to return archived and deleted comments
      scraper.getComments.mockImplementationOnce(async () => {
        const now = new Date();
        return [
          {
            id: 'comment-1',
            content: 'Archived comment',
            author: 'user1',
            score: 100,
            createdAt: now,
            isArchived: true,
            parentId: undefined
          },
          {
            id: 'comment-2',
            content: '[deleted]',
            author: '[deleted]',
            score: 0,
            createdAt: now,
            isArchived: false,
            parentId: 'comment-1'
          }
        ];
      });

      const comments = await scraper.getComments('post-1');
      
      expect(comments).toHaveLength(2);
      expect(comments[0].isArchived).toBe(true);
      expect(comments[1].content).toBe('[deleted]');
      expect(comments[1].author).toBe('[deleted]');
    });
  });
}); 