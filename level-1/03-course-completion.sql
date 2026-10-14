-- Level 1 | Question 3: Course Completion
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display unique student names for completed courses with score at least 80; sort alphabetically.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE course_enrollments (enrollment_id INT PRIMARY KEY, student_name VARCHAR(100), course_name VARCHAR(100), score INT, completion_status VARCHAR(30));
INSERT INTO course_enrollments VALUES
(301,'Ananya','Python',88,'Completed'),(302,'Ravi','SQL',72,'In Progress'),(303,'Divya','Python',95,'Completed'),(304,'Karthik','Java',NULL,'In Progress'),(305,'Ananya','SQL',88,'Completed'),(306,'Ravi','Java',65,'Completed');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT DISTINCT student_name
FROM course_enrollments
WHERE completion_status = 'Completed' AND score >= 80
ORDER BY student_name ASC;

-- FINAL ACCEPTED QUERY
SELECT DISTINCT student_name
FROM course_enrollments
WHERE completion_status = 'Completed' AND score >= 80
ORDER BY student_name ASC;
