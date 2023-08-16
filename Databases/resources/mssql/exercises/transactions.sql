/* Read Uncommitted x Dirty Read */
-- session 1
BEGIN TRANSACTION;

UPDATE students
SET lastname = 'Dirtyread'
WHERE studentid = 1;
-- exclusive lock on studentid 2;

-- session 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Exclusive lock on studentid 1 for the duration of the update

SELECT *
FROM students;
-- This transaction reads the uncommited update of session 1: Dirty Read

-- session 1
ROLLBACK TRANSACTION;

-- session 2
COMMIT TRANSACTION;


/* Read  Committed x Non-Repeatable Read*/
-- session 1
BEGIN TRANSACTION;

UPDATE customers
SET lastname = 'Luck'
WHERE cust_id = 1;
-- Exclusive lock on studentid 2


-- session 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Exclusive lock on studentid 2 for the duration of the update

SELECT *
FROM customers;
-- Waiting
-- Dirty read is impossible


-- session 1
COMMIT TRANSACTION;

-- session 2
COMMIT TRANSACTION;


/* Repeatable Read x Phantom Rows */
-- session 2

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRANSACTION;
SELECT *
FROM students
WHERE studentid = 1;
-- Shared lock on studentid 1 for the duration of the transaction

-- session 1
UPDATE students
SET lastname = 'Dekorte'
WHERE studentid = 1;
-- Waiting for Shared lock to clear (Exclusive lock required)

-- session 2
SELECT *
FROM students
WHERE studentid = 1;

COMMIT TRANSACTION;
-- Same data as in first select
-- A non-repeatable read is impossible

/* Serializable */
-- session 2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRANSACTION;

SELECT *
FROM students
WHERE firstname = 'Veerle'
--S-lock on students Veerle for the duration OF the TRANSACTION
--other transactions will not be able to  INSERT or UPDATE rows that meet the CONDITION IN the WHERE clause

-- session 1
UPDATE students
SET firstname = 'Veerle'
WHERE studentid = 5;
--waiting
--a phantom row is impossible
-- but at the expense of concurrency

-- session  2
COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--Return to default


-- 1
/* Write a transaction that adds a new book with its author(s) and publisher to the
database. If something goes wrong in this transaction (for example, a constraint is not
met), then the entire transaction must be undone.
Check that, after a successful transaction, the book is in the database.
Check that, after an unsuccessful transaction, no data is added to the database. */

-- session 1
--Sample data
--Publisher:
INSERT INTO publishers(publisher, city)
VALUES ('Packt Publishing', 'Birmingham');
--Book published by this publisher:
INSERT INTO books(title, category, pno, price, pubdate)
VALUES ('SQL Server 2016 Developer''s Guide', 'Informatics', /*XXX*/, 55, '2017-03-20');

-- three authors OF this book:
INSERT INTO authors(lastname, firstname)
VALUES ('Sarka', 'Dejan')
INSERT INTO authors(lastname, firstname)
VALUES ('Radivojevic', 'Milos')
INSERT INTO authors(lastname, firstname)
VALUES ('Durkin', 'William');

-- session 2
BEGIN TRY
    BEGIN TRANSACTION
        INSERT INTO publishers(publisher, city)
        VALUES ('Packt Publishing', 'Birmingham')
        DECLARE @pno INT = @@IDENTITY
        INSERT INTO books(title, category, pno, price, pubdate)
        VALUES ('SQL Server 2016 Developer''s Guide', 'Informatics', @pno, 55, '2017-03-20')
        DECLARE @bookno INT = @@IDENTITY
        INSERT INTO authors(lastname, firstname)
        VALUES ('Sarka', 'Dejan')
        DECLARE @au1 INT = @@IDENTITY
        INSERT INTO authors(lastname, firstname)
        VALUES ('Radivojevic', 'Milos')
        DECLARE @au2 INT = @@IDENTITY
        INSERT INTO authors(lastname, firstname)
        VALUES ('Durkin', 'William')
        DECLARE @au3 INT = @@IDENTITY -- + 1 --for an unsuccessful transaction
        INSERT INTO booksauthors(bno, ano)
        VALUES (@bookno, @au1),
               (@bookno, @au2),
               (@bookno, @au3)
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    PRINT 'Rollback complete transaction'
    ROLLBACK TRANSACTION
END CATCH

-- session 1
SELECT *
FROM books b
         JOIN publishers p ON b.pno = p.pno
         JOIN booksauthors ba ON b.bno = ba.bno
         JOIN authors a ON a.ano = ba.ano;

-- 2
/* Work in the default isolation level. If a transaction enters a new book, can another
transaction simultaneously view the books? Illustrate your answer (yes/no) with a
concrete example in the books database */
-- Answer: No
--session 1
BEGIN TRANSACTION
INSERT INTO books(title, category)
VALUES ('SQL Server 2016 Beginners Guide', 'Informatics');

-- session 2
SELECT *
FROM books;
-- wait state

-- session 1
COMMIT TRANSACTION;


-- 3
/*What is a deadlock? Give a concrete example of a deadlock situation in the books
database. What does SQL Server do in case of a deadlock?*/
-- session 1
BEGIN TRANSACTION
UPDATE authors
SET city = 'San Francisco'
WHERE ano = 1;

-- session 2
BEGIN TRANSACTION
UPDATE authors
SET city = 'Rotterdam'
WHERE ano = 2;

-- session 1
UPDATE authors
SET city = 'Rotterdam'
WHERE ano = 2;

-- session 2
UPDATE authors
SET city = 'San Francisco'
WHERE ano = 1;


-- session 1
COMMIT TRANSACTION;

-- session 2
-- Transaction has been chosen as the deadlock victim
-- SQL Server will detect deadlocks automatically. The victim transaction will be undone
-- (rollback). The other transaction will continue to work. The victim transaction must be resumed


-- 4
/*Work in the standard isolation level. Are phantom rows possible? Illustrate your answer
(yes/no) with a concrete example in the books database.*/
-- Answer: Yes
-- session 1
BEGIN TRANSACTION;
SELECT *
FROM authors
WHERE city = 'San Francisco';

-- session 2
BEGIN TRANSACTION;
UPDATE authors
SET city = 'San Francisco'
WHERE ano = 25;
COMMIT TRANSACTION;

-- session 1
SELECT *
FROM authors
WHERE city = 'San Francisco';
--phantom row commit transaction