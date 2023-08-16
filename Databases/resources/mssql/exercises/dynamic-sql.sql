/* example with sql injection possible */
-- declaration
DECLARE @sql NVARCHAR(500);
DECLARE @lastname NVARCHAR(100);

-- user input
SET @lastname = 'Van Maele" OR 1=1 --';

-- preparing SQL statement
SET  @sql = 'SELECT * FROM students WHERE lastname = "' + @lastname + '"';

-- execute
EXEC sp_executesql @sql;

GO;


/* example to avoid sql injection with parameters */
-- declaration
DECLARE @sql NVARCHAR(500);
DECLARE @lastname NVARCHAR(100);

--user input
SET @lastname = 'Van Maele" or 1=1 --'

--preparing the SELECT-statement
SET @sql = 'select * from students where lastname = @lastname'
DECLARE @paramdef NVARCHAR(100) = '@lastname nvarchar(100)'

--execute the formed SQL statement
EXEC sp_executesql @sql, @paramdef, @lastname;

GO;