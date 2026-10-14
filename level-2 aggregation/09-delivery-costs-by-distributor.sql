-- Level 2 | Question 9: Delivery Costs by Distributor
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display distributor and total delivery cost across all regions; include totals at least 10000; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE medicine_deliveries (delivery_id INT PRIMARY KEY, distributor VARCHAR(100), region VARCHAR(100), packages_delivered INT, delivery_cost NUMERIC(12,2));
INSERT INTO medicine_deliveries VALUES
(1,'Alpha Pharma','South',120,6000),(2,'Beta Med','North',80,5000),(3,'Alpha Pharma','North',100,4500),(4,'Gamma Health','South',150,7000),(5,'Beta Med','South',90,5500),(6,'Gamma Health','North',70,3500);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT distributor, SUM(delivery_cost) AS total_delivery
FROM medicine_deliveries
GROUP BY distributor
HAVING SUM(delivery_cost) >= 10000
ORDER BY total_delivery DESC;

-- FINAL ACCEPTED QUERY
SELECT distributor, SUM(delivery_cost) AS total_delivery
FROM medicine_deliveries
GROUP BY distributor
HAVING SUM(delivery_cost) >= 10000
ORDER BY total_delivery DESC;
