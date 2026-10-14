-- Level 1 | Question 4: Clinical Trial Participants
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display participant_name, age, trial_status for active participants aged at least 40 with no adverse event; sort age descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE trial_participants (participant_id INT PRIMARY KEY, participant_name VARCHAR(100), age INT, trial_status VARCHAR(30), adverse_event VARCHAR(10));
INSERT INTO trial_participants VALUES
(401,'Neha',34,'Active','No'),(402,'Vikram',58,'Completed','Yes'),(403,'Pooja',42,'Active','Yes'),(404,'Sandeep',29,'Withdrawn','No'),(405,'Aisha',63,'Active','No'),(406,'Rohit',51,'Completed','Yes');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT participant_name, age, trial_status
FROM trial_participants
WHERE age >= 40 AND trial_status = 'Active' AND adverse_event = 'No'
ORDER BY age DESC;

-- FINAL ACCEPTED QUERY
SELECT participant_name, age, trial_status
FROM trial_participants
WHERE age >= 40 AND trial_status = 'Active' AND adverse_event = 'No'
ORDER BY age DESC;
