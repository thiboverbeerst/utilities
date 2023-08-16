-- 1
/*n the Database Properties of the books database, under the Files tab, view the files
that have been created. Then view these files in Explorer.*/


-- 2
/* Set the Full recovery model for the books database.*/

ALTER DATABASE books
    SET RECOVERY FULL

-- 3
/*Create a full database backup (booksEx.bak) of the books database in the
location C:\MySQLBackups. Backup set name: "books-Full Database Backup".
- Verify in the Explorer that the backup was made.
- Also verify the backup in the Object Explorer. Right-click on books, Tasks,
Backup ..... Select the .bak file and choose Contents. Cancel after viewing.*/
BACKUP DATABASE [books]
    TO DISK = N'/home/thibo/scripts'
    WITH NAME = N'books-Full Database Backup';

-- 4
/*Drop the tables booksauthors and books. */
USE books
GO
DROP TABLE booksauthors
GO
DROP TABLE books

-- 5
/*The above actions are a failure. Restore the database. */
USE [master]
ALTER DATABASE books
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [books]
    FROM DISK = N'C:\MySQLBackups\booksEx.bak'
    WITH FILE = 1, REPLACE
ALTER DATABASE [books]
    SET MULTI_USER

-- 6
/*Add test data to the tables.
To do this, write a script to add 100 publishers and 100 books.
- Name the publisher "publisherX" (X is a number from 1 to 100).
- Give the books the title "booktitleX" (X is a number from 1 to 100), the publisher is 1
and the pubdate is today's date.
Run the script*/

USE books
DECLARE @counter INT = 1
WHILE @counter <= 100
    BEGIN
        INSERT INTO publishers(publisher)
        VALUES ('publisher' + (SELECT CAST(@counter AS NVARCHAR(3))))
        SET @counter = @counter + 1
    END
GO
SELECT *
FROM publishers
GO
DECLARE @counter INT = 1
WHILE @counter <= 100
    BEGIN
        INSERT INTO books(title, pno, pubdate)
        VALUES ('booktitle' + (SELECT CAST(@counter AS NVARCHAR(3))), 1, GETDATE())
        SET @counter = @counter + 1
    END

GO
SELECT *
FROM books

-- 7
/*s it possible to take a transaction log backup?
- If yes, take the transaction log backup (booksEx.bak) of the database in the
location C:\MySQLBackups. Backup set name: "books-Transaction Log
Backup".
o Verify the backup in the Object Explorer. Right-click on books, Tasks,
Backup ..... Select the .bak file and choose Contents. Cancel after viewing.
- If not, why not?*/

-- Yes, a transaction log backup is possible because the recovery model is set to Full for
-- the books database.
BACKUP LOG [books]
    TO DISK = N'C:\MySQLBackups\booksEx.bak'
    WITH NAME = N'books-Transaction Log Backup';

-- 8
/*Drop the tables booksauthors and books. */
USE books
GO
DROP TABLE booksauthors
GO
DROP TABLE books

-- 9
/*The above actions are a failure. Restore the database. */
USE [master]
ALTER DATABASE [books]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [books]
    FROM DISK = N'C:\MySQLBackups\booksEx.bak'
    WITH FILE = 1, NORECOVERY, REPLACE
RESTORE LOG [books]
    FROM DISK = N'C:\MySQLBackups\booksEx.bak'
    WITH FILE = 2
ALTER DATABASE [books]
    SET MULTI_USER