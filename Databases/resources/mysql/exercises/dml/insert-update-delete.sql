
-- 1
/*Voeg een driver toe: D6, Ackermans, 10, Bruges*/
insert into drivers (dno, dname, STATUS, city)
value ('D6', 'Ackermans', 10, 'Bruges');

-- 2
/*Verhoog de status van de drivers uit Bruges met 10.*/
update drivers
set STATUS = STATUS + 10
where city = 'Bruges';

-- 3
/*Voeg de werknemers (empno, empname) die werken in Computerland uit de databank
company toe aan de tabel drivers.*/
insert into drivers (dno, dname)
select empno, empname from company.employees where officename = 'Computerland';

-- 4
/*Plaats de status van de drivers die nog niets geleverd hebben op 0.*/
update drivers
set STATUS = 0
where dno NOT IN (select distinct dno from deliveries);

-- 5
/*Verwijder de drivers waarvan het dno niet begint met D*/
delete from drivers
where dno NOT LIKE 'D%';

-- 6
/*Stop de volgende gegevens in de databank. Het boek “Microsoft SQL Server 2016
Bible” (categorie Informatica), uitgegeven door “Wiley Publishing” uit Indianapolis op 9
juli 2016 en geschreven door Paul Nielsen, Mike White en Uttam Parui.
Geef na toevoeging, ter controle, een lijst van alle boeken met hun uitgever en
auteur(s): books.*, publishers.*, authors.*.
Tip: de functie LAST_INSERT_ID() levert de eerste automatisch gegenereerde waarde
van de meest recente INSERT.
Het is mogelijk deze waarde op te vangen in een variabele: SET @var =
LAST_INSERT_ID();*/
insert into publishers (publisher, city)
value ('Wiley Publishing', 'Indianapolis');
SET @pno = LAST_INSERT_ID();

insert into books (title, category, pno, pubdate)
value ('Microsoft SQL Server 2016 Bible', 'Informatica', @pno, '2016-07-09');
set @bno = last_insert_id();

insert into AUTHORS (fname, lname)
value ('Paul', 'Nielsen');
set @ano1 = last_insert_id();

insert into AUTHORS (fname, lname)
value ('Mike', 'White');
set @ano2 = last_insert_id();

insert into AUTHORS (fname, lname)
value ('Uttam', 'Parui');
set @ano3 = last_insert_id();

insert into booksauthors (bno, ano)
value (@bno, @ano1), (@bno, @ano2), (@bno, @ano3);


-- 7
/*De hometown van de auteur Stefan Hertmans moet gewijzigd worden in Antwerpen.
Vul tevens de hometown van Uttam Parui in: Indianapolis.*/
update AUTHORS
set hometown = 'Antwerp'
where fname = 'Stefan' and lname = 'Hertmans';

update AUTHORS
set hometown = 'Indianapolis'
where fname = 'Uttam' and lname = 'Parui';

-- 8
/*De prijs van boeken uit de categorie “Roman” die uitgegeven zijn bij
“Wereldbibliotheek” wordt verminderd met 10%. Let op: dit mag enkel gebeuren voor
de boeken die reeds 10 jaar of langer zijn uitgegeven. Houd hierbij enkel rekening met
uitgiftejaar en huidig jaar (dus niet met maand en dag van de uitgiftedatum en huidige
datum).*/
update books
set price = price * 0.9
where category = 'Roman'
and pno = (select pno from publishers where publisher = 'Wereldbibliotheek')
and year(current_date) - year(pubdate) >= 10;