/* create a stored procedure student_list that delivers students with their courses */

CREATE OR ALTER PROCEDURE student_list
AS
    SET NOCOUNT ON; -- don't send message with number of rows affected
SELECT s.studentid, s.firstname, s.lastname, c.courseid, c.coursename
FROM students s
         JOIN students_courses sc ON s.studentid = sc.studentid
         JOIN courses c ON sc.courseid = c.courseid
ORDER BY s.studentid;

GO;

EXEC student_list;

GO;

/* alter student_list so it returns all students */
CREATE OR ALTER PROCEDURE student_list
AS
    SET NOCOUNT ON; -- don't send message with number of rows affected
SELECT s.studentid, s.firstname, s.lastname, c.courseid, c.coursename
FROM students s
         LEFT JOIN students_courses sc ON s.studentid = sc.studentid
         LEFT JOIN courses c ON sc.courseid = c.courseid
ORDER BY s.studentid;

GO;

EXEC student_list;

GO;

/* delete students_list */
DROP PROCEDURE IF EXISTS student_list;


/* create a stored procedure get_students with 2 parameters: year and gender
   This procedure returns the students who were born after the given year and with the given gender
   However if no year is specified, then the year of birth is not taken into account, and if no
   gender is specified, then the gender is set to M*/

CREATE OR ALTER PROCEDURE get_students @year INT = NULL, @gender CHAR = 'M'
AS
    IF @year IS NOT NULL
        BEGIN
            SELECT *
            FROM students
            WHERE YEAR(birthdate) > @year
              AND gender = @gender
            ORDER BY lastname, firstname;
        END
    ELSE
        BEGIN
            SELECT *
            FROM students
            WHERE gender = @gender
            ORDER BY lastname, firstname;
        END

GO;

EXEC get_students;
EXEC get_students 1980;
EXEC get_students 1980, 'V';

DROP PROCEDURE IF EXISTS get_students;

GO;

/* Create a stored procedure get_student_name, in the form of an output parameter of a given student */
CREATE OR ALTER PROCEDURE get_student_name @studentid INT,
                                           @firstname NVARCHAR(50) OUTPUT,
                                           @lastname NVARCHAR(50) OUTPUT
AS
    SET NOCOUNT ON;
SELECT @firstname = firstname, @lastname = lastname
FROM students
WHERE studentid = @studentid;

GO;

DECLARE @fname NVARCHAR(50);
DECLARE @lname NVARCHAR(50);
EXEC get_student_name 1, @fname OUTPUT, @lname OUTPUT;
PRINT @fname;
PRINT @lname;

DROP PROCEDURE IF EXISTS get_student_name;

GO;

/* Create a procedure get_sum_paid of the students born in a given year */

CREATE OR ALTER PROCEDURE get_sum_paid @year INT
AS
    SET NOCOUNT ON;
DECLARE @sum INT = 0;
SELECT @sum = SUM(paid)
FROM students
WHERE YEAR(birthdate) = @year;
    RETURN @sum;

GO;

DECLARE @result INT;
EXEC @result = get_sum_paid 1987;
PRINT @result;

DROP PROCEDURE IF EXISTS get_sum_paid;

GO;


-- 1
/* Write a stored procedure fill_email which fills the email column of the students of which the
   email column is empty with a standard email address: firstname.lastname@howest.be.
   Spaces in the name should be replaced by periods and ' in the name should be removed*/

CREATE OR ALTER PROCEDURE fill_email
AS
    SET NOCOUNT ON;
UPDATE students
SET email = REPLACE(REPLACE(LOWER(firstname) + '.' + LOWER(lastname) + '@howest.be', '`', ''), ' ', '.')
WHERE email IS NULL;

GO;

-- 2
/* Preparation work: add a new column in the table students: penalty (type: int).
Write a stored procedure calculatePenalties that fills the penalty column for all
students.
If a student is 18 years or older
and he's taking at least two courses
and he hasn't paid anything yet,
he'll be fined 50% of the registration fee he should have paid.
Otherwise, the penalty will be 0.  */

ALTER TABLE students
    ADD penalty INT;

GO;


CREATE OR ALTER PROCEDURE calculate_penalties
AS
    SET NOCOUNT ON;

UPDATE students
SET penalty = (SELECT ISNULL(SUM(c.fee), 0) / 2
               FROM students_courses sc
                        JOIN courses c ON sc.courseid = c.courseid
               WHERE sc.studentid = students.studentid)
WHERE DATEDIFF(YEAR, birthdate, GETDATE()) >= 18
  AND studentid IN
      (SELECT studentid
       FROM students_courses
       GROUP BY studentid
       HAVING COUNT(*) >= 2)
  AND (paid = 0 OR paid IS NULL);

GO;

EXEC calculate_penalties;


ALTER TABLE students
    DROP COLUMN penalty;

GO;

-- 3
/* Write a stored procedure payAllStudents that, for all students, fills in the column paid
with the sum of the student’s registration fees and fills in the penalty with 0. */

CREATE OR ALTER PROCEDURE pay_all_students
AS
    SET NOCOUNT ON;
UPDATE students
SET paid    = ISNULL((SELECT SUM(fee)
                      FROM courses
                               JOIN students_courses sc ON courses.courseid = sc.courseid
                      WHERE students.studentid = sc.studentid), 0),
    penalty = 0;

GO;

EXEC pay_all_students;

GO;

-- 4
/*Write a stored procedure payAStudent that, for a certain student (input parameter
studentid), fills in the column paid with the sum of his registration fees and fills in the
penalty with 0.*/

CREATE OR ALTER PROCEDURE pay_a_student @studentid INT
AS
    SET NOCOUNT ON;
UPDATE students
SET paid    = ISNULL((SELECT SUM(fee)
                      FROM courses
                               JOIN students_courses sc ON courses.courseid = sc.courseid
                      WHERE students.studentid = sc.studentid), 0),
    penalty = 0
WHERE studentid = @studentid;

GO;

-- 5
/*Write a stored procedure removeSubscriptions. This stored procedure will delete the
subscriptions of all men under the age of 18 years.*/
CREATE OR ALTER PROCEDURE remove_subscriptions
AS
    SET NOCOUNT ON
DELETE
FROM students_courses
WHERE studentid IN
      (SELECT studentid
       FROM students
       WHERE gender = 'M'
         AND YEAR(GETDATE()) - YEAR(birthdate) < 18);
GO;


-- 6
/*Write a stored procedure studentList1 with 2 input parameters: year of birth and
gender. This procedure returns the students who were born after the given year of birth
and with the given gender.*/

CREATE OR ALTER PROCEDURE student_list1 @year INT,
                                        @gender CHAR(1)
AS
    SET NOCOUNT ON
SELECT *
FROM students
WHERE YEAR(birthdate) > @year
  AND gender = @gender;
GO;

-- 7
/*Write a stored procedure studentList2 that further uses the result of the stored
procedure studentList1. The obtained students are delivered with the courses they are
taking.*/

CREATE OR ALTER PROCEDURE student_list2 @year INT,
                                        @gender CHAR(1)
AS
    SET NOCOUNT ON
    CREATE TABLE #temp
    (
        studentid INT NOT NULL,
        firstname NVARCHAR(30),
        lastname  NVARCHAR(30),
        birthdate DATE,
        gender    CHAR(1),
        paid      INT          DEFAULT 0,
        email     NVARCHAR(50) DEFAULT NULL,
        penalty   INT,
        CONSTRAINT pk_students PRIMARY KEY (studentid)
    )
INSERT INTO #temp
    EXEC student_list1 @year, @gender
SELECT *
FROM #temp
         LEFT JOIN students_courses sc ON #temp.studentid = sc.studentid
         LEFT JOIN courses c ON sc.courseid = c.courseid;
GO;
-- DOESN't WORK
EXEC student_list2 1980, 'V'
GO;


-- 8
/*Write a stored procedure fillWeekends. This stored procedure creates a table
Weekends. If a table Weekends already exists in the database that old table is deleted
and a new table Weekends is created.
The structure of the table Weekends: id, date.
The table is filled with the dates of the saturdays and sundays in a certain year. This
year is given as input parameter to the stored procedure.*/

CREATE OR ALTER PROCEDURE fill_weekends @year INT
AS
    SET NOCOUNT ON
    DROP TABLE IF EXISTS weekends
    CREATE TABLE weekends
    (
        id   INT IDENTITY PRIMARY KEY,
        date DATE
    )
DECLARE
    @startdate       DATE,
    @startdatestring VARCHAR(10),
    @stopdate        DATE,
    @stopdatestring  VARCHAR(10),
    @date            DATE

--select @@DATEFIRST --contains the current setting of datefirst
    SET DATEFIRST 1 --Monday is the first day of the week
    SET @startdatestring = CONVERT(CHAR(4), @year) + '-01-01'
    SET @startdate = CONVERT(DATETIME, @startdatestring)
    SET @stopdatestring = CONVERT(CHAR(4), @year) + '-12-31'
    SET @stopdate = CONVERT(DATETIME, @stopdatestring)
    SET @date = @startdate
    WHILE YEAR(@date) = YEAR(@stopdate)
        BEGIN
            IF DATEPART(WEEKDAY, @date) = 6 -- saturday
                BEGIN
                    INSERT INTO weekends(date) VALUES (@date)
                    SET @date = DATEADD(DAY, 1, @date)
                END
            ELSE
                IF DATEPART(WEEKDAY, @date) = 7 -- Sunday
                    BEGIN
                        INSERT INTO weekends(date) VALUES (@date)
                        SET @date = DATEADD(DAY, 6, @date)
                    END
                ELSE
                    BEGIN
                        SET @date = DATEADD(DAY, 1, @date)
                    END
        END;

        GO;
EXEC fill_weekends 2024;

SELECT * FROM weekends;

GO;
