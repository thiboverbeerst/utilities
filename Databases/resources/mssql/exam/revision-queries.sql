
USE pubs;

/* Limit number of rows return with offset */
SELECT *
FROM authors
ORDER BY au_lname, au_fname
OFFSET 2 ROWS
FETCH NEXT 5 ROWS ONLY;

/* Top */
SELECT TOP(3) WITH TIES *
FROM titles
ORDER BY advance DESC;