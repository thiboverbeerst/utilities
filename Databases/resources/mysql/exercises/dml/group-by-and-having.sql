
-- 1
/*Hoeveel werknemers werken in Antwerp?*/
SELECT COUNT(DISTINCT empno)
FROM employees
JOIN offices ON employees.officename = offices.officename
WHERE city = 'Antwerp';

-- 2
/*Hoeveel werknemers met job Programmer zijn er in de vestiging Technica?*/
SELECT COUNT(DISTINCT empno)
FROM employees
WHERE officename = 'Technica' AND job = 'Programmer';

-- 3
/*Wat is het gemiddelde salaris van de werknemers met job Analyst? Rond wiskundig af
op 0 decimalen.*/
SELECT SUM(salary)
FROM employees
JOIN offices ON employees.officename = offices.officename
WHERE sector = 'Training';

-- 4
/*Wat is het totale salaris van de werknemers uit de sector Training?*/


-- 5
/*Geef voor elke job het laagste salaris en het hoogste salaris dat wordt uitbetaald aan
een werknemer.*/
SELECT job, MIN(salary), MAX(salary)
FROM employees
WHERE job IS NOT NULL
GROUP BY job;

-- 6
/*Welke werknemers (geef het empno) kunnen door 2 of meer werknemers vervangen
worden?*/
SELECT empno, COUNT(replno)
FROM replacements
GROUP BY empno
HAVING COUNT(replno) >= 2;

-- 7
/*Geef per job het aantal werknemers.*/
SELECT job, COUNT(empno)
FROM employees
GROUP BY job;

-- 8
/*Geef per sector het aantal werknemers met een salaris tussen 50000 en 100000.*/
SELECT sector, COUNT(empno)
FROM offices
JOIN employees ON offices.officename = employees.officename
WHERE salary BETWEEN 50000 AND 100000
GROUP BY sector;

-- 9
/*Geef per city het aantal werknemers dat overbetaald wordt (meer verdient dan het
overeenkomstige maximumsalaris).*/
SELECT city, COUNT(DISTINCT empno)
FROM employees
JOIN offices ON employees.officename = offices.officename
JOIN jobs ON employees.job = jobs.job
WHERE salary > jobs.maxsal
GROUP BY city;

-- 10
/*Geef per sector het gemiddelde salaris. Rond wiskundig af op 0 decimalen. Sorteer op
het gemiddelde*/
SELECT sector, ROUND(AVG(salary), 0) AS average
FROM employees
JOIN offices ON employees.officename = offices.officename
GROUP BY sector
ORDER BY average;

-- 11
/*Geef het aantal artikels waarvan de quality 1 is. Geef eveneens het totale gewicht van
deze artikels.*/
SELECT COUNT(ano), SUM(weight)
FROM articles
WHERE quality = 1;

-- 12
/*Geef het aantal verschillende waarden die in de kolom quality van de tabel articles
voorkomen*/
SELECT count(distinct quality)
FROM articles;

-- 13
/*Geef het aantal projecten waaraan driver D1 artikels heeft geleverd.*/
select COUNT(DISTINCT pno)
from deliveries
WHERE dno = 'D1';

-- 14
/*Geef het aantal leveringen per driver.*/
SELECT dno, COUNT(*)
FROM deliveries
GROUP BY dno;

-- 15
/*Geef de totale hoeveelheid (quantity) artikels dat per project wordt geleverd.*/
SELECT pno, SUM(quantity)
FROM deliveries
GROUP BY pno;

-- 16
/*Met uitzondering van de leveringen door driver D1, geef voor ieder geleverd artikel het
artikelnummer en de totale hoeveelheid dat voor dat artikel is geleverd.*/
SELECT ano, SUM(quantity)
FROM deliveries
WHERE dno != 'D1'
GROUP BY ano;

-- 17
/*Welke artikels (ano) worden aan meerdere projecten geleverd?*/
SELECT ano, COUNT(DISTINCT pno)
FROM deliveries
GROUP BY ano
HAVING COUNT(DISTINCT pno) > 1;

-- 18
/*Geef de drivers (dno) waarvan de leveringen een gemiddelde quantity hebben van
meer dan 300 eenheden.*/
SELECT dno, AVG(quantity)
FROM deliveries
GROUP BY dno
HAVING AVG(quantity) > 300;

-- 19
/*Geef de drivers (dno en dname) met minstens 2 leveringen van artikel A1.*/
SELECT deliveries.dno, dname, COUNT(*) AS counterA1
FROM deliveries
JOIN drivers ON deliveries.dno = drivers.dno
WHERE ano = 'A1'
GROUP BY deliveries.dno, dname
HAVING COUNT(*) >= 2;

-- 20
/*Geef nummer en naam van de driver en het artikelnummer waarvoor de driver het
artikel minstens 3 keer leverde.*/
SELECT drivers.dno, dname, ano, COUNT(*)
FROM deliveries
JOIN drivers ON deliveries.dno = drivers.dno
GROUP BY drivers.dno, dname, ano
HAVING COUNT(*) >= 3;

-- 21
/*Geef per categorie boeken de gemiddelde prijs. Rond de gemiddelde prijs af op 2
decimalen. Sorteer volgens stijgende gemiddelde prijs.*/
SELECT category, round(avg(price), 2) as average
FROM books
GROUP BY category
ORDER BY average;

-- 22
/*Geef per hometown het aantal auteurs. Sorteer alfabetisch op hometown*/
SELECT hometown, COUNT(ano)
FROM AUTHORS
GROUP BY hometown
ORDER BY hometown;

-- 23
/* Geef per uitgever (pno, publisher) het aantal boeken uit de categorie Roman dat hij
uitgegeven heeft.*/
SELECT publishers.pno, publisher, COUNT(bno)
FROM publishers
JOIN books ON publishers.pno = books.pno
WHERE category = 'Roman'
GROUP BY publishers.pno, publisher;

-- 24
/*Geef de boeken die ten hoogste 10 jaar geleden werden uitgegeven. Sorteer op titel.*/
SELECT *
FROM books
WHERE YEAR(pubdate) > (YEAR(CURRENT_DATE()) - 10)
ORDER BY title;

-- 25
/*Geef een alfabetische lijst van de auteurs die dit jaar een leeftijd hebben die deelbaar
is door 5 (bijvoorbeeld 45, 50, ...)*/
SELECT *
FROM AUTHORS
WHERE MOD((YEAR(CURDATE()) - YEAR(birthdate)), 5) = 0
ORDER BY lname, fname;