-- Level 2 | Question 5: Clinical Trial Participants by Drug
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display drug and total participants across phases; include totals above 150; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE clinical_trial_results (result_id INT PRIMARY KEY, drug_name VARCHAR(100), trial_phase VARCHAR(30), participant_count INT, success_count INT);
INSERT INTO clinical_trial_results VALUES
(1,'Drug A','Phase 1',40,32),(2,'Drug B','Phase 2',100,75),(3,'Drug A','Phase 2',80,68),(4,'Drug C','Phase 3',200,150),(5,'Drug B','Phase 3',160,136),(6,'Drug C','Phase 2',120,84);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT drug_name, SUM(participant_count) AS total_participants
FROM clinical_trial_results
GROUP BY drug_name
HAVING SUM(participant_count) > 150
ORDER BY total_participants DESC;

-- FINAL ACCEPTED QUERY
SELECT drug_name, SUM(participant_count) AS total_participants
FROM clinical_trial_results
GROUP BY drug_name
HAVING SUM(participant_count) > 150
ORDER BY total_participants DESC;
