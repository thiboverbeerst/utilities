-- 3.6
# Which offices are in the same city? PLaats de vestigingen per 2
# en geef telkens de naam van de vestiging end de city.
SELECT o1.officename, o1.city, o2.officename, o2.city
FROM offices o1
JOIN offices o2 ON o1.city = o2.city
WHERE o1.officename < o2.officename #!!!!!!!!!!!!!!!!!!!!!!
ORDER BY o1.officename;

-- 3.16
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

-- 5.6
# Geef een lijst van de 10 meest verdienende werknemers.
SELECT *
FROM (SELECT * FROM employees ORDER BY salary DESC LIMIT 10) AS helper
ORDER BY empname;

-- 5.15
# Geef de artikels die zowel door D2 als door D3 zijn geleverd.
select *
from articles
where ano in (select ano from deliveries where dno = 'D2')
and ano in (select ano from deliveries where dno = 'D3')
order by aname;

-- 6.2
# Geef de gegevens van de werknemers die kunnen vervangen worden door een werknemer met een andere job.
# PAY ATTENTION ON WHAT I JOIN THE TWO TABLES!!!
SELECT *
FROM employees
WHERE empno IN (SELECT replacements.empno FROM replacements
                JOIN employees e on e.empno = replacements.replno
                WHERE employees.job NOT LIKE e.job)
ORDER BY empno;

-- 6.11
# Geef de gegevens van de drivers die voor elk project geleverd hebben
SELECT *
FROM drivers
WHERE (SELECT COUNT(*) FROM projects) = (SELECT COUNT(DISTINCT pno) FROM deliveries
                                            WHERE drivers.dno = deliveries.dno);

-- 10.9
select s1.*
# Geef per gender de studenten (students.*) die het minst betalen.
from students s1
where paid = (select min(paid) from students s2 where s1.gender = s2.gender)
order by gender, lname, fname;

-- 12.9 en 12.10
# verwijder FK en voeg FK opnieuw toe
alter table booksauthors
DROP FOREIGN KEY fk_bookno,
DROP FOREIGN KEY fk_auno;

alter table booksauthors
add CONSTRAINT fk_bookno FOREIGN KEY (bookno) references books(bookno),
add CONSTRAINT fk_auno FOREIGN KEY (auno) references authors(auno);

-- 13.11
# Geef de gegevens van de auto’s die wel hebben deelgenomen aan evenement 201502, maar niet aan evenement 201505.
SELECT *
FROM cars
WHERE carno IN (SELECT carno FROM carparticipations WHERE eventno = 201502)
AND carno NOT IN (SELECT carno FROM carparticipations WHERE eventno = 201505);

-- 13.12
# Geef de lidgegevens (members.*) en de autogegevens (cars.*) van de leden die een auto hebben
# waarvan de waarde meer bedraagt dan de helft van de totale waarde
# van alle auto’s van andere leden uit de city waar dit lid woont.
SELECT m1.*, c1.*
FROM members m1
JOIN cars c1 ON m1.memberno = c1.memberno
WHERE value > (select sum(VALUE)/2 FROM members
                JOIN cars ON members.memberno = cars.memberno
                where members.city = m1.city and m1.memberno != members.memberno)
order by m1.memberno, c1.carno;

-- 13.13
# Geef de leden die aan alle evenementen hebben deelgenomen.
SELECT members.*
FROM members
WHERE (SELECT COUNT(eventno) FROM EVENTS) = (SELECT COUNT( DISTINCT eventno) FROM members m2
                                            JOIN cars ON m2.memberno = cars.memberno
                                            JOIN carparticipations ON cars.carno = carparticipations.carno
                                            WHERE members.memberno = m2.memberno)
ORDER BY memberno;