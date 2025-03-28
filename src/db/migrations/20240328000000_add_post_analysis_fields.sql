-- Add new columns to posts table
ALTER TABLE posts
ADD COLUMN keywords TEXT[],
ADD COLUMN author_score FLOAT,
ADD COLUMN top_commenters JSONB,
ADD COLUMN summary TEXT,
ADD COLUMN sentiment JSONB;

-- Add contribution_score to comments table
ALTER TABLE comments
ADD COLUMN contribution_score FLOAT;

-- Drop old tables that are no longer needed
DROP TABLE IF EXISTS post_categories;
DROP TABLE IF EXISTS post_keywords;
DROP TABLE IF EXISTS comment_keywords;
DROP TABLE IF EXISTS post_sentiment;
DROP TABLE IF EXISTS comment_sentiment;

-- Add NOT NULL constraints to required fields
ALTER TABLE posts
ALTER COLUMN post_type SET NOT NULL,
ALTER COLUMN permalink SET NOT NULL;

-- Add indexes for new columns
CREATE INDEX idx_posts_keywords ON posts USING GIN (keywords);
CREATE INDEX idx_posts_sentiment ON posts USING GIN (sentiment);
CREATE INDEX idx_posts_top_commenters ON posts USING GIN (top_commenters);
CREATE INDEX idx_comments_contribution_score ON comments (contribution_score); 