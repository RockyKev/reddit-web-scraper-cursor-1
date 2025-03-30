import { KeywordAnalysisService } from '../../backend/services/keyword-analysis-service.js';
import { RedditPost, RedditComment } from '../../backend/types/reddit.js';

describe('KeywordAnalysisService', () => {
  let service: KeywordAnalysisService;

  beforeEach(() => {
    service = new KeywordAnalysisService();
  });

  it('should extract keywords from post and top comments', () => {
    const post: RedditPost = {
      id: 'test1',
      title: 'Best sushi restaurants in Portland',
      content: 'Looking for recommendations for sushi places in Portland. Preferably downtown area.',
      url: 'https://reddit.com/test',
      author: 'testuser',
      score: 100,
      commentCount: 5,
      createdAt: new Date(),
      isArchived: false,
      isLocked: false,
      permalink: '/r/Portland/test1',
      post_type: 'text',
      keywords: [],
      author_score: 2,
      top_commenters: [],
      summary: null,
      sentiment: null
    };

    const comments: RedditComment[] = [
      {
        id: 'comment1',
        content: 'Sushi Hana is amazing! They have the best rolls.',
        author: 'user1',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment2',
        content: 'I love Bamboo Sushi, especially their sustainable options.',
        author: 'user2',
        score: 45,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment3',
        content: 'The downtown location of Yama Sushi is great!',
        author: 'user3',
        score: 40,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      }
    ];

    const keywords = service.extractKeywordsFromPost(post, comments);

    // Should include relevant terms
    expect(keywords).toContain('sushi');
    expect(keywords).toContain('portland');
    expect(keywords).toContain('restaurants');
    expect(keywords.length).toBeGreaterThan(0);
    
    // Log keywords for debugging
    console.log('Extracted keywords:', keywords);
  });

  it('should extract keywords from post without comments', () => {
    const post: RedditPost = {
      id: 'test2',
      title: 'Test post',
      content: 'Test content',
      url: 'https://reddit.com/test',
      author: 'testuser',
      score: 100,
      commentCount: 0,
      createdAt: new Date(),
      isArchived: false,
      isLocked: false,
      permalink: '/r/Portland/test2',
      post_type: 'text',
      keywords: [],
      author_score: 2,
      top_commenters: [],
      summary: null,
      sentiment: null
    };

    const keywords = service.extractKeywordsFromPost(post, []);
    expect(keywords).toContain('test');
    expect(keywords).toContain('post');
    expect(keywords).toContain('content');
  });

  it('should get top comments based on score', () => {
    const comments: RedditComment[] = [
      {
        id: 'comment1',
        content: 'Comment 1',
        author: 'user1',
        score: 100,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment2',
        content: 'Comment 2',
        author: 'user2',
        score: 50,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment3',
        content: 'Comment 3',
        author: 'user3',
        score: 75,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment4',
        content: 'Comment 4',
        author: 'user4',
        score: 25,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment5',
        content: 'Comment 5',
        author: 'user5',
        score: 60,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      },
      {
        id: 'comment6',
        content: 'Comment 6',
        author: 'user6',
        score: 40,
        createdAt: new Date(),
        isArchived: false,
        parentId: undefined,
        contribution_score: 3
      }
    ];

    const post: RedditPost = {
      id: 'test3',
      title: 'Test post',
      content: 'Test content',
      url: 'https://reddit.com/test',
      author: 'testuser',
      score: 100,
      commentCount: 6,
      createdAt: new Date(),
      isArchived: false,
      isLocked: false,
      permalink: '/r/Portland/test3',
      post_type: 'text',
      keywords: [],
      author_score: 2,
      top_commenters: [],
      summary: null,
      sentiment: null
    };

    const keywords = service.extractKeywordsFromPost(post, comments);
    expect(keywords).toContain('comment');
    expect(keywords).toContain('test');
    expect(keywords).toContain('post');
    expect(keywords).toContain('content');
  });
}); 