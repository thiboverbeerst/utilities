
-- 2.6 # find the names with t on the 6th position
SELECT *
FROM offices
WHERE officename LIKE '_____t%';

-- 2.16
#  give the articles where the name starts with a B or C
SELECT *
FROM articles
WHERE aname LIKE 'B%' OR aname LIKE 'C%'
ORDER BY aname;
-- 2.20
SELECT *
FROM AUTHORS
WHERE hometown LIKE 'San Francisco' AND YEAR(birthdate) >= 1950 AND YEAR(birthdate) < 1970
ORDER BY lname, fname;

-- 2.21
# give a list of cities!!!
SELECT DISTINCT city
FROM publishers
WHERE city LIKE 'A%';

-- 3.4
SELECT employees.empno, employees.empname, employees.salary, j.minsal, (employees.salary - j.minsal) AS diff
FROM employees
JOIN jobs j on j.job = employees.job
ORDER BY diff, employees.empname;

-- 3.6 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Which offices are in the same city? PLaats de vestigingen per 2
# en geef telkens de naam van de vestiging end de city.
SELECT officename, city
FROM offices
WHERE city IN (SELECT city
                FROM offices
                GROUP BY city
                HAVING COUNT(city) > 1);
# OR with JOIN !!!!!!!! NEXT LEVEL
SELECT o1.officename, o1.city, o2.officename, o2.city
FROM offices o1
JOIN offices o2 ON o1.city = o2.city
WHERE o1.officename < o2.officename #!!!!!!!!!!!!!!!!!!!!!!
ORDER BY o1.officename;

-- 3.16 !!!!!!!!!!!!!!!!!!!!!!!!!!
# Geef het nummer en de naam van de artikels die geleverd zijn door driver Jones én door driver Blake.
# PAY ATTENTION TO ON WHAT YOU JOIN, MAKES DIFFERENCE IN THIS METHOD!
SELECT DISTINCT deliv1.ano, articles.aname, d1.dno, d1.dname, d2.dno, d2.dname
FROM deliveries deliv1
JOIN deliveries deliv2 ON deliv1.ano = deliv2.ano
JOIN drivers d1 ON deliv1.dno = d1.dno
JOIN drivers d2 ON deliv2.dno = d2.dno
JOIN articles ON deliv1.ano = articles.ano
WHERE d1.dname = 'Jones' AND d2.dname = 'Blake'
ORDER BY deliv1.ano;

-- 3.23
# Give a list of publishers that haven't published any book
SELECT *
FROM publishers
LEFT JOIN books b on publishers.pno = b.pno
WHERE b.bno IS NULL;


-- 4.8
# Geef per sector het aantal werknemers met een salaris tussen 50000 en 100000.
SELECT COUNT(empno)
FROM employees
JOIN offices o on o.officename = employees.officename
WHERE employees.salary BETWEEN 50000 AND 100000
GROUP BY o.sector;

-- 4.12
# Geef het aantal verschillende waarden die in de kolom quality van de tabel articles voorkomen
SELECT COUNT( DISTINCT quality)
FROM articles;

-- 4.16
# Met uitzondering van de leveringen door driver D1, geef voor ieder geleverd artikel het
# artikelnummer en de totale hoeveelheid dat voor dat artikel is geleverd.
SELECT ano, SUM(quantity)
FROM deliveries
WHERE dno NOT LIKE 'D1'
GROUP BY ano;


-- 4.24
# Geef de boeken die ten hoogste 10 jaar geleden werden uitgegeven. Sorteer op titel.
SELECT *
FROM books
WHERE YEAR(pubdate) >=  YEAR(CURDATE())-10
ORDER BY title;

-- 4.25
# Geef een alfabetische lijst van de auteurs die dit jaar een leeftijd hebben die deelbaar
# is door 5 (bijvoorbeeld 45, 50, ...)
SELECT *
FROM AUTHORS
WHERE (YEAR(CURDATE()) - YEAR(birthdate)) % 5 = 0
ORDER BY lname, fname;


