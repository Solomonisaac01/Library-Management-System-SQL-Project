# 📚 Library Management System — SQL Project

## 📌 Project Overview

**Library Management System** is an end-to-end SQL database project focused on managing library operations and extracting useful insights using SQL.

The project covers **database creation, data exploration, CRUD operations, CTAS (Create Table As Select), joins, aggregation, date-based analysis, advanced SQL queries, stored procedures, overdue-book analysis, and library performance reporting**.

The goal is to demonstrate practical SQL skills that are commonly required for **Data Analyst and Business Analyst roles**.

---

## 🎯 Project Objectives

- Create and manage a library management database.
- Explore and work with multiple related library tables.
- Perform CRUD operations using SQL.
- Retrieve and analyze book, member, employee, branch, issue, and return information.
- Use joins to combine data from multiple tables.
- Create summary tables using CTAS.
- Analyze book categories and rental income.
- Identify members with multiple book issues.
- Identify books that have not yet been returned.
- Identify overdue books and calculate fines.
- Generate branch performance reports.
- Analyze employee book-issue activity.
- Create and use a stored procedure to manage book status.
- Demonstrate practical SQL problem-solving skills.

---

## 🛠️ Technologies & SQL Concepts Used

- **MySQL**
- **CRUD Operations**
- **SELECT, INSERT, UPDATE**
- **JOINs**
- **LEFT JOIN**
- **GROUP BY & HAVING**
- **Aggregate Functions**
- **COUNT()**
- **SUM()**
- **COALESCE()**
- **DISTINCT**
- **Subqueries**
- **CTAS (CREATE TABLE AS SELECT)**
- **CASE / IF / ELSEIF**
- **DATE_SUB()**
- **DATEDIFF()**
- **CURRENT_DATE**
- **Stored Procedures**
- **DELIMITER**
- **ORDER BY & LIMIT**

---

## 🗄️ Database Structure

### Database

```text
library_management_system_project
```

### Main Tables

```text
books
branch
employees
issued_status
members
return_status
```

The project uses six main tables representing books, library branches, employees, members, issued books, and returned books. The SQL project also creates analysis tables such as `book_issue_summary`, `active_members`, and `overdue_books_fines`.

---

## 📊 Database Tables

### 📚 books

Stores information about books available in the library.

| Column | Description |
|---|---|
| `isbn` | Unique ISBN of the book |
| `book_title` | Title of the book |
| `category` | Book category/genre |
| `rental_price` | Rental price of the book |
| `status` | Current book status |
| `author` | Book author |
| `publisher` | Book publisher |

### 🏢 branch

Stores library branch information.

| Column | Description |
|---|---|
| `branch_id` | Unique branch identifier |
| `manager_id` | Employee managing the branch |
| `branch_address` | Branch address |
| `contact_no` | Branch contact number |

### 👨‍💼 employees

Stores information about library employees.

| Column | Description |
|---|---|
| `emp_id` | Unique employee identifier |
| `emp_name` | Employee name |
| `position` | Employee position |
| `salary` | Employee salary |
| `branch_id` | Branch associated with the employee |

### 📖 issued_status

Stores information about books issued to members.

| Column | Description |
|---|---|
| `issued_id` | Unique issue identifier |
| `issued_member_id` | Member who received the book |
| `issued_book_isbn` | ISBN of the issued book |
| `issued_book_name` | Name of the issued book |
| `issued_date` | Date the book was issued |
| `issued_emp_id` | Employee who processed the issue |

### 👤 members

Stores library member information.

| Column | Description |
|---|---|
| `member_id` | Unique member identifier |
| `member_name` | Member name |
| `member_address` | Member address |
| `reg_date` | Member registration date |

### 🔄 return_status

Stores information about returned books.

| Column | Description |
|---|---|
| `return_id` | Unique return identifier |
| `issued_id` | Related book issue identifier |

---

## 🔗 Table Relationships

The project connects the tables through identifiers such as:

```text
members
   │
   │ member_id
   ▼
issued_status
   │
   ├──────────────► books
   │                │
   │                └── isbn
   │
   └──────────────► employees
                    │
                    └── branch_id
                         │
                         ▼
                       branch

issued_status
      │
      │ issued_id
      ▼
return_status
```

These relationships allow the project to analyze which members issued books, which employees processed issues, which branches handled transactions, and which books were returned.

---

# 🗺️ Entity Relationship Diagram (ERD)

The following Entity Relationship Diagram represents the database structure and relationships of the Library Management System.

![Library Management System ERD](screenshots/library_erd.png)

