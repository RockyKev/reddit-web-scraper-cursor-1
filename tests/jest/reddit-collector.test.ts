import { RedditCollector } from '../../backend/services/reddit-collector.js';
import { MockRedditScraper } from '../mocks/reddit-scraper.mock.js';
import { RedditStorage } from '../../backend/services/reddit-storage.js';

// Mock the RedditStorage class
jest.mock('../../src/services/reddit-storage');

describe('RedditCollector', () => {
  let collector: RedditCollector;
  let mockScraper: MockRedditScraper;
  let mockStorage: jest.Mocked<RedditStorage>;

  beforeEach(() => {
    mockScraper = new MockRedditScraper('Portland');
    mockStorage = new RedditStorage() as jest.Mocked<RedditStorage>;
    // Override the storage instance in the collector
    (RedditCollector as any).prototype.storage = mockStorage;
    collector = new RedditCollector(mockScraper);
  });

  describe('collectAndStore', () => {
    it('should collect and store posts from subreddit', async () => {
      const postLimit = 5;
      
      // Mock storage methods
      mockStorage.storeSubreddit.mockResolvedValue('subreddit-1');
      mockStorage.storePost.mockResolvedValue('post-1');
      mockStorage.storeComment.mockResolvedValue('comment-1');

      await collector.collectAndStore(postLimit);

      // Verify that the mock scraper was called with default parameters
      expect(mockScraper.getPosts).toHaveBeenCalledWith(postLimit, 'hot', 'day');

      // Verify storage calls
      expect(mockStorage.storeSubreddit).toHaveBeenCalledWith('Portland');
      expect(mockStorage.storePost).toHaveBeenCalled();
      expect(mockStorage.storeComment).not.toHaveBeenCalled(); // Comments not fetched by default
    });

    it('should handle errors from scraper gracefully', async () => {
      // Make the mock scraper throw an error
      mockScraper.getPosts.mockRejectedValueOnce(new Error('Test error'));

      await expect(collector.collectAndStore(5)).rejects.toThrow('Test error');
    });

    it('should handle errors from storage gracefully', async () => {
      // Mock storage to throw an error
      mockStorage.storeSubreddit.mockRejectedValueOnce(new Error('Storage error'));

      await expect(collector.collectAndStore(5)).rejects.toThrow('Storage error');
    });

    it('should collect and store comments when fetchComments is true', async () => {
      const postLimit = 2;
      
      // Mock storage methods
      mockStorage.storeSubreddit.mockResolvedValue('subreddit-1');
      mockStorage.storePost.mockResolvedValue('post-1');
      mockStorage.storeComment.mockResolvedValue('comment-1');

      await collector.collectAndStore(postLimit, 'hot', 'day', true);

      // Verify that comments were fetched and stored
      expect(mockScraper.getComments).toHaveBeenCalled();
      expect(mockStorage.storeComment).toHaveBeenCalled();
    });

    it('should handle rate limiting between requests', async () => {
      const postLimit = 2;
      
      // Mock storage methods
      mockStorage.storeSubreddit.mockResolvedValue('subreddit-1');
      mockStorage.storePost.mockResolvedValue('post-1');
      mockStorage.storeComment.mockResolvedValue('comment-1');

      // Record the time before starting
      const startTime = Date.now();

      // Collect posts with comments to ensure multiple requests
      await collector.collectAndStore(postLimit, 'hot', 'day', true);
      
      // Calculate the time difference
      const endTime = Date.now();
      const timeDiff = endTime - startTime;
      
      // Should have waited at least 5 seconds between requests
      // We make 2 post requests and 2 comment requests, so should wait at least 3 times
      expect(timeDiff).toBeGreaterThanOrEqual(15000);
    });
  });
}); 