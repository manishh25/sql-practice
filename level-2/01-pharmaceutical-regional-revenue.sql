-- Level 2 | Question 1: Pharmaceutical Regional Revenue
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display each region and total revenue; include totals above 50000; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE drug_sales (sale_id INT PRIMARY KEY, drug_name VARCHAR(100), region VARCHAR(100), units_sold INT, revenue NUMERIC(12,2));
INSERT INTO drug_sales VALUES
(1,'MedA','South',120,24000),(2,'MedB','North',80,16000),(3,'MedA','North',100,20000),(4,'MedC','South',150,30000),(5,'MedB','South',90,18000),(6,'MedC','North',70,14000);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT region, SUM(revenue) AS total_revenue
FROM drug_sales
GROUP BY region
HAVING SUM(revenue) > 50000
ORDER BY total_revenue DESC;

-- FINAL ACCEPTED QUERY
SELECT region, SUM(revenue) AS total_revenue
FROM drug_sales
GROUP BY region
HAVING SUM(revenue) > 50000
ORDER BY total_revenue DESC;
