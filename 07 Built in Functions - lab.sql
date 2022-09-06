USE book_library;

# 01. Find Book Titles
SELECT title FROM books
WHERE title LIKE 'The%'
ORDER BY id;

# 02. Replace Titles
SELECT REPLACE(title, 'The', '***') FROM books
WHERE title LIKE 'The%'
ORDER BY id;

# 03. Sum Cost of All Books
SELECT ROUND(SUM(cost), 2) FROM books;

# 04. Days Lived
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Full Name',
    TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived'
FROM
    authors;
# 05. Harry Potter Books
SELECT 
    title
FROM
    books
WHERE
    title LIKE '%Harry Potter%'
ORDER BY id;    