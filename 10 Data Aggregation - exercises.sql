USE gringotts;
# 01. Records’ Count
SELECT COUNT(*) AS count
FROM wizzard_deposits;

# 02. Longest Magic Wand
SELECT MAX(magic_wand_size) as 'longest_magic_wand'
FROM wizzard_deposits;

# 03. Longest Magic Wand per Deposit Groups
SELECT 
    deposit_group, MAX(magic_wand_size) AS 'longest_magic_wand'
FROM
    wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand , deposit_group;

# 04. Smallest Deposit Group per Magic Wand Size
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY AVG(magic_wand_size)
LIMIT 1;

# 05. Deposits Sum
SELECT deposit_group, SUM(deposit_amount) as 'total_sum'
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;

# 06. Deposits Sum for Ollivander Family
SELECT deposit_group, SUM(deposit_amount) as 'total_sum'
FROM wizzard_deposits
WHERE substring(magic_wand_creator, 1, 10) = "Ollivander" 
GROUP BY deposit_group
ORDER BY deposit_group;

# 07. Deposits Filter
SELECT deposit_group, SUM(deposit_amount) as 'total_sum'
FROM wizzard_deposits
WHERE substring(magic_wand_creator, 1, 10) = "Ollivander" 
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

# 08. Deposit Charge
SELECT deposit_group, magic_wand_creator, MIN(deposit_charge) AS 'min_deposit_charge'
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

# 09. Age Groups
SELECT 
    CASE
        WHEN age <= 10 THEN '[0-10]'
        WHEN age <= 20 THEN '[11-20]'
        WHEN age <= 30 THEN '[21-30]'
        WHEN age <= 40 THEN '[31-40]'
        WHEN age <= 50 THEN '[41-50]'
        WHEN age <= 60 THEN '[51-60]'
        ELSE '[61+]'
    END AS 'age_group',
    COUNT(*) AS 'wizard_count' 
FROM wizzard_deposits
GROUP BY age_group
ORDER BY age_group;

# 10. First Letter
SELECT DISTINCT LEFT(first_name, 1) AS 'first_letter'
FROM wizzard_deposits
WHERE SUBSTRING(deposit_group, 1, 5) = "Troll"
GROUP BY first_name
ORDER BY first_letter;

# 11. Average Interest
SELECT deposit_group, is_deposit_expired, AVG(deposit_interest) AS 'average_interest'
FROM wizzard_deposits
WHERE deposit_start_date > '1985/01/01'
GROUP BY is_deposit_expired, deposit_group
ORDER BY deposit_group DESC, is_deposit_expired ASC;

# 12. Employees Minimum Salaries
SELECT (
(SELECT deposit_amount
FROM wizzard_deposits
LIMIT 1) - 
(SELECT deposit_amount
FROM wizzard_deposits
ORDER BY id DESC
LIMIT 1)
) AS sum_difference;

SELECT
	SUM(`hw`.`deposit_amount` - `gw`.`deposit_amount`) as 'sum_difference'
FROM
    `wizzard_deposits` AS `hw`, `wizzard_deposits` AS `gw`
WHERE
     `gw`.`id` - `hw`.`id` = 1;
     
# 13. Employees Minimum Salaries
USE soft_uni;

SELECT 
    e.department_id, 
    MIN(e.salary) AS 'minumum_salary'
FROM
    employees AS e
WHERE
    e.department_id IN (2, 5, 7)
        AND hire_date > '2000/01/01'
GROUP BY department_id
ORDER BY e.department_id;

# 14. Employees Average Salaries
CREATE TABLE `new_table` 
AS SELECT * FROM employees
WHERE salary > 30000;

DELETE FROM new_table
WHERE manager_id = 42;

UPDATE new_table
SET salary = salary + 5000
WHERE department_id = 1;

SELECT department_id, AVG(salary) AS 'avg_salary'
FROM new_table
GROUP BY department_id
ORDER BY department_id;

# 15. Employees Maximum Salaries
SELECT department_id, MAX(salary) AS 'max_salary'
FROM employees
GROUP BY department_id
HAVING `max_salary` < 30000 OR `max_salary` > 70000
ORDER BY department_id;

# 16. Employees Count Salaries
SELECT COUNT(*)
FROM employees
WHERE manager_id IS NULL;

# 17. 3rd Highest Salary
SELECT 
    department_id,
    (SELECT DISTINCT
            salary
        FROM
            employees AS e2
        WHERE
            e1.department_id = e2.department_id
        ORDER BY salary DESC
        LIMIT 2 , 1) AS 'third_highest_salary'
FROM
    employees AS e1
GROUP BY department_id
HAVING third_highest_salary IS NOT NULL
ORDER BY department_id;

# 18. Salary Challenge
SELECT 
    e1.first_name, e1.last_name, e1.department_id
FROM
    employees AS e1
        JOIN
    (
    SELECT 
        e2.department_id, AVG(salary) AS salary
    FROM
        employees AS e2
    GROUP BY e2.department_id
    ) AS dep_average ON e1.department_id = dep_average.department_id
WHERE
    e1.salary > dep_average.salary
ORDER BY e1.department_id , e1.employee_id
LIMIT 10;

# 19. Departments Total Salaries
SELECT department_id, SUM(salary) AS 'total_salary'
FROM employees
GROUP BY department_id
ORDER BY department_id;

