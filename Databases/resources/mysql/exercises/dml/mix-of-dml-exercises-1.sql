

-- 1
/* Geef een lijst van de mannelijke studenten waarvan de familienaam begint met de
letter B. Sorteer op familienaam en voornaam.*/
SELECT *
FROM students
WHERE lname LIKE 'B%'
ORDER BY lname, fname;

-- 2
/*Geef een lijst van de studenten die geboren zijn in de huidige maand. Sorteer op het
geboortejaar. Indien het geboortejaar hetzelfde is, sorteer dan op geboortedag. */
SELECT *
FROM students
WHERE MONTH(current_date()) = MONTH(birthdate)
ORDER BY year(birthdate), DAY(birthdate);

-- 3
/*Geef een overzicht van de studenten met de cursussen die ze volgen. Toon per
student: studentno, lname, fname, courseno en coursename. Sorteer stijgend op
lname, fname en courseno*/
select students.studentno, lname, fname, courses.courseno, coursename
from students
join registrations on students.studentno = registrations.studentno
join courses on registrations.courseno = courses.courseno
order by lname, fname, courses.courseno;

-- 4
/*Idem vorige vraag, maar zorg ervoor dat ook de studenten getoond worden die geen
enkele cursus volgen.*/
select students.studentno, lname, fname, courses.courseno, coursename
from students
left join registrations on students.studentno = registrations.studentno
left join courses on registrations.courseno = courses.courseno
order by lname, fname, courses.courseno;

-- 5
/*Hoeveel studenten volgen de cursus C#?*/
select count(studentno)
from registrations
where courseno = (select courseno from courses where coursename = 'C#');

-- 6
/*Hoeveel mannelijke studenten zijn er en hoeveel vrouwelijke? Er worden 2 kolommen
weergegeven: een kolom gender en een kolom counter*/
select gender, count(studentno)
from students
group by gender;

-- 7
/*Geef alle gegevens van elke student (students.*) en geef per student ook wat zou
moeten betaald worden volgens de cursussen die gevolgd worden (voor elke cursus
moet fee betaald worden). Sorteer alfabetisch op lname en fname*/
select students.*, (select sum(fee) from registrations
                    join courses on registrations.courseno = courses.courseno
                    where students.studentno = registrations.studentno) as sumfee
from students
order by lname, fname;

-- 8
/*Geef de studenten (students.*) die een naamgenoot hebben in de school. Een
naamgenoot is een persoon met dezelfde familienaam. Sorteer de naamgenoten
alfabetisch op familienaam en voornaam. Zorg dat geen 2 (of meer) keer dezelfde
informatie getoond wordt*/
select distinct s1.*
from students s1
where lname IN (select distinct lname from students s2 where s1.studentno != s2.studentno)
order by lname, fname;

-- 9
/*Geef per gender de studenten (students.*) die het minst betalen. Sorteer volgens
gender en daarbinnen op lname en fname.*/
select s1.*
from students s1
where paid = (select min(paid) from students s2 where s1.gender = s2.gender)
order by gender, lname, fname;

-- 10
/* Welke studenten (students.*) volgen alle aangeboden cursussen? Sorteer alfabetisch.*/
select *
from students
where (select count(courseno) from courses) = (select count(courseno) from registrations
                                                where students.studentno = registrations.studentno)
order by lname, fname;

-- 11
/*Geef per cursus (courses.*) het aantal studenten dat de cursus volgt. Sorteer op
courseno*/
select *, (select count(studentno) from registrations where courses.courseno = registrations.courseno) as counter
from courses
order by courseno;

-- 12
/*Geef per cursus (courses.*) het aantal studenten dat de cursus volgt. Toon enkel de
cursussen met meer dan 3 studenten. Sorteer op courseno.*/
select *, (select count(studentno) from registrations where courses.courseno = registrations.courseno) as counter
from courses
where (select count(studentno) from registrations where courses.courseno = registrations.courseno)  > 3
order by courseno;

-- 13
/* Geef de cursussen waarvoor geen vrouwen zijn ingeschreven. Sorteer op courseno.*/
select courses.*
from courses
where courseno not in (select courseno from registrations
                        join students on registrations.studentno = students.studentno
                        where gender = 'V')
order by courseno;

-- 14
/*Verwijder de student met nummer 10. Indien deze student inschrijvingen heeft, worden
deze ook verwijderd*/

-- 15
/*Verwijder de studenten die geen enkele cursus volgen.*/

-- 16
/*Voeg de nieuwe cursus MySQL toe (fee 120 Euro). Schrijf de student met nummer 4 in
voor deze cursus. Ook de nieuwe student Peter Decorte, geboren op 22 november
1997 schrijft zich in voor deze nieuwe cursus en heeft 120 Euro betaald.*/


-- 17
/* Wijzig de kolom paid voor de student met nummer 4. Deze student heeft de fee voor
alle cursussen waarvoor hij ingeschreven is, betaald*/