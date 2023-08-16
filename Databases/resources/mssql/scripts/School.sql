CREATE DATABASE school
GO
USE school
GO
CREATE TABLE students
(studentid	INT identity NOT NULL,
 firstname	NVARCHAR(30),
 lastname	NVARCHAR(30),
 birthdate	DATE,
 gender		CHAR(1),
 paid		INT DEFAULT 0,
 email 		NVARCHAR(50) DEFAULT NULL,
 CONSTRAINT pk_students PRIMARY KEY (studentid)
)
GO
CREATE TABLE courses
(courseid	INT identity NOT NULL,
 coursename	NVARCHAR(30),
 fee		INT,
 CONSTRAINT pk_courses PRIMARY KEY (courseid)
)
GO
CREATE TABLE students_courses
(studentid	INT NOT NULL,
 courseid	INT NOT NULL,
 CONSTRAINT pk_students_courses PRIMARY KEY (studentid, courseid),
 CONSTRAINT fk1_students_courses FOREIGN KEY(studentid) REFERENCES students(studentid),
 CONSTRAINT fk2_students_courses FOREIGN KEY(courseid) REFERENCES courses(courseid)
)
GO
INSERT INTO students VALUES ('Francois','Bemelmans','1985-04-28','M',250,NULL)
INSERT INTO students VALUES ('Veerle','Van Maele','1987-07-06','V',50,NULL)
INSERT INTO students VALUES ('Karel','Govaert','1985-05-07','M',0,NULL)
INSERT INTO students VALUES ('Luc','Janssens','1988-12-10','M',50,NULL)
INSERT INTO students VALUES ('Leen','Verstraete','1988-12-09','V',120,NULL)
INSERT INTO students VALUES ('Jos','Van Den Berg','1985-08-23','M',150,NULL)
INSERT INTO students VALUES ('Diane','Hanssen','1986-05-12','V',50,NULL)
INSERT INTO students VALUES ('Bart','Baertmans','1990-11-03','M',50,NULL)
INSERT INTO students VALUES ('Carol','Mestdagh','1989-01-07','V',100,NULL)
INSERT INTO students VALUES ('Lucie','Jaspaert','1989-05-22','V',120,NULL)
INSERT INTO students VALUES ('Koen','Mortelgems','1990-04-04','M',100,NULL)
INSERT INTO students VALUES ('Marie','Van Maele','1988-10-26','V',0,NULL)
INSERT INTO students VALUES ('Marc','Vandoorne', NULL,'M',0,NULL)
INSERT INTO students VALUES ('Lieve','Van Maele','1986-11-24','V',0,NULL)
INSERT INTO students VALUES ('Marc','van Emergem','1980-11-01','M',0,NULL)
GO
INSERT INTO courses VALUES ('C#',50)
INSERT INTO courses VALUES ('SQL',100)
INSERT INTO courses VALUES ('Java',70)
INSERT INTO courses VALUES ('Excel',70)
INSERT INTO courses VALUES ('MS SQL Server',100)
GO
INSERT INTO students_courses VALUES (1,1)
INSERT INTO students_courses VALUES (1,2)
INSERT INTO students_courses VALUES (1,3)
INSERT INTO students_courses VALUES (1,4)
INSERT INTO students_courses VALUES (2,1)
INSERT INTO students_courses VALUES (4,1)
INSERT INTO students_courses VALUES (5,2)
INSERT INTO students_courses VALUES (5,3)
INSERT INTO students_courses VALUES (6,3)
INSERT INTO students_courses VALUES (6,4)
INSERT INTO students_courses VALUES (7,1)
INSERT INTO students_courses VALUES (8,1)
INSERT INTO students_courses VALUES (9,2)
INSERT INTO students_courses VALUES (10,2)
INSERT INTO students_courses VALUES (10,4)
INSERT INTO students_courses VALUES (11,2)
INSERT INTO students_courses VALUES (12,1)
INSERT INTO students_courses VALUES (12,2)
GO