### Main Table Relationships

- **Branch → Employees** using `branch_id`
- **Branch → Employees** using `manager_id`
- **Employees → Issued Status** using `emp_id`
- **Members → Issued Status** using `member_id`
- **Books → Issued Status** using `isbn`
- **Issued Status → Return Status** using `issued_id`

## 📂 Project Workflow

The project follows this workflow:

```text
Library Dataset
      ↓
Database Creation
      ↓
Data Import
      ↓
Data Exploration
      ↓
CRUD Operations
      ↓
Joins & Aggregations
      ↓
CTAS & Advanced SQL
      ↓
Stored Procedure
      ↓
Library Analysis & Reports
```

---

# 🔍 1. Database Setup

The project begins by creating the MySQL database:

```sql
CREATE DATABASE library_management_system_project;
USE library_management_system_project;
```

The data was explored after importing the tables using the table data import workflow.

The main tables were checked using:

```sql
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;
```

---

# ✏️ 2. CRUD Operations

## Task 1 — Create a New Book Record

A new book record is inserted into the `books` table.

```sql
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
```

The inserted record is then verified using the ISBN.

---

## Task 2 — Update an Existing Member's Address

Update the address of member `C101`.

```sql
UPDATE members
SET member_address = '999 New Main'
WHERE member_id = 'C101';
```

The updated member record is then retrieved for verification.

---

## Task 3 — Delete a Record from Issued Status

The project identifies the record with `issued_id = 'IS104'` in the `issued_status` table.

```sql
SELECT *
FROM issued_status
WHERE issued_id = 'IS104';
```

> The current SQL file contains the verification query for this task; it does not contain the actual `DELETE` statement.

---

## Task 4 — Retrieve All Books Issued by a Specific Employee

Find all books issued by employee `E101`.

```sql
SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';
```

---

## Task 5 — Members Who Have Issued More Than One Book

Use `GROUP BY` and `HAVING` to identify members who have issued more than one book.

```sql
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
```

---

# 🧮 3. CTAS — Create Table As Select

## Task 6 — Create Book Issue Summary

A summary table is created to calculate the number of times each book has been issued.

```sql
CREATE TABLE book_issue_summary AS
SELECT
    issued_book_isbn,
    issued_book_name,
    COUNT(*) AS total_book_issued_cnt
FROM issued_status
GROUP BY
    issued_book_isbn,
    issued_book_name;
```

The resulting table contains each book and its total issue count.

---

# 📊 4. Data Analysis & Findings

## Task 7 — Retrieve Books from a Specific Category

Retrieve all books belonging to the **Fantasy** category.

```sql
SELECT *
FROM books
WHERE category = 'Fantasy';
```

---

## Task 8 — Total Rental Income by Category

Calculate total rental income for each book category.

```sql
SELECT
    b.category,
    SUM(b.rental_price) AS total_rental_income
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
GROUP BY b.category
ORDER BY total_rental_income DESC;
```

---

## Task 9 — Members Registered in the Last 180 Days

Identify members who registered within the last 180 days relative to the latest registration date in the dataset.

```sql
SELECT *
FROM members
WHERE reg_date >= DATE_SUB(
    (SELECT MAX(reg_date) FROM members),
    INTERVAL 180 DAY
);
```

---

## Task 10 — Employees, Branch Managers & Branch Details

Retrieve employee information along with their branch details and branch manager.

```sql
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
```

This query demonstrates the use of multiple joins and a self-join on the `employees` table.

---

## Task 11 — Books Above a Rental Price Threshold

Retrieve books with a rental price greater than 7.

```sql
SELECT *
FROM books
WHERE rental_price > 7;
```

---

## Task 12 — Books Not Yet Returned

Identify books that have been issued but do not have a corresponding return record.

```sql
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
```

---

# 🚀 5. Advanced SQL Operations

## Task 13 — Identify Members with Overdue Books

Assuming a **30-day return period**, identify members whose books are overdue and calculate the number of overdue days.

```sql
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
```

---

## Task 14 — Update Book Status on Return

When a book has a matching return record, its status is updated to `yes`.

```sql
UPDATE books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
JOIN return_status r
    ON i.issued_id = r.issued_id
SET b.status = 'yes';
```

---

## Task 15 — Branch Performance Report

Generate a branch-level report showing:

- Number of books issued
- Number of books returned
- Total rental revenue

```sql
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
```

---

## Task 16 — Create an Active Members Table

Create an `active_members` table containing members who have issued at least one book within the last 6 months relative to the latest issue date in the dataset.

```sql
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
```

