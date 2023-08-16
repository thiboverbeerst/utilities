

-- 1
/*Geef een overzicht van de vestigingen (offices) met de werknemers (employees) die er
werken. Sorteer de lijst alfabetisch op vestigingsnaam en binnen elke vestiging
alfabetisch op werknemersnaam.*/
SELECT *
FROM offices
JOIN employees ON offices.officename = employees.officename
ORDER BY offices.officename, empname;

-- 2
/* Geef een lijst van de werknemers die overbetaald zijn (meer verdienen dan het
maximumsalaris van hun job). Sorteer de lijst volgens dalend salaris*/
SELECT employees.*
FROM employees
JOIN jobs ON employees.job = jobs.job
WHERE salary > jobs.maxsal
ORDER BY salary DESC;

-- 3
/*Geef een lijst van de werknemers die overbetaald zijn. Geef bij elke overbetaalde
werknemer ook de gegevens van de vestiging waar hij werkt. Sorteer de lijst volgens
dalend salaris*/
SELECT employees.*, offices.*
FROM employees
JOIN jobs ON employees.job = jobs.job
JOIN offices ON employees.officename = offices.officename
WHERE salary > jobs.maxsal
ORDER BY salary DESC;

-- 4
/*Bereken voor elke werknemer het verschil van zijn salaris met het overeenkomstig
(volgens de job) minimumsalaris. Geef het nummer van de werknemer, de naam van
de werknemer, het salaris, het minimumsalaris van zijn job en het positieve of
negatieve verschil. Sorteer de lijst op het berekende verschil en daarna op naam*/
SELECT empno, empname, salary, minsal, (salary - minsal) AS diff
FROM employees
JOIN jobs ON employees.job = jobs.job
ORDER BY diff, empname;

-- 5
/*Idem vorige oefening, maar nu met uitzondering van de rijen waarin het salaris
hetzelfde is als het minimumsalaris.*/
SELECT empno, empname, salary, minsal, (salary - minsal) AS diff
FROM employees
JOIN jobs ON employees.job = jobs.job
WHERE salary != minsal
ORDER BY diff, empname;

-- 6
/*Welke vestigingen zijn in dezelfde city gelegen? Plaats de vestigingen per 2 en geef
telkens de naam van de vestiging en de city.*/
SELECT o1.officename, o1.city, o2.officename, o2.city
FROM offices o1
JOIN offices o2 ON o1.city = o2.city
WHERE o1.officename < o2.officename #!!!!!!!!!!!!!!!!!!!!!!
ORDER BY o1.officename;

-- 7
/*Geef alle gegevens van de werknemers die vervangen kunnen worden. Sorteer op werknemersnaam.*/
SELECT DISTINCT employees.*
FROM employees
JOIN replacements ON employees.empno = replacements.empno
ORDER BY employees.empname;

-- 8
/*Geef een alfabetische lijst van alle werknemers met de job Analyst uit de sector Sales.*/
SELECT employees.*
FROM employees
JOIN offices ON employees.officename = offices.officename
WHERE job = 'Analyst' AND sector = 'Sales'
ORDER BY empname;

-- 9
/*Geef alle vestigingen met de werknemers. Sorteer de lijst alfabetisch op
vestigingsnaam en binnen elke vestiging alfabetisch op werknemersnaam.*/
SELECT *
FROM offices
LEFT JOIN employees ON offices.officename = employees.officename
ORDER BY offices.officename, empname;

-- 10
/*Geef de vestigingen waarin geen enkele werknemer werkt.*/
SELECT offices.*
FROM offices
LEFT JOIN employees ON offices.officename = employees.officename
WHERE empno IS NULL
ORDER BY offices.officename, empname;

-- 11
/*Geef een alfabetische lijst van de drivers die een levering gedaan hebben voor project P5.*/
SELECT drivers.*
FROM drivers
JOIN deliveries ON drivers.dno = deliveries.dno AND deliveries.pno = 'P5'
ORDER BY dname;

-- 12
/*Geef een alfabetische lijst van de drivers die een artikel met quality 1 hebben geleverd.*/
SELECT DISTINCT drivers.*
FROM drivers
JOIN deliveries ON drivers.dno = deliveries.dno
JOIN articles ON deliveries.ano = articles.ano AND articles.quality = 1
ORDER BY dname;

