-- Up migration
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add author_id to posts table
ALTER TABLE posts ADD COLUMN IF NOT EXISTS author_id VARCHAR(255);
ALTER TABLE posts ADD CONSTRAINT fk_posts_author FOREIGN KEY (author_id) REFERENCES users(id);

-- Add author_id to comments table
ALTER TABLE comments ADD COLUMN IF NOT EXISTS author_id VARCHAR(255);
ALTER TABLE comments ADD CONSTRAINT fk_comments_author FOREIGN KEY (author_id) REFERENCES users(id);

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_posts_author_id ON posts(author_id);
CREATE INDEX IF NOT EXISTS idx_comments_author_id ON comments(author_id);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Down migration
DROP INDEX IF EXISTS idx_posts_author_id;
DROP INDEX IF EXISTS idx_comments_author_id;
DROP INDEX IF EXISTS idx_users_username;

ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_author;
ALTER TABLE comments DROP COLUMN IF EXISTS author_id;

ALTER TABLE posts DROP CONSTRAINT IF EXISTS fk_posts_author;
ALTER TABLE posts DROP COLUMN IF EXISTS author_id;

DROP TABLE IF EXISTS users; 