-- 5.2
# Geef de jobs die niet voorkomen in de tabel employees.
SELECT *
FROM jobs
WHERE job NOT IN (SELECT job
                    FROM employees
                    WHERE job IS NOT NULL);
/*Let op!
Als de [NOT] IN-operator gebruikt wordt met een subquery,
zorg er dan voor dat de subquery geen NULL-waarden aflevert.
*/
# OF
SELECT *
FROM jobs
LEFT JOIN employees e on jobs.job = e.job
WHERE e.job IS NULL;

-- 5.3
# Geef de Analyst(en) die het meest verdienen
# NOT THIS: !!
SELECT *
FROM employees
WHERE job LIKE 'Analyst'
ORDER BY salary DESC
LIMIT 1;
# BUT THIS: !!
SELECT *
FROM employees
WHERE job = 'Analyst'
AND salary = (SELECT MAX(salary)
                     FROM employees
                     WHERE job = 'Analyst');

-- 5.6
# Geef een lijst van de 10 meest verdienende werknemers. Sorteer deze lijst alfabetisch op naam.
SELECT *
FROM (SELECT *
        FROM employees
        ORDER BY salary DESC
        LIMIT 10) AS helptable
ORDER BY empname;

-- 5.15
# Geef de artikels die zowel door D2 als door D3 zijn geleverd. Sorteer alfabetisch op artikelnaam.
SELECT *
FROM articles
WHERE ano IN (SELECT d1.ano
            FROM deliveries d1
            JOIN deliveries d2 ON d1.ano = d2.ano
            WHERE d1.dno LIKE 'D2' AND d2.dno LIKE 'D3')
ORDER BY aname;

-- 5.16
# Welke artikels wegen zwaarder dan het gemiddelde gewicht en zijn meer dan 3 maal geleverd?
# THIS: !!!
SELECT *
FROM articles
WHERE weight > (SELECT AVG(weight)
                FROM articles)
AND ano IN (SELECT ano
            FROM deliveries
            GROUP BY ano
            HAVING COUNT(dno) > 3);
# NOT THIS: !!!
SELECT *
FROM articles
WHERE weight > (SELECT AVG(weight)
                FROM articles
                WHERE ano IN (SELECT ano
                                FROM deliveries
                                GROUP BY ano
                                HAVING COUNT(dno) > 3));

-- 5.20
# Welke auteurs (authors.*) staan met meer dan 1 boek in de databank? Sorteer alfabetisch op familienaam en voornaam.
SELECT *
FROM AUTHORS
WHERE 1 < (SELECT COUNT(books.bno)
            FROM books
            JOIN booksauthors b on books.bno = b.bno
            where AUTHORS.ano = b.ano)
order by lname, fname;
# OF
SELECT *
FROM AUTHORS
WHERE ano IN (SELECT ano
                FROM booksauthors
                GROUP BY ano
                HAVING COUNT(*) > 1)
ORDER BY lname, fname;

-- 6.1
# Geef van alle vestigingen alle gegevens met het aantal werknemers uit die vestiging
SELECT *, (SELECT COUNT(empno)
                    FROM employees
                    WHERE employees.officename = offices.officename) AS counter
FROM offices
ORDER BY counter DESC, city;

-- 6.2
# Geef de gegevens van de werknemers die kunnen vervangen worden door een werknemer met een andere job.
# PAY ATTENTION ON WHAT I JOIN THE TWO TABLES!!!
SELECT *
FROM employees
WHERE empno IN (SELECT replacements.empno FROM replacements
                JOIN employees e on e.empno = replacements.replno
                WHERE employees.job NOT LIKE e.job)
ORDER BY empno;


-- 6.3
# Geef een alfabetische lijst van de werknemers die binnen hun vestiging het minst verdienen.
SELECT *
FROM employees e1
WHERE salary = (SELECT MIN(salary)
                 FROM employees e2
                 WHERE e2.officename = e1.officename)
ORDER BY empname;

-- 6.9
# Geef van alle drivers de gegevens en het aantal leveringen dat ze reeds deden.
SELECT *, (SELECT COUNT(*)
            FROM deliveries
            WHERE drivers.dno = deliveries.dno) AS counter
