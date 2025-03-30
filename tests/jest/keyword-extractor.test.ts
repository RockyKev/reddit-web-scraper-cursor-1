import { KeywordExtractor } from '../../backend/services/keyword-extractor.js';
import { RedditPost, RedditComment } from '../../backend/types/reddit.js';

describe('KeywordExtractor', () => {
  let extractor: KeywordExtractor;

  beforeEach(() => {
    extractor = new KeywordExtractor();
  });

  it('should extract keywords from post and comments', () => {
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
      }
    ];

    const keywords = extractor.extractKeywords(post, comments);

    // Should include relevant terms
    expect(keywords).toContain('sushi');
    expect(keywords).toContain('portland');
    expect(keywords).toContain('restaurants');
    expect(keywords).toHaveLength(10); // TF-IDF returns top 10 terms
    
    // Log the actual keywords for debugging
    console.log('Extracted keywords:', keywords);
  });

  it('should handle empty content', () => {
    const post: RedditPost = {
      id: 'test2',
      title: '',
      content: '',
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

    const keywords = extractor.extractKeywords(post, []);
    expect(keywords).toHaveLength(0);
  });
});