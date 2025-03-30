import request from 'supertest';
import { app } from '../../backend/app.js';
import { db } from '../../backend/db.js';
import { mockPosts, mockComments, mockUsers } from '../mocks/reddit-data.js';

describe('GET /api/digest', () => {
  beforeEach(async () => {
    // Clear and seed test data
    await db.query('DELETE FROM comments');
    await db.query('DELETE FROM posts');
    await db.query('DELETE FROM users');
    
    // Insert mock data
    for (const user of mockUsers) {
      await db.query(
        'INSERT INTO users (id, username, created_at) VALUES ($1, $2, $3)',
        [user.id, user.username, user.created_at]
      );
    }

    for (const post of mockPosts) {
      await db.query(
        'INSERT INTO posts (id, subreddit, title, type, upvotes, comment_count, permalink, selftext, url, keywords, author_id, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)',
        [post.id, post.subreddit, post.title, post.type, post.upvotes, post.comment_count, post.permalink, post.selftext, post.url, post.keywords, post.author_id, post.created_at]
      );
    }

    for (const comment of mockComments) {
      await db.query(
        'INSERT INTO comments (id, post_id, author_id, body, upvotes, created_at) VALUES ($1, $2, $3, $4, $5, $6)',
        [comment.id, comment.post_id, comment.author_id, comment.body, comment.upvotes, comment.created_at]
      );
    }
  });

  it('should return today\'s digest with correct structure', async () => {
    const response = await request(app).get('/api/digest');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('date');
    expect(response.body).toHaveProperty('summary');
    expect(response.body).toHaveProperty('top_posts');

    // Verify summary structure
    expect(response.body.summary).toHaveProperty('total_posts');
    expect(response.body.summary).toHaveProperty('total_comments');
    expect(response.body.summary).toHaveProperty('top_subreddits');

    // Verify post structure
    if (response.body.top_posts.length > 0) {
      const post = response.body.top_posts[0];
      expect(post).toHaveProperty('id');
      expect(post).toHaveProperty('subreddit');
      expect(post).toHaveProperty('title');
      expect(post).toHaveProperty('type');
      expect(post).toHaveProperty('upvotes');
      expect(post).toHaveProperty('comment_count');
      expect(post).toHaveProperty('permalink');
      expect(post).toHaveProperty('keywords');
      expect(post).toHaveProperty('author');
      expect(post).toHaveProperty('top_commenters');
      expect(post).toHaveProperty('summary');
      expect(post).toHaveProperty('sentiment');
    }
  });

  it('should return correct summary statistics', async () => {
    const response = await request(app).get('/api/digest');
    
    expect(response.body.summary.total_posts).toBe(mockPosts.length);
    expect(response.body.summary.total_comments).toBe(mockComments.length);
    expect(response.body.summary.top_subreddits).toContain('r/Portland');
    expect(response.body.summary.top_subreddits).toContain('r/askportland');
  });

  it('should include correct author information', async () => {
    const response = await request(app).get('/api/digest');
    
    const firstPost = response.body.top_posts[0];
    expect(firstPost.author.username).toBe('PDX_Dave');
  });

  it('should include correct top commenters', async () => {
    const response = await request(app).get('/api/digest');
    
    const firstPost = response.body.top_posts[0];
    expect(firstPost.top_commenters).toHaveLength(2);
    expect(firstPost.top_commenters[0].username).toBe('CatLadySarah');
    expect(firstPost.top_commenters[1].username).toBe('PortlandNative');
  });

  it('should return 404 for non-existent date', async () => {
    const response = await request(app)
      .get('/api/digest')
      .query({ date: '2020-01-01' });
    
    expect(response.status).toBe(404);
    expect(response.body).toHaveProperty('error');
    expect(response.body.error).toHaveProperty('message');
  });

  it('should handle invalid date format', async () => {
    const response = await request(app)
      .get('/api/digest')
      .query({ date: 'invalid-date' });
    
    expect(response.status).toBe(400);
    expect(response.body).toHaveProperty('error');
    expect(response.body.error).toHaveProperty('message');
  });

  it('should handle different post types correctly', async () => {
    const response = await request(app).get('/api/digest');
    
    // Find posts by type
    const textPost = response.body.top_posts.find((p: any) => p.type === 'text');
    const linkPost = response.body.top_posts.find((p: any) => p.type === 'link');
    const imagePost = response.body.top_posts.find((p: any) => p.type === 'image');

    // Verify text post
    expect(textPost.selftext).toBe('This is a test text post');
    expect(textPost.url).toBe('');

    // Verify link post
    expect(linkPost.selftext).toBe('');
    expect(linkPost.url).toBe('https://example.com/image.jpg');

    // Verify image post
    expect(imagePost.selftext).toBe('');
    expect(imagePost.url).toBe('https://example.com/image2.jpg');
  });

  it('should include keywords for all posts', async () => {
    const response = await request(app).get('/api/digest');
    
    response.body.top_posts.forEach((post: any) => {
      expect(Array.isArray(post.keywords)).toBe(true);
      expect(post.keywords.length).toBeGreaterThan(0);
      expect(post.keywords).toContain('test');
      expect(post.keywords).toContain('portland');
    });
  });

  it('should handle empty top_commenters array', async () => {
    // Create a post with no comments
    await db.query(
      'INSERT INTO posts (id, subreddit, title, type, upvotes, comment_count, permalink, selftext, url, keywords, author_id, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)',
      ['post4', 'r/Portland', 'Test Post 4', 'text', 25, 0, 'https://reddit.com/r/Portland/post4', 'Test content', '', ['test'], 'user1', new Date()]
    );

    const response = await request(app).get('/api/digest');
    const postWithNoComments = response.body.top_posts.find((p: any) => p.id === 'post4');
    
    expect(Array.isArray(postWithNoComments.top_commenters)).toBe(true);
    expect(postWithNoComments.top_commenters.length).toBe(0);
  });

  it('should handle null summary and sentiment', async () => {
    const response = await request(app).get('/api/digest');
    
    response.body.top_posts.forEach((post: any) => {
      expect(post.summary).toBeNull();
      expect(post.sentiment).toBeNull();
    });
  });
}); 