-- Level 2 | Question 3: Customer Total Spending
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display each customer and total spending; include totals above 10000; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE customer_purchases (purchase_id INT PRIMARY KEY, customer_name VARCHAR(100), category VARCHAR(100), amount NUMERIC(12,2));
INSERT INTO customer_purchases VALUES
(1,'Anika','Electronics',12000),(2,'Varun','Clothing',2500),(3,'Anika','Books',1500),(4,'Rahul','Electronics',9000),(5,'Varun','Electronics',7000),(6,'Priya','Books',3000),(7,'Rahul','Clothing',2000);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT customer_name, SUM(amount) AS total_amount
FROM customer_purchases
GROUP BY customer_name
HAVING SUM(amount) > 10000
ORDER BY total_amount DESC;

-- FINAL ACCEPTED QUERY
SELECT customer_name, SUM(amount) AS total_amount
FROM customer_purchases
GROUP BY customer_name
HAVING SUM(amount) > 10000
ORDER BY total_amount DESC;
