

-- 1
/*Give the students, sorted alphabetically by last name and first name. Only the first 12
students from the alphabetical list are displayed. Make sure that spaces do not play a
role in determining the sorting order.*/
SELECT TOP(12) *
FROM students
ORDER BY REPLACE(lastname, ' ', ''), REPLACE(firstname, ' ', '');

-- 2
/*Skip the alphabetically first 3 male students and give the alphabetically next 3 male students*/
SELECT *
FROM students
WHERE gender = 'M'
ORDER BY lastname, firstname
OFFSET 3 ROWS
FETCH NEXT 3 ROWS ONLY;

-- 3
/* Give all students with their age (current year - year of birth). Sort by age, last name and first name. */
SELECT *, DATEDIFF(year, birthdate, GETDATE()) AS age
FROM students
ORDER BY age, lastname, firstname;

-- 4
/*Give the details of the students whose last names begin with v (lowercase v).*/
SELECT *
FROM students
WHERE lastname LIKE 'v%';

-- 5
/*Give the students whose last names sound approximately like 'Vanmale'*/
SELECT *, SOUNDEX(lastname) AS soundxcode
FROM students
WHERE DIFFERENCE(REPLACE(lastname, ' ', ''), 'Vanmale') = 4;
-- The DIFFERENCE() function compares two SOUNDEX values, and returns an integer.
-- The integer value indicates the match for the two SOUNDEX values, from 0 to 4.

-- 6
/*List the students and the courses they are taking. Give per student: studentid, last
name, first name and the name of the course they are taking. Sort alphabetically by last
name and first name.*/
SELECT students.studentid, lastname, firstname, coursename
FROM students
JOIN students_courses sc on students.studentid = sc.studentid
JOIN courses on courses.courseid = sc.courseid
ORDER BY lastname, firstname;

-- 7
/*Same as the previous question, but make sure that students who are not taking any
courses are also displayed.*/
SELECT students.studentid, lastname, firstname, coursename
FROM students
LEFT JOIN students_courses sc on students.studentid = sc.studentid
LEFT JOIN courses on courses.courseid = sc.courseid
ORDER BY lastname, firstname;

-- 8
/*Same as the previous question, but make sure that courses not taken by any student
are also displayed.*/
SELECT students.studentid, lastname, firstname, coursename
FROM students
FULL JOIN students_courses sc on students.studentid = sc.studentid
FULL JOIN courses on courses.courseid = sc.courseid
ORDER BY lastname, firstname;

-- 9
/*For each student, give what he has already paid (the paid column of the students table)
and what the student should pay according to the courses he is taking (each course
requires a registration fee). If the student is not taking any courses, then display 0 (and
not NULL).*/
SELECT students.*,
       ISNULL((SELECT SUM(c.fee)
               FROM courses c
                JOIN students_courses sc ON c.courseid = sc.courseid
               WHERE sc.studentid = students.studentid), 0) AS shouldpay
FROM students

-- 10
/*Give the details of the students who are not taking any courses*/
SELECT *
FROM students
WHERE studentid NOT IN (SELECT studentid
                        FROM students_courses);

-- 11
/*Give the details of the students taking all courses.*/
SELECT *
FROM students
WHERE (SELECT COUNT(*) FROM courses) = (SELECT COUNT(*)
                                        FROM students_courses sc
                                        WHERE sc.studentid = students.studentid)

/* test */
INSERT INTO students(firstname, lastname, birthdate, gender) VALUES ('Thibo', 'Verbeerst', '2003-03-26', 'M');

INSERT INTO students_courses(studentid, courseid) VALUES (16, 1);
INSERT INTO students_courses(studentid, courseid) VALUES (16, 2);
INSERT INTO students_courses(studentid, courseid) VALUES (16, 3);
INSERT INTO students_courses(studentid, courseid) VALUES (16, 4);
INSERT INTO students_courses(studentid, courseid) VALUES (16, 5);

DELETE students_courses
WHERE studentid = 16;
DELETE students
WHERE studentid = 16;

-- 12
/* Give the students taking the highest number of courses. */
SELECT TOP 1 WITH TIES *,
                       (SELECT COUNT(*)
                        FROM students_courses
                        WHERE studentid = students.studentid) AS course_count
FROM students
ORDER BY course_count DESC;

-- 13
/*  Give the courses with the highest number of enrolled students. */
SELECT TOP 1 WITH TIES *,
                       (SELECT COUNT(studentid)
                        FROM students_courses
                        WHERE courses.courseid = students_courses.courseid) AS count
FROM courses
ORDER BY count DESC

-- 14
/* Give the courses for which only women are enrolled */
SELECT *
FROM courses
WHERE courseid NOT IN (
    SELECT students_courses.courseid
    FROM students_courses
    JOIN students s on students_courses.studentid = s.studentid
    WHERE gender = 'M'
    )


-- 15
/* Give the details of the students who have a namesake in the school. A namesake is a
person with the same last name. Sort the list alphabetically by last name and first
name.*/
SELECT *
FROM students AS s1
WHERE s1.lastname IN (SELECT s2.lastname
                      FROM students AS s2
                      WHERE s1.studentid != s2.studentid)
ORDER BY lastname, firstname;

-- 16
/*If the column email is empty, fill this column with a standard email address:
firstname.lastname@.howest.be. Spaces in the name should be replaced by periods
and ' in the name should be removed*/
UPDATE students
SET email = REPLACE(LOWER(firstname) + '.' + LOWER(lastname), ' ', '.') + '@howest.be'
WHERE email IS NULL;

-- reset:
UPDATE students
SET email = NULL;

-- 17
/* Create a new table studentsOld. Fill this new table with the students born in 1980 or earlier*/
SELECT *
INTO old_students
FROM students
WHERE YEAR(birthdate) <= YEAR('1980');

-- 18
/* Add to the table studentsOld the authors from the pubs database.*/
INSERT INTO old_students(firstname, lastname)
SELECT au_fname, au_lname
FROM pubs.dbo.authors;

-- 19
/*From the table studentsOld, remove the students with a last name starting with the letter V*/
DELETE old_students
WHERE CHARINDEX('v', lastname) = 1;

-- 20
/* Create a view vStudentsWithCourses that lists the students and their courses. Use the
view to get an alphabetical list*/
CREATE VIEW view_students_with_courses AS
SELECT students.studentid, firstname, lastname, c.courseid, coursename
FROM students
JOIN students_courses sc on students.studentid = sc.studentid
JOIN courses c on c.courseid = sc.courseid;

SELECT *
FROM view_students_with_courses
ORDER BY lastname, firstname;
