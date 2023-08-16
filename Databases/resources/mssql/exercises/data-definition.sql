USE school;

-- 1
/*Add a column city to the students table. Choose an appropriate data type.*/
ALTER TABLE students
    ADD city VARCHAR(50);


-- 2
/*Make sure that if a student is removed, all of their enrolments are also removed.*/
ALTER TABLE students_courses
    DROP CONSTRAINT fk1_students_courses

ALTER TABLE students_courses
    ADD CONSTRAINT fk1_students_courses FOREIGN KEY (studentid) REFERENCES students (studentid) ON DELETE CASCADE;

-- 3
/*The paid column should only contain positive amounts*/
ALTER TABLE students
    ADD CHECK (paid >= 0);

-- 4
/*Add a column godfather/godmother. A godfather or godmother is a student who is
listed in the students table.*/
ALTER TABLE students
    ADD godperson INT
        CONSTRAINT fk_godperson FOREIGN KEY REFERENCES students (studentid);

-- 5
/*Give some students a godfather or godmother (choose one yourself).*/
UPDATE students
SET godperson = 4
WHERE studentid IN (1, 2, 3);

UPDATE students
SET godperson = 5
WHERE studentid IN (4, 5, 6);

-- 6
/*List the students who have a godfather or godmother, along with the details of this
godfather or godmother.*/
SELECT *
FROM students AS student
         JOIN students AS godperson ON student.godperson = godperson.studentid;

-- 7
/*A course is taught by one teacher. Create a teachers table with teacher details and
make sure that the appropriate relationships are created.*/
CREATE TABLE teachers
(
    teacherid INT IDENTITY PRIMARY KEY NOT NULL,
    firstname VARCHAR(50)              NOT NULL,
    lastname  VARCHAR(50)              NOT NULL
);

ALTER TABLE courses
    ADD teacherid INT FOREIGN KEY REFERENCES teachers (teacherid);

-- 8
/*Complete the teachers table with the authors from the state CA, from the database pubs.*/
INSERT INTO teachers(firstname, lastname)
SELECT au_fname, au_lname
FROM pubs.dbo.authors
WHERE state = 'CA';


-- 9
/* Assign a teacher to each course */
UPDATE courses
SET teacherid = 1
WHERE courseid = 1;

UPDATE courses
SET teacherid = 2
WHERE courseid = 2;

UPDATE courses
SET teacherid = 3
WHERE courseid = 3;

UPDATE courses
SET teacherid = 4
WHERE courseid = 4;

UPDATE courses
SET teacherid = 5
WHERE courseid = 5;


-- 10
/*What index is on the table students? Is this a clustered or non-clustered index?*/
-- pk_students, clustered index on primary key (studentid)

-- 11
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

-- 12
/*Create a clustered index on the lastname column.*/
CREATE CLUSTERED INDEX idx_lastname
ON students(lastname ASC);

-- 13
/* Give a list of all students. Was anything changed to this list after the clustered index
was created*/
-- The rows are alphabetically on last name