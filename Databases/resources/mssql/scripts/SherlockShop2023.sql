--sherlockshop2023

use master
go
if exists (select * from sys.databases where name = 'sherlockshop2023')
begin
	alter database sherlockshop2023 set single_user with rollback immediate
	drop database sherlockshop2023
end
go
create database sherlockshop2023
go
use sherlockshop2023
go
create table categories(
cat_id		int identity not null,
category	nvarchar(50) not null,
constraint pk_categories primary key (cat_id)
) 
go
create table articles(
art_id		int identity not null,
cat_id		int not null,
article		nvarchar(50) not null,
description	nvarchar(500),
price		smallmoney,
instock		smallint,
constraint pk_articles primary key (art_id),
constraint fk_articles foreign key(cat_id) references categories(cat_id)
)
go
create table customers(
cust_id		int identity not null,
lastname	nvarchar(50) not null,
firstname	nvarchar(50) not null,
city		nvarchar(50),
birthdate	date,
deathdate	date,
constraint pk_customers primary key (cust_id)
) 
go
create table orders(
ord_id		int identity not null,
cust_id		int not null,
orderdate	date not null,
constraint pk_orders primary key(ord_id),
constraint fk_orders foreign key(cust_id) references customers(cust_id)
) 
go
create table orderdetails(
odet_id		int identity not null,
ord_id		int not null,
art_id		int not null,
amount		smallint not null,
constraint pk_orderdetails primary key(odet_id),
constraint fk1_orderdetails foreign key(ord_id) references orders(ord_id),
constraint fk2_orderdetails foreign key(art_id) references articles(art_id)
) 
go

INSERT INTO categories (category) VALUES ('Communication')
INSERT INTO categories (category) VALUES ('Extra')
INSERT INTO categories (category) VALUES ('General')
GO

INSERT INTO  articles (cat_id, article, description, price, instock) 
	VALUES (1, 'Communication Device', 'Small communication device in the shape of a pencil.', 49.99, 25)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (1, 'Fake Moustache Translator', 'This false moustache ensures that, through the use of advanced speech technology, your speech is translated into a language set by you.', 599.99, 2)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (1, 'Earrings Translator', 'These earrings translate spoken words into a language you desire so that you can understand foreign languages.', 459.99, 3)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (1, 'Cigar Laser', 'Laser pointer in the shape of a cigar, does not explode!', 29.99, 50)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (1, 'Persuasion Pencil', 'Point this pencil at your opponent in a discussion and convince him that you are right.', 1.99, 100)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (2, 'Anti Lying Liquid', 'One drop of this liquid on the victim''s nose and he will tell you no more lies.', 3.99, 80)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (2, 'Exchange Wallet', 'Place money in this wallet and close it. When it is opened again, you will have money in the local currency.', 12.50, 5)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (2, 'Identity Confusion Device', 'When a hostile person approaches you, put this device on, and he will not recognise you and will walk right past you.', 17.80, 1)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (3, 'Contact lenses', 'These lenses replace traditional binoculars and provide perfect vision up to 15km.', 13.75, 4)
INSERT INTO articles (cat_id, article, description, price, instock) 
	VALUES (3, 'Quick plasters', 'Put a quick plaster on a wound and after 10-30 min the wound is fully healed.', 3.99, 12)
GO

INSERT INTO customers (lastname, firstname, city, birthdate) 
	VALUES ('De Vlieger', 'Mehdi', 'Bruges', '1990-05-30')
INSERT INTO customers (lastname, firstname, city, birthdate) 
	VALUES ('Devadder', 'Mirwa', 'Ghent', '1988-07-16')
INSERT INTO customers (lastname, firstname, city, birthdate) 
	VALUES ('de Merode', 'Gert', 'Bruges', '1991-10-05')
INSERT INTO customers (lastname, firstname, city, birthdate) 
	VALUES ('Holmes', 'Sherlock', 'Ghent', '2000-02-06')
INSERT INTO customers (lastname, firstname, city, birthdate) 
	VALUES ('Averechts', 'Annie', 'Bruges', '1980-09-12')
INSERT INTO customers (lastname, firstname, city, birthdate) 
	VALUES ('De Fluisteraar', 'Charles', 'Ghent', NULL)
INSERT INTO customers (lastname, firstname, city, birthdate, deathdate) 
	VALUES ('Bond', 'James', 'Ghent', '1950-04-06', '2016-05-28')
GO

INSERT INTO orders (cust_id, orderdate) VALUES (3, '2018-01-02')
INSERT INTO orders (cust_id, orderdate) VALUES (2, '2018-01-02')
INSERT INTO orders (cust_id, orderdate) VALUES (4, '2018-01-02')
INSERT INTO orders (cust_id, orderdate) VALUES (5, '2017-01-03')
INSERT INTO orders (cust_id, orderdate) VALUES (2, '2018-01-12')
INSERT INTO orders (cust_id, orderdate) VALUES (3, '2018-01-13')
INSERT INTO orders (cust_id, orderdate) VALUES (4, '2018-01-15')
INSERT INTO orders (cust_id, orderdate) VALUES (4, '2018-01-16')
INSERT INTO orders (cust_id, orderdate) VALUES (5, '2018-02-02')
INSERT INTO orders (cust_id, orderdate) VALUES (2, '2018-02-04')
INSERT INTO orders (cust_id, orderdate) VALUES (3, '2018-02-25')
INSERT INTO orders (cust_id, orderdate) VALUES (4, '2018-03-20')
INSERT INTO orders (cust_id, orderdate) VALUES (2, '2018-03-20')
INSERT INTO orders (cust_id, orderdate) VALUES (3, '2018-03-21')
INSERT INTO orders (cust_id, orderdate) VALUES (1, '2018-03-23')
INSERT INTO orders (cust_id, orderdate) VALUES (1, '2018-04-01')
INSERT INTO orders (cust_id, orderdate) VALUES (2, '2018-04-01')
INSERT INTO orders (cust_id, orderdate) VALUES (1, '2018-04-02')
INSERT INTO orders (cust_id, orderdate) VALUES (7, '2015-11-30')
INSERT INTO orders (cust_id, orderdate) VALUES (7, '2015-12-01')
INSERT INTO orders (cust_id, orderdate) VALUES (7, '2015-12-02')
GO

INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (1, 1, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (1, 3, 4)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (1, 7, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (2, 1, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (2, 2, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (2, 9, 6)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (2, 10, 4)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (3, 3, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (3, 4, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (3, 8, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (3, 9, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (4, 2, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (5, 6, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (5, 7, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (6, 9, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (6, 10, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (7, 8, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (8, 3, 4)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (8, 5, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (8, 7, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (9, 8, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (10, 10, 4)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (11, 6, 7)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (11, 7, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (12, 2, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (12, 9, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (13, 4, 5)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (13, 5, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (13, 7, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (13, 10, 5)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (14, 5, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (15, 5, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (16, 2, 7)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (16, 5, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (17, 6, 5)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (17, 8, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (18, 6, 5)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (19, 6, 2)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (20, 8, 1)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (21, 6, 3)
INSERT INTO orderdetails (ord_id, art_id, amount) VALUES (21, 8, 1)
GO
