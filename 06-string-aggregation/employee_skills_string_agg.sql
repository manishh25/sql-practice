-- Problem: Combine each employee's skills into an alphabetically sorted list.
-- Topic: STRING_AGG()
-- Database: PostgreSQL

DROP TABLE IF EXISTS employee_skill;

CREATE TABLE employee_skill (
    employee_name VARCHAR(50),
    skill VARCHAR(50)
);

INSERT INTO employee_skill VALUES
('Rahul', 'SQL'),
('Rahul', 'Python'),
('Rahul', 'Java'),
('Priya', 'SQL'),
('Priya', 'Excel');

SELECT
    employee_name,
    STRING_AGG(skill, ', ' ORDER BY skill ASC) AS skills
FROM employee_skill
GROUP BY employee_name
ORDER BY employee_name;
