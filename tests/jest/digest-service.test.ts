import { db } from '../../database/index.js';
import { DigestService } from '../../backend/services/digest-service.js';
import { DbPost, DbComment, DbUser } from '../../backend/types/database.js';
import { MockDigestService } from '../mocks/digest-service.mock.js';
import { setupDatabase } from '../../database/setup.js';

describe('DigestService', () => {
  let digestService: MockDigestService;
  const testDate = '2024-03-20';

  beforeAll(async () => {
    // Set up test database
    await setupDatabase(true);

    // Insert test data
    const subredditResult = await db.query<{ id: string }>(
      'INSERT INTO subreddits (name, description) VALUES ($1, $2) RETURNING id',
      ['portland', 'Portland, Oregon']
    );
    const subredditId = subredditResult.rows[0].id;

    const userResult = await db.query<DbUser>(
      'INSERT INTO users (id, username) VALUES ($1, $2) RETURNING *',
      ['t2_123abc', 'testuser']
    );

    const postResult = await db.query<DbPost>(
      `INSERT INTO posts (
        subreddit_id, author_id, title, selftext, url, score, num_comments,
        permalink, created_at, post_type, daily_score, daily_rank, keywords,
        author_score, top_commenters, summary, sentiment
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
      RETURNING *`,
      [
        subredditId,
        userResult.rows[0].id,
        'Test Post',
        'This is a test post',
        null,
        100,
        50,
        '/r/portland/test_post',
        testDate,
        'self',
        150,
        1,
        ['test', 'portland'],
        5,
        JSON.stringify([{ username: 'testuser', contribution_score: 5 }]),
        'Test summary',
        { score: 0.5, label: 'positive' }
      ]
    );

    await db.query<DbComment>(
      `INSERT INTO comments (
        post_id, author_id, content, score, contribution_score, created_at
      ) VALUES ($1, $2, $3, $4, $5, $6)`,
      [
        postResult.rows[0].id,
        userResult.rows[0].id,
        'Test comment',
        10,
        5,
        testDate
      ]
    );

    digestService = new MockDigestService();
  });

  afterAll(async () => {
    // Clean up test tables
    await db.query(`
      DROP TABLE IF EXISTS comments;
      DROP TABLE IF EXISTS posts;
      DROP TABLE IF EXISTS users;
      DROP TABLE IF EXISTS subreddits;
    `);
  });

  describe('getDigest', () => {
    it('should return digest data in the correct format', async () => {
      const digest = await digestService.getDigest(testDate);

      // Check response structure
      expect(digest).toHaveProperty('date', testDate);
      expect(digest).toHaveProperty('summary');
      expect(digest).toHaveProperty('top_posts');
      expect(digest).toHaveProperty('top_commenters');

      // Check summary structure
      expect(digest.summary).toHaveProperty('total_posts', 1);
      expect(digest.summary).toHaveProperty('total_comments', 1);
      expect(digest.summary).toHaveProperty('top_subreddits');
      expect(digest.summary.top_subreddits[0]).toHaveProperty('name', 'portland');
      expect(digest.summary.top_subreddits[0]).toHaveProperty('post_count', 1);

      // Check post structure
      const post = digest.top_posts[0];
      expect(post).toHaveProperty('id');
      expect(post).toHaveProperty('title', 'Test Post');
      expect(post).toHaveProperty('content', 'This is a test post');
      expect(post).toHaveProperty('score', 100);
      expect(post).toHaveProperty('num_comments', 50);
      expect(post).toHaveProperty('post_type', 'self');
      expect(post).toHaveProperty('daily_rank', 1);
      expect(post).toHaveProperty('daily_score', 150);
      expect(post).toHaveProperty('author');
      expect(post.author).toHaveProperty('username', 'testuser');
      expect(post.author).toHaveProperty('reddit_id', 't2_123abc');
      expect(post.author).toHaveProperty('contribution_score', 5);
      expect(post).toHaveProperty('keywords');
      expect(post.keywords).toEqual(['test', 'portland']);
      expect(post).toHaveProperty('top_commenters');
      expect(post.top_commenters[0]).toHaveProperty('username', 'testuser');
      expect(post).toHaveProperty('summary', 'Test summary');
      expect(post).toHaveProperty('sentiment');
      expect(post.sentiment).toEqual({ score: 0.5, label: 'positive' });

      // Check top commenters
      expect(digest.top_commenters[0]).toHaveProperty('username', 'testuser');
    });

    it('should handle different post types correctly', async () => {
      // Insert a link post
      const subredditResult = await db.query<{ id: string }>(
        'SELECT id FROM subreddits WHERE name = $1',
        ['portland']
      );
      const subredditId = subredditResult.rows[0].id;

      const userResult = await db.query<DbUser>(
        'SELECT * FROM users WHERE username = $1',
        ['testuser']
      );

      await db.query<DbPost>(
        `INSERT INTO posts (
          subreddit_id, author_id, title, selftext, url, score, num_comments,
          permalink, created_at, post_type, daily_score, daily_rank
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)`,
        [
          subredditId,
          userResult.rows[0].id,
          'Link Post',
          null,
          'https://example.com',
          200,
          30,
          '/r/portland/link_post',
          testDate,
          'link',
          230,
          2
        ]
      );

      const digest = await digestService.getDigest(testDate);
      const linkPost = digest.top_posts[1];

      expect(linkPost.title).toBe('Link Post');
      expect(linkPost.content).toBe('https://example.com');
      expect(linkPost.post_type).toBe('link');
    });

    it('should handle empty data gracefully', async () => {
      const futureDate = '2025-01-01';
      await expect(digestService.getDigest(futureDate)).rejects.toThrow('No data found for the specified date');
    });
  });
}); 