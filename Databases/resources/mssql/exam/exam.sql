-- 1a
USE sherlockshop2023;

ALTER TABLE articles
    DROP CONSTRAINT IF EXISTS fk_articles;

DROP TABLE IF EXISTS article_categories;

CREATE TABLE article_categories
(
    article_id  INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT pk_article_categories PRIMARY KEY (article_id, category_id),
    CONSTRAINT fk1_articles FOREIGN KEY (article_id) REFERENCES articles (art_id),
    CONSTRAINT fk2_categories FOREIGN KEY (category_id) REFERENCES categories (cat_id)
);

INSERT INTO article_categories(article_id, category_id)
SELECT art_id, cat_id
FROM articles;

ALTER TABLE articles
    DROP COLUMN cat_id;

-- 1b
INSERT INTO article_categories(article_id, category_id)
VALUES (1, 2),
       (1, 3);


-- 1c
SELECT articles.*, c.*
FROM articles
         LEFT JOIN article_categories ac ON articles.art_id = ac.article_id
         LEFT JOIN categories c ON c.cat_id = ac.category_id;



-- 2a
CREATE OR ALTER PROCEDURE addcolumncusttype
AS
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1
                  FROM sys.columns
                  WHERE name = N'CustType'
                    AND object_id = OBJECT_ID(N'dbo.customers'))
        BEGIN
            ALTER TABLE customers
                ADD custtype NVARCHAR(20) DEFAULT NULL CHECK (custtype IN ('Bronze', 'Silver', 'Gold', NULL));
        END

GO;

-- 2b

EXEC addcolumncusttype;

GO;

-- 2c

SELECT *
FROM customers
ORDER BY REPLACE(lastname, ' ', ''), REPLACE(firstname, ' ', '');



-- 3a
CREATE OR ALTER PROCEDURE fillcusttype @cust_id INT
AS
    SET NOCOUNT ON;
UPDATE customers
SET custtype = (CASE (SELECT COUNT(*)
                      FROM orders
                      WHERE orders.cust_id = @cust_id)
                    WHEN 0 THEN NULL
                    WHEN 1 THEN 'Bronze'
                    WHEN 2 THEN 'Bronze'
                    WHEN 3 THEN 'Silver'
                    WHEN 4 THEN 'Silver'
                    ELSE 'Gold' END)
WHERE cust_id = @cust_id;

GO;

-- 3b

EXEC fillcusttype 2;

GO;


-- 4a
CREATE OR ALTER FUNCTION fage(
    @birthdate DATE,
    @deathdate DATE = NULL
)
    RETURNS INT
BEGIN
    DECLARE @age INT;
    IF @deathdate IS NULL
        BEGIN
            SET @age = DATEDIFF(YEAR, @birthdate, GETDATE());
        END
    ELSE
        BEGIN
            SET @age = DATEDIFF(YEAR, @birthdate, @deathdate);
        END
    RETURN @age;
END;


GO;

-- 4b

SELECT *, dbo.fage(birthdate, deathdate) AS age
FROM customers;

GO;


-- 5a
CREATE OR ALTER FUNCTION fcustomerswithordersin(
    @year1 INT,
    @year2 INT
)
    RETURNS TABLE
        AS
        RETURN
            (
                SELECT *
                FROM customers
                WHERE cust_id IN (SELECT orders.cust_id FROM orders WHERE YEAR(orderdate) = @year1)
                  AND cust_id IN (SELECT orders.cust_id FROM orders WHERE YEAR(orderdate) = @year2)
            );

GO;

SELECT *
FROM fcustomerswithordersin(2017, 2018) AS c
         JOIN orders ON c.cust_id = orders.cust_id;

GO;


-- 6
CREATE OR ALTER TRIGGER ControlAmount
    ON orderdetails
    AFTER INSERT
    AS
    IF EXISTS(SELECT *
              FROM inserted
                       JOIN articles ON inserted.art_id = articles.art_id
              WHERE inserted.amount > articles.instock)
        BEGIN
            ROLLBACK TRANSACTION;
        END;

GO;


-- 8a
CREATE LOGIN Exam1
    WITH PASSWORD ='Exam1-PWD' MUST_CHANGE,
    CHECK_EXPIRATION = ON,
    CHECK_POLICY = ON;

GO;

-- 8b
USE sherlockshop2023;
CREATE USER Exam1;

GO;

-- 8c
ALTER ROLE db_datareader
    ADD MEMBER [Exam1];

GO;


-- 8d
USE sherlockshop2023;
DROP USER [Exam1];

GO;


-- 9a


-- 10a
DECLARE @data NVARCHAR(MAX)
SET @data = (SELECT c.cust_id,
                    c.lastname,
                    c.firstname,
                    (SELECT COUNT(*) FROM orders WHERE c.cust_id = orders.cust_id) AS [stats.countorders],
                    (SELECT TOP (1) orderdate
                     FROM orders
                     WHERE c.cust_id = orders.cust_id
                     ORDER BY orderdate DESC)                                      AS [stats.lastorderdate]
             FROM customers c
             FOR JSON PATH);


-- 10b
DROP TABLE IF EXISTS JSONdata
SELECT *
INTO JSONdata
FROM OPENJSON(@data)
              WITH (cust_id INT,
                  lastname NVARCHAR(100),
                  firstname NVARCHAR(100),
                  countorders INT '$.stats.countorders',
                  lastorderdate DATE '$.stats.lastorderdate')

GO;
