-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create subreddits table
CREATE TABLE subreddits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subreddit_id UUID NOT NULL REFERENCES subreddits(id),
    author_id VARCHAR(255) REFERENCES users(id),
    title TEXT NOT NULL,
    selftext TEXT,
    url TEXT,
    score INTEGER DEFAULT 0,
    num_comments INTEGER DEFAULT 0,
    permalink TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    reddit_created_at TIMESTAMP WITH TIME ZONE,
    is_archived BOOLEAN DEFAULT FALSE,
    is_locked BOOLEAN DEFAULT FALSE,
    post_type VARCHAR(50) NOT NULL,
    daily_score FLOAT DEFAULT 0,
    daily_rank INTEGER DEFAULT 0,
    keywords TEXT[],
    author_score FLOAT,
    top_commenters JSONB,
    summary TEXT,
    sentiment JSONB,
    UNIQUE(author_id, permalink)
);

-- Create comments table
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id),
    author_id VARCHAR(255) REFERENCES users(id),
    content TEXT NOT NULL,
    score INTEGER DEFAULT 0,
    contribution_score FLOAT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    reddit_created_at TIMESTAMP WITH TIME ZONE,
    is_archived BOOLEAN DEFAULT FALSE,
    reddit_id VARCHAR(255) UNIQUE
);

-- Create indexes for better query performance
CREATE INDEX idx_posts_subreddit_id ON posts(subreddit_id);
CREATE INDEX idx_posts_author_id ON posts(author_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_posts_reddit_created_at ON posts(reddit_created_at);
CREATE INDEX idx_posts_daily_rank ON posts(daily_rank);
CREATE INDEX idx_posts_keywords ON posts USING GIN (keywords);
CREATE INDEX idx_posts_sentiment ON posts USING GIN (sentiment);
CREATE INDEX idx_posts_top_commenters ON posts USING GIN (top_commenters);

CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_author_id ON comments(author_id);
CREATE INDEX idx_comments_created_at ON comments(created_at);
CREATE INDEX idx_comments_reddit_created_at ON comments(reddit_created_at);
CREATE INDEX idx_comments_contribution_score ON comments(contribution_score);

CREATE INDEX idx_users_username ON users(username);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_subreddits_updated_at
    BEFORE UPDATE ON subreddits
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 