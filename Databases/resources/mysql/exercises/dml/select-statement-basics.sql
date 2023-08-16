
-- 1
/*Welke vestigingen (offices) zijn gelokaliseerd in Antwerp? Sorteer alfabetisch volgens
vestigingsnaam.*/
SELECT *
FROM offices
WHERE city LIKE 'Antwerp'
ORDER BY officename;

-- 2
/*Door wie (geef replno) kunnen de werknemers 5, 8 en 9 vervangen worden?*/
SELECT DISTINCT replno
FROM replacements
WHERE empno = 5 OR empno = 8 OR empno = 9;

-- 3
/*Geef een lijst van de 10 meest verdienende werknemers.*/
select *
from employees
order by salary desc
limit 10;

-- 4
/*Geef alle vestigingen in alfabetische volgorde met in hun naam het woord ‘computer’*/
select *
from offices
where officename like '%computer%';

-- 5
/*Geef nummer en naam van de werknemers die ofwel Programmer ofwel Teacher zijn
en meer verdienen dan 60000.*/
SELECT empno, empname
FROM employees
WHERE (job LIKE 'Programmer' OR job LIKE 'Teacher') AND salary > 60000;

-- 6
/*Geef de naam van alle vestigingen met in de 6de positie de letter t*/
SELECT officename
FROM offices
WHERE officename LIKE '_____t%';

-- 7
/*Van welke werknemer(s) is de afdeling onbekend?*/
SELECT *
FROM employees
WHERE division IS NULL;

-- 8
/*Van welke werknemer(s) is de afdeling bekend?*/
SELECT *
FROM employees
WHERE division IS NOT NULL;

-- 9
/*Geef een overzicht van alle vestigingen die niet gelegen zijn in Brussels of Antwerp.
Geef dit overzicht in stijgende volgorde van city en binnen city in dalende volgorde van
vestigingsnaam.*/
SELECT *
FROM offices
WHERE city NOT LIKE 'Brussels' AND city NOT LIKE 'Antwerp'
ORDER BY city ASC, officename DESC;

-- 10
/*Geef een lijst van de artikelnummers die geleverd werden.*/

-- 11
/* Geef de drivers gevestigd in Brussels, met een status groter dan 10, in alfabetische
volgorde*/


-- 12
/* Geef de artikels met een gewicht tussen 5 en 30 (inclusief de grenswaarden) in
stijgende volgorde van artikelnummer*/
SELECT *
FROM articles
WHERE weight BETWEEN 5 AND 30
ORDER BY ano;

-- 13
/*Geef nummer, naam en gewicht van de artikels A1, A2 en A4.*/


-- 14
/* Geef een alfabetische lijst van de projecten. Beperk de lijst tot de eerste 5 rijen.*/

-- 15
/*Geef de artikels opgeslagen in Brussels, waarvan het gewicht onbekend is*/

-- 16 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/* Geef de artikels waarvan de naam begint met de letter B of C in stijgende volgorde van
artikelnaam.*/
SELECT *
FROM articles
WHERE aname LIKE 'B%' OR aname LIKE 'C%'
ORDER BY aname;

-- 17
/* Geef een alfabetische lijst van de boeken uit de categorie ‘Roman’ waarvan de prijs 19
Euro is of meer.*/


-- 18
/*Geef de 10 ‘oudste’ boeken (volgens publicatiedatum)*/


-- 19
/*Geef een lijst van de boeken uit de categorieën ‘Informatica’ en ‘Filosofie’. Sorteer de
lijst eerst op categorie en binnen elke categorie op titel*/


-- 20
/*Geef een alfabetische lijst van de auteurs die in San Francisco wonen en geboren zijn
tussen 1950 (inbegrepen) en 1970 (niet inbegrepen).*/
SELECT *
FROM AUTHORS
WHERE hometown LIKE 'San Francisco' AND YEAR(birthdate) >= 1950 AND YEAR(birthdate) < 1970
ORDER BY lname, fname;


-- 21
/*Geef een alfabetische lijst van de steden waar een uitgever gevestigd is. Zorg dat de
lijst beperkt wordt tot de steden waarvan de naam begint met de letter A.*/
SELECT DISTINCT city
FROM publishers
WHERE city LIKE 'A%';