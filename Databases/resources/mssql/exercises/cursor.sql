/* give a list of all students sorted by studentid with a
cumulative sum of the already paid amount. */

ALTER TABLE students
    ADD fee INT;

GO;

-- declaration
DECLARE @studentid INT;
DECLARE @paid INT;
DECLARE @sum INT = 0;

DECLARE sum_cursor CURSOR
    FOR SELECT studentid, paid
        FROM students
        ORDER BY studentid;


OPEN sum_cursor;

-- fetch first row
FETCH sum_cursor INTO @studentid, @paid;
-- while fetch was successful
WHILE @@fetch_status = 0
    BEGIN
        SET @sum += @paid;
        UPDATE students
        SET fee = @sum
        WHERE studentid = @studentid;

        FETCH sum_cursor INTO @studentid, @paid;
    END;

CLOSE sum_cursor;
DEALLOCATE  sum_cursor;

GO;

SELECT *
FROM students;

ALTER TABLE students
DROP COLUMN fee;