---

## Task 17 — Top 3 Employees by Books Processed

Identify the top 3 employees who processed the highest number of book issues.

```sql
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
```

---

## Task 18 — Members Issuing High-Risk Books

Identify members who have issued books more than twice where the book status is `damaged`.

```sql
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
```

---

# ⚙️ 6. Stored Procedure

## Task 19 — Manage Book Status

A stored procedure named `manage_book_status` is created to update book availability based on whether the book is issued or returned.

```sql
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
```

### Execute the procedure

For an issued book:

```sql
CALL manage_book_status(
    '978-0-330-25864-8',
    'issued'
);
```

For a returned book:

```sql
CALL manage_book_status(
    '978-0-330-25864-8',
    'returned'
);
```

---

# 💰 7. Overdue Books & Fine Calculation

## Task 20 — Create Overdue Books and Fines Table

A CTAS query creates the `overdue_books_fines` table.

The analysis includes:

- Member ID
- Number of overdue books
- Total fines
- Total books issued

The fine is calculated at **$0.50 per overdue day**.

```sql
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
```

---

# 📈 Key Analysis Areas

The project demonstrates SQL analysis across several library-management areas.

### 📚 Book Analysis

- Books by category
- Books above a rental-price threshold
- Book issue frequency
- Book availability status
- Damaged-book analysis

### 👥 Member Analysis

- Members with multiple book issues
- Recently registered members
- Active members
- Members with overdue books
- Member fine calculations

### 👨‍💼 Employee Analysis

- Books processed by employees
- Top employees by number of issues
- Employees and their branch details
- Branch manager information

### 🏢 Branch Analysis

- Books issued by branch
- Books returned by branch
- Rental revenue by branch
- Branch performance reporting

### ⏰ Overdue & Return Analysis

- Books not yet returned
- Overdue books
- Days overdue
- Fine calculation
- Book status updates after returns

---

# 💡 Key SQL Skills Demonstrated

This project demonstrates practical knowledge of:

```text
✓ Database Creation
✓ Data Import & Exploration
✓ SELECT
✓ INSERT
✓ UPDATE
✓ CRUD Operations
✓ WHERE
✓ DISTINCT
✓ JOIN
✓ LEFT JOIN
✓ GROUP BY
✓ HAVING
✓ ORDER BY
✓ LIMIT
✓ COUNT()
✓ SUM()
✓ COALESCE()
✓ Subqueries
✓ CTAS
✓ DATE_SUB()
✓ DATEDIFF()
✓ CURRENT_DATE
✓ CASE / IF / ELSEIF
✓ Stored Procedures
✓ DELIMITER
✓ Self Join
✓ Business Analysis
```

---

# 📁 Recommended GitHub Repository Structure

```text
Library-Management-System-SQL/
│
├── README.md
│
├── library_management_system.sql
│
├── dataset/
│   ├── books.csv
│   ├── branch.csv
│   ├── employees.csv
│   ├── issued_status.csv
│   ├── members.csv
│   └── return_status.csv
│
└── screenshots/
    ├── library_erd.png
    └── sql_results.png
```

If the CSV files are not included in the repository, remove the `dataset/` folder from the structure.

---

# ▶️ How to Run the Project

### Step 1 — Clone the Repository

```bash
git clone <your-github-repository-url>
```

### Step 2 — Open MySQL Workbench

Open the project SQL file in **MySQL Workbench** or another MySQL-compatible SQL environment.

### Step 3 — Create the Database

Run:

```sql
CREATE DATABASE library_management_system_project;
USE library_management_system_project;
```

### Step 4 — Import the Dataset

Import the six CSV files into their respective tables:

```text
books
branch
employees
issued_status
members
return_status
```

### Step 5 — Run the SQL Project

Open:

```text
library_management_system.sql
```

Execute the queries in order.

### Step 6 — Explore the Results

Review the output of the analysis queries and modify or extend the queries to perform additional library-management analysis.

---

# 🎓 Project Purpose

This project was created as part of my **Data Analytics portfolio** to demonstrate practical SQL skills and the ability to work with a relational library-management dataset.

It demonstrates how SQL can be used for **data exploration, CRUD operations, joins, aggregation, business analysis, CTAS, advanced date calculations, stored procedures, overdue analysis, and reporting**.

---

# 👨‍💻 Author

**Solomon Isaac**

Aspiring Data Analyst | SQL | Excel | Power BI | Python

---

## ⭐ If you found this project useful

Feel free to explore the SQL queries, modify them, and extend the project with additional library-management questions and analysis.
