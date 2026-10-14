-- Level 2 | Question 4: Inventory Value by Warehouse
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display warehouse and sum of quantity * unit_cost; include totals above 12000; sort descending.
-- Result: Correct after revision

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE medicine_stock (stock_id INT PRIMARY KEY, medicine_name VARCHAR(100), warehouse VARCHAR(100), quantity INT, unit_cost NUMERIC(10,2));
INSERT INTO medicine_stock VALUES
(1,'MedA','Hyderabad',100,50),(2,'MedB','Chennai',200,30),(3,'MedC','Hyderabad',150,40),(4,'MedA','Chennai',80,50),(5,'MedB','Hyderabad',120,30),(6,'MedC','Chennai',100,40);

-- FIRST ATTEMPT (incorrect; preserved exactly)
 /*
SELECT warehouse, quantity * unit_cost AS total_inventory_value
FROM medicine_stock
GROUP BY warehouse
HAVING quantity * unit_cost > 120000
ORDER BY total_inventory_value DESC;
 */
-- Why it was incorrect: it calculated value per row instead of summing inventory value per warehouse,
-- grouped by the wrong column, and used 120000 instead of the requested 12000.
-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT warehouse, SUM(quantity * unit_cost) AS total_inventory_value
FROM medicine_stock
GROUP BY warehouse
HAVING SUM(quantity * unit_cost) > 12000
ORDER BY total_inventory_value DESC;

-- FINAL ACCEPTED QUERY
SELECT warehouse, SUM(quantity * unit_cost) AS total_inventory_value
FROM medicine_stock
GROUP BY warehouse
HAVING SUM(quantity * unit_cost) > 12000
ORDER BY total_inventory_value DESC;
