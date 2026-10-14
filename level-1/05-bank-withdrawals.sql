-- Level 1 | Question 5: Bank Withdrawals
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display unique account holders with successful withdrawals above 2000; sort alphabetically.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE bank_transactions (transaction_id INT PRIMARY KEY, account_holder VARCHAR(100), transaction_type VARCHAR(30), amount NUMERIC(10,2), transaction_status VARCHAR(30));
INSERT INTO bank_transactions VALUES
(501,'Arjun','Deposit',5000,'Successful'),(502,'Meera','Withdrawal',2500,'Failed'),(503,'Arjun','Withdrawal',1500,'Successful'),(504,'Kavya','Deposit',8000,'Pending'),(505,'Meera','Deposit',3500,'Successful'),(506,'Rahul','Withdrawal',6000,'Successful');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT DISTINCT account_holder
FROM bank_transactions
WHERE transaction_type = 'Withdrawal' AND transaction_status = 'Successful' AND amount > 2000
ORDER BY account_holder ASC;

-- FINAL ACCEPTED QUERY
SELECT DISTINCT account_holder
FROM bank_transactions
WHERE transaction_type = 'Withdrawal' AND transaction_status = 'Successful' AND amount > 2000
ORDER BY account_holder ASC;
