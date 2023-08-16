-- 1
/* Write a trigger onlySubscribeWithoutPenalty. A student with a penalty cannot
subscribe for a course */

CREATE OR ALTER TRIGGER only_subscribe_without_penalty
    ON students_courses
    AFTER INSERT
    AS
    IF EXISTS(SELECT *
              FROM inserted
                       JOIN students ON inserted.studentid = students.studentid
              WHERE students.penalty > 0)
        BEGIN
            ROLLBACK TRANSACTION;
        END;

GO;

DROP TRIGGER only_subscribe_without_penalty;

SELECT *
FROM students;


-- 2
/*Write a trigger noDeletingWithPenalty. A student with a penalty cannot be deleted*/
CREATE OR ALTER TRIGGER no_deleting_with_penalty
    ON students
    AFTER DELETE
    AS
    IF EXISTS
        (SELECT *
         FROM deleted
         WHERE penalty != 0)
        BEGIN
            PRINT 'Cannot delete: has a penalty'
            ROLLBACK TRANSACTION
        END

GO;

-- 3
/*Write a trigger max4SubscriptionsPerStudent. A student can only have a maximum
of 4 subscriptions. If the student tries to subscribe in more courses, it may not happen.*/
CREATE OR ALTER TRIGGER max_4_subscriptions_per_student
    ON students_courses
    AFTER INSERT
    AS
    IF EXISTS
        (SELECT studentid
         FROM students_courses
         WHERE studentid IN (SELECT studentid FROM inserted)
         GROUP BY studentid
         HAVING COUNT(*) > 4)
        BEGIN
            ROLLBACK TRANSACTION
        END

GO;

-- 4
/*Write a trigger max6SubscriptionsPerCourse. This trigger does not allow a course to
have more than 6 subscriptions*/
CREATE OR ALTER TRIGGER max_6_subscriptions_per_course
    ON students_courses
    AFTER INSERT
    AS
    IF EXISTS
        (SELECT courseid
         FROM students_courses
         WHERE courseid IN (SELECT courseid FROM inserted)
         GROUP BY courseid
         HAVING COUNT(*) > 6)
        BEGIN
            ROLLBACK TRANSACTION
        END

GO;

-- 5
/* Write a trigger noSubscriptions. There is a subscription stop: no more subscriptions! */
CREATE OR ALTER TRIGGER no_subscriptions
    ON students_courses
    INSTEAD OF INSERT
    AS
    PRINT 'There is a subscription stop!';

GO;

-- 6
/* Preparation work: add a column "deleted" to both the table students and the table
students_courses.
Write a trigger noDelete. This trigger ensures that a student is never actually deleted
from the students table, but instead the "deleted" column is set to 1 for this student.
Also the registrations of this student will be marked as "deleted"*/
ALTER TABLE students
    ADD deleted BIT;

ALTER TABLE students_courses
    ADD deleted BIT;

CREATE OR ALTER TRIGGER no_delete
    ON students
    INSTEAD OF DELETE
    AS
    UPDATE students
    SET deleted = 1
    WHERE studentid IN (SELECT studentid FROM deleted)
    UPDATE students_courses
    SET deleted = 1
    WHERE studentid IN (SELECT studentid FROM deleted)


GO;

-- 7
/*Write a trigger controlUpdatePaid. If the column paid is changed, the new amount
entered cannot be greater than the sum of the fees to be paid according to the
subscriptions.*/
CREATE OR ALTER TRIGGER control_update_paid
    ON students
    AFTER UPDATE, INSERT
    AS
    IF (UPDATE(paid))
        BEGIN
            IF EXISTS
                (SELECT i.studentid
                 FROM inserted i
                          LEFT JOIN students_courses sc ON i.studentid = sc.studentid
                          LEFT JOIN courses c ON sc.courseid = c.courseid
                 GROUP BY i.studentid
                 HAVING ISNULL(AVG(paid), 0) > ISNULL(SUM(fee), 0))
                BEGIN
                    ROLLBACK TRANSACTION
                END
        END

GO;

-- 8
/*Write a trigger noNewTable. No new table should be created in the School database*/
CREATE OR ALTER TRIGGER no_new_table
    ON DATABASE
    AFTER create_table
    AS
    PRINT 'A new table must not be created!'
--provide the text of the SQL statement that triggered it
SELECT EVENTDATA().VALUE('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(1000)')
ROLLBACK TRANSACTION

-- 9
/*Write a trigger noNewDatabase. No new database may be created.*/
CREATE OR ALTER TRIGGER no_new_database
    ON ALL SERVER
    AFTER create_database
    AS
    PRINT 'No new database may be created!'
--provide the text of the SQL statement that triggered it
SELECT EVENTDATA().VALUE('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(1000)')
ROLLBACK TRANSACTION