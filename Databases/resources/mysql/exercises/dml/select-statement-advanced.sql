
-- 1
/*Geef een alfabetische lijst van de bieren waarvan het alcoholpercentage tussen 6 en 8
ligt (grenzen inbegrepen) en waarvan de naam begint met ‘Cuvee’ of met ‘St.’*/
SELECT *
FROM beers
WHERE alcohol BETWEEN 6 and 8
AND (bname LIKE 'Cuvee%' OR bname LIKE 'St.%')
ORDER BY bname;

-- 2
/*Geef een lijst van de brouwers uit West-Vlaanderen (postcode tussen 8000 en 8999)
met de bieren die ze brouwen. Sorteer op brouwernaam en daarbinnen op biernaam.*/
SELECT *
from brewers
JOIN beers ON brewers.brewerno = beers.brewerno
where zip BETWEEN 8000 AND 8999
ORDER BY brname, bname;

-- 3
/*Geef van de levende personen die ouder zijn dan 45 jaar, de bieren die ze proefden en
hun opmerkingen. Geef weer: persons.*, beertasters.*, beers.*. Sorteer op personno.*/
Select *
from persons
JOIN beertasters ON persons.personno = beertasters.personno
JOIN beers ON beertasters.beerno = beers.beerno
where year(current_date()) - year(birthdate) > 45 AND deathdate IS NULL
ORDER BY persons.personno;

-- 4
/*Geef van alle personen uit de databank, de bieren die ze proefden en hun
opmerkingen.
Let op: ook de personen uit de databank die nog geen bieren proefden, moeten in de
lijst voorkomen.
Zorg dat de volgende gegevens weergegeven worden:
het persoonsnummer, de naam en het geslacht van de persoon,
de biernaam en het alcoholpercentage,
de naam van het biertype,
en de opmerkingen.
Sorteer op persoonsnaam*/
SELECT persons.personno, pname, gender, bname, alcohol, beertype, remarks
FROM persons
LEFT JOIN beertasters ON persons.personno = beertasters.personno
left JOIN beers ON beertasters.beerno = beers.beerno
LEFT JOIN beertypes ON beers.typeno = beertypes.typeno
order by pname;

-- 5
/*Geef voor elk biertype: de naam van het biertype, het aantal bieren binnen dit biertype
en het gemiddelde alcoholpercentage van de bieren binnen dit biertype. Rond het
gemiddelde alhoholpercentage af op 1 decimaal.*/
SELECT beertype, (SELECT COUNT(beerno) FROM beers WHERE beertypes.typeno = beers.typeno) AS counter,
       (SELECT ROUND(Avg(alcohol), 1) FROM beers WHERE beertypes.typeno = beers.typeno) AS average
FROM beertypes;

-- 6
/*Geef de bieren met het hoogste alcoholpercentage binnen hun type.
Geef de volgende kolommen weer: het biertype, de biernaam en het
alcoholpercentage.
Sorteer op biertype.*/
SELECT beertype, bname, alcohol
FROM beers b1
JOIN beertypes on b1.typeno = beertypes.typeno
WHERE alcohol = (select max(alcohol) from beers b2 where b1.typeno = b2.typeno)
ORDER BY beertype;

-- 7
/*Geef de gegevens van de bieren waarvoor nog geen opmerkingen werden ingegeven*/
select *
from beers
where beerno not in (select distinct beerno from beertasters);

-- 8
/*Geef de gegevens van de brouwers (brewers.*) die meer dan 20 bieren brouwen*/
select brewers.*
from brewers
where 20 < (select count(beerno) from beers where brewers.brewerno = beers.brewerno);

-- 9
/*Geef de gegevens van de brouwers (brewers.*) met een omzet (turnover) die groter is
dan de gemiddelde omzet (turnover). Sorteer zodat de brouwers met de grootste
omzet (turnover) bovenaan de lijst staan.*/
select *
from brewers
where turnover > (select avg(turnover) from brewers)
order by turnover desc;

-- 10
/*Geef de top 10 van de brouwers (brewers.*) met het meeste aantal bieren. Geef ook
het aantal bieren weer.*/
select *, (select count(beerno) from beers where brewers.brewerno = beers.brewerno) as counter
from brewers
order by counter desc
limit 10;
