USE restaurant;

# 1. Departments Info
SELECT department_id, COUNT(*) AS'Number of employees'
FROM employees AS e
GROUP BY e.department_id
ORDER BY department_id, `Number of employees`;

# 2. Average Salary
SELECT department_id, ROUND(AVG(e.salary), 2) AS 'Average Salary'
FROM employees AS e
GROUP BY e.department_id
ORDER BY department_id;

# 3. Minimum Salary
SELECT department_id, ROUND(MIN(e.salary), 2) AS 'Min Salary'
FROM employees AS e
GROUP BY e.department_id
HAVING `Min Salary` > 800
ORDER BY department_id;

# 4. Appetizers Count
SELECT COUNT(*)
FROM products AS p
WHERE category_id = 2 AND price > 8
GROUP BY p.category_id;

# 5. Menu Prices
SELECT 
    p.category_id,
    ROUND(AVG(p.price), 2) AS 'Average Price',
    ROUND(MIN(p.price), 2) AS 'Cheapest Product',
    ROUND(MAX(p.price), 2) AS 'Most Expensive Product'
FROM
    products AS p
GROUP BY category_id;
