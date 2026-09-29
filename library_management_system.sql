-- Create Database

create database library_management_system_project;
use library_management_system_project;

-- Data Exploration using table data import wizard

-- execute all tables
select * from books;

select * from branch;

select * from employees;

select * from issued_status;

select * from members;

select * from return_status;

-- Project TASK

-- CRUD Operations

-- Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books
(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2',
 'To Kill a Mockingbird',
 'Classic',
 6.00,
 'yes',
 'Harper Lee',
 'J.B. Lippincott & Co.');
 SELECT * 
FROM books
WHERE isbn = '978-1-60129-456-2';
 
-- Update an Existing Member's Address
UPDATE members
SET member_address = '999 New Main'
WHERE member_id = 'C101';
SELECT *
FROM members
WHERE member_id = 'C101';

-- Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.
SELECT *
FROM issued_status
WHERE issued_id = 'IS104';

-- Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';

-- List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
    m.member_id,
    m.member_name,
    COUNT(i.issued_id) AS total_books_issued
FROM members m
JOIN issued_status i
    ON m.member_id = i.issued_member_id
GROUP BY
    m.member_id,
    m.member_name
HAVING COUNT(i.issued_id) > 1;


-- CTAS (Create Table As Select)

-- Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_issue_summary AS
SELECT
    issued_book_isbn,
    issued_book_name,
    COUNT(*) AS total_book_issued_cnt
FROM issued_status
GROUP BY
    issued_book_isbn,
    issued_book_name;
SELECT *
FROM book_issue_summary;


-- Data Analysis & Findings

-- Retrieve All Books in a Specific Category:
SELECT *
FROM books
WHERE category = 'Fantasy';

-- Find Total Rental Income by Category:
SELECT
    b.category,
    SUM(b.rental_price) AS total_rental_income
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
GROUP BY b.category
ORDER BY total_rental_income DESC;

-- List Members Who Registered in the Last 180 Days**:
SELECT *
FROM members
WHERE reg_date >= DATE_SUB(
    (SELECT MAX(reg_date) FROM members),
    INTERVAL 180 DAY
);

-- List Employees with Their Branch Manager's Name and their branch details**:
SELECT
    e.emp_id,
    e.emp_name,
    e.position,
    e.salary,
    b.branch_id,
    b.branch_address,
    b.contact_no,
    m.emp_name AS branch_manager
FROM employees e
JOIN branch b
    ON e.branch_id = b.branch_id
JOIN employees m
    ON b.manager_id = m.emp_id;

-- Create a Table of Books with Rental Price Above a Certain Threshold
SELECT *
FROM books
WHERE rental_price > 7;

-- Retrieve the List of Books Not Yet Returned
SELECT
    i.issued_id,
    i.issued_member_id,
    i.issued_book_name,
    i.issued_date,
    i.issued_book_isbn
FROM issued_status i
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE r.issued_id IS NULL;
    
-- Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.
SELECT
    m.member_name,
    i.issued_book_name,
    i.issued_date,
    DATEDIFF(CURRENT_DATE, i.issued_date) - 30 AS days_overdue
FROM issued_status i
JOIN members m
    ON i.issued_member_id = m.member_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE r.issued_id IS NULL
  AND DATEDIFF(CURRENT_DATE, i.issued_date) > 30;

-- Update Book Status on Return
-- Write a query to update the status of books in the books table to "available" when they are returned (based on entries in the return_status table).
UPDATE books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
JOIN return_status r
    ON i.issued_id = r.issued_id
SET b.status = 'yes';

-- Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
SELECT
    b.branch_id,
    b.branch_address,
    COUNT(i.issued_id) AS books_issued,
    COUNT(r.return_id) AS books_returned,
    COALESCE(SUM(bo.rental_price), 0) AS total_revenue
FROM branch b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
LEFT JOIN books bo
    ON i.issued_book_isbn = bo.isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.branch_id,
    b.branch_address
ORDER BY
    total_revenue DESC;

-- CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.
CREATE TABLE active_members AS
SELECT DISTINCT
    m.member_id,
    m.member_name,
    m.member_address,
    m.reg_date
FROM members m
JOIN issued_status i
    ON m.member_id = i.issued_member_id
WHERE i.issued_date >= DATE_SUB(
    (SELECT MAX(issued_date) FROM issued_status),
    INTERVAL 6 MONTH
);

-- Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
SELECT
    e.emp_id,
    e.emp_name,
    b.branch_id,
    b.branch_address,
    COUNT(i.issued_id) AS books_processed
FROM employees e
JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
JOIN branch b
    ON e.branch_id = b.branch_id
GROUP BY
    e.emp_id,
    e.emp_name,
    b.branch_id,
    b.branch_address
ORDER BY
    books_processed DESC
LIMIT 3;

-- Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    
SELECT
    m.member_name,
    i.issued_book_name,
    COUNT(*) AS damaged_issue_count
FROM issued_status i
JOIN members m
    ON i.issued_member_id = m.member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
WHERE b.status = 'damaged'
GROUP BY
    m.member_id,
    m.member_name,
    i.issued_book_name
HAVING COUNT(*) > 2;

-- Stored Procedure
-- Objective: Create a stored procedure to manage the status of books in a library system.
-- Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
-- If a book is issued, the status should change to 'no'.
-- If a book is returned, the status should change to 'yes'.
DELIMITER $$

CREATE PROCEDURE manage_book_status(
    IN p_isbn VARCHAR(20),
    IN p_action VARCHAR(20)
)
BEGIN

    IF LOWER(p_action) = 'issued' THEN

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_isbn;

    ELSEIF LOWER(p_action) = 'returned' THEN

        UPDATE books
        SET status = 'yes'
        WHERE isbn = p_isbn;

    END IF;

END $$

DELIMITER ;

CALL manage_book_status(
    '978-0-330-25864-8',
    'issued'
);

CALL manage_book_status(
    '978-0-330-25864-8',
    'returned'
);


-- Create Table As Select (CTAS)
-- Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
-- The number of overdue books.
-- The total fines, with each day's fine calculated at $0.50.
-- The number of books issued by each member.
-- The resulting table should show:
-- Member ID
-- Number of overdue books
-- Total fines
CREATE TABLE overdue_books_fines AS
SELECT
    i.issued_member_id AS member_id,

    COUNT(i.issued_id) AS overdue_books,

    SUM(
        (
            DATEDIFF(
                (SELECT MAX(issued_date) FROM issued_status),
                i.issued_date
            ) - 30
        ) * 0.50
    ) AS total_fines,

    COUNT(i.issued_id) AS total_books_issued

FROM issued_status i

LEFT JOIN return_status r
    ON i.issued_id = r.issued_id

WHERE r.issued_id IS NULL
  AND DATEDIFF(
        (SELECT MAX(issued_date) FROM issued_status),
        i.issued_date
      ) > 30

GROUP BY
    i.issued_member_id;

-- End of project --