import pkg from 'pg';
const { Pool } = pkg;
import type { DbPool } from '../types/shared.js';
import { Post } from '../types/post.js';
import { db } from '../../database/index.js';

export class ScoringService {
    private readonly pool: DbPool;

    constructor(db: DbPool) {
        this.pool = db;
    }

    /**
     * Calculate the score for a post using the formula:
     * score = (score * 1.0) + (num_comments * 2.0)
     */
    public calculatePostScore(post: Post): number {
        return (post.score * 1.0) + (post.num_comments * 2.0);
    }

    /**
     * Update scores and ranks for all posts from a specific date
     */
    public async updateDailyScores(date: Date): Promise<void> {
        const client = await this.pool.connect();
        try {
            await client.query('BEGIN');

            // Get all posts for the given date
            const posts = await client.query(
                `SELECT id, score, num_comments 
                 FROM posts 
                 WHERE DATE(created_at) = $1`,
                [date]
            );

            // Calculate scores and update them
            for (const post of posts.rows) {
                const dailyScore = this.calculatePostScore(post);
                await client.query(
                    `UPDATE posts 
                     SET daily_score = $1 
                     WHERE id = $2`,
                    [dailyScore, post.id]
                );
            }

            // Update daily ranks based on daily_score
            await client.query(
                `WITH ranked_posts AS (
                    SELECT id, ROW_NUMBER() OVER (ORDER BY daily_score DESC) as rank
                    FROM posts
                    WHERE DATE(created_at) = $1
                )
                UPDATE posts p
                SET daily_rank = r.rank
                FROM ranked_posts r
                WHERE p.id = r.id`,
                [date]
            );

            await client.query('COMMIT');
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }

    /**
     * Get posts for a specific date, ordered by daily rank
     */
    public async getDailyPosts(date: Date): Promise<Post[]> {
        const result = await this.pool.query(
            `SELECT * FROM posts 
             WHERE DATE(created_at) = $1 
             ORDER BY daily_rank ASC`,
            [date]
        );
        return result.rows;
    }
} 