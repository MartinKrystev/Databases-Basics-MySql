CREATE DATABASE `minions`;

-- 01. Create Tables
CREATE TABLE `minions` (
`id` INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(30) NOT NULL, 
`age` INT);

CREATE TABLE `towns` (
`town_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

-- 02. Alter Minions Table
ALTER TABLE `towns`
CHANGE COLUMN `town_id` `id` INT NOT NULL AUTO_INCREMENT;
-- without submition to Judge

ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY `minions`(`town_id`)
REFERENCES `towns` (`id`);

-- 03. Insert Records in Both Tables
INSERT INTO `towns` (`id`, `name`)
VALUES 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO `minions` (`id`, `name`, `age`, `town_id`)
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

-- 04. Truncate Table Minions
TRUNCATE TABLE `minions`;

-- 05. Drop All Tables
DROP TABLE `minions`;
DROP TABLE `towns`;

-- 06. Create Table People
CREATE TABLE `people` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (200) NOT NULL,
`picture` BLOB,
`height` DOUBLE,
`weight` DOUBLE,
`gender` CHAR (1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT 
);

INSERT INTO `people` (`name`,  `gender`, `birthdate`)
VALUES
('Ivan Ivanov', 'M', DATE(NOW())),
('Kirk Hammet', 'M', DATE(NOW())),
('Maria Petrova', 'F', DATE(NOW())),
('Vasilis Karras', 'M', DATE(NOW())),
('Lili Ivanova', 'F', DATE(NOW()));

-- 07. Create Table Users
CREATE TABLE `users` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`username` VARCHAR (30) NOT NULL,
`password` VARCHAR (26) NOT NULL,
`profile_picture` BLOB,
`last_login_time` DATETIME,
`is_deleted` BOOLEAN
);

INSERT INTO `users` (`username`, `password`)
VALUES
('Tempest', 'protoss'),
('Zealot', 'protoss'),
('Probe', 'protoss'),
('DarkTemplar', 'protoss'),
('HighTemplar', 'protoss');

-- 08. Change Primary Key
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`, `username`);

-- 9. Set Default Value of a Field
ALTER TABLE `users`
CHANGE `last_login_time` `last_login_time` DATETIME DEFAULT NOW();

