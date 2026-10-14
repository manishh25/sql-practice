-- Level 2 | Question 7: Approved Insurance Claims
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display policy type and total approved claims; include totals above 30000; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE insurance_claims (claim_id INT PRIMARY KEY, policy_type VARCHAR(100), claim_status VARCHAR(30), claim_amount NUMERIC(12,2));
INSERT INTO insurance_claims VALUES
(1,'Health','Approved',25000),(2,'Vehicle','Pending',18000),(3,'Health','Approved',32000),(4,'Life','Rejected',50000),(5,'Vehicle','Approved',22000),(6,'Health','Pending',15000),(7,'Vehicle','Approved',12000);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT policy_type, SUM(claim_amount) AS total_claim
FROM insurance_claims
WHERE claim_status = 'Approved'
GROUP BY policy_type
HAVING SUM(claim_amount) > 30000
ORDER BY total_claim DESC;

-- FINAL ACCEPTED QUERY
SELECT policy_type, SUM(claim_amount) AS total_claim
FROM insurance_claims
WHERE claim_status = 'Approved'
GROUP BY policy_type
HAVING SUM(claim_amount) > 30000
ORDER BY total_claim DESC;
