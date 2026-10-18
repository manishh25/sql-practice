-- PostgreSQL Practice: Level 7 - Arrays
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    tags TEXT[]
);

INSERT INTO products (product_id, product_name, tags) VALUES
(1, 'Laptop', ARRAY['electronics', 'computers']),
(2, 'Phone', ARRAY['electronics', 'mobile']),
(3, 'Desk', ARRAY['furniture', 'office']),
(4, 'Chair', ARRAY['furniture', 'office', 'ergonomic']),
(5, 'Tablet', ARRAY['electronics', 'mobile']);

-- Q1. Display products whose tags contain 'mobile'.
-- User attempt (correct):
SELECT product_name, tags
FROM products
WHERE 'mobile' = ANY(tags);

-- Q2. Display products that have both 'electronics' and 'mobile' tags.
-- User attempt (correct):
SELECT product_name
FROM products
WHERE 'electronics' = ANY(tags) AND 'mobile' = ANY(tags);

-- Q3. Display each product name and the number of tags in its array.
-- Solution revealed; not independently attempted:
SELECT product_name, CARDINALITY(tags) AS tag_count
FROM products;

-- Q4. Display each product name and the first element of its tags array.
-- User attempt (correct):
SELECT product_name, tags[1] AS first_element
FROM products;

-- Q5. Return one row per tag, alongside the product name.
-- User attempt (correct):
SELECT product_name, tag
FROM products,
     UNNEST(tags) AS tag;

-- Q6. Display each product and one array containing all its tags sorted alphabetically.
-- Solution revealed; not independently attempted:
SELECT product_name,
       ARRAY_AGG(tag ORDER BY tag) AS sorted_tags
FROM products,
     UNNEST(tags) AS tag
GROUP BY product_name;

-- Q6 alternative discussed: STRING_AGG returns text, not an array.
SELECT product_name,
       STRING_AGG(tag, ', ' ORDER BY tag) AS sorted_tags
FROM products,
     UNNEST(tags) AS tag
GROUP BY product_name;

-- Q7. Display products whose tags array contains both 'electronics' and 'computers'.
-- User attempt (correct):
SELECT product_name
FROM products
WHERE 'electronics' = ANY(tags) AND 'computers' = ANY(tags);

-- Q8. Display product_name and tags for products with at least three tags.
-- Original user attempt had extra commas after tags and products:
-- SELECT product_name, tags,
-- FROM products,
-- WHERE CARDINALITY(tags) >=3;
-- Logic correct; corrected syntax:
SELECT product_name, tags
FROM products
WHERE CARDINALITY(tags) >= 3;

-- Q9. Display products whose tags array has exactly the same tags as Phone,
-- regardless of order.
-- User's subquery attempt (valid for exact equality, but equality is order-sensitive):
SELECT product_name, tags
FROM products
WHERE tags IN (
    SELECT tags
    FROM products
    WHERE product_name = 'Phone'
);
-- Order-independent solution using array containment:
SELECT p.product_name, p.tags
FROM products p
WHERE p.tags @> (
    SELECT tags FROM products WHERE product_name = 'Phone'
)
AND p.tags <@ (
    SELECT tags FROM products WHERE product_name = 'Phone'
);

-- Q10. Count products whose tags contain 'electronics' across the table.
-- Original attempt had correct filter but mismatched aggregation/output:
-- SELECT product_name, COUNT(tags)
-- FROM products
-- WHERE 'electronics' = ANY(tags);
-- Correct query for total matching products:
SELECT COUNT(*) AS electronics_count
FROM products
WHERE 'electronics' = ANY(tags);
-- Result: 3. This counts matching products, not repeated occurrences within an array.
