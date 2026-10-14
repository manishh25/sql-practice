-- Level 1 | Question 2: Food Delivery Orders
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display customer_name, city, order_amount for non-cancelled orders between 200 and 600 inclusive; sort customer name ascending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE food_orders (order_id INT PRIMARY KEY, customer_name VARCHAR(100), city VARCHAR(100), order_amount NUMERIC(10,2), delivery_status VARCHAR(30));
INSERT INTO food_orders VALUES
(201,'Rahul','Hyderabad',450,'Delivered'),(202,'Priya','Chennai',280,'Pending'),(203,'Arjun','Hyderabad',650,'Delivered'),(204,'Sneha','Bengaluru',350,'Cancelled'),(205,'Kiran','Chennai',520,'Delivered'),(206,'Meera','Hyderabad',180,'Pending');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT customer_name, city, order_amount
FROM food_orders
WHERE NOT delivery_status = 'Cancelled' AND order_amount BETWEEN 200 AND 600 
ORDER BY customer_name ASC;

-- FINAL ACCEPTED QUERY
SELECT customer_name, city, order_amount
FROM food_orders
WHERE NOT delivery_status = 'Cancelled' AND order_amount BETWEEN 200 AND 600 
ORDER BY customer_name ASC;
