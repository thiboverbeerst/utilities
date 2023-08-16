
/* Give all students with their age (current year - year of birth). Sort by age, last name and first name. */
SELECT *, DATEDIFF(year, birthdate, GETDATE()) AS age
FROM students
ORDER BY age, lastname, firstname;


/*Give the details of the students taking all courses.*/
select *
from students
where (select COUNT(*) from courses) = (
    select COUNT(*)
    from students_courses sc
    where sc.studentid = students.studentid
    )


/*  Give the courses with the highest number of enrolled students. */
SELECT TOP 1 WITH TIES *, (SELECT COUNT(studentid) FROM students_courses WHERE courses.courseid = students_courses.courseid) as count
FROM courses
ORDER BY count DESC


/*If the column email is empty, fill this column with a standard email address:
firstname.lastname@.howest.be. Spaces in the name should be replaced by periods
and ' in the name should be removed*/
UPDATE students
SET email = REPLACE(LOWER(firstname) + '.' + LOWER(lastname), ' ', '.') + '@howest.be'
WHERE email IS NULL;


/* Create a new table studentsOld. Fill this new table with the students born in 1980 or earlier*/
SELECT *
INTO old_students
FROM students
WHERE YEAR(birthdate) <= YEAR('1980');


/* Add to the table studentsOld the authors from the pubs database.*/
INSERT INTO old_students(firstname, lastname)
SELECT au_fname, au_lname
FROM pubs.dbo.authors;


/*Add a column city to the students table. Choose an appropriate data type.*/
ALTER TABLE students_courses
    DROP CONSTRAINT fk1_students_courses

ALTER TABLE students_courses
    ADD CONSTRAINT fk1_students_courses FOREIGN KEY (studentid) REFERENCES students (studentid) ON DELETE CASCADE;

/*The paid column should only contain positive amounts*/
ALTER TABLE students
    ADD CONSTRAINT positive_values_paid_col CHECK (paid >= 0)


/*Make sure this index is non-clustered.*/
-- PK is by default a clustered index.
-- FK is by default non-clustered index
-- DROP THE pk_students CLUSTERED INDEX AND THE FK THAT REFERENCES TO THIS PK
ALTER TABLE students_courses
    DROP CONSTRAINT fk1_students_courses;
ALTER TABLE students
    DROP CONSTRAINT fk_godperson;
ALTER TABLE students
    DROP CONSTRAINT pk_students;

-- CREATE NEW CONSTRAINT BUT AS A NON-CLUSTERED INDEX
ALTER TABLE students
    ADD CONSTRAINT pk_students PRIMARY KEY NONCLUSTERED(studentid);
ALTER TABLE students_courses
    ADD CONSTRAINT fk1_students FOREIGN KEY (studentid) REFERENCES
        students (studentid);
ALTER TABLE students
    ADD CONSTRAINT fk2_students FOREIGN KEY (godperson) REFERENCES
        students (studentid);


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
END