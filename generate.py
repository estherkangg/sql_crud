import csv
import random
import string
import datetime

# Generate 1000 random user records
users = []
for i in range(1, 1001):
    username = ''.join(random.choice(string.ascii_lowercase) for _ in range(8))
    email = f'{username}@example.com'
    password = ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(16))
    users.append((i, email, password, username))

# Write user records to a CSV file
with open('data/users.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['id', 'email', 'password', 'username'])
    writer.writerows(users)

# Generate 1000 random message records
messages = []
for i in range(1, 1001):
    sender_id = random.randint(1, 1000)
    recipient_id = random.randint(1, 1000)
    content = ''.join(random.choice(string.ascii_letters + string.digits + '.,?!') for _ in range(64))
    created_at = datetime.datetime.now() - datetime.timedelta(days=random.randint(1, 365))
    is_visible = random.randint(1, 2)  # Generate 1 or 2 randomly for the is_visible column
    messages.append((i, 'message', content, sender_id, recipient_id, is_visible, created_at, None, False))

# Write message records to a CSV file
with open('data/posts.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['post_id', 'post_type', 'content', 'sender_id', 'recipient_id', 'is_visible', 'created_at', 'invisible_at', 'is_deleted'])
    writer.writerows(messages)

# Generate 1000 random story records
stories = []
for i in range(1, 2001):
    sender_id = random.randint(1, 1000)
    content = ''.join(random.choice(string.ascii_letters + string.digits + '.,?!') for _ in range(128))
    created_at = datetime.datetime.now() - datetime.timedelta(days=random.randint(1, 365))
    is_visible = random.randint(1, 2)  # Generate 1 or 2 randomly for the is_visible column
    stories.append((i, 'story', content, sender_id, None, is_visible, created_at, None, False))

# Append story records to the CSV file
with open('data/posts.csv', 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(stories)
