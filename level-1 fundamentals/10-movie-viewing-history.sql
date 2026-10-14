-- Level 1 | Question 10: Movie Viewing History
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display unique users who completed Thriller or Sci-Fi movies longer than 100 minutes; sort alphabetically.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE viewing_history (viewing_id INT PRIMARY KEY, user_name VARCHAR(100), movie_title VARCHAR(100), genre VARCHAR(100), watch_duration INT, watch_status VARCHAR(30));
INSERT INTO viewing_history VALUES
(1001,'Nikhil','Silent Night','Thriller',115,'Completed'),(1002,'Tara','Ocean Blue','Drama',45,'In Progress'),(1003,'Nikhil','Space Beyond','Sci-Fi',130,'Completed'),(1004,'Maya','Hidden Truth','Thriller',95,'Completed'),(1005,'Tara','Wild Earth','Documentary',80,'Completed'),(1006,'Arjun','Star Voyage','Sci-Fi',140,'In Progress');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT DISTINCT user_name 
FROM viewing_history
WHERE genre IN('Thriller', 'Sci-Fi') AND watch_duration > 100 AND watch_status = 'Completed'
ORDER BY user_name ASC;

-- FINAL ACCEPTED QUERY
SELECT DISTINCT user_name 
FROM viewing_history
WHERE genre IN('Thriller', 'Sci-Fi') AND watch_duration > 100 AND watch_status = 'Completed'
ORDER BY user_name ASC;