-- 10. Set Unique Field
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`),
CHANGE COLUMN `username` `username` VARCHAR (30) UNIQUE;

-- 11. Movies Database
CREATE DATABASE `Movies`;
USE `Movies`;

CREATE TABLE `directors` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`director_name` VARCHAR (30) NOT NULL,
`notes` TEXT
);

INSERT INTO `directors` (`director_name`)
VALUES
('James Cameron'),
('Steven Spielberg'),
('Quentin Tarantino'),
('Martin Scorsese'),
('Orson Welles');

CREATE TABLE `genres` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`genre_name` VARCHAR (30) NOT NULL,
`notes` TEXT
);

INSERT INTO `genres` (`genre_name`)
VALUES
('fantasy'),
('thriller'),
('drama'),
('action'),
('horror');

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`category_name` VARCHAR (30) NOT NULL,
`notes` TEXT
);

INSERT INTO `categories` (`category_name`)
VALUES
('the best fantasy'),
('the best thriller'),
('the best drama'),
('the best action'),
('the best horror');

CREATE TABLE `movies` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`title` VARCHAR (100) NOT NULL,
`director_id` INT NOT NULL,
`copyright_year` DATE,
`length` TIME,
`genre_id` INT NOT NULL,
`category_id` INT NOT NULL,
`rating` DOUBLE,
`notes` TEXT
);

INSERT INTO `movies` (`title`, `director_id`, `genre_id`, `category_id`)
VALUES
('Avatar', 1, 1, 1),
('Kill Bill', 3, 2, 2),
('Star Wars', 2, 4, 3),
('Don Quixote', 5, 3, 4),
('The Irishman', 4, 5, 5);

-- 12. Car Rental Database
CREATE DATABASE `car_rental`;
USE `car_rental`;

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`category` VARCHAR (20),
`daily_rate` DOUBLE,
`weekly_rate` DOUBLE,
`monthly_rate` DOUBLE,
`weekend_rate` DOUBLE
);

INSERT INTO `categories` (`category`)
VALUES
('SUV'),
('Sports Car'),
('Truck');

CREATE TABLE `cars` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`plate_number` VARCHAR (20),
`make` VARCHAR (20),
`model` VARCHAR (20),
`car_year` INT,
`category_id` INT,
`doors` INT,
`picture` BLOB,
`car_condition` VARCHAR (20),
`available` BOOLEAN
);

INSERT INTO `cars` (`model`)
VALUES
('Ford'),
('Audi'),
('BMW');

CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`first_name` VARCHAR (20),
`last_name` VARCHAR (20),
`title` VARCHAR (20),
`notes` TEXT
);

INSERT INTO `employees` (`first_name`)
VALUES
('Pesho'),
('Gosho'),
('Tosho');

CREATE TABLE `customers` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`driver_licence_number` VARCHAR (30) NOT NULL,
`full_name` VARCHAR (30) NOT NULL,
`address` VARCHAR (50) NOT NULL,
`city` VARCHAR (20) NOT NULL,
`zip_code` INT,
`notes` TEXT
);

INSERT INTO `customers` (`driver_licence_number`, `full_name`, `address`, `city`)
VALUES
('DLN1', 'John Doe', 'unknown', 'N/A'),
('DLN2', 'Jane Doe', ' John Doe neighbor', 'N/A'),
('DLN3', 'Hiro Nakamura', 'Jumping thru time and space', 'Tokyo');

CREATE TABLE `rental_orders` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`employee_id` INT,
`customer_id` INT,
`car_id` INT,
`car_condition` VARCHAR (20),
`tank_level` INT,
`kilometrage_start` INT,
`kilometrage_end` INT,
`total_kilometrage` INT,
`start_date` DATE,
`end_date` DATE,
`total_days` INT,
`rate_applied` DOUBLE,
`tax_rate` DOUBLE,
`order_status` VARCHAR (20),
`notes` TEXT
);

INSERT INTO `rental_orders` (`tank_level`)
VALUES
(25),
(50),
(100);

-- 13. Basic Insert
CREATE DATABASE `soft_uni`;
USE soft_uni;

CREATE TABLE `towns` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30)
);

CREATE TABLE `addresses` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`address_text` TEXT,
`town_id` INT
);

CREATE TABLE `departments` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30)
);

CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`first_name` VARCHAR (20) NOT NULL,
`middle_name` VARCHAR (20),
`last_name` VARCHAR (20) NOT NULL,
`job_title` VARCHAR (20),
`department_id` INT NOT NULL,
`hire_date` DATE,
`salary` DECIMAL (10, 2),
`address_id` INT
);

INSERT INTO `towns` (`name`)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments` (`name`)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00 ),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00 ),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25 ),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00 ),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88 );

ALTER TABLE `employees`
ADD CONSTRAINT fk_employees_departments
FOREIGN KEY `employees` (`department_id`)
REFERENCES `departments` (`id`);

-- 14. Basic Select All Fields
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

-- 15. Basic Select All Fields and Order Them
SELECT * FROM `towns`
ORDER BY `name`;
SELECT * FROM `departments`
ORDER BY `name`;
SELECT * FROM `employees`
ORDER BY `salary` DESC;

-- 16. Basic Select Some Fields
SELECT `name` FROM `towns`
ORDER BY `name`;
SELECT `name` FROM `departments`
ORDER BY `name`;
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

-- 17. Increase Employees Salary
UPDATE `employees`
SET `salary` = `salary` * 1.1;

SELECT `salary` FROM `employees`;

-- 18. Delete All Records
TRUNCATE TABLE `occupancies`;


