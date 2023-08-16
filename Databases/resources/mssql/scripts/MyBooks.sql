CREATE DATABASE MyBooks
GO
USE books
GO
CREATE TABLE authors (
  ano INT NOT NULL IDENTITY,
  lastname VARCHAR(50) DEFAULT NULL,
  firstname VARCHAR(50) DEFAULT NULL,
  birthdate DATE DEFAULT NULL,
  city VARCHAR(80) DEFAULT NULL,
  CONSTRAINT pk_authors PRIMARY KEY (ano)
)
GO
INSERT  INTO authors(lastname,firstname,birthdate,city) 
VALUES 	('Marai','Sandor','1900-04-11','San Diego'),
	('Hermsen','Joke','1961-05-25','Amsterdam'),
	('Müller','Herta','1953-06-04','Berlijn'),
	('Converse','Tim','1970-11-05','San Francisco'),
	('Park','Joyce','1975-07-22','San Francisco'),
	('Hertmans','Stefan','1955-07-15','Brussel'),
	('Hosseini','Khaled','1950-04-20','San Francisco'),
	('Yalom','Irvin','1952-05-06','San Francisco'),
	('de Rosnay','Tatiana','1963-09-15','Parijs'),
	('Duenas','Maria','1964-05-24','Madrid'),
	('Doerr','Anthony','1960-10-24','Boisse'),
	('De Pauw','Ivo','1955-03-20','Kortrijk'),
	('Masselis','Bieke','1973-01-05','Kortrijk'),
	('Verbeken','Pascal','1960-10-05','Brussel'),
	('Allende','Isabel','1945-06-10','San Francisco'),
	('Van Reybrouck','David','1971-10-04','Brussel')
GO
CREATE TABLE publishers (
  pno INT NOT NULL IDENTITY,
  publisher VARCHAR(80) DEFAULT NULL,
  city VARCHAR(80) DEFAULT NULL,
  CONSTRAINT pk_publishers PRIMARY KEY (pno)
) 
GO
INSERT  INTO publishers(publisher,city) 
VALUES	('Academic Service','Den Haag'),
	('De Geus','Breda'),
	('De Arbeiderspers','Utrecht'),
	('Wereldbibliotheek','Amsterdam'),
	('Lannoo','Tielt'),
	('De Bezige Bij','Amsterdam'),
	('Balans','Amsterdam'),
	('Artemis & co','Amsterdam'),
	('The house of books', 'Amsterdam'),
	('Manteau','Antwerpen')
GO
CREATE TABLE books (
  bno INT NOT NULL IDENTITY,
  title VARCHAR(100) DEFAULT NULL,
  category VARCHAR(50) DEFAULT NULL,
  pno INT DEFAULT NULL,
  price DECIMAL(8,2) DEFAULT NULL,
  pubdate DATE DEFAULT NULL,
  CONSTRAINT pk_books PRIMARY KEY (bno),
  CONSTRAINT fk1_books FOREIGN KEY (pno) REFERENCES publishers (pno)
) 
GO
INSERT  INTO books(title,category,pno,price,pubdate) 
VALUES 	('Ademschommel','Roman',2,'19.00','2009-08-05'),
	('PHP5 en MySQL','Informatica',1,'45.50','2006-10-30'),
	('Kairos. Een nieuwe bevlogenheid','Filosofie',3,'19.95','2014-02-01'),
	('Gloed','Roman',4,'16.50','2011-05-06'),
	('Hartedier','Roman',2,'19.00','2009-04-01'),
	('Oorlog en terpentijn','Roman',6,'19.00','2014-01-16'),
	('De vliegeraar','Roman',6,'19.00','2007-05-17'),
	('En uit de bergen kwam de echo','Roman',6,'19.00','2013-06-18'),
	('Nietzsches tranen','Roman',7,'19.90','2007-08-12'),
	('De therapeut','Roman',7,'19.90','1996-07-06'),
	('Haar naam was Sarah','Roman',8,'10.00','2009-03-22'),
	('Het geluid van de nacht','Roman',4,'12.00','2014-02-08'),
	('Als je het licht niet kunt zien','Roman',9,'12.00','2015-06-22'),
	('Wiskunde voor IT','Informatica',5,'25.00','2014-03-10'),
	('Fortunas dochter','Roman',4,'22.00','1999-06-04'),
	('Paula','Roman',4,'22.00','1994-05-26'),
	('Congo Een geschiedenis','Roman',6,'24.90','2010-09-08')
GO
CREATE TABLE booksauthors (
  bno INT NOT NULL,
  ano INT NOT NULL,
  CONSTRAINT pk_booksauthors PRIMARY KEY (bno,ano),
  CONSTRAINT fk1_booksauthors FOREIGN KEY (bno) REFERENCES books (bno),
  CONSTRAINT fk2_booksauthors FOREIGN KEY (ano) REFERENCES authors (ano)
) 
GO
INSERT  INTO booksauthors(bno,ano) 
VALUES 	(1,3),
	(2,4),
	(2,5),
	(3,2),
	(4,1),
	(5,3),
	(6,6),
	(7,7),
	(8,7),
	(9,8),
	(10,8),
	(11,9),
	(12,10),
	(13,11),
	(14,12),
	(14,13),
	(15,15),
	(16,15),
	(17,16)
GO

