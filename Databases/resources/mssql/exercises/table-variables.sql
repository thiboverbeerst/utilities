/* Is a variable of type table. Same lifetime and scope as a local variable. */
DECLARE @women TABLE (
	studentid INT PRIMARY KEY,
	lastname VARCHAR(50)
)

INSERT INTO @women
	SELECT studentid, lastname
	FROM students
	WHERE gender = 'V';