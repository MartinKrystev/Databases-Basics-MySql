# 1. Count Employees by Town
DELIMITER $$$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50)) 
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN (SELECT COUNT(*) 
	FROM employees AS e
	JOIN addresses AS a USING (address_id)
	JOIN towns AS t USING (town_id)
	WHERE t.name = town_name);
END
$$$

# 2. Employees Promotion
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries (department_name VARCHAR(50))
BEGIN
	UPDATE employees AS e
	JOIN departments AS d ON e.department_id = d.department_id
	SET e.salary = e.salary * 1.05
	WHERE d.name = (department_name);
END 
$$

# 3. Employees Promotion By ID
DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(given_id INT) 
BEGIN
	UPDATE employees AS e
	SET salary = salary * 1.05
	WHERE employee_id = given_id;
END
$$

# 4. Triggered
CREATE TABLE deleted_employees
(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL,
middle_name VARCHAR(45) ,
job_title VARCHAR(45) NOT NULL,
department_id INT NOT NULL,
salary DECIMAL(19, 4) NOT NULL
);

DELIMITER $$
CREATE TRIGGER tr_deleted_empl
BEFORE DELETE 
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees (first_name, last_name, middle_name, job_title, department_id, salary)
    VALUES(OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END $$

DELIMITER ;


