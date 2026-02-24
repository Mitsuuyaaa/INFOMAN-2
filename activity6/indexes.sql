-- Scenario 1
CREATE INDEX idx_posts_author_date
ON posts (author_id, date DESC);

-- Scenario 2
CREATE INDEX idx_posts_title
ON posts(title);

-- Scenario 3
CREATE INDEX idx_posts_date
ON posts(date);