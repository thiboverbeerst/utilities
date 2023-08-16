/*Write a scalar function fAge that calculates the age from a date of birth.*/

CREATE OR ALTER FUNCTION fn_age(
    @birthdate DATE
)
    RETURNS INT
BEGIN
    RETURN DATEDIFF(YEAR, @birthdate, GETDATE());
END;


GO;

/* get total number of students */

CREATE OR ALTER FUNCTION fn_total_number_of_students()
    RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM students;
    RETURN @count;
END;

GO;

PRINT dbo.fn_total_number_of_students();

GO;

-- 1
/*Write a scalar function fNumberofStudents that delivers the number of students for a
given course (input parameter).
Use this function to provide a list of all courses with the number of students subscribed*/

CREATE OR ALTER FUNCTION fn_number_of_students(@courseid INT)
    RETURNS INT
AS
BEGIN
    DECLARE @number INT
    SELECT @number = COUNT(*)
    FROM students_courses sc
    WHERE courseid = @courseid
    RETURN @number
END

-- 2
/* Write a scalar function fStillToPay that indicates how much a given student (input
parameter) still has to pay according to his subscriptions.
Use this function to provide a list of all students with the amount they still have to pay */

CREATE OR ALTER FUNCTION fn_still_to_pay(@studentid INT)
    RETURNS INT
AS
BEGIN
    DECLARE @paid INT = (SELECT paid FROM students WHERE studentid = @studentid);
    DECLARE @fee INT = (SELECT ISNULL(SUM(fee), 0)
                        FROM courses
                                 JOIN students_courses sc ON courses.courseid = sc.courseid
                        WHERE sc.studentid = @studentid);
    RETURN @fee - @paid;
END;

GO;

SELECT *, dbo.fn_still_to_pay(studentid) AS to_pay
FROM students;

GO;

-- 3
/*Write a scalar function fTitleCase that converts a text (input parameter) to 'title case'.
This means: the first letter of EACH word is uppercase, the rest is lowercase.*/

CREATE OR ALTER FUNCTION fn_title_case(@text NVARCHAR(1000))
    RETURNS NVARCHAR(1000)
AS
BEGIN
    DECLARE @result NVARCHAR(1000) = '',
        @currentplace INT = 1,
        @nextspace INT,
        @strlen INT = LEN(@text),
        @lastword BIT = 0
    WHILE(@lastword = 0)
        BEGIN
            SET @nextspace = CHARINDEX(' ', @text, @currentplace)
            IF (@nextspace IS NULL OR @nextspace = 0)
                BEGIN
                    SET @lastword = 1
                    SET @nextspace = @strlen
                END
            SET @result = @result
                + UPPER(SUBSTRING(@text, @currentplace, 1))
                + LOWER(SUBSTRING(@text, @currentplace + 1, @nextspace -
                                                            @currentplace))
            SET @currentplace = @nextspace + 1
        END

    RETURN @result
END;

GO;

-- 4
/* Retake exercise 5 from exercise series 3.
Rewrite the stored procedure removeSubscriptions. This stored procedure removes
the registrations of all men who are younger than 18 years old. Use the function fAge
from the course. */

CREATE OR ALTER PROCEDURE remove_subscriptions
AS
    SET NOCOUNT ON
DELETE
FROM students_courses
WHERE studentid IN
      (SELECT studentid
       FROM students
       WHERE gender = 'M'
         AND dbo.fn_age(birthdate) < 18);

GO;


-- 5
/* Retake exercise 6 from exercise series 3: work with functions.
Write a function fStudentList1 with 2 input parameters: year of birth and gender. This
functions returns the students who were born after the given year of birth and with the
given gender */
CREATE OR ALTER FUNCTION fn_student_list1(@year INT, @gender CHAR(1))
    RETURNS TABLE
        AS
        RETURN
            (
                SELECT *
                FROM students
                WHERE YEAR(birthdate) > @year
                  AND gender = @gender
            );
GO;

-- 6
/*Retake exercise 7 from exercise series 3: work with functions.
Write a function fStudentList2 that further uses the result of the function fStudentList1.
The obtained students are delivered with the courses they are taking*/

CREATE OR ALTER FUNCTION fn_student_list2(@year INT, @gender CHAR(1))
    RETURNS TABLE
        AS
        RETURN
            (
                SELECT s.*, c.*
                FROM dbo.fn_student_list1(@year, @gender) AS s
                         JOIN students_courses sc ON s.studentid = sc.studentid
                         JOIN courses c ON sc.courseid = c.courseid
            );

GO;