FROM drivers
ORDER BY counter DESC;

-- 6.10
# Geef de drivers (drivers.*) met de hoogste status binnen hun city.
SELECT *
FROM drivers d1
WHERE d1.STATUS = (SELECT MAX(d2.STATUS)
                    FROM drivers d2
                    WHERE d1.city = d2.city)
ORDER BY d1.city;

-- 6.11
# Geef de gegevens van de drivers die voor elk project geleverd hebben
SELECT *
FROM drivers
WHERE (SELECT COUNT(*) FROM projects) = (SELECT COUNT(DISTINCT pno) FROM deliveries
                                            WHERE drivers.dno = deliveries.dno);

-- 6.15
# Geef een lijst van de boeken (books.*) die in hun uitgiftejaar het duurst zijn.
# Enkel de boeken die ten hoogste 10 jaar geleden werden uitgegeven worden meegenomen.
SELECT *
FROM books b1
WHERE b1.price = (SELECT MAX(b2.price)
                    FROM books b2
                    WHERE YEAR(b1.pubdate) = YEAR(b2.pubdate))
AND YEAR(b1.pubdate) > YEAR(CURRENT_DATE()) - 10
ORDER BY b1.pubdate, b1.title;

-- 8.5
# Geef voor elk biertype: de naam van het biertype,
# het aantal bieren binnen dit biertype en het gemiddelde alcoholpercentage van de bieren binnen dit biertype
SELECT DISTINCT beertype,
       (SELECT COUNT(*)
        FROM beers
        WHERE b.typeno = beers.typeno) AS beers_count,
       (SELECT ROUND(AVG(beers.alcohol), 1)
        FROM beers
        WHERE b.typeno = beers.typeno) AS avg_alcohol
FROM beertypes
JOIN beers b on beertypes.typeno = b.typeno;

-- 9.3
# Voeg de werknemers (empno, empname) die werken in Computerland uit de databank
# company toe aan de tabel drivers.
INSERT INTO drivers (dno, dname)
SELECT empno, empname
FROM  company.employees
WHERE officename LIKE 'Computerland';

-- 9.4
# Plaats de status van de drivers die nog niets geleverd hebben op 0
UPDATE drivers
SET STATUS = 0
WHERE dno NOT IN (SELECT dno FROM deliveries);

-- 9.5
# Verwijder de drivers waarvan het dno niet begint met D.
DELETE FROM drivers
WHERE dno NOT LIKE 'D%';

-- 9.6
INSERT INTO publishers (publisher, city)
VALUES ('Wiley Publishing', 'Indianapolis');
SET @pno = LAST_INSERT_ID();

INSERT INTO books (title, category, pno, pubdate)
VALUES ('Microsoft SQL Server 2016 Bible', 'Informatica', @pno, '2016-07-09');
SET @bno = LAST_INSERT_ID();

INSERT INTO AUTHORS (lname, fname)
VALUES ('Paul', 'Nielsen');
SET @ano1 = LAST_INSERT_ID();

INSERT INTO AUTHORS (lname, fname)
VALUES ('Mike', 'White');
SET @ano2 = LAST_INSERT_ID();

INSERT INTO AUTHORS (lname, fname)
VALUES ('Utam', 'Parui');
SET @ano3 = LAST_INSERT_ID();

INSERT INTO booksauthors (bno, ano)
VALUES (@bno, @ano1),
       (@bno, @ano2),
       (@bno, @ano3);

-- 9.8
# De prijs van boeken uit de categorie “Roman” die uitgegeven zijn bij
# “Wereldbibliotheek” wordt verminderd met 10%. Let op: dit mag enkel gebeuren voor
# de boeken die reeds 10 jaar of langer zijn uitgegeven.
UPDATE books
SET price = price * 0.9
WHERE category LIKE 'Roman'
AND EXISTS(SELECT *
            FROM publishers
            WHERE books.pno = publishers.pno AND publishers.publisher LIKE 'Wereldbibliotheek')
