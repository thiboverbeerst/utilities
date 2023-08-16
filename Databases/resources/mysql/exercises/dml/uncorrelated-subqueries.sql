
-- 1
/*Geef de werknemers met het laagste salaris.*/
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 2
/*Geef de jobs die niet voorkomen in de tabel employees.*/
SELECT *
FROM jobs
WHERE job NOT IN (SELECT job FROM employees WHERE job IS NOT NULL );

-- 3
/*Geef de Analyst(en) die het meest verdienen.*/
SELECT *
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees WHERE job = 'Analyst')
AND job = 'Analyst';

-- 4
/*Geef per vestiging het aantal werknemers dat kan vervangen worden*/
SELECT officename, COUNT(empno)
FROM employees
WHERE empno IN (SELECT empno FROM replacements)
GROUP BY officename;

-- 5
/*Geef per vestiging het aantal werknemers dat niet vervangen kan worden*/
SELECT officename, COUNT(empno)
FROM employees
WHERE empno NOT IN (SELECT empno FROM replacements)
GROUP BY officename;

-- 6
/*Geef een lijst van de 10 meest verdienende werknemers. Sorteer deze lijst alfabetisch
op naam.*/
SELECT *
FROM (SELECT * FROM employees ORDER BY salary DESC LIMIT 10) AS helper
ORDER BY empname;

-- 7
/*Geef de artikels met het kleinste gewicht. Sorteer dalend volgens artikelnummer.*/
SELECT *
FROM articles
WHERE weight = (SELECT MIN(weight) FROM articles)
ORDER BY ano desc;

-- 8
/*Geef de projectgegevens van de projecten waarvoor reeds werd geleverd.*/
SELECT *
FROM projects
WHERE pno IN (SELECT pno FROM deliveries);

-- 9
/*Geef de projectgegevens van de projecten waarvoor nog niets werd geleverd*/
SELECT *
FROM projects
WHERE pno NOT IN (SELECT pno FROM deliveries);

-- 10
/*Geef de drivers met de hoogste status. Sorteer alfabetisch op naam.*/
SELECT *
FROM drivers
WHERE STATUS = (SELECT MAX(STATUS) FROM drivers)
ORDER BY dname;

-- 11
/*Geef de drivers waarvan de status beneden het gemiddelde ligt, samen met de artikels
die ze reeds leverden. Geef van deze drivers en hun geleverde artikels alle gegevens.
De leveringsgegevens zelf moeten niet weergegeven worden. Sorteer op
drivernummer en artikelnummer.*/
SELECT DISTINCT drivers.*, articles.*
FROM drivers
JOIN deliveries ON drivers.dno = deliveries.dno
JOIN articles ON deliveries.ano = articles.ano
WHERE STATUS < (SELECT AVG(STATUS) FROM drivers)
ORDER BY drivers.dno;

-- 12
/*Welke drivers die in Antwerp zijn gevestigd hebben nog niets geleverd?*/
SELECT *
FROM drivers
WHERE city = 'Antwerp'
AND dno NOT IN (SELECT dno FROM deliveries);

-- 13
/*Geef de projectgegevens van de projecten waarvoor driver D5 niets geleverd heeft*/
select *
from projects
WHERE pno NOT in (select pno from deliveries where dno = 'D5');

-- 14
/*Geef de drivers die meer dan 2 leveringen hebben gedaan. Sorteer alfabetisch op
naam.*/
select *
from drivers
where dno IN (select dno from deliveries group by dno having count(*) > 2)
order by dname;

-- 15
/*Geef de artikels die zowel door D2 als door D3 zijn geleverd. Sorteer alfabetisch op
artikelnaam.*/
select *
from articles
where ano in (select ano from deliveries where dno = 'D2')
and ano in (select ano from deliveries where dno = 'D3')
order by aname;

-- 16
/*. Welke artikels wegen zwaarder dan het gemiddelde gewicht en zijn meer dan 3 maal
geleverd?*/
select *
from articles
where weight > (select avg(weight) from articles)
and ano in (select ano from deliveries group by ano having count(*) > 3);

-- 17
/*Geef de drivers met een status groter dan de status van alle drivers uit Brussels.*/
select *
from drivers
where STATUS > (select MAX(STATUS) from drivers where city = 'Brussels');

-- 18
/*Geef de leveringen waarbij de city van het project waaraan geleverd wordt, Antwerp is
en de city van de driver uit de levering ook Antwerp is. Sorteer dalend op quantity.*/
select *
from deliveries
where pno in (select pno from projects where city = 'Antwerp')
and dno in (select dno from drivers where city = 'Antwerp');

-- 19
/*Welke uitgevers (publishers.*) hebben geen boek uitgegeven? Sorteer alfabetisch op
uitgeversnaam*/
select *
from publishers
where pno not in (select distinct pno from books)
order by publisher;

-- 20
/*Welke auteurs (authors.*) staan met meer dan 1 boek in de databank? Sorteer
alfabetisch op familienaam en voornaam.*/
select *
from AUTHORS
where ano in (select ano from booksauthors group by ano having count(bno) > 1)
order by lname, fname;

-- 21
/*Welke boeken (books.*) hebben meer dan 1 auteur? Sorteer alfabetisch op titel*/
select *
from books
where bno in (select bno from booksauthors group by bno having count(ano) > 1)
order by title;

-- 22
/*Geef de uitgevers (publishers.*) samen met de gegevens van de auteur(s) (authors.*)
die een boek bij hen uitgegeven hebben. Enkel de uitgevers die meer dan 1 boek
hebben uitgegeven worden weerhouden in de lijst. Sorteer op uitgever en naam van de
auteur.*/
select DISTINCT publishers.*, AUTHORS.*
from publishers
join books on publishers.pno = books.pno
join booksauthors on books.bno = booksauthors.bno
join AUTHORS on booksauthors.ano = AUTHORS.ano
where publishers.pno in (SELECT pno from books group by pno having count(bno) > 1)
order by publishers.publisher, AUTHORS.lname, AUTHORS.fname;