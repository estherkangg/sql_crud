CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE
);

CREATE TABLE posts (
  post_id INTEGER PRIMARY KEY AUTOINCREMENT,
  post_type TEXT NOT NULL, 
  content TEXT NOT NULL,
  sender_id INTEGER NOT NULL,
  recipient_id INTEGER,
  is_visible BOOLEAN,
  created_at TIMESTAMP,
  invisible_at TIMESTAMP,
  is_deleted BOOLEAN,
  FOREIGN KEY (sender_id) REFERENCES users (id),
  FOREIGN KEY (recipient_id) REFERENCES users (id)
);

-- register a new user
INSERT INTO users (email, password, username)
VALUES ('newuser@example.com', 'password123', 'newuser');

-- create a new message sent by user to user (user 3 to 4)
INSERT INTO posts (post_type, content, sender_id, recipient_id, is_visible, created_at, is_deleted)
VALUES ('message', 'Hello, how are you?', 3, 4, 1, datetime('now'), 0);


-- create a new story by a user (pick any)
INSERT INTO posts (post_type, content, sender_id, is_visible, created_at, is_deleted)
VALUES ('story', 'This is my new story!', '3', 1, CURRENT_TIMESTAMP, 0);

-- show 10 most recent messages/story that are visible, order of recency
SELECT * FROM (
  SELECT post_id, post_type, content, sender_id, recipient_id, created_at 
  FROM posts 
  WHERE is_visible = 1 
  ORDER BY created_at DESC 
  LIMIT 10
) AS visible_posts 
ORDER BY created_at ASC;

-- show 10 most recent visible messages sent by user to user, order of recency (pick any)
SELECT * FROM (
  SELECT post_id, post_type, content, sender_id, recipient_id, created_at 
  FROM posts 
  WHERE sender_id = 3 AND recipient_id = 4 AND is_visible = 1 
  ORDER BY created_at DESC 
  LIMIT 10
) AS visible_posts 
ORDER BY created_at ASC;

-- make all stories more than 24 hours invisible
UPDATE posts SET is_visible = 0 WHERE post_type = 'story' AND created_at < datetime('now', '-24 hours');

-- show all invisible messages/stories, order of recency
SELECT * FROM posts
WHERE is_visible = 0
ORDER BY created_at DESC;

-- show the number of posts by each user
SELECT users.username, COUNT(posts.post_id) as num_posts
FROM users
LEFT JOIN posts ON users.id = posts.sender_id
GROUP BY users.id
ORDER BY num_posts DESC;

-- show the post text and email address of all posts and the user who made them in the last 24 hours
SELECT p.content, u.email
FROM posts p
JOIN users u ON p.sender_id = u.id
WHERE p.created_at >= datetime('now', '-24 hours');

-- show email of users who have not posted
SELECT email
FROM users
LEFT JOIN posts ON users.id = posts.sender_id
WHERE posts.sender_id IS NULL;