-- 13
/*Geef een lijst van de drivers met de projectnummers waarvoor ze geleverd hebben.
Sorteer op dno.*/
SELECT DISTINCT drivers.*, deliveries.pno
FROM drivers
JOIN deliveries ON drivers.dno = deliveries.dno
ORDER BY drivers.dno

-- 14
/*Geef het nummer van de artikels die geleverd zijn door driver D2 én door driver D3.*/
SELECT DISTINCT d1.ano
FROM deliveries d1
JOIN deliveries d2 ON d1.ano = d2.ano AND d2.dno = 'D2' AND d1.dno = 'D3';

-- 15
/*Geef het nummer en de naam van de artikels die geleverd zijn door driver D2 én door
driver D3*/
SELECT DISTINCT d1.ano, articles.aname
FROM deliveries d1
JOIN deliveries d2 ON d1.ano = d2.ano AND d2.dno = 'D2' AND d1.dno = 'D3'
JOIN articles ON d2.ano = articles.ano;

-- 16
/* Geef het nummer en de naam van de artikels die geleverd zijn door driver Jones én
door driver Blake.*/
SELECT DISTINCT deliv1.ano, articles.aname, d1.dno, d1.dname, d2.dno, d2.dname
FROM deliveries deliv1
JOIN deliveries deliv2 ON deliv1.ano = deliv2.ano
JOIN drivers d1 ON deliv1.dno = d1.dno
JOIN drivers d2 ON deliv2.dno = d2.dno
JOIN articles ON deliv1.ano = articles.ano
WHERE d1.dname = 'Jones' AND d2.dname = 'Blake'
ORDER BY deliv1.ano;

-- 17
/*Geef het nummer en de naam van de artikels die geleverd zijn door driver Jones of
door driver Blake.*/
SELECT DISTINCT articles.ano, aname
FROM articles
JOIN deliveries ON articles.ano = deliveries.ano
JOIN drivers ON deliveries.dno = drivers.dno
WHERE dname IN ('Jones', 'Blake');

-- 18
/*Geef een lijst van de boeken met de gegevens van de uitgever (books.* en
publishers.*). Sorteer op bno.*/
SELECT *
FROM books
JOIN publishers ON books.pno = publishers.pno
ORDER BY bno;

-- 19
/*Geef een lijst van de boeken met de auteur(s) (books.* en authors.*). Sorteer op bno
en ano*/
SELECT books.*, AUTHORS.*
FROM books
JOIN booksauthors ON books.bno = booksauthors.bno
JOIN AUTHORS ON booksauthors.ano = AUTHORS.ano
ORDER BY books.bno, AUTHORS.ano;

-- 20
/*Geef een lijst van de boeken met de auteur(s) (books.* en authors.*). Weerhoud enkel
de boeken waarvoor de prijs maximaal 20 Euro is. Sorteer op bno en ano.*/
SELECT books.*, AUTHORS.*
FROM books
JOIN booksauthors ON books.bno = booksauthors.bno
JOIN AUTHORS ON booksauthors.ano = AUTHORS.ano
WHERE books.price <= 20
ORDER BY books.bno, AUTHORS.ano;

-- 21
/* Geef een lijst van de boeken met de auteur(s) (books.* en authors.*). Geef ook de
uitgevergegevens weer (publishers.*). Sorteer op bno en ano.*/
SELECT books.*, AUTHORS.*, publishers.*
FROM books
JOIN booksauthors ON books.bno = booksauthors.bno
JOIN AUTHORS ON booksauthors.ano = AUTHORS.ano
JOIN publishers ON books.pno = publishers.pno
ORDER BY books.bno, AUTHORS.ano;

-- 22
/*Geef alle uitgevers met de boeken die ze uitgegeven hebben (publishers.* en books.*).
Sorteer op pno.*/
SELECT *
FROM publishers
LEFT JOIN books ON publishers.pno = books.pno
ORDER BY publishers.pno;

-- 23
/*Geef de uitgevers die geen enkel boek hebben uitgegeven.*/
SELECT publishers.*
FROM publishers
LEFT JOIN books ON publishers.pno = books.pno
WHERE bno IS NULL
ORDER BY publishers.pno;

-- 24
/*Geef een lijst van de boeken met de gegevens van de uitgever (books.* en
publishers.*). Enkel de boeken waarvan de titel begint met ‘De’ worden weerhouden.
Sorteer op bno.*/
SELECT *
FROM books
JOIN publishers ON books.pno = publishers.pno
WHERE title LIKE 'De%'
ORDER BY bno;
