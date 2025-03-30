import { Pool, QueryResult } from 'pg';
import { ScoringService } from '../../src/services/scoringService';
import { Post } from '../../src/types/post';

// Mock the pg Pool
jest.mock('pg', () => {
    const mPool = {
        connect: jest.fn(),
        query: jest.fn(),
    };
    return { Pool: jest.fn(() => mPool) };
});

type MockClient = {
    query: jest.Mock<Promise<QueryResult>, [string, any[]]>;
    release: jest.Mock<void, []>;
};

describe('ScoringService', () => {
    let scoringService: ScoringService;
    let mockPool: jest.Mocked<Pool>;
    let mockClient: MockClient;

    beforeEach(() => {
        // Reset all mocks
        jest.clearAllMocks();

        // Setup mock client
        mockClient = {
            query: jest.fn(),
            release: jest.fn(),
        };

        // Setup mock pool
        mockPool = new Pool() as jest.Mocked<Pool>;
        mockPool.connect.mockResolvedValue(mockClient as unknown as any);

        scoringService = new ScoringService(mockPool);
    });

    describe('calculatePostScore', () => {
        it('should calculate score correctly based on upvotes and comments', () => {
            const post: Post = {
                id: '1',
                subreddit_id: '1',
                reddit_id: 'abc123',
                title: 'Test Post',
                selftext: 'Test content',
                url: 'https://reddit.com',
                score: 100, // upvotes
                num_comments: 50, // comments
                created_at: new Date(),
                updated_at: new Date(),
                reddit_created_at: new Date(),
                is_archived: false,
                is_locked: false,
                post_type: 'text',
                daily_rank: 0,
                daily_score: 0,
                author_id: '1',
                keywords: [],
                author_score: 0,
                top_commenters: {},
                summary: '',
                sentiment: {},
            };

            const score = scoringService.calculatePostScore(post);
            // score = (100 * 1.0) + (50 * 2.0) = 100 + 100 = 200
            expect(score).toBe(200);
        });
    });

    describe('updateDailyScores', () => {
        it('should update scores and ranks for posts from a specific date', async () => {
            const testDate = new Date('2024-03-20');
            const mockPosts = [
                {
                    id: '1',
                    score: 100,
                    num_comments: 50,
                    subreddit_id: '1',
                    reddit_id: 'abc123',
                    title: 'Test Post 1',
                    selftext: 'Test content 1',
                    url: 'https://reddit.com/1',
                    created_at: testDate,
                    updated_at: testDate,
                    reddit_created_at: testDate,
                    is_archived: false,
                    is_locked: false,
                    post_type: 'text',
                    daily_rank: 0,
                    daily_score: 0,
                    author_id: '1',
                    keywords: [],
                    author_score: 0,
                    top_commenters: {},
                    summary: '',
                    sentiment: {},
                },
                {
                    id: '2',
                    score: 200,
                    num_comments: 30,
                    subreddit_id: '1',
                    reddit_id: 'def456',
                    title: 'Test Post 2',
                    selftext: 'Test content 2',
                    url: 'https://reddit.com/2',
                    created_at: testDate,
                    updated_at: testDate,
                    reddit_created_at: testDate,
                    is_archived: false,
                    is_locked: false,
                    post_type: 'text',
                    daily_rank: 0,
                    daily_score: 0,
                    author_id: '2',
                    keywords: [],
                    author_score: 0,
                    top_commenters: {},
                    summary: '',
                    sentiment: {},
                },
            ];

            const mockQueryResult: QueryResult<Post> = {
                rows: [],
                command: '',
                rowCount: 0,
                oid: 0,
                fields: [],
            };

            // Mock the queries
            mockClient.query
                .mockResolvedValueOnce({ ...mockQueryResult, rows: mockPosts }) // SELECT posts
                .mockResolvedValueOnce(mockQueryResult) // UPDATE daily_score for post 1
                .mockResolvedValueOnce(mockQueryResult) // UPDATE daily_score for post 2
                .mockResolvedValueOnce(mockQueryResult) // UPDATE daily_rank
                .mockResolvedValueOnce(mockQueryResult); // COMMIT

            await scoringService.updateDailyScores(testDate);

            // Verify transaction was started and committed
            expect(mockClient.query).toHaveBeenCalledWith('BEGIN');
            expect(mockClient.query).toHaveBeenCalledWith('COMMIT');

            // Verify posts were queried for the correct date
            expect(mockClient.query).toHaveBeenCalledWith(
                expect.stringContaining('SELECT id, score, num_comments'),
                [testDate]
            );

            // Verify client was released
            expect(mockClient.release).toHaveBeenCalled();
        });

        it('should rollback transaction on error', async () => {
            const testDate = new Date('2024-03-20');
            mockClient.query
                .mockRejectedValueOnce(new Error('Database error'));

            await expect(scoringService.updateDailyScores(testDate))
                .rejects
                .toThrow('Database error');

            expect(mockClient.query).toHaveBeenCalledWith('ROLLBACK');
            expect(mockClient.release).toHaveBeenCalled();
        });
    });

    describe('getDailyPosts', () => {
        it('should return posts ordered by daily rank', async () => {
            const testDate = new Date('2024-03-20');
            const mockPosts: Post[] = [
                {
                    id: '1',
                    subreddit_id: '1',
                    reddit_id: 'abc123',
                    title: 'Test Post 1',
                    selftext: 'Test content 1',
                    url: 'https://reddit.com/1',
                    score: 100,
                    num_comments: 50,
                    created_at: testDate,
                    updated_at: testDate,
                    reddit_created_at: testDate,
                    is_archived: false,
                    is_locked: false,
                    post_type: 'text',
                    daily_rank: 1,
                    daily_score: 200,
                    author_id: '1',
                    keywords: [],
                    author_score: 0,
                    top_commenters: {},
                    summary: '',
                    sentiment: {},
                },
                {
                    id: '2',
                    subreddit_id: '1',
                    reddit_id: 'def456',
                    title: 'Test Post 2',
                    selftext: 'Test content 2',
                    url: 'https://reddit.com/2',
                    score: 200,
                    num_comments: 30,
                    created_at: testDate,
                    updated_at: testDate,
                    reddit_created_at: testDate,
                    is_archived: false,
                    is_locked: false,
                    post_type: 'text',
                    daily_rank: 2,
                    daily_score: 260,
                    author_id: '2',
                    keywords: [],
                    author_score: 0,
                    top_commenters: {},
                    summary: '',
                    sentiment: {},
                },
            ];

            const mockQueryResult: QueryResult<Post> = {
                rows: mockPosts,
                command: '',
                rowCount: mockPosts.length,
                oid: 0,
                fields: [],
            };

            mockPool.query.mockResolvedValueOnce(mockQueryResult);

            const posts = await scoringService.getDailyPosts(testDate);

            expect(mockPool.query).toHaveBeenCalledWith(
                expect.stringContaining('ORDER BY daily_rank ASC'),
                [testDate]
            );
            expect(posts).toEqual(mockPosts);
        });
    });
}); 