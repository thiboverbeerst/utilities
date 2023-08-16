
-- 1
/*Maak een databank mylibrary met de onderstaande structuur. Geef aan elke kolom
een gepast type en definieer de nodige constraints.
books (bookno, title, subtitle, language, pubno)
publishers (pubno, pubname, pubcity, pubcountry)
booksauthors (bookno, auno)
authors (auno, firstname, lastname, city, country, birthdate)
editions (bookno, edno, month, year)*/
CREATE DATABASE mylibrary;

CREATE TABLE publishers (
    pubno INT AUTO_INCREMENT NOT NULL,
    pubname VARCHAR(100) NOT NULL UNIQUE,
    pubcity VARCHAR(100),
    pubcountry VARCHAR(100),
    PRIMARY KEY (pubno)
) ENGINE = INNODB;

CREATE TABLE books (
    bookno INT AUTO_INCREMENT NOT NULL,
    title VARCHAR(100) NOT NULL,
    subtitle VARCHAR(100),
    language VARCHAR(50),
    pubno INT,
    primary key (bookno),
    CONSTRAINT fk_books FOREIGN KEY (pubno) references publishers(pubno)
) ENGINE = INNODB;

CREATE TABLE authors (
    auno INT AUTO_INCREMENT NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    birthdate date,
    PRIMARY KEY (auno)
) ENGINE = INNODB;

CREATE TABLE booksauthors (
    bookno INT NOT NULL,
    auno INT not null,
    PRIMARY KEY (bookno, auno),
    CONSTRAINT fk_bookno FOREIGN KEY (bookno) references books(bookno),
    CONSTRAINT fk_auno FOREIGN KEY (auno) references authors(auno)
) ENGINE = INNODB;

CREATE TABLE editions (
    bookno INT not null,
    edno INT NOT NULL,
    month int,
    year int,
    PRIMARY KEY (bookno, edno),
    CONSTRAINT fk_editions FOREIGN KEY (bookno) references books(bookno)
) ENGINE = INNODB;

-- 2
/*Geef minimaal de volgende gegevens in:
Boek: Professional C#, taal: English, uitgegeven bij Wrox, geschreven door Christian
Nagel (San Francisco, USA, 24/12/1970), Bill Evjen (San Francisco, USA, 20/12/1980)
en Jay Glynn (San Francisco, USA, 24/01/1975).
Tips:
- De functie LAST_INSERT_ID() levert de eerste automatisch gegenereerde waarde
van de meest recente INSERT.
- Het is mogelijk deze waarde op te vangen in een variabele: SET @var =
LAST_INSERT_ID();*/
INSERT INTO publishers (pubname)
VALUE ('Wrox');
SET @pubno = LAST_INSERT_ID();

INSERT INTO books (title, language, pubno)
VALUE ('Professional C#', 'English', @pubno);
SET @bookno = LAST_INSERT_ID();

INSERT INTO authors (firstname, lastname, city, country, birthdate)
VALUE ('Christian', 'Nagel', 'San Francisco', 'USA', '1970-12-24');
SET @ano1 = LAST_INSERT_ID();

INSERT INTO authors (firstname, lastname, city, country, birthdate)
VALUE ('Bill', 'Evjen', 'San Francisco', 'USA', '1980-12-20');
SET @ano2 = LAST_INSERT_ID();

INSERT INTO authors (firstname, lastname, city, country, birthdate)
VALUE ('Jay', 'Glynn', 'San Francisco', 'USA', '1975-01-24');
SET @ano3 = LAST_INSERT_ID();

INSERT INTO booksauthors (bookno, auno)
value (@bookno, @ano1), (@bookno, @ano2), (@bookno, @ano3);

-- 3
/*Geef een overzicht van de boeken met de auteurs en de gegevens van de uitgever.*/
select books.*, authors.*, publishers.*
from books
join booksauthors on books.bookno = booksauthors.bookno
join authors on booksauthors.auno = authors.auno
join publishers on books.pubno = publishers.pubno;

-- 4
/*Verwijder de auteur Bill Evjen.
Wat stel je vast? Verklaar*/
ALTER TABLE books
ADD pubdate DATE;

ALTER TABLE authors
ADD gender CHAR;

-- 5
/*Voeg aan de tabel books een kolom pubdate toe.
Voeg aan de tabel authors een kolom gender toe*/
ALTER TABLE authors
ALTER gender SET default 'M';

-- 6
/*Geef aan de zojuist toegevoegde kolom gender een defaultwaarde ‘M’*/
ALTER TABLE authors
CHANGE gender gnd CHAR DEFAULT 'M';

-- 7
/*Wijzig de naam van de kolom gender in gnd*/

-- 8
/*Wijzig het type van de kolom gnd: een tekstveld van 10 tekens (defaultwaarde ‘Man’).*/
ALTER TABLE authors
change gnd gnd VARCHAR(10) DEFAULT 'Man';

-- 9
/*Verwijder in de tabel booksauthors de vreemde sleutels.*/
alter table booksauthors
DROP FOREIGN KEY fk_bookno,
DROP FOREIGN KEY fk_auno;

-- 10
/*Voeg in de tabel booksauthors de vreemde sleutels toe*/
alter table booksauthors
add CONSTRAINT fk_bookno FOREIGN KEY (bookno) references books(bookno),
add CONSTRAINT fk_auno FOREIGN KEY (auno) references authors(auno);

-- 11
/*Verwijder de tabel publishers.
Wat stel je vast? Verklaar*/
drop table publishers;