-- Rename url column to content_url in posts table
ALTER TABLE posts RENAME COLUMN url TO content_url;

-- Update any existing indexes or constraints if they reference the url column
-- (Add any necessary index/constraint updates here) 