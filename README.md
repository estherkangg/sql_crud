# Report  
  
## SQL Code to Generate Tables  
  
### Restaurant  
  
create TABLE restaurants (
  id INTEGER PRIMARY KEY,
  rest_name TEXT,
  cuisine TEXT,
  neighborhood TEXT,
  price TEXT,
  opening_hours TIME,
  closing_hours TIME,
  average_rating INTEGER,
  good_for_kids BOOLEAN
);  
  
### Reviews  
  
CREATE TABLE reviews (
  id INTEGER PRIMARY KEY,
  restaurant_id INTEGER,
  customer_name TEXT,
  review_text TEXT,
  rating INTEGER,
  date DATE,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);  
  
### Users  
  
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE
);  
  
### Posts  
  
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
  
## Python Code to Generate CSV Files  
  
import csv
import random
import string
import datetime

#### Generate 1000 random user records
users = []
for i in range(1, 1001):
    username = ''.join(random.choice(string.ascii_lowercase) for _ in range(8))
    email = f'{username}@example.com'
    password = ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(16))
    users.append((i, email, password, username))

#### Write user records to a CSV file
with open('data/users.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['id', 'email', 'password', 'username'])
    writer.writerows(users)

#### Generate 1000 random message records
messages = []
for i in range(1, 1001):
    sender_id = random.randint(1, 1000)
    recipient_id = random.randint(1, 1000)
    content = ''.join(random.choice(string.ascii_letters + string.digits + '.,?!') for _ in range(64))
    created_at = datetime.datetime.now() - datetime.timedelta(days=random.randint(1, 365))
    is_visible = random.randint(1, 2)  # Generate 1 or 2 randomly for the is_visible column
    messages.append((i, 'message', content, sender_id, recipient_id, is_visible, created_at, None, False))

#### Write message records to a CSV file
with open('data/posts.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['post_id', 'post_type', 'content', 'sender_id', 'recipient_id', 'is_visible', 'created_at', 'invisible_at', 'is_deleted'])
    writer.writerows(messages)

#### Generate 1000 random story records
stories = []
for i in range(1, 2001):
    sender_id = random.randint(1, 1000)
    content = ''.join(random.choice(string.ascii_letters + string.digits + '.,?!') for _ in range(128))
    created_at = datetime.datetime.now() - datetime.timedelta(days=random.randint(1, 365))
    is_visible = random.randint(1, 2)  # Generate 1 or 2 randomly for the is_visible column
    stories.append((i, 'story', content, sender_id, None, is_visible, created_at, None, False))

#### Append story records to the CSV file
with open('data/posts.csv', 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(stories)
  
    
## Link to CSV Files in Drive  
[CSV FILES](https://drive.google.com/drive/folders/1iT06Y5IPPW1F4luePJTB1L5e0CaAgR7f?usp=share_link)  
  
## SQLite code to Import Practice CSV Data Files into Tables  
  
- .import data/rest.csv rest --skip 1  
- .import data/users.csv users --skip 1  
- .import data/posts.csv posts --skip 1  
  
## SQL Queries  
  
##### Finding cheapest restaurant:  
SELECT rest_name
FROM restaurants
WHERE neighborhood = 'West Village' AND price = 'cheap';  
  
##### Find restaurants in specific cuisine, by rating, descending order:  
SELECT rest_name, average_rating
FROM restaurants
WHERE cuisine = 'Chinese' AND average_rating >= 3
ORDER BY average_rating DESC;  
  
##### Find restaurants that are open now:  
SELECT rest_name
FROM restaurants
WHERE strftime('%H:%M', 'now') BETWEEN opening_hours AND closing_hours;  
  
##### Leave a review for any restaurant:  
INSERT INTO reviews (restaurant_id, customer_name, review_text, rating, date)
VALUES (1, 'John Doe', 'Great food and friendly service', 4, DATE('now'));  
  
##### Delete restaurants that are not good for kids:  
SELECT * FROM restaurants WHERE good_for_kids = false;
DELETE FROM restaurants WHERE good_for_kids = false;  
  
##### Find number of restaurants in each neighborhood:  
SELECT neighborhood, COUNT(*) AS num_restaurants
FROM restaurants
GROUP BY neighborhood;  
  
  
##### Register a new user:  
INSERT INTO users (email, password, username)
VALUES ('newuser@example.com', 'password123', 'newuser');  
  
##### Create a new message sent by user to user (user 3 to 4):  
INSERT INTO posts (post_type, content, sender_id, recipient_id, is_visible, created_at, is_deleted)
VALUES ('message', 'Hello, how are you?', 3, 4, 1, datetime('now'), 0);  
  
##### Create a new story by a user:  
INSERT INTO posts (post_type, content, sender_id, is_visible, created_at, is_deleted)
VALUES ('story', 'This is my new story!', '3', 1, CURRENT_TIMESTAMP, 0);  
  
##### Show 10 most recent message/story that are visible, order of recency:  
SELECT * FROM (
  SELECT post_id, post_type, content, sender_id, recipient_id, created_at 
  FROM posts 
  WHERE is_visible = 1 
  ORDER BY created_at DESC 
  LIMIT 10
) AS visible_posts 
ORDER BY created_at ASC;  
  
##### Show 10 most recent visible messages sent by user to user, order of recency (pick any two):  
SELECT * FROM (
  SELECT post_id, post_type, content, sender_id, recipient_id, created_at 
  FROM posts 
  WHERE sender_id = 3 AND recipient_id = 4 AND is_visible = 1 
  ORDER BY created_at DESC 
  LIMIT 10
) AS visible_posts 
ORDER BY created_at ASC;  
  
##### Make all stories more than 24 hours invisible:  
UPDATE posts SET is_visible = 0 WHERE post_type = 'story' AND created_at < datetime('now', '-24 hours');  
  
##### Show all invisible messages/stories, order of recency:  
SELECT * FROM posts
WHERE is_visible = 0
ORDER BY created_at DESC;  
  
##### Show the number of posts by each user:  
SELECT users.username, COUNT(posts.post_id) as num_posts
FROM users
LEFT JOIN posts ON users.id = posts.sender_id
GROUP BY users.id
ORDER BY num_posts DESC;
  
  
