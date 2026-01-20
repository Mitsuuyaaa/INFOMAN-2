-- PostgreSQL Schema for Blog Database

-- Drop tables if they already exist (optional but helpful for re-running)
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (username) VALUES
('alice'),
('bob'),
('charlie'),
('diana'),
('eric'),
('frank'),
('grace');

-- Posts (2 original + 5 more)
INSERT INTO posts (user_id, title, body) VALUES
(1, 'First Post!', 'This is the body of the first post.'),
(2, 'Bob''s Thoughts', 'A penny for my thoughts.'),
(3, 'Hello World', 'My first blog post here.'),
(4, 'College Life', 'Thoughts about studying and exams.'),
(5, 'Tech Talk', 'Let us talk about databases.'),
(6, 'Random Ideas', 'Just sharing some random ideas.'),
(7, 'Daily Routine', 'What I do every day.');

-- Comments (2 original + 5 more)
INSERT INTO comments (post_id, user_id, comment) VALUES
(1, 2, 'Great first post, Alice!'),
(2, 1, 'Interesting thoughts, Bob.'),
(3, 1, 'Welcome to blogging!'),
(4, 3, 'College life is tough but fun.'),
(5, 4, 'Databases are really interesting.'),
(6, 5, 'Nice ideas you got there.'),
(7, 6, 'Daily routines keep us organized.');