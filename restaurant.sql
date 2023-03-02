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

CREATE TABLE reviews (
  id INTEGER PRIMARY KEY,
  restaurant_id INTEGER,
  customer_name TEXT,
  review_text TEXT,
  rating INTEGER,
  date DATE,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- find cheap restaurant
SELECT rest_name
FROM restaurants
WHERE neighborhood = 'West Village' AND price = 'cheap';

-- find restaurants in specific cuisine, by rating, descending order
SELECT rest_name, average_rating
FROM restaurants
WHERE cuisine = 'Chinese' AND average_rating >= 3
ORDER BY average_rating DESC;

-- restaurants that are open now
SELECT rest_name
FROM restaurants
WHERE strftime('%H:%M', 'now') BETWEEN opening_hours AND closing_hours;

-- leave a review for any restaurant
INSERT INTO reviews (restaurant_id, customer_name, review_text, rating, date)
VALUES (1, 'John Doe', 'Great food and friendly service', 4, DATE('now'));

-- delete restaurants that are not good for kids 
SELECT * FROM restaurants WHERE good_for_kids = false;
DELETE FROM restaurants WHERE good_for_kids = false;

-- find number of restaurants in each neighborhood
SELECT neighborhood, COUNT(*) AS num_restaurants
FROM restaurants
GROUP BY neighborhood;