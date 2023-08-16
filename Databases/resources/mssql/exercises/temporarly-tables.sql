
/*
A temporarily table is created as regular table, but the name must start with `#`. The temporarily tables are created in the tempdb database.
Only the connection which created the table can see the table.

Lifespan:
- When created in stored procedure, the temp table will be dropped when procedure ends
- Other temp tables are dropped when session ends.
*/

CREATE TABLE #women (
	studentid INT PRIMARY KEY,
	lastname VARCHAR(50)
)

INSERT INTO #women
	SELECT studentid, lastname
	FROM students
	WHERE gender = 'V';