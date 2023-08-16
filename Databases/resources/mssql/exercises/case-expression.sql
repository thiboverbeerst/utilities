SELECT firstname,
       lastname,
       CASE gender
           WHEN 'V' THEN 'Woman'
           ELSE 'Man' -- OPTIONAL
           END AS gender_fullname
FROM students;


SELECt firstname, lastname,
	CASE
	WHEN DATEDIFF(year, birthdate, GETDATE()) <= 18 THEN 'teen'
	WHEN DATEDIFF(year, birthdate, GETDATE()) <= 60 THEN 'adult'
	WHEN DATEDIFF(year, birthdate, GETDATE()) > 60 THEN 'senior'
	ELSE 'unknown'
	END AS birth_category
FROM students;