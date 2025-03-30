-- Add scoring columns to posts table
ALTER TABLE posts
ADD COLUMN daily_score FLOAT DEFAULT 0,
ADD COLUMN daily_rank INTEGER DEFAULT 0;

-- Create index for daily_rank to improve query performance
CREATE INDEX idx_posts_daily_rank ON posts(daily_rank); 