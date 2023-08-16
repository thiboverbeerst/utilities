-- 1
/*Geef van alle vestigingen (offices) alle gegevens samen met het aantal werknemers uit
die vestiging. Zorg dat de lijst gesorteerd wordt volgens dalend aantal werknemers.
Indien er vestigingen zijn met hetzelfde aantal werknemers, sorteer deze alfabetisch op
city*/
SELECT *, (SELECT count(empno) from employees where employees.officename = offices.officename) as counter
FROM offices
order by counter desc, city;

-- 2
/*Geef de gegevens van de werknemers die kunnen vervangen worden door een
werknemer met een andere job. Sorteer volgens werknemersnummer*/
SELECT *
FROM employees
WHERE empno IN (SELECT replacements.empno FROM replacements
                JOIN employees e2 ON replacements.replno = e2.empno
                WHERE e2.job != employees.job)
ORDER BY empno;

-- 3
/*Geef een alfabetische lijst van de werknemers die binnen hun vestiging het minst
verdienen.*/
SELECT *
FROM employees e1
WHERE salary = (SELECT MIN(salary) FROM employees e2 WHERE e1.officename = e2.officename)
ORDER BY empname;

-- 4
/*Geef een lijst van de werknemers die binnen hun job het meest verdienen. Sorteer op
job.*/
SELECT *
FROM employees e1
WHERE salary = (SELECT MAX(salary) FROM employees e2 WHERE e1.job = e2.job)
ORDER BY job;

-- 5
/*Geef een alfabetische lijst van de werknemers die slechts door één werknemer kunnen
vervangen worden.*/
SELECT *
FROM employees
WHERE empno IN (SELECT empno FROM replacements GROUP BY empno HAVING COUNT(replno) = 1)
ORDER BY empname;

-- 6
/*Geef de werknemers die meer verdienen dan de Director van hun vestiging.*/
SELECT *
from employees e1
WHERE salary > (SELECT salary FROM employees e2
                WHERE e2.job = 'Director' AND e1.officename = e2.officename);

-- 7
/*Geef alle gegevens van de drivers die meer dan 2 leveringen hebben gedaan. Sorteer
alfabetisch op naam.*/
SELECT *
FROM drivers
WHERE 2 < (SELECT COUNT(*) FROM deliveries WHERE drivers.dno = deliveries.dno)
ORDER BY dname;

-- 8
/*Welke artikels wegen zwaarder dan het gemiddelde gewicht en zijn meer dan 3 maal
geleverd?*/
SELECT *
FROM articles
WHERE weight > (SELECT AVG(weight) FROM articles)
AND 3 < (SELECT COUNT(*) FROM deliveries WHERE articles.ano = deliveries.ano);

-- 9
/*Geef van alle drivers de gegevens en het aantal leveringen dat ze reeds deden.
Sorteer dalend volgens aantal leveringen*/
SELECT drivers.*, (SELECT COUNT(*) FROM deliveries WHERE drivers.dno = deliveries.dno) AS counter
FROM drivers
ORDER BY counter desc;

-- 10
/*Geef de drivers (drivers.*) met de hoogste status binnen hun city. Sorteer alfabetisch
op city.*/
SELECT d1.*
FROM drivers d1
WHERE STATUS = (SELECT MAX(STATUS) FROM drivers d2 WHERE d1.city = d2.city)
ORDER BY city;

-- 11
/*Geef de gegevens van de drivers die voor elk project geleverd hebben.*/
SELECT *
FROM drivers
WHERE (SELECT COUNT(pno) FROM projects) = (SELECT COUNT(DISTINCT pno) FROM deliveries
                                            where drivers.dno = deliveries.dno);

-- 12
/*Geef alle gegevens van alle uitgevers (publishers), samen met het aantal boeken dat
ze uitgegeven hebben. Sorteer alfabetisch op uitgeversnaam*/
SELECT *, (SELECT COUNT(bno) FROM books WHERE publishers.pno = books.pno) AS counter
FROM publishers
ORDER BY publisher;

-- 13
/*Geef alle gegevens van alle auteurs, samen met het aantal boeken dat ze geschreven
hebben. Sorteer volgens dalend aantal boeken en vervolgens op naam van auteur.*/
SELECT *, (SELECT COUNT(bno) FROM booksauthors WHERE AUTHORS.ano = booksauthors.ano) AS counter
from AUTHORS
ORDER BY counter DESC, lname, fname;

-- 14
/* Geef een lijst van de boeken (books.*) die in hun categorie het duurst zijn. Sorteer op
categorie en daarbinnen op titel*/
SELECT *
FROM books b1
WHERE price = (Select max(price) from books b2 where b1.category = b2.category)
ORDER BY category, title;

-- 15
/*Geef een lijst van de boeken (books.*) die in hun uitgiftejaar het duurst zijn. Enkel de
boeken die ten hoogste 10 jaar geleden werden uitgegeven worden meegenomen.
Sorteer volgens uitgiftedatum en titel.*/
SELECT *
FROM books b1
WHERE price = (SELECT MAX(price) FROM books b2 WHERE YEAR(b1.pubdate) = YEAR(b2.pubdate))
AND YEAR(pubdate) > (YEAR(CURRENT_DATE()) - 10)
order by pubdate, title;