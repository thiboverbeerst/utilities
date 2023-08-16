-- 1
/*Give all stored procedures in the database. Give 2 solutions:
- using catalog views
- using information schema views.*/

--with catalog views
SELECT *
FROM sys.objects
WHERE type = 'P'
--with information schema views
SELECT *
FROM [INFORMATION_SCHEMA].[ROUTINES]
WHERE routine_type = 'PROCEDURE'


-- 2
/*Give all stored procedures that have changed in the last 100 (50) days. Give 2
solutions:
- using catalog views
- using information schema views*/

--with catalog views
SELECT *
FROM sys.objects
WHERE type = 'P'
--with information schema views
SELECT *
FROM [INFORMATION_SCHEMA].[ROUTINES]
WHERE routine_type = 'PROCEDURE'


-- 3
/*Give all stored procedures that have changed in the last 100 (50) days. Give 2
solutions:
- using catalog views
- using information schema views.*/
--with catalog views
SELECT *
FROM sys.objects
WHERE type = 'P'
  AND modify_date > DATEADD(DAY, -100, GETDATE())

--with information schema views
SELECT *
FROM [INFORMATION_SCHEMA].[ROUTINES]
WHERE routine_type = 'PROCEDURE'
  AND last_altered > GETDATE() - 100

-- 4
/*Which columns are the primary key in students_courses? Give 3 solutions:
- using system stored procedures
- using information schema views
- using catalog views.
For the solution with the catalog views: first explore sys.indexes, sys.index_columns
and sys.columns. Then join these views correctly*/

-- with information schema views
SELECT *
FROM [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE]
WHERE table_name = 'students_courses'
  AND constraint_name LIKE 'pk%'
--with catalog views
--first explore sys.indexes, sys.index_columns and sys.columns
SELECT *
FROM sys.indexes
WHERE object_id = OBJECT_ID('students_courses')
SELECT *
FROM sys.index_columns
WHERE object_id = OBJECT_ID('students_courses')
SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('students_courses')
--then join
SELECT *
FROM sys.indexes i
         JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
         JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('students_courses')
  AND i.is_primary_key = 1


-- 5
/*What is the collation in the database?*/
SELECT DATABASEPROPERTYEX('school', 'collation') AS collation