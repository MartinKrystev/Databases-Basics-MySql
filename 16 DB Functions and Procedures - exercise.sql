# 01. Employees with Salary Above 35000
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	WHERE e.salary > 35000
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

# 02. Employees with Salary Above Number
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(given_salary DECIMAL(19,4))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	WHERE e.salary >= given_salary
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

# 03. Town Names Starting With
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(given_town VARCHAR(45))
BEGIN
	SELECT `name`
	FROM towns
	WHERE `name` LIKE CONCAT(given_town, '%')
	ORDER BY `name`;
END $$
DELIMITER ;

# 04. Employees from Town
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(given_town VARCHAR(45))
BEGIN
	SELECT e.first_name, e.last_name
	FROM towns AS t
	JOIN addresses AS a ON t.town_id = a.town_id
    JOIN employees AS e ON a.address_id = e.address_id
    WHERE t.name = given_town
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

# 05. Salary Level Function
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(given_salary DECIMAL(19,4))
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN
	DECLARE salary_level VARCHAR(45);
    
		IF given_salary < 30000 THEN SET salary_level := 'Low';
		ELSE IF given_salary <= 50000 THEN SET salary_level := 'Average';
		ELSE SET salary_level := 'High';
		END IF;
END IF;
    RETURN salary_level; 
END $$
DELIMITER ;

# 06. Employees by Salary Level
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(45))
BEGIN
	CASE
		WHEN salary_level LIKE 'low'
			THEN SELECT first_name, last_name FROM employees
            WHERE salary < 30000
            ORDER BY first_name DESC, last_name DESC;
        WHEN salary_level LIKE 'average'
			THEN SELECT first_name, last_name FROM employees
            WHERE salary BETWEEN 30000 AND 50000
            ORDER BY first_name DESC, last_name DESC;
		WHEN salary_level LIKE 'high' 
			THEN SELECT first_name, last_name FROM employees
            WHERE salary > 50000
            ORDER BY first_name DESC, last_name DESC;
		ELSE 
			SELECT first_name, last_name FROM employees
            WHERE SALARY = 0;
    END CASE;
END $$
DELIMITER ;

# 07. Define Function
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
DETERMINISTIC 
	BEGIN
		RETURN word REGEXP(CONCAT('^[', letters, ']+$'));
    END $$
DELIMITER ;

# 08. Find Full Name
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
	BEGIN
		SELECT CONCAT_WS(' ', first_name, last_name) AS full_name
	FROM account_holders
	ORDER BY full_name;
	END $$
DELIMITER ;

# 9. People with Balance Higher Than 
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(given_money DECIMAL(19,4))
	BEGIN
		SELECT ah.first_name, ah.last_name
		FROM account_holders AS ah
		JOIN accounts AS a ON ah.id = a.account_holder_id
		GROUP BY ah.first_name, ah.last_name
		HAVING SUM(a.balance) > given_money;
    END $$
DELIMITER ;

# 10. Future Value Function
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19,4),
											interest DOUBLE,
                                            years INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
	BEGIN
		DECLARE fv DECIMAL(19,4);
        SET fv := sum * POW((1 + interest), years);
        RETURN fv;
    END $$
DELIMITER ;

# 11. Calculating Interest
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19,4),
											interest DECIMAL(19,4),
                                            years INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
	BEGIN
		RETURN sum * POW((1 + interest), years);
    END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(given_id INT, given_interest DECIMAL(19,4))
	BEGIN
		SELECT a.id AS account_id, 
        ah.first_name, 
        ah.last_name, 
        a.balance AS current_balance, 
        ufn_calculate_future_value(a.balance, given_interest, 5) AS balance_in_5_years
        FROM account_holders AS ah
        JOIN accounts AS a ON ah.id = a.account_holder_id
        WHERE a.id = given_id;        
    END $$
DELIMITER ;

# 12. Deposit Money
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
	BEGIN
		START TRANSACTION;
	        
        IF (money_amount <= 0) 
			THEN ROLLBACK;
        ELSE 
			UPDATE accounts
			SET balance = balance + money_amount
			WHERE id = account_id;
        COMMIT;
        END IF;
    END $$
DELIMITER ;

# 13. Withdraw Money
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
	BEGIN
		IF((SELECT balance FROM accounts WHERE id = account_id) < money_amount OR money_amount < 0)
			THEN ROLLBACK;
		ELSE 
			UPDATE accounts
            SET balance = balance - money_amount
            WHERE id = account_id;
		COMMIT;
        END IF;
    END $$
DELIMITER ;

# 14. Money Transfer
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
	BEGIN
		START TRANSACTION;
        
        IF(from_account_id = to_account_id 
			OR (SELECT COUNT(id) FROM accounts WHERE id = from_account_id) != 1
			OR (SELECT COUNT(id) FROM accounts WHERE id = to_account_id) != 1
			OR (SELECT balance FROM accounts WHERE id = from_account_id) < amount
			OR amount < 0)
			THEN ROLLBACK;
		ELSE
			UPDATE accounts
            SET balance = balance - amount
            WHERE id = from_account_id;
            
			UPDATE accounts
            SET balance = balance + amount
            WHERE id = to_account_id;
		COMMIT;
        END IF;
    END $$
DELIMITER ;

# 15. Log Accounts Trigger 
CREATE TABLE `logs`
(log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(19,4) NOT NULL,
new_sum DECIMAL(19,4) NOT NULL);

DELIMITER $$
CREATE TRIGGER tr_balance_change
BEFORE UPDATE ON accounts
FOR EACH ROW
	BEGIN
		INSERT INTO `logs` (account_id, old_sum, new_sum)
        VALUES (OLD.id, OLD.balance, NEW.balance);
	END $$
DELIMITER ;

# 16. Emails Trigger
CREATE TABLE `logs`
(log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(19,4) NOT NULL,
new_sum DECIMAL(19,4) NOT NULL);

DELIMITER $$
CREATE TRIGGER tr_balance_change
BEFORE UPDATE ON accounts
FOR EACH ROW
	BEGIN
		INSERT INTO `logs` (account_id, old_sum, new_sum)
        VALUES (OLD.id, OLD.balance, NEW.balance);
	END $$
DELIMITER ;

CREATE TABLE `notification_emails`
(`id` INT PRIMARY KEY AUTO_INCREMENT,
`recipient` INT NOT NULL,
`subject` TEXT NOT NULL,
`body` TEXT NOT NULL);

DELIMITER $$
CREATE TRIGGER tr_new_record
AFTER INSERT ON `logs`
FOR EACH ROW
	BEGIN
		INSERT INTO `notification_emails` (`recipient`, `subject`, `body`)
        VALUES (NEW.account_id,
				CONCAT('Balance change for account: ', NEW.account_id),
                CONCAT('On ', 
                DATE_FORMAT(NOW(), '%b %d %Y at %r'), 
                ' your balance was changed from ', 
                ROUND(NEW.old_sum, 2), 
                ' to ', 
                ROUND(NEW.new_sum, 2), 
                '.'));
	END $$
DELIMITER ;

    






