-- Problem A: Find employees who have BOTH SQL and Python in their skills array.
-- Problem B: Expand each employee's skills array into one row per skill.
-- Topic: PostgreSQL arrays, ANY(), UNNEST()

DROP TABLE IF EXISTS employee_skills;

CREATE TABLE employee_skills (
    employee_id INT,
    name VARCHAR(50),
    skills TEXT[]
);

INSERT INTO employee_skills (employee_id, name, skills) VALUES
(1, 'Rahul', ARRAY['SQL', 'Python', 'Java']),
(2, 'Priya', ARRAY['SQL', 'Excel']),
(3, 'Arjun', ARRAY['Python', 'Java']),
(4, 'Sneha', ARRAY['SQL', 'Python']);

-- A. Employees who have both SQL and Python.
SELECT employee_id, name, skills
FROM employee_skills
WHERE 'SQL' = ANY(skills)
  AND 'Python' = ANY(skills)
ORDER BY employee_id;

-- B. Expand the array so each skill gets its own row.
SELECT e.employee_id, e.name, s.skill
FROM employee_skills AS e
CROSS JOIN UNNEST(e.skills) AS s(skill)
ORDER BY e.employee_id, s.skill;

-- Note: TEXT[] and ANY()/UNNEST() syntax here is PostgreSQL-specific.