AND YEAR(pubdate) <= YEAR(CURRENT_DATE()) - 10;

-- 10.7
# 7. Geef alle gegevens van elke student (students.*)
# en geef per student ook wat zou moeten betaald worden volgens de cursussen die gevolgd worden
# (voor elke cursus moet fee betaald worden).
SELECT students.*, (SELECT SUM(courses.fee)
                    FROM registrations
                    JOIN courses ON registrations.courseno = courses.courseno
                    WHERE students.studentno = registrations.studentno) AS coursefee
FROM students
ORDER BY lname, fname;

-- 10.8
# Geef de studenten (students.*) die een naamgenoot hebben in de school.
# Een naamgenoot is een persoon met dezelfde familienaam
# PAY ATTENTION ON WHAT I JOIN THE TWO TABLES!!!
SELECT DISTINCT s1.*
FROM students s1
JOIN students s2 ON s1.lname = s2.lname AND s1.studentno != s2.studentno
ORDER BY lname, fname;

-- 10.9
# Geef per gender de studenten (students.*) die het minst betalen.
SELECT students.*
FROM students
WHERE students.paid = (SELECT MIN(s2.paid)
                        FROM students s2
                        WHERE students.gender = s2.gender)
ORDER BY gender, lname, fname;

-- 10.10
# Welke studenten (students.*) volgen alle aangeboden cursussen?
SELECT students.*
FROM students
WHERE (SELECT COUNT(courseno)
        FROM courses) = (SELECT COUNT(DISTINCT courseno)
                        FROM registrations
                        WHERE students.studentno = registrations.studentno)
ORDER BY lname, fname;

-- 10.13
# geef de cursussen waarvoor geen vrouwen zijn ingeschreven.
SELECT courses.*
FROM courses
WHERE courseno NOT IN (SELECT courseno
                        FROM registrations
                        LEFT JOIN students ON registrations.studentno = students.studentno
                        WHERE gender LIKE 'M')
ORDER BY courseno;

-- 13.6
# Geef van alle evenementen het evenementnummer, het aantal auto’s dat aan dit evenement deelneemt
# en de totale waarde van de deelnemende auto’s
SELECT EVENTS.eventno,
       (SELECT COUNT(carno) FROM carparticipations
       WHERE EVENTS.eventno = carparticipations.eventno) AS amntcars,
       (SELECT SUM(VALUE) FROM carparticipations
        JOIN cars ON carparticipations.carno = cars.carno
        WHERE carparticipations.eventno = EVENTS.eventno) AS carvalues
FROM EVENTS;

-- 13.9
# Geef de gegevens van de auto’s die aan geen enkel evenement deelnamen.
SELECT *
FROM cars
WHERE NOT EXISTS(SELECT *
                FROM carparticipations
                WHERE cars.carno = carparticipations.carno)
ORDER BY VALUE DESC;

-- 13.12 --- HARD!!!
# Geef de lidgegevens (members.*) en de autogegevens (cars.*) van de leden die een auto hebben
# waarvan de waarde meer bedraagt dan de helft van de totale waarde
# van alle auto’s van andere leden uit de city waar dit lid woont.
SELECT members.*, cars.*
FROM members
JOIN cars ON members.memberno = cars.memberno
WHERE VALUE > (SELECT SUM(VALUE)/2
                FROM members m2
                JOIN cars ON m2.memberno = cars.memberno
                WHERE m2.city = members.city AND m2.memberno != members.memberno)
ORDER BY members.memberno, carno;

-- 13.13
# Geef de leden die aan alle evenementen hebben deelgenomen.
# DISTINCT IS IMPORTANT HERE!
SELECT members.*
FROM members
WHERE (SELECT COUNT(eventno) FROM EVENTS) = (SELECT COUNT( DISTINCT eventno)
                                            FROM members m2
                                            JOIN cars ON m2.memberno = cars.memberno
                                            JOIN carparticipations ON cars.carno = carparticipations.carno
                                            WHERE members.memberno = m2.memberno)
ORDER BY memberno;