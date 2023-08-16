-- 1
/*Give the book and publisher data for the first 3 books as JSON data.
Make sure category, price and pubdate form a nested info object within a book object
and make sure the publisher data forms another nested object within a book object*/
SELECT TOP 3 b.bno,
             b.title,
             b.category  AS [info.category],
             b.price     AS [info.price],
             b.pubdate   AS [info.pubdate],
             p.pno       AS [publisher.pno],
             p.publisher AS [publisher.publisher],
             p.city      AS [publisher.city]
FROM books b
         JOIN publishers p ON b.pno = p.pno
FOR JSON PATH

-- 2
/*For all the books, give the book and author data as JSON data.
Make sure the authors form a nested array within a book object.*/
SELECT b.bno,
       b.title,
       b.category,
       b.price,
       b.pubdate,
       a.ano,
       a.lastname,
       a.firstname,
       a.birthdate,
       a.city
FROM books b
         JOIN booksauthors ba ON b.bno = ba.bno
         JOIN authors a ON ba.ano = a.ano
FOR JSON AUTO

-- 3
/*For all the books, give the book and author data as JSON data.
Make sure there is a JSON object per join row (so, the authors do not form a nested
array within a book object)*/
SELECT b.bno,
       b.title,
       b.category,
       b.price,
       b.pubdate,
       a.ano,
       a.lastname,
       a.firstname,
       a.birthdate,
       a.city
FROM books b
         JOIN booksauthors ba ON b.bno = ba.bno
         JOIN authors a ON ba.ano = a.ano
FOR JSON PATH

-- 4
/*Put the result of the previous query into a local variable: set @data = (select ...).
Convert the JSON data from this local variable, to a table with an appropriate schema.*/
DECLARE @data NVARCHAR(MAX)
SET @data = (SELECT b.bno,
                    b.title,
                    b.category,
                    b.price,
                    b.pubdate,
                    a.ano,
                    a.lastname,
                    a.firstname,
                    a.birthdate,
                    a.city
             FROM books b
                      JOIN booksauthors ba ON b.bno = ba.bno
                      JOIN authors a ON ba.ano = a.ano
             FOR JSON PATH)
SELECT *
FROM OPENJSON(@data)
              WITH (bno INT,
                  title NVARCHAR(50),
                  category NVARCHAR(50),
                  price DECIMAL(5, 2),
                  pubdate DATE,
                  ano INT,
                  lastname NVARCHAR(50),
                  firstname NVARCHAR(50),
                  birthdate DATE,
                  city NVARCHAR(50))

-- 5
/*Work with the JSON data from the sqlspojexport.json file.
First, put this JSON data in a local variable. Tip: use the function
OPENROWSET(BULK 'datasource', SINGLE_CLOB).
Then, look at the contents of the local variable: select @data.
Finally, convert the JSON data to a table with the columns id, name, email, isadmin*/

DECLARE @data NVARCHAR(MAX)
SET @data = (SELECT *
             FROM OPENROWSET(BULK 'C:\sqlspojexport.json ', SINGLE_CLOB) AS j)
SELECT @data
SELECT *
FROM OPENJSON(@data)
              WITH (id INT,
                  name NVARCHAR(100), email NVARCHAR(100),
                  isadmin BIT)

-- 6
/*Extension of the previous question: the result set consists only of the rows where the
column isadmin = 0.*/
DECLARE @data NVARCHAR(MAX)
SET @data = (SELECT *
             FROM OPENROWSET(BULK 'C:\sqlspojexport.json ', SINGLE_CLOB) AS j)
SELECT *
FROM OPENJSON(@data)
              WITH (id INT,
                  name NVARCHAR(100),
                  email NVARCHAR(100),
                  isadmin BIT)
WHERE isadmin = 0;

-- 7
/*Put all the data obtained in question 6 in a new table Users in the MyBooks database.*/
DECLARE @data NVARCHAR(MAX)
SET @data = (SELECT *
             FROM OPENROWSET(BULK 'C:\sqlspojexport.json ', SINGLE_CLOB) AS j)
DROP TABLE IF EXISTS users
SELECT *
INTO users
FROM OPENJSON(@data)
              WITH (id INT,
                  name NVARCHAR(100),
                  email NVARCHAR(100),
                  isadmin BIT)
WHERE isadmin = 0
SELECT *
FROM users