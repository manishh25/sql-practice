-- Level 1 | Question 8: Product Inventory
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display product_name, stock_quantity, unit_price for stock below 20 and price between 500 and 3500 inclusive; sort price descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE product_inventory (product_id INT PRIMARY KEY, product_name VARCHAR(100), category VARCHAR(100), stock_quantity INT, unit_price NUMERIC(10,2));
INSERT INTO product_inventory VALUES
(801,'Wireless Mouse','Electronics',25,750),(802,'Office Chair','Furniture',0,4500),(803,'USB Cable','Electronics',120,250),(804,'Desk Lamp','Home Decor',8,900),(805,'Keyboard','Electronics',12,1500),(806,'Bookshelf','Furniture',5,3200);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT product_name, stock_quantity, unit_price
FROM product_inventory
WHERE stock_quantity < 20 AND unit_price BETWEEN 500 AND 3500
ORDER BY unit_price DESC;

-- FINAL ACCEPTED QUERY
SELECT product_name, stock_quantity, unit_price
FROM product_inventory
WHERE stock_quantity < 20 AND unit_price BETWEEN 500 AND 3500
ORDER BY unit_price DESC;
