
-- 1
/*Geef de gegevens van de alfabetisch eerste 5 JUNIOR-leden.*/
SELECT *
FROM members
WHERE membertype = 'JUNIOR'
ORDER BY membername
LIMIT 5;

-- 2
/*Geef de evenementen van het type TOERRIT of SHOW uit de maand augustus.
Sorteer op evenementnummer.*/
SELECT *
FROM EVENTS
where (eventtype IN ('TOERRIT', 'SHOW')) AND MONTH(eventdate) = 8
order by eventno;

-- 3
/*Geef het autonummer en de autonaam van de auto’s die toebehoren aan een JUNIOR-
lid en een waarde hebben van meer dan 2500. Sorteer volgens autonummer*/
SELECT carno, carname
FROM cars
WHERE memberno IN (SELECT memberno FROM members WHERE membertype = 'JUNIOR')  and VALUE > 2500
order by carno;

-- 4
/*Geef een overzicht van de evenementen van het type TOERRIT, en de auto’s die
eraan deelnemen. Toon het evenementnummer, de evenementnaam, het
autonummer, de autonaam en de naam van de eigenaar van de auto. Sorteer volgens
evenementnummer en daarbinnen volgens autonummer.*/
SELECT EVENTS.eventno, eventname, cars.carno, carname, membername
FROM EVENTS
JOIN carparticipations ON EVENTS.eventno = carparticipations.eventno
JOIN cars ON carparticipations.carno = cars.carno
JOIN members ON cars.memberno = members.memberno
WHERE eventtype = 'TOERRIT'
ORDER BY EVENTS.eventno, cars.carno;

-- 5
/*Wat is het totaal aantal passagiersplaatsen in de auto’s die deelnemen aan het
evenement met nummer 201502?*/
SELECT SUM(passengers)
FROM carparticipations
JOIN cars ON carparticipations.carno = cars.carno
WHERE eventno = '201502';

-- 6
/*Geef van alle evenementen het evenementnummer, het aantal auto’s dat aan dit
evenement deelneemt en de totale waarde van de deelnemende auto’s.*/
SELECT EVENTS.eventno, COUNT( DISTINCT carparticipations.carno), SUM(VALUE)
FROM EVENTS
JOIN carparticipations ON EVENTS.eventno = carparticipations.eventno
JOIN cars ON carparticipations.carno = cars.carno
GROUP BY EVENTS.eventno;

-- 7
/*Geef van alle leden alle gegevens en het aantal auto’s dat ze bezitten. Sorteer volgens
lidnummer.*/
select *, (select count(carno) from cars where members.memberno = cars.memberno) as ncars
from members
order by memberno;

-- 8
/*Geef van de leden die deelgenomen hebben aan evenementen, het lidnummer en de
som van de prijs van de evenementen waaraan ze deelnamen. Sorteer op lidnummer.*/
select members.memberno, sum(price)
from members
join cars on members.memberno = cars.memberno
join carparticipations on cars.carno = carparticipations.carno
join EVENTS on carparticipations.eventno = EVENTS.eventno
group by members.memberno
order by members.memberno;

-- 9
/*Geef de gegevens van de auto’s die aan geen enkel evenement deelnamen. Sorteer
volgens dalende value.*/
select *
from cars
where carno not in (select distinct carno from carparticipations)
order by VALUE desc;

-- 10
/*Geef de gegevens van de leden, die niet met één van hun auto’s aan het evenement
201501 deelnamen. Plaats eerst de JUNIOR-leden en daarna de SENIOR-leden.
Sorteer daarbinnen op lidnaam*/
select *
from members
where memberno not in (select memberno from cars
                        where carno in (select carno from carparticipations
                                        where eventno = '201501'))
order by membertype, membername;

-- 11
/*Geef de gegevens van de auto’s die wel hebben deelgenomen aan evenement
201502, maar niet aan evenement 201505. Sorteer volgens autonummer.*/
SELECT *
FROM cars
WHERE carno IN (SELECT carno FROM carparticipations WHERE eventno = 201502)
AND carno NOT IN (SELECT carno FROM carparticipations WHERE eventno = 201505);

-- 12
/*Geef de lidgegevens (members.*) en de autogegevens (cars.*) van de leden die een
auto hebben waarvan de waarde meer bedraagt dan de helft van de totale waarde van
alle auto’s van andere leden uit de city waar dit lid woont. Sorteer op lidnummer en
autonummer*/
SELECT m1.*, c1.*
FROM members m1
JOIN cars c1 ON m1.memberno = c1.memberno
WHERE value > (select sum(VALUE)/2 FROM members
                JOIN cars ON members.memberno = cars.memberno
                where members.city = m1.city and m1.memberno != members.memberno)
order by m1.memberno, c1.carno;

-- 13
/* Geef de leden die aan alle evenementen hebben deelgenomen. Sorteer op
lidnummer.*/
SELECT members.*
FROM members
WHERE (SELECT COUNT(eventno) FROM EVENTS) = (SELECT COUNT( DISTINCT eventno) FROM members m2
                                            JOIN cars ON m2.memberno = cars.memberno
                                            JOIN carparticipations ON cars.carno = carparticipations.carno
                                            WHERE members.memberno = m2.memberno)
ORDER BY memberno;