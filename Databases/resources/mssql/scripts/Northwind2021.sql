/************************************************
 * Northwind2021
 ************************************************/

USE master
GO
DROP DATABASE IF EXISTS Northwind2021
GO
CREATE DATABASE Northwind2021
GO
/* Set DATEFORMAT so that the date strings are interpreted correctly regardless of
   the default DATEFORMAT on the server.
*/
SET DATEFORMAT mdy
GO
USE Northwind2021
GO
CREATE TABLE Employees (
	EmployeeID int IDENTITY (1, 1) NOT NULL ,
	LastName nvarchar (20) NOT NULL ,
	FirstName nvarchar (10) NOT NULL ,
	Title nvarchar (30) NULL ,
	TitleOfCourtesy nvarchar (25) NULL ,
	BirthDate date NULL ,
	HireDate date NULL ,
	Address nvarchar (60) NULL ,
	City nvarchar (15) NULL ,
	Region nvarchar (15) NULL ,
	PostalCode nvarchar (10) NULL ,
	Country nvarchar (15) NULL ,
	HomePhone nvarchar (24) NULL ,
	Extension nvarchar (4) NULL ,
	Notes nvarchar(max) NULL ,
	CONSTRAINT PK_Employees PRIMARY KEY  CLUSTERED (EmployeeID),
	CONSTRAINT CK_Birthdate CHECK (BirthDate < getdate())
)
GO

CREATE TABLE Categories (
	CategoryID int IDENTITY (1, 1) NOT NULL ,
	CategoryName nvarchar (15) NOT NULL ,
	Description nvarchar(max) NULL ,
	CONSTRAINT PK_Categories PRIMARY KEY  CLUSTERED (CategoryID)
)
GO

CREATE TABLE Customers (
	CustomerID nchar (5) NOT NULL ,
	CompanyName nvarchar (40) NOT NULL ,
	ContactName nvarchar (30) NULL ,
	ContactTitle nvarchar (30) NULL ,
	Address nvarchar (60) NULL ,
	City nvarchar (15) NULL ,
	Region nvarchar (15) NULL ,
	PostalCode nvarchar (10) NULL ,
	Country nvarchar (15) NULL ,
	Phone nvarchar (24) NULL ,
	Fax nvarchar (24) NULL ,
	CONSTRAINT PK_Customers PRIMARY KEY  CLUSTERED (CustomerID)
)
GO

CREATE TABLE Suppliers (
	SupplierID int IDENTITY (1, 1) NOT NULL ,
	CompanyName nvarchar (40) NOT NULL ,
	ContactName nvarchar (30) NULL ,
	ContactTitle nvarchar (30) NULL ,
	Address nvarchar (60) NULL ,
	City nvarchar (15) NULL ,
	Region nvarchar (15) NULL ,
	PostalCode nvarchar (10) NULL ,
	Country nvarchar (15) NULL ,
	Phone nvarchar (24) NULL ,
	Fax nvarchar (24) NULL ,
	HomePage nvarchar(max) NULL ,
	CONSTRAINT PK_Suppliers PRIMARY KEY  CLUSTERED (SupplierID)
)
GO

CREATE TABLE Orders (
	OrderID int IDENTITY (1, 1) NOT NULL ,
	CustomerID nchar (5) NULL ,
	EmployeeID int NULL ,
	OrderDate date NULL ,
	RequiredDate date NULL ,
	ShippedDate date NULL ,
	CONSTRAINT PK_Orders PRIMARY KEY  CLUSTERED (OrderID),
	CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers (CustomerID),
	CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees (EmployeeID)
)
GO

CREATE TABLE Products (
	ProductID int IDENTITY (1, 1) NOT NULL ,
	ProductName nvarchar (40) NOT NULL ,
	SupplierID int NULL ,
	CategoryID int NULL ,
	QuantityPerUnit nvarchar (20) NULL ,
	UnitPrice money NULL CONSTRAINT DF_Products_UnitPrice DEFAULT (0),
	UnitsInStock smallint NULL CONSTRAINT DF_Products_UnitsInStock DEFAULT (0),
	UnitsOnOrder smallint NULL CONSTRAINT DF_Products_UnitsOnOrder DEFAULT (0),
	ReorderLevel smallint NULL CONSTRAINT DF_Products_ReorderLevel DEFAULT (0),
	Discontinued bit NOT NULL CONSTRAINT DF_Products_Discontinued DEFAULT (0),
	CONSTRAINT PK_Products PRIMARY KEY  CLUSTERED (ProductID),
	CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Categories (CategoryID),
	CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers (SupplierID),
	CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
	CONSTRAINT CK_ReorderLevel CHECK (ReorderLevel >= 0),
	CONSTRAINT CK_UnitsInStock CHECK (UnitsInStock >= 0),
	CONSTRAINT CK_UnitsOnOrder CHECK (UnitsOnOrder >= 0)
)
GO

CREATE TABLE OrderDetails (
	OrderID int NOT NULL ,
	ProductID int NOT NULL ,
	UnitPrice money NOT NULL CONSTRAINT DF_Order_Details_UnitPrice DEFAULT (0),
	Quantity smallint NOT NULL CONSTRAINT DF_Order_Details_Quantity DEFAULT (1),
	Discount real NOT NULL CONSTRAINT DF_Order_Details_Discount DEFAULT (0),
	CONSTRAINT PK_Order_Details PRIMARY KEY  CLUSTERED (OrderID, ProductID),
	CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders (OrderID),
	CONSTRAINT FK_Order_Details_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products (ProductID),
	CONSTRAINT CK_Discount CHECK (Discount >= 0 and (Discount <= 1)),
	CONSTRAINT CK_Quantity CHECK (Quantity > 0),
	CONSTRAINT CK_UnitPrice CHECK (UnitPrice >= 0)
)
GO

set identity_insert Categories on
go
INSERT Categories(CategoryID,CategoryName,Description) VALUES(1,'Beverages','Soft drinks, coffees, teas, beers, and ales')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(2,'Condiments','Sweet and savory sauces, relishes, spreads, and seasonings')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(3,'Confections','Desserts, candies, and sweet breads')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(4,'Dairy Products','Cheeses')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(5,'Grains/Cereals','Breads, crackers, pasta, and cereal')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(6,'Meat/Poultry','Prepared meats')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(7,'Produce','Dried fruit and bean curd')
INSERT Categories(CategoryID,CategoryName,Description) VALUES(8,'Seafood','Seaweed and fish')
go
set identity_insert Categories off

go
INSERT Customers VALUES('ALFKI','Alfreds Futterkiste','Maria Anders','Sales Representative','Obere Str. 57','Berlin',NULL,'12209','Germany','030-0074321','030-0076545')
INSERT Customers VALUES('ANATR','Ana Trujillo Emparedados y helados','Ana Trujillo','Owner','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico','(5) 555-4729','(5) 555-3745')
INSERT Customers VALUES('ANTON','Antonio Moreno Taquería','Antonio Moreno','Owner','Mataderos  2312','México D.F.',NULL,'05023','Mexico','(5) 555-3932',NULL)
INSERT Customers VALUES('AROUT','Around the Horn','Thomas Hardy','Sales Representative','120 Hanover Sq.','London',NULL,'WA1 1DP','UK','(171) 555-7788','(171) 555-6750')
INSERT Customers VALUES('BERGS','Berglunds snabbköp','Christina Berglund','Order Administrator','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden','0921-12 34 65','0921-12 34 67')
INSERT Customers VALUES('BLAUS','Blauer See Delikatessen','Hanna Moos','Sales Representative','Forsterstr. 57','Mannheim',NULL,'68306','Germany','0621-08460','0621-08924')
INSERT Customers VALUES('BLONP','Blondesddsl père et fils','Frédérique Citeaux','Marketing Manager','24, place Kléber','Strasbourg',NULL,'67000','France','88.60.15.31','88.60.15.32')
INSERT Customers VALUES('BOLID','Bólido Comidas preparadas','Martín Sommer','Owner','C/ Araquil, 67','Madrid',NULL,'28023','Spain','(91) 555 22 82','(91) 555 91 99')
INSERT Customers VALUES('BONAP','Bon app''','Laurence Lebihan','Owner','12, rue des Bouchers','Marseille',NULL,'13008','France','91.24.45.40','91.24.45.41')
INSERT Customers VALUES('BOTTM','Bottom-Dollar Markets','Elizabeth Lincoln','Accounting Manager','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada','(604) 555-4729','(604) 555-3745')
go
INSERT Customers VALUES('BSBEV','B''s Beverages','Victoria Ashworth','Sales Representative','Fauntleroy Circus','London',NULL,'EC2 5NT','UK','(171) 555-1212',NULL)
INSERT Customers VALUES('CACTU','Cactus Comidas para llevar','Patricio Simpson','Sales Agent','Cerrito 333','Buenos Aires',NULL,'1010','Argentina','(1) 135-5555','(1) 135-4892')
INSERT Customers VALUES('CENTC','Centro comercial Moctezuma','Francisco Chang','Marketing Manager','Sierras de Granada 9993','México D.F.',NULL,'05022','Mexico','(5) 555-3392','(5) 555-7293')
INSERT Customers VALUES('CHOPS','Chop-suey Chinese','Yang Wang','Owner','Hauptstr. 29','Bern',NULL,'3012','Switzerland','0452-076545',NULL)
INSERT Customers VALUES('COMMI','Comércio Mineiro','Pedro Afonso','Sales Associate','Av. dos Lusíadas, 23','Sao Paulo','SP','05432-043','Brazil','(11) 555-7647',NULL)
INSERT Customers VALUES('CONSH','Consolidated Holdings','Elizabeth Brown','Sales Representative','Berkeley Gardens 12  Brewery','London',NULL,'WX1 6LT','UK','(171) 555-2282','(171) 555-9199')
INSERT Customers VALUES('DRACD','Drachenblut Delikatessen','Sven Ottlieb','Order Administrator','Walserweg 21','Aachen',NULL,'52066','Germany','0241-039123','0241-059428')
INSERT Customers VALUES('DUMON','Du monde entier','Janine Labrune','Owner','67, rue des Cinquante Otages','Nantes',NULL,'44000','France','40.67.88.88','40.67.89.89')
INSERT Customers VALUES('EASTC','Eastern Connection','Ann Devon','Sales Agent','35 King George','London',NULL,'WX3 6FW','UK','(171) 555-0297','(171) 555-3373')
INSERT Customers VALUES('ERNSH','Ernst Handel','Roland Mendel','Sales Manager','Kirchgasse 6','Graz',NULL,'8010','Austria','7675-3425','7675-3426')
go
INSERT Customers VALUES('FAMIA','Familia Arquibaldo','Aria Cruz','Marketing Assistant','Rua Orós, 92','Sao Paulo','SP','05442-030','Brazil','(11) 555-9857',NULL)
INSERT Customers VALUES('FISSA','FISSA Fabrica Inter. Salchichas S.A.','Diego Roel','Accounting Manager','C/ Moralzarzal, 86','Madrid',NULL,'28034','Spain','(91) 555 94 44','(91) 555 55 93')
INSERT Customers VALUES('FOLIG','Folies gourmandes','Martine Rancé','Assistant Sales Agent','184, chaussée de Tournai','Lille',NULL,'59000','France','20.16.10.16','20.16.10.17')
INSERT Customers VALUES('FOLKO','Folk och fä HB','Maria Larsson','Owner','Åkergatan 24','Bräcke',NULL,'S-844 67','Sweden','0695-34 67 21',NULL)
INSERT Customers VALUES('FRANK','Frankenversand','Peter Franken','Marketing Manager','Berliner Platz 43','München',NULL,'80805','Germany','089-0877310','089-0877451')
INSERT Customers VALUES('FRANR','France restauration','Carine Schmitt','Marketing Manager','54, rue Royale','Nantes',NULL,'44000','France','40.32.21.21','40.32.21.20')
INSERT Customers VALUES('FRANS','Franchi S.p.A.','Paolo Accorti','Sales Representative','Via Monte Bianco 34','Torino',NULL,'10100','Italy','011-4988260','011-4988261')
INSERT Customers VALUES('FURIB','Furia Bacalhau e Frutos do Mar','Lino Rodriguez','Sales Manager','Jardim das rosas n. 32','Lisboa',NULL,'1675','Portugal','(1) 354-2534','(1) 354-2535')
INSERT Customers VALUES('GALED','Galería del gastrónomo','Eduardo Saavedra','Marketing Manager','Rambla de Cataluña, 23','Barcelona',NULL,'08022','Spain','(93) 203 4560','(93) 203 4561')
INSERT Customers VALUES('GODOS','Godos Cocina Típica','José Pedro Freyre','Sales Manager','C/ Romero, 33','Sevilla',NULL,'41101','Spain','(95) 555 82 82',NULL)
go
INSERT Customers VALUES('GOURL','Gourmet Lanchonetes','André Fonseca','Sales Associate','Av. Brasil, 442','Campinas','SP','04876-786','Brazil','(11) 555-9482',NULL)
INSERT Customers VALUES('GREAL','Great Lakes Food Market','Howard Snyder','Marketing Manager','2732 Baker Blvd.','Eugene','OR','97403','USA','(503) 555-7555',NULL)
INSERT Customers VALUES('GROSR','GROSELLA-Restaurante','Manuel Pereira','Owner','5ª Ave. Los Palos Grandes','Caracas','DF','1081','Venezuela','(2) 283-2951','(2) 283-3397')
INSERT Customers VALUES('HANAR','Hanari Carnes','Mario Pontes','Accounting Manager','Rua do Paço, 67','Rio de Janeiro','RJ','05454-876','Brazil','(21) 555-0091','(21) 555-8765')
INSERT Customers VALUES('HILAA','HILARION-Abastos','Carlos Hernández','Sales Representative','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela','(5) 555-1340','(5) 555-1948')
INSERT Customers VALUES('HUNGC','Hungry Coyote Import Store','Yoshi Latimer','Sales Representative','City Center Plaza 516 Main St.','Elgin','OR','97827','USA','(503) 555-6874','(503) 555-2376')
INSERT Customers VALUES('HUNGO','Hungry Owl All-Night Grocers','Patricia McKenna','Sales Associate','8 Johnstown Road','Cork','Co. Cork',NULL,'Ireland','2967 542','2967 3333')
INSERT Customers VALUES('ISLAT','Island Trading','Helen Bennett','Marketing Manager','Garden House Crowther Way','Cowes','Isle of Wight','PO31 7PJ','UK','(198) 555-8888',NULL)
INSERT Customers VALUES('KOENE','Königlich Essen','Philip Cramer','Sales Associate','Maubelstr. 90','Brandenburg',NULL,'14776','Germany','0555-09876',NULL)
INSERT Customers VALUES('LACOR','La corne d''abondance','Daniel Tonini','Sales Representative','67, avenue de l''Europe','Versailles',NULL,'78000','France','30.59.84.10','30.59.85.11')
go
INSERT Customers VALUES('LAMAI','La maison d''Asie','Annette Roulet','Sales Manager','1 rue Alsace-Lorraine','Toulouse',NULL,'31000','France','61.77.61.10','61.77.61.11')
INSERT Customers VALUES('LAUGB','Laughing Bacchus Wine Cellars','Yoshi Tannamuri','Marketing Assistant','1900 Oak St.','Vancouver','BC','V3F 2K1','Canada','(604) 555-3392','(604) 555-7293')
INSERT Customers VALUES('LAZYK','Lazy K Kountry Store','John Steel','Marketing Manager','12 Orchestra Terrace','Walla Walla','WA','99362','USA','(509) 555-7969','(509) 555-6221')
INSERT Customers VALUES('LEHMS','Lehmanns Marktstand','Renate Messner','Sales Representative','Magazinweg 7','Frankfurt a.M.',NULL,'60528','Germany','069-0245984','069-0245874')
INSERT Customers VALUES('LETSS','Let''s Stop N Shop','Jaime Yorres','Owner','87 Polk St. Suite 5','San Francisco','CA','94117','USA','(415) 555-5938',NULL)
INSERT Customers VALUES('LILAS','LILA-Supermercado','Carlos González','Accounting Manager','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','Lara','3508','Venezuela','(9) 331-6954','(9) 331-7256')
INSERT Customers VALUES('LINOD','LINO-Delicateses','Felipe Izquierdo','Owner','Ave. 5 de Mayo Porlamar','I. de Margarita','Nueva Esparta','4980','Venezuela','(8) 34-56-12','(8) 34-93-93')
INSERT Customers VALUES('LONEP','Lonesome Pine Restaurant','Fran Wilson','Sales Manager','89 Chiaroscuro Rd.','Portland','OR','97219','USA','(503) 555-9573','(503) 555-9646')
INSERT Customers VALUES('MAGAA','Magazzini Alimentari Riuniti','Giovanni Rovelli','Marketing Manager','Via Ludovico il Moro 22','Bergamo',NULL,'24100','Italy','035-640230','035-640231')
INSERT Customers VALUES('MAISD','Maison Dewey','Catherine Dewey','Sales Agent','Rue Joseph-Bens 532','Bruxelles',NULL,'B-1180','Belgium','(02) 201 24 67','(02) 201 24 68')
go
INSERT Customers VALUES('MEREP','Mère Paillarde','Jean Fresnière','Marketing Assistant','43 rue St. Laurent','Montréal','Québec','H1J 1C3','Canada','(514) 555-8054','(514) 555-8055')
INSERT Customers VALUES('MORGK','Morgenstern Gesundkost','Alexander Feuer','Marketing Assistant','Heerstr. 22','Leipzig',NULL,'04179','Germany','0342-023176',NULL)
INSERT Customers VALUES('NORTS','North/South','Simon Crowther','Sales Associate','South House 300 Queensbridge','London',NULL,'SW7 1RZ','UK','(171) 555-7733','(171) 555-2530')
INSERT Customers VALUES('OCEAN','Océano Atlántico Ltda.','Yvonne Moncada','Sales Agent','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires',NULL,'1010','Argentina','(1) 135-5333','(1) 135-5535')
INSERT Customers VALUES('OLDWO','Old World Delicatessen','Rene Phillips','Sales Representative','2743 Bering St.','Anchorage','AK','99508','USA','(907) 555-7584','(907) 555-2880')
INSERT Customers VALUES('OTTIK','Ottilies Käseladen','Henriette Pfalzheim','Owner','Mehrheimerstr. 369','Köln',NULL,'50739','Germany','0221-0644327','0221-0765721')
INSERT Customers VALUES('PARIS','Paris spécialités','Marie Bertrand','Owner','265, boulevard Charonne','Paris',NULL,'75012','France','(1) 42.34.22.66','(1) 42.34.22.77')
INSERT Customers VALUES('PERIC','Pericles Comidas clásicas','Guillermo Fernández','Sales Representative','Calle Dr. Jorge Cash 321','México D.F.',NULL,'05033','Mexico','(5) 552-3745','(5) 545-3745')
INSERT Customers VALUES('PICCO','Piccolo und mehr','Georg Pipps','Sales Manager','Geislweg 14','Salzburg',NULL,'5020','Austria','6562-9722','6562-9723')
INSERT Customers VALUES('PRINI','Princesa Isabel Vinhos','Isabel de Castro','Sales Representative','Estrada da saúde n. 58','Lisboa',NULL,'1756','Portugal','(1) 356-5634',NULL)
go
INSERT Customers VALUES('QUEDE','Que Delícia','Bernardo Batista','Accounting Manager','Rua da Panificadora, 12','Rio de Janeiro','RJ','02389-673','Brazil','(21) 555-4252','(21) 555-4545')
INSERT Customers VALUES('QUEEN','Queen Cozinha','Lúcia Carvalho','Marketing Assistant','Alameda dos Canàrios, 891','Sao Paulo','SP','05487-020','Brazil','(11) 555-1189',NULL)
INSERT Customers VALUES('QUICK','QUICK-Stop','Horst Kloss','Accounting Manager','Taucherstraße 10','Cunewalde',NULL,'01307','Germany','0372-035188',NULL)
INSERT Customers VALUES('RANCH','Rancho grande','Sergio Gutiérrez','Sales Representative','Av. del Libertador 900','Buenos Aires',NULL,'1010','Argentina','(1) 123-5555','(1) 123-5556')
INSERT Customers VALUES('RATTC','Rattlesnake Canyon Grocery','Paula Wilson','Assistant Sales Representative','2817 Milton Dr.','Albuquerque','NM','87110','USA','(505) 555-5939','(505) 555-3620')
INSERT Customers VALUES('REGGC','Reggiani Caseifici','Maurizio Moroni','Sales Associate','Strada Provinciale 124','Reggio Emilia',NULL,'42100','Italy','0522-556721','0522-556722')
INSERT Customers VALUES('RICAR','Ricardo Adocicados','Janete Limeira','Assistant Sales Agent','Av. Copacabana, 267','Rio de Janeiro','RJ','02389-890','Brazil','(21) 555-3412',NULL)
INSERT Customers VALUES('RICSU','Richter Supermarkt','Michael Holz','Sales Manager','Grenzacherweg 237','Genève',NULL,'1203','Switzerland','0897-034214',NULL)
INSERT Customers VALUES('ROMEY','Romero y tomillo','Alejandra Camino','Accounting Manager','Gran Vía, 1','Madrid',NULL,'28001','Spain','(91) 745 6200','(91) 745 6210')
INSERT Customers VALUES('SANTG','Santé Gourmet','Jonas Bergulfsen','Owner','Erling Skakkes gate 78','Stavern',NULL,'4110','Norway','07-98 92 35','07-98 92 47')
go
INSERT Customers VALUES('SAVEA','Save-a-lot Markets','Jose Pavarotti','Sales Representative','187 Suffolk Ln.','Boise','ID','83720','USA','(208) 555-8097',NULL)
INSERT Customers VALUES('SEVES','Seven Seas Imports','Hari Kumar','Sales Manager','90 Wadhurst Rd.','London',NULL,'OX15 4NB','UK','(171) 555-1717','(171) 555-5646')
INSERT Customers VALUES('SIMOB','Simons bistro','Jytte Petersen','Owner','Vinbæltet 34','Kobenhavn',NULL,'1734','Denmark','31 12 34 56','31 13 35 57')
INSERT Customers VALUES('SPECD','Spécialités du monde','Dominique Perrier','Marketing Manager','25, rue Lauriston','Paris',NULL,'75016','France','(1) 47.55.60.10','(1) 47.55.60.20')
INSERT Customers VALUES('SPLIR','Split Rail Beer & Ale','Art Braunschweiger','Sales Manager','P.O. Box 555','Lander','WY','82520','USA','(307) 555-4680','(307) 555-6525')
INSERT Customers VALUES('SUPRD','Suprêmes délices','Pascale Cartrain','Accounting Manager','Boulevard Tirou, 255','Charleroi',NULL,'B-6000','Belgium','(071) 23 67 22 20','(071) 23 67 22 21')
INSERT Customers VALUES('THEBI','The Big Cheese','Liz Nixon','Marketing Manager','89 Jefferson Way Suite 2','Portland','OR','97201','USA','(503) 555-3612',NULL)
INSERT Customers VALUES('THECR','The Cracker Box','Liu Wong','Marketing Assistant','55 Grizzly Peak Rd.','Butte','MT','59801','USA','(406) 555-5834','(406) 555-8083')
INSERT Customers VALUES('TOMSP','Toms Spezialitäten','Karin Josephs','Marketing Manager','Luisenstr. 48','Münster',NULL,'44087','Germany','0251-031259','0251-035695')
INSERT Customers VALUES('TORTU','Tortuga Restaurante','Miguel Angel Paolino','Owner','Avda. Azteca 123','México D.F.',NULL,'05033','Mexico','(5) 555-2933',NULL)
go
INSERT Customers VALUES('TRADH','Tradição Hipermercados','Anabela Domingues','Sales Representative','Av. Inês de Castro, 414','Sao Paulo','SP','05634-030','Brazil','(11) 555-2167','(11) 555-2168')
INSERT Customers VALUES('TRAIH','Trail''s Head Gourmet Provisioners','Helvetius Nagy','Sales Associate','722 DaVinci Blvd.','Kirkland','WA','98034','USA','(206) 555-8257','(206) 555-2174')
INSERT Customers VALUES('VAFFE','Vaffeljernet','Palle Ibsen','Sales Manager','Smagsloget 45','Århus',NULL,'8200','Denmark','86 21 32 43','86 22 33 44')
INSERT Customers VALUES('VICTE','Victuailles en stock','Mary Saveley','Sales Agent','2, rue du Commerce','Lyon',NULL,'69004','France','78.32.54.86','78.32.54.87')
INSERT Customers VALUES('VINET','Vins et alcools Chevalier','Paul Henriot','Accounting Manager','59 rue de l''Abbaye','Reims',NULL,'51100','France','26.47.15.10','26.47.15.11')
INSERT Customers VALUES('WANDK','Die Wandernde Kuh','Rita Müller','Sales Representative','Adenauerallee 900','Stuttgart',NULL,'70563','Germany','0711-020361','0711-035428')
INSERT Customers VALUES('WARTH','Wartian Herkku','Pirkko Koskitalo','Accounting Manager','Torikatu 38','Oulu',NULL,'90110','Finland','981-443655','981-443655')
INSERT Customers VALUES('WELLI','Wellington Importadora','Paula Parente','Sales Manager','Rua do Mercado, 12','Resende','SP','08737-363','Brazil','(14) 555-8122',NULL)
INSERT Customers VALUES('WHITC','White Clover Markets','Karl Jablonski','Owner','305 - 14th Ave. S. Suite 3B','Seattle','WA','98128','USA','(206) 555-4112','(206) 555-4115')
INSERT Customers VALUES('WILMK','Wilman Kala','Matti Karttunen','Owner/Marketing Assistant','Keskuskatu 45','Helsinki',NULL,'21240','Finland','90-224 8858','90-224 8858')
go
INSERT Customers VALUES('WOLZA','Wolski  Zajazd','Zbyszek Piestrzeniewicz','Owner','ul. Filtrowa 68','Warszawa',NULL,'01-012','Poland','(26) 642-7012','(26) 642-7012')
go

set identity_insert Employees on
go
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(1,'Davolio','Nancy','Sales Representative','Ms.','12/08/1948','05/01/1992','507 - 20th Ave. E.
Apt. 2A','Seattle','WA','98122','USA','(206) 555-9857','5467','Education includes a BA in psychology from Colorado State University in 1970.  She also completed The Art of the Cold Call.  Nancy is a member of Toastmasters International.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(2,'Fuller','Andrew','Vice President, Sales','Dr.','02/19/1952','08/14/1992','908 W. Capital Way','Tacoma','WA','98401','USA','(206) 555-9482','3457','Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager in January 1992 and to vice president of sales in March 1993.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(3,'Leverling','Janet','Sales Representative','Ms.','08/30/1963','04/01/1992','722 Moss Bay Blvd.','Kirkland','WA','98033','USA','(206) 555-3412','3355','Janet has a BS degree in chemistry from Boston College (1984).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(4,'Peacock','Margaret','Sales Representative','Mrs.','09/19/1937','05/03/1993','4110 Old Redmond Rd.','Redmond','WA','98052','USA','(206) 555-8122','5176','Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).  She was assigned to the London office temporarily from July through November 1992.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(5,'Buchanan','Steven','Sales Manager','Mr.','03/04/1955','10/17/1993','14 Garrett Hill','London',NULL,'SW1 8JR','UK','(71) 555-4848','3453','Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses Successful Telemarketing and International Sales Management.  He is fluent in French.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(6,'Suyama','Michael','Sales Representative','Mr.','07/02/1963','10/17/1993','Coventry House
Miner Rd.','London',NULL,'EC2 7JR','UK','(71) 555-7773','428','Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses Multi-Cultural Selling and Time Management for the Sales Professional.  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(7,'King','Robert','Sales Representative','Mr.','05/29/1960','01/02/1994','Edgeham Hollow
Winchester Way','London',NULL,'RG1 9SP','UK','(71) 555-5598','465','Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan in 1992, the year he joined the company.  After completing a course entitled Selling in Europe, he was transferred to the London office in March 1993.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(8,'Callahan','Laura','Inside Sales Coordinator','Ms.','01/09/1958','03/05/1994','4726 - 11th Ave. N.E.','Seattle','WA','98105','USA','(206) 555-1189','2344','Laura received a BA in psychology from the University of Washington.  She has also completed a course in business French.  She reads and writes French.')
GO
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(9,'Dodsworth','Anne','Sales Representative','Ms.','01/27/1966','11/15/1994','7 Houndstooth Rd.','London',NULL,'WG2 7LT','UK','(71) 555-4444','452','Anne has a BA degree in English from St. Lawrence College.  She is fluent in French and German.')
go
INSERT Employees(EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) VALUES(10,'Dodsworth','Carol','Sales Representative','Ms.','03/15/1968','05/12/1996','7 Houndstooth Rd.','London',NULL,'WG2 7LT','UK','(71) 555-4444','452','Carol has a BA degree in English from University College London.  She is fluent in Dutch and German.')
go
set identity_insert Employees off
go

set identity_insert Suppliers on
go
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(1,'Exotic Liquids','Charlotte Cooper','Purchasing Manager','49 Gilbert St.','London',NULL,'EC1 4SD','UK','(171) 555-2222',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(2,'New Orleans Cajun Delights','Shelley Burke','Order Administrator','P.O. Box 78934','New Orleans','LA','70117','USA','(100) 555-4822',NULL,'#CAJUN.HTM#')
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(3,'Grandma Kelly''s Homestead','Regina Murphy','Sales Representative','707 Oxford Rd.','Ann Arbor','MI','48104','USA','(313) 555-5735','(313) 555-3349',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(4,'Tokyo Traders','Yoshi Nagase','Marketing Manager','9-8 Sekimai Musashino-shi','Tokyo',NULL,'100','Japan','(03) 3555-5011',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(5,'Cooperativa de Quesos ''Las Cabras''','Antonio del Valle Saavedra','Export Administrator','Calle del Rosal 4','Oviedo','Asturias','33007','Spain','(98) 598 76 54',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(6,'Mayumi''s','Mayumi Ohno','Marketing Representative','92 Setsuko Chuo-ku','Osaka',NULL,'545','Japan','(06) 431-7877',NULL,'Mayumi''s (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#')
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(7,'Pavlova, Ltd.','Ian Devling','Marketing Manager','74 Rose St. Moonie Ponds','Melbourne','Victoria','3058','Australia','(03) 444-2343','(03) 444-6588',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(8,'Specialty Biscuits, Ltd.','Peter Wilson','Sales Representative','29 King''s Way','Manchester',NULL,'M14 GSD','UK','(161) 555-4448',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(9,'PB Knäckebröd AB','Lars Peterson','Sales Agent','Kaloadagatan 13','Göteborg',NULL,'S-345 67','Sweden','031-987 65 43','031-987 65 91',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(10,'Refrescos Americanas LTDA','Carlos Diaz','Marketing Manager','Av. das Americanas 12.890','Sao Paulo',NULL,'5442','Brazil','(11) 555 4640',NULL,NULL)
go
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(11,'Heli Süßwaren GmbH & Co. KG','Petra Winkler','Sales Manager','Tiergartenstraße 5','Berlin',NULL,'10785','Germany','(010) 9984510',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(12,'Plutzer Lebensmittelgroßmärkte AG','Martin Bein','International Marketing Mgr.','Bogenallee 51','Frankfurt',NULL,'60439','Germany','(069) 992755',NULL,'Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#')
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(13,'Nord-Ost-Fisch Handelsgesellschaft mbH','Sven Petersen','Coordinator Foreign Markets','Frahmredder 112a','Cuxhaven',NULL,'27478','Germany','(04721) 8713','(04721) 8714',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(14,'Formaggi Fortini s.r.l.','Elio Rossi','Sales Representative','Viale Dante, 75','Ravenna',NULL,'48100','Italy','(0544) 60323','(0544) 60603','#FORMAGGI.HTM#')
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(15,'Norske Meierier','Beate Vileid','Marketing Manager','Hatlevegen 5','Sandvika',NULL,'1320','Norway','(0)2-953010',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(16,'Bigfoot Breweries','Cheryl Saylor','Regional Account Rep.','3400 - 8th Avenue Suite 210','Bend','OR','97101','USA','(503) 555-9931',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(17,'Svensk Sjöföda AB','Michael Björn','Sales Representative','Brovallavägen 231','Stockholm',NULL,'S-123 45','Sweden','08-123 45 67',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(18,'Aux joyeux ecclésiastiques','Guylène Nodier','Sales Manager','203, Rue des Francs-Bourgeois','Paris',NULL,'75004','France','(1) 03.83.00.68','(1) 03.83.00.62',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(19,'New England Seafood Cannery','Robb Merchant','Wholesale Account Agent','Order Processing Dept. 2100 Paul Revere Blvd.','Boston','MA','02134','USA','(617) 555-3267','(617) 555-3389',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(20,'Leka Trading','Chandra Leka','Owner','471 Serangoon Loop, Suite #402','Singapore',NULL,'0512','Singapore','555-8787',NULL,NULL)
go
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(21,'Lyngbysild','Niels Petersen','Sales Manager','Lyngbysild Fiskebakken 10','Lyngby',NULL,'2800','Denmark','43844108','43844115',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(22,'Zaanse Snoepfabriek','Dirk Luchte','Accounting Manager','Verkoop Rijnweg 22','Zaandam',NULL,'9999 ZZ','Netherlands','(12345) 1212','(12345) 1210',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(23,'Karkki Oy','Anne Heikkonen','Product Manager','Valtakatu 12','Lappeenranta',NULL,'53120','Finland','(953) 10956',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(24,'G''day, Mate','Wendy Mackenzie','Sales Representative','170 Prince Edward Parade Hunter''s Hill','Sydney','NSW','2042','Australia','(02) 555-5914','(02) 555-4873','G''day Mate (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/gdaymate.htm#')
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(25,'Ma Maison','Jean-Guy Lauzon','Marketing Manager','2960 Rue St. Laurent','Montréal','Québec','H1J 1C3','Canada','(514) 555-9022',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(26,'Pasta Buttini s.r.l.','Giovanni Giudici','Order Administrator','Via dei Gelsomini, 153','Salerno',NULL,'84100','Italy','(089) 6547665','(089) 6547667',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(27,'Escargots Nouveaux','Marie Delamare','Sales Manager','22, rue H. Voiron','Montceau',NULL,'71300','France','85.57.00.07',NULL,NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(28,'Gai pâturage','Eliane Noz','Sales Representative','Bat. B 3, rue des Alpes','Annecy',NULL,'74000','France','38.76.98.06','38.76.98.58',NULL)
INSERT Suppliers(SupplierID,CompanyName,ContactName,ContactTitle,Address,City,Region,PostalCode,Country,Phone,Fax,HomePage) VALUES(29,'Forêts d''érables','Chantal Goulet','Accounting Manager','148 rue Chasseur','Ste-Hyacinthe','Québec','J2S 7S8','Canada','(514) 555-2955','(514) 555-2921',NULL)
go
set identity_insert Suppliers off
go

set identity_insert Orders on
go
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10248,N'VINET',5,'7/4/1996','8/1/1996','7/16/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10249,N'TOMSP',6,'7/5/1996','8/16/1996','7/10/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10250,N'HANAR',4,'7/8/1996','8/5/1996','7/12/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10251,N'VICTE',3,'7/8/1996','8/5/1996','7/15/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10252,N'SUPRD',4,'7/9/1996','8/6/1996','7/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10253,N'HANAR',3,'7/10/1996','7/24/1996','7/16/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10254,N'CHOPS',5,'7/11/1996','8/8/1996','7/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10255,N'RICSU',9,'7/12/1996','8/9/1996','7/15/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10256,N'WELLI',3,'7/15/1996','8/12/1996','7/17/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10257,N'HILAA',4,'7/16/1996','8/13/1996','7/22/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10258,N'ERNSH',1,'7/17/1996','8/14/1996','7/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10259,N'CENTC',4,'7/18/1996','8/15/1996','7/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10260,N'OTTIK',4,'7/19/1996','8/16/1996','7/29/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10261,N'QUEDE',4,'7/19/1996','8/16/1996','7/30/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10262,N'RATTC',8,'7/22/1996','8/19/1996','7/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10263,N'ERNSH',9,'7/23/1996','8/20/1996','7/31/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10264,N'FOLKO',6,'7/24/1996','8/21/1996','8/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10265,N'BLONP',2,'7/25/1996','8/22/1996','8/12/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10266,N'WARTH',3,'7/26/1996','9/6/1996','7/31/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10267,N'FRANK',4,'7/29/1996','8/26/1996','8/6/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10268,N'GROSR',8,'7/30/1996','8/27/1996','8/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10269,N'WHITC',5,'7/31/1996','8/14/1996','8/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10270,N'WARTH',1,'8/1/1996','8/29/1996','8/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10271,N'SPLIR',6,'8/1/1996','8/29/1996','8/30/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10272,N'RATTC',6,'8/2/1996','8/30/1996','8/6/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10273,N'QUICK',3,'8/5/1996','9/2/1996','8/12/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10274,N'VINET',6,'8/6/1996','9/3/1996','8/16/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10275,N'MAGAA',1,'8/7/1996','9/4/1996','8/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10276,N'TORTU',8,'8/8/1996','8/22/1996','8/14/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10277,N'MORGK',2,'8/9/1996','9/6/1996','8/13/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10278,N'BERGS',8,'8/12/1996','9/9/1996','8/16/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10279,N'LEHMS',8,'8/13/1996','9/10/1996','8/16/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10280,N'BERGS',2,'8/14/1996','9/11/1996','9/12/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10281,N'ROMEY',4,'8/14/1996','8/28/1996','8/21/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10282,N'ROMEY',4,'8/15/1996','9/12/1996','8/21/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10283,N'LILAS',3,'8/16/1996','9/13/1996','8/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10284,N'LEHMS',4,'8/19/1996','9/16/1996','8/27/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10285,N'QUICK',1,'8/20/1996','9/17/1996','8/26/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10286,N'QUICK',8,'8/21/1996','9/18/1996','8/30/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10287,N'RICAR',8,'8/22/1996','9/19/1996','8/28/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10288,N'REGGC',4,'8/23/1996','9/20/1996','9/3/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10289,N'BSBEV',7,'8/26/1996','9/23/1996','8/28/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10290,N'COMMI',8,'8/27/1996','9/24/1996','9/3/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10291,N'QUEDE',6,'8/27/1996','9/24/1996','9/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10292,N'TRADH',1,'8/28/1996','9/25/1996','9/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10293,N'TORTU',1,'8/29/1996','9/26/1996','9/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10294,N'RATTC',4,'8/30/1996','9/27/1996','9/5/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10295,N'VINET',2,'9/2/1996','9/30/1996','9/10/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10296,N'LILAS',6,'9/3/1996','10/1/1996','9/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10297,N'BLONP',5,'9/4/1996','10/16/1996','9/10/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10298,N'HUNGO',6,'9/5/1996','10/3/1996','9/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10299,N'RICAR',4,'9/6/1996','10/4/1996','9/13/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10300,N'MAGAA',2,'9/9/1996','10/7/1996','9/18/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10301,N'WANDK',8,'9/9/1996','10/7/1996','9/17/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10302,N'SUPRD',4,'9/10/1996','10/8/1996','10/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10303,N'GODOS',7,'9/11/1996','10/9/1996','9/18/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10304,N'TORTU',1,'9/12/1996','10/10/1996','9/17/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10305,N'OLDWO',8,'9/13/1996','10/11/1996','10/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10306,N'ROMEY',1,'9/16/1996','10/14/1996','9/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10307,N'LONEP',2,'9/17/1996','10/15/1996','9/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10308,N'ANATR',7,'9/18/1996','10/16/1996','9/24/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10309,N'HUNGO',3,'9/19/1996','10/17/1996','10/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10310,N'THEBI',8,'9/20/1996','10/18/1996','9/27/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10311,N'DUMON',1,'9/20/1996','10/4/1996','9/26/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10312,N'WANDK',2,'9/23/1996','10/21/1996','10/3/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10313,N'QUICK',2,'9/24/1996','10/22/1996','10/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10314,N'RATTC',1,'9/25/1996','10/23/1996','10/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10315,N'ISLAT',4,'9/26/1996','10/24/1996','10/3/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10316,N'RATTC',1,'9/27/1996','10/25/1996','10/8/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10317,N'LONEP',6,'9/30/1996','10/28/1996','10/10/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10318,N'ISLAT',8,'10/1/1996','10/29/1996','10/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10319,N'TORTU',7,'10/2/1996','10/30/1996','10/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10320,N'WARTH',5,'10/3/1996','10/17/1996','10/18/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10321,N'ISLAT',3,'10/3/1996','10/31/1996','10/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10322,N'PERIC',7,'10/4/1996','11/1/1996','10/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10323,N'KOENE',4,'10/7/1996','11/4/1996','10/14/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10324,N'SAVEA',9,'10/8/1996','11/5/1996','10/10/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10325,N'KOENE',1,'10/9/1996','10/23/1996','10/14/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10326,N'BOLID',4,'10/10/1996','11/7/1996','10/14/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10327,N'FOLKO',2,'10/11/1996','11/8/1996','10/14/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10328,N'FURIB',4,'10/14/1996','11/11/1996','10/17/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10329,N'SPLIR',4,'10/15/1996','11/26/1996','10/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10330,N'LILAS',3,'10/16/1996','11/13/1996','10/28/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10331,N'BONAP',9,'10/16/1996','11/27/1996','10/21/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10332,N'MEREP',3,'10/17/1996','11/28/1996','10/21/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10333,N'WARTH',5,'10/18/1996','11/15/1996','10/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10334,N'VICTE',8,'10/21/1996','11/18/1996','10/28/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10335,N'HUNGO',7,'10/22/1996','11/19/1996','10/24/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10336,N'PRINI',7,'10/23/1996','11/20/1996','10/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10337,N'FRANK',4,'10/24/1996','11/21/1996','10/29/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10338,N'OLDWO',4,'10/25/1996','11/22/1996','10/29/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10339,N'MEREP',2,'10/28/1996','11/25/1996','11/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10340,N'BONAP',1,'10/29/1996','11/26/1996','11/8/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10341,N'SIMOB',7,'10/29/1996','11/26/1996','11/5/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10342,N'FRANK',4,'10/30/1996','11/13/1996','11/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10343,N'LEHMS',4,'10/31/1996','11/28/1996','11/6/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10344,N'WHITC',4,'11/1/1996','11/29/1996','11/5/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10345,N'QUICK',2,'11/4/1996','12/2/1996','11/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10346,N'RATTC',3,'11/5/1996','12/17/1996','11/8/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10347,N'FAMIA',4,'11/6/1996','12/4/1996','11/8/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10348,N'WANDK',4,'11/7/1996','12/5/1996','11/15/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10349,N'SPLIR',7,'11/8/1996','12/6/1996','11/15/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10350,N'LAMAI',6,'11/11/1996','12/9/1996','12/3/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10351,N'ERNSH',1,'11/11/1996','12/9/1996','11/20/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10352,N'FURIB',3,'11/12/1996','11/26/1996','11/18/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10353,N'PICCO',7,'11/13/1996','12/11/1996','11/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10354,N'PERIC',8,'11/14/1996','12/12/1996','11/20/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10355,N'AROUT',6,'11/15/1996','12/13/1996','11/20/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10356,N'WANDK',6,'11/18/1996','12/16/1996','11/27/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10357,N'LILAS',1,'11/19/1996','12/17/1996','12/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10358,N'LAMAI',5,'11/20/1996','12/18/1996','11/27/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10359,N'SEVES',5,'11/21/1996','12/19/1996','11/26/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10360,N'BLONP',4,'11/22/1996','12/20/1996','12/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10361,N'QUICK',1,'11/22/1996','12/20/1996','12/3/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10362,N'BONAP',3,'11/25/1996','12/23/1996','11/28/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10363,N'DRACD',4,'11/26/1996','12/24/1996','12/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10364,N'EASTC',1,'11/26/1996','1/7/1997','12/4/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10365,N'ANTON',3,'11/27/1996','12/25/1996','12/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10366,N'GALED',8,'11/28/1996','1/9/1997','12/30/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10367,N'VAFFE',7,'11/28/1996','12/26/1996','12/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10368,N'ERNSH',2,'11/29/1996','12/27/1996','12/2/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10369,N'SPLIR',8,'12/2/1996','12/30/1996','12/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10370,N'CHOPS',6,'12/3/1996','12/31/1996','12/27/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10371,N'LAMAI',1,'12/3/1996','12/31/1996','12/24/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10372,N'QUEEN',5,'12/4/1996','1/1/1997','12/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10373,N'HUNGO',4,'12/5/1996','1/2/1997','12/11/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10374,N'WOLZA',1,'12/5/1996','1/2/1997','12/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10375,N'HUNGC',3,'12/6/1996','1/3/1997','12/9/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10376,N'MEREP',1,'12/9/1996','1/6/1997','12/13/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10377,N'SEVES',1,'12/9/1996','1/6/1997','12/13/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10378,N'FOLKO',5,'12/10/1996','1/7/1997','12/19/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10379,N'QUEDE',2,'12/11/1996','1/8/1997','12/13/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10380,N'HUNGO',8,'12/12/1996','1/9/1997','1/16/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10381,N'LILAS',3,'12/12/1996','1/9/1997','12/13/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10382,N'ERNSH',4,'12/13/1996','1/10/1997','12/16/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10383,N'AROUT',8,'12/16/1996','1/13/1997','12/18/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10384,N'BERGS',3,'12/16/1996','1/13/1997','12/20/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10385,N'SPLIR',1,'12/17/1996','1/14/1997','12/23/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10386,N'FAMIA',9,'12/18/1996','1/1/1997','12/25/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10387,N'SANTG',1,'12/18/1996','1/15/1997','12/20/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10388,N'SEVES',2,'12/19/1996','1/16/1997','12/20/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10389,N'BOTTM',4,'12/20/1996','1/17/1997','12/24/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10390,N'ERNSH',6,'12/23/1996','1/20/1997','12/26/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10391,N'DRACD',3,'12/23/1996','1/20/1997','12/31/1996')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10392,N'PICCO',2,'12/24/1996','1/21/1997','1/1/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10393,N'SAVEA',1,'12/25/1996','1/22/1997','1/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10394,N'HUNGC',1,'12/25/1996','1/22/1997','1/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10395,N'HILAA',6,'12/26/1996','1/23/1997','1/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10396,N'FRANK',1,'12/27/1996','1/10/1997','1/6/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10397,N'PRINI',5,'12/27/1996','1/24/1997','1/2/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10398,N'SAVEA',2,'12/30/1996','1/27/1997','1/9/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10399,N'VAFFE',8,'12/31/1996','1/14/1997','1/8/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10400,N'EASTC',1,'1/1/1997','1/29/1997','1/16/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10401,N'RATTC',1,'1/1/1997','1/29/1997','1/10/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10402,N'ERNSH',8,'1/2/1997','2/13/1997','1/10/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10403,N'ERNSH',4,'1/3/1997','1/31/1997','1/9/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10404,N'MAGAA',2,'1/3/1997','1/31/1997','1/8/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10405,N'LINOD',1,'1/6/1997','2/3/1997','1/22/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10406,N'QUEEN',7,'1/7/1997','2/18/1997','1/13/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10407,N'OTTIK',2,'1/7/1997','2/4/1997','1/30/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10408,N'FOLIG',8,'1/8/1997','2/5/1997','1/14/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10409,N'OCEAN',3,'1/9/1997','2/6/1997','1/14/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10410,N'BOTTM',3,'1/10/1997','2/7/1997','1/15/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10411,N'BOTTM',9,'1/10/1997','2/7/1997','1/21/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10412,N'WARTH',8,'1/13/1997','2/10/1997','1/15/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10413,N'LAMAI',3,'1/14/1997','2/11/1997','1/16/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10414,N'FAMIA',2,'1/14/1997','2/11/1997','1/17/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10415,N'HUNGC',3,'1/15/1997','2/12/1997','1/24/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10416,N'WARTH',8,'1/16/1997','2/13/1997','1/27/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10417,N'SIMOB',4,'1/16/1997','2/13/1997','1/28/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10418,N'QUICK',4,'1/17/1997','2/14/1997','1/24/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10419,N'RICSU',4,'1/20/1997','2/17/1997','1/30/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10420,N'WELLI',3,'1/21/1997','2/18/1997','1/27/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10421,N'QUEDE',8,'1/21/1997','3/4/1997','1/27/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10422,N'FRANS',2,'1/22/1997','2/19/1997','1/31/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10423,N'GOURL',6,'1/23/1997','2/6/1997','2/24/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10424,N'MEREP',7,'1/23/1997','2/20/1997','1/27/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10425,N'LAMAI',6,'1/24/1997','2/21/1997','2/14/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10426,N'GALED',4,'1/27/1997','2/24/1997','2/6/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10427,N'PICCO',4,'1/27/1997','2/24/1997','3/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10428,N'REGGC',7,'1/28/1997','2/25/1997','2/4/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10429,N'HUNGO',3,'1/29/1997','3/12/1997','2/7/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10430,N'ERNSH',4,'1/30/1997','2/13/1997','2/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10431,N'BOTTM',4,'1/30/1997','2/13/1997','2/7/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10432,N'SPLIR',3,'1/31/1997','2/14/1997','2/7/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10433,N'PRINI',3,'2/3/1997','3/3/1997','3/4/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10434,N'FOLKO',3,'2/3/1997','3/3/1997','2/13/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10435,N'CONSH',8,'2/4/1997','3/18/1997','2/7/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10436,N'BLONP',3,'2/5/1997','3/5/1997','2/11/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10437,N'WARTH',8,'2/5/1997','3/5/1997','2/12/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10438,N'TOMSP',3,'2/6/1997','3/6/1997','2/14/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10439,N'MEREP',6,'2/7/1997','3/7/1997','2/10/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10440,N'SAVEA',4,'2/10/1997','3/10/1997','2/28/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10441,N'OLDWO',3,'2/10/1997','3/24/1997','3/14/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10442,N'ERNSH',3,'2/11/1997','3/11/1997','2/18/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10443,N'REGGC',8,'2/12/1997','3/12/1997','2/14/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10444,N'BERGS',3,'2/12/1997','3/12/1997','2/21/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10445,N'BERGS',3,'2/13/1997','3/13/1997','2/20/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10446,N'TOMSP',6,'2/14/1997','3/14/1997','2/19/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10447,N'RICAR',4,'2/14/1997','3/14/1997','3/7/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10448,N'RANCH',4,'2/17/1997','3/17/1997','2/24/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10449,N'BLONP',3,'2/18/1997','3/18/1997','2/27/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10450,N'VICTE',8,'2/19/1997','3/19/1997','3/11/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10451,N'QUICK',4,'2/19/1997','3/5/1997','3/12/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10452,N'SAVEA',8,'2/20/1997','3/20/1997','2/26/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10453,N'AROUT',1,'2/21/1997','3/21/1997','2/26/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10454,N'LAMAI',4,'2/21/1997','3/21/1997','2/25/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10455,N'WARTH',8,'2/24/1997','4/7/1997','3/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10456,N'KOENE',8,'2/25/1997','4/8/1997','2/28/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10457,N'KOENE',2,'2/25/1997','3/25/1997','3/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10458,N'SUPRD',7,'2/26/1997','3/26/1997','3/4/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10459,N'VICTE',4,'2/27/1997','3/27/1997','2/28/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10460,N'FOLKO',8,'2/28/1997','3/28/1997','3/3/1997')
INSERT INTO Orders
(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate)
VALUES (10461,N'LILAS',1,'2/28/1997','3/28/1997','3/5/1997')
go
set identity_insert Orders off

go
set identity_insert Products on
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(1,'Chai',1,1,'10 boxes x 20 bags',18,39,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(2,'Chang',1,1,'24 - 12 oz bottles',19,17,40,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(3,'Aniseed Syrup',1,2,'12 - 550 ml bottles',10,13,70,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(4,'Chef Anton''s Cajun Seasoning',2,2,'48 - 6 oz jars',22,53,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(5,'Chef Anton''s Gumbo Mix',2,2,'36 boxes',21.35,0,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(6,'Grandma''s Boysenberry Spread',3,2,'12 - 8 oz jars',25,120,0,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(7,'Uncle Bob''s Organic Dried Pears',3,7,'12 - 1 lb pkgs.',30,15,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(8,'Northwoods Cranberry Sauce',3,2,'12 - 12 oz jars',40,6,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(9,'Mishi Kobe Niku',4,6,'18 - 500 g pkgs.',97,29,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(10,'Ikura',4,8,'12 - 200 ml jars',31,31,0,0,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(11,'Queso Cabrales',5,4,'1 kg pkg.',21,22,30,30,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(12,'Queso Manchego La Pastora',5,4,'10 - 500 g pkgs.',38,86,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(13,'Konbu',6,8,'2 kg box',6,24,0,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(14,'Tofu',6,7,'40 - 100 g pkgs.',23.25,35,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(15,'Genen Shouyu',6,2,'24 - 250 ml bottles',15.5,39,0,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(16,'Pavlova',7,3,'32 - 500 g boxes',17.45,29,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(17,'Alice Mutton',7,6,'20 - 1 kg tins',39,0,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(18,'Carnarvon Tigers',7,8,'16 kg pkg.',62.5,42,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(19,'Teatime Chocolate Biscuits',8,3,'10 boxes x 12 pieces',9.2,25,0,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(20,'Sir Rodney''s Marmalade',8,3,'30 gift boxes',81,40,0,0,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(21,'Sir Rodney''s Scones',8,3,'24 pkgs. x 4 pieces',10,3,40,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(22,'Gustaf''s Knäckebröd',9,5,'24 - 500 g pkgs.',21,104,0,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(23,'Tunnbröd',9,5,'12 - 250 g pkgs.',9,61,0,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(24,'Guaraná Fantástica',10,1,'12 - 355 ml cans',4.5,20,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(25,'NuNuCa Nuß-Nougat-Creme',11,3,'20 - 450 g glasses',14,76,0,30,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(26,'Gumbär Gummibärchen',11,3,'100 - 250 g bags',31.23,15,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(27,'Schoggi Schokolade',11,3,'100 - 100 g pieces',43.9,49,0,30,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(28,'Rössle Sauerkraut',12,7,'25 - 825 g cans',45.6,26,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(29,'Thüringer Rostbratwurst',12,6,'50 bags x 30 sausgs.',123.79,0,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(30,'Nord-Ost Matjeshering',13,8,'10 - 200 g glasses',25.89,10,0,15,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(31,'Gorgonzola Telino',14,4,'12 - 100 g pkgs',12.5,0,70,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(32,'Mascarpone Fabioli',14,4,'24 - 200 g pkgs.',32,9,40,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(33,'Geitost',15,4,'500 g',2.5,112,0,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(34,'Sasquatch Ale',16,1,'24 - 12 oz bottles',14,111,0,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(35,'Steeleye Stout',16,1,'24 - 12 oz bottles',18,20,0,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(36,'Inlagd Sill',17,8,'24 - 250 g  jars',19,112,0,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(37,'Gravad lax',17,8,'12 - 500 g pkgs.',26,11,50,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(38,'Côte de Blaye',18,1,'12 - 75 cl bottles',263.5,17,0,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(39,'Chartreuse verte',18,1,'750 cc per bottle',18,69,0,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(40,'Boston Crab Meat',19,8,'24 - 4 oz tins',18.4,123,0,30,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(41,'Jack''s New England Clam Chowder',19,8,'12 - 12 oz cans',9.65,85,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(42,'Singaporean Hokkien Fried Mee',20,5,'32 - 1 kg pkgs.',14,26,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(43,'Ipoh Coffee',20,1,'16 - 500 g tins',46,17,10,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(44,'Gula Malacca',20,2,'20 - 2 kg bags',19.45,27,0,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(45,'Rogede sild',21,8,'1k pkg.',9.5,5,70,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(46,'Spegesild',21,8,'4 - 450 g glasses',12,95,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(47,'Zaanse koeken',22,3,'10 - 4 oz boxes',9.5,36,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(48,'Chocolade',22,3,'10 pkgs.',12.75,15,70,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(49,'Maxilaku',23,3,'24 - 50 g pkgs.',20,10,60,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(50,'Valkoinen suklaa',23,3,'12 - 100 g bars',16.25,65,0,30,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(51,'Manjimup Dried Apples',24,7,'50 - 300 g pkgs.',53,20,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(52,'Filo Mix',24,5,'16 - 2 kg boxes',7,38,0,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(53,'Perth Pasties',24,6,'48 pieces',32.8,0,0,0,1)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(54,'Tourtière',25,6,'16 pies',7.45,21,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(55,'Pâté chinois',25,6,'24 boxes x 2 pies',24,115,0,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(56,'Gnocchi di nonna Alice',26,5,'24 - 250 g pkgs.',38,21,10,30,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(57,'Ravioli Angelo',26,5,'24 - 250 g pkgs.',19.5,36,0,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(58,'Escargots de Bourgogne',27,8,'24 pieces',13.25,62,0,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(59,'Raclette Courdavault',28,4,'5 kg pkg.',55,79,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(60,'Camembert Pierrot',28,4,'15 - 300 g rounds',34,19,0,0,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(61,'Sirop d''érable',29,2,'24 - 500 ml bottles',28.5,113,0,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(62,'Tarte au sucre',29,3,'48 pies',49.3,17,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(63,'Vegie-spread',7,2,'15 - 625 g jars',43.9,24,0,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(64,'Wimmers gute Semmelknödel',12,5,'20 bags x 4 pieces',33.25,22,80,30,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(65,'Louisiana Fiery Hot Pepper Sauce',2,2,'32 - 8 oz bottles',21.05,76,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(66,'Louisiana Hot Spiced Okra',2,2,'24 - 8 oz jars',17,4,100,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(67,'Laughing Lumberjack Lager',16,1,'24 - 12 oz bottles',14,52,0,10,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(68,'Scottish Longbreads',8,3,'10 boxes x 8 pieces',12.5,6,10,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(69,'Gudbrandsdalsost',15,4,'10 kg pkg.',36,26,0,15,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(70,'Outback Lager',7,1,'24 - 355 ml bottles',15,15,10,30,0)
go
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(71,'Flotemysost',15,4,'10 - 500 g pkgs.',21.5,26,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(72,'Mozzarella di Giovanni',14,4,'24 - 200 g pkgs.',34.8,14,0,0,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(73,'Röd Kaviar',17,8,'24 - 150 g jars',15,101,0,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(74,'Longlife Tofu',4,7,'5 kg pkg.',10,4,20,5,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(75,'Rhönbräu Klosterbier',12,1,'24 - 0.5 l bottles',7.75,125,0,25,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(76,'Lakkalikööri',23,1,'500 ml',18,57,0,20,0)
INSERT Products(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued) VALUES(77,'Original Frankfurter grüne Soße',12,2,'12 boxes',13,32,0,15,0)
go
set identity_insert Products off

go
INSERT OrderDetails VALUES(10248,11,14,12,0)
INSERT OrderDetails VALUES(10248,42,9.8,10,0)
INSERT OrderDetails VALUES(10248,72,34.8,5,0)
INSERT OrderDetails VALUES(10249,14,18.6,9,0)
INSERT OrderDetails VALUES(10249,51,42.4,40,0)
INSERT OrderDetails VALUES(10250,41,7.7,10,0)
INSERT OrderDetails VALUES(10250,51,42.4,35,0.15)
INSERT OrderDetails VALUES(10250,65,16.8,15,0.15)
INSERT OrderDetails VALUES(10251,22,16.8,6,0.05)
INSERT OrderDetails VALUES(10251,57,15.6,15,0.05)
go
INSERT OrderDetails VALUES(10251,65,16.8,20,0)
INSERT OrderDetails VALUES(10252,20,64.8,40,0.05)
INSERT OrderDetails VALUES(10252,33,2,25,0.05)
INSERT OrderDetails VALUES(10252,60,27.2,40,0)
INSERT OrderDetails VALUES(10253,31,10,20,0)
INSERT OrderDetails VALUES(10253,39,14.4,42,0)
INSERT OrderDetails VALUES(10253,49,16,40,0)
INSERT OrderDetails VALUES(10254,24,3.6,15,0.15)
INSERT OrderDetails VALUES(10254,55,19.2,21,0.15)
INSERT OrderDetails VALUES(10254,74,8,21,0)
go
INSERT OrderDetails VALUES(10255,2,15.2,20,0)
INSERT OrderDetails VALUES(10255,16,13.9,35,0)
INSERT OrderDetails VALUES(10255,36,15.2,25,0)
INSERT OrderDetails VALUES(10255,59,44,30,0)
INSERT OrderDetails VALUES(10256,53,26.2,15,0)
INSERT OrderDetails VALUES(10256,77,10.4,12,0)
INSERT OrderDetails VALUES(10257,27,35.1,25,0)
INSERT OrderDetails VALUES(10257,39,14.4,6,0)
INSERT OrderDetails VALUES(10257,77,10.4,15,0)
INSERT OrderDetails VALUES(10258,2,15.2,50,0.2)
go
INSERT OrderDetails VALUES(10258,5,17,65,0.2)
INSERT OrderDetails VALUES(10258,32,25.6,6,0.2)
INSERT OrderDetails VALUES(10259,21,8,10,0)
INSERT OrderDetails VALUES(10259,37,20.8,1,0)
INSERT OrderDetails VALUES(10260,41,7.7,16,0.25)
INSERT OrderDetails VALUES(10260,57,15.6,50,0)
INSERT OrderDetails VALUES(10260,62,39.4,15,0.25)
INSERT OrderDetails VALUES(10260,70,12,21,0.25)
INSERT OrderDetails VALUES(10261,21,8,20,0)
INSERT OrderDetails VALUES(10261,35,14.4,20,0)
go
INSERT OrderDetails VALUES(10262,5,17,12,0.2)
INSERT OrderDetails VALUES(10262,7,24,15,0)
INSERT OrderDetails VALUES(10262,56,30.4,2,0)
INSERT OrderDetails VALUES(10263,16,13.9,60,0.25)
INSERT OrderDetails VALUES(10263,24,3.6,28,0)
INSERT OrderDetails VALUES(10263,30,20.7,60,0.25)
INSERT OrderDetails VALUES(10263,74,8,36,0.25)
INSERT OrderDetails VALUES(10264,2,15.2,35,0)
INSERT OrderDetails VALUES(10264,41,7.7,25,0.15)
INSERT OrderDetails VALUES(10265,17,31.2,30,0)
go
INSERT OrderDetails VALUES(10265,70,12,20,0)
INSERT OrderDetails VALUES(10266,12,30.4,12,0.05)
INSERT OrderDetails VALUES(10267,40,14.7,50,0)
INSERT OrderDetails VALUES(10267,59,44,70,0.15)
INSERT OrderDetails VALUES(10267,76,14.4,15,0.15)
INSERT OrderDetails VALUES(10268,29,99,10,0)
INSERT OrderDetails VALUES(10268,72,27.8,4,0)
INSERT OrderDetails VALUES(10269,33,2,60,0.05)
INSERT OrderDetails VALUES(10269,72,27.8,20,0.05)
INSERT OrderDetails VALUES(10270,36,15.2,30,0)
go
INSERT OrderDetails VALUES(10270,43,36.8,25,0)
INSERT OrderDetails VALUES(10271,33,2,24,0)
INSERT OrderDetails VALUES(10272,20,64.8,6,0)
INSERT OrderDetails VALUES(10272,31,10,40,0)
INSERT OrderDetails VALUES(10272,72,27.8,24,0)
INSERT OrderDetails VALUES(10273,10,24.8,24,0.05)
INSERT OrderDetails VALUES(10273,31,10,15,0.05)
INSERT OrderDetails VALUES(10273,33,2,20,0)
INSERT OrderDetails VALUES(10273,40,14.7,60,0.05)
INSERT OrderDetails VALUES(10273,76,14.4,33,0.05)
go
INSERT OrderDetails VALUES(10274,71,17.2,20,0)
INSERT OrderDetails VALUES(10274,72,27.8,7,0)
INSERT OrderDetails VALUES(10275,24,3.6,12,0.05)
INSERT OrderDetails VALUES(10275,59,44,6,0.05)
INSERT OrderDetails VALUES(10276,10,24.8,15,0)
INSERT OrderDetails VALUES(10276,13,4.8,10,0)
INSERT OrderDetails VALUES(10277,28,36.4,20,0)
INSERT OrderDetails VALUES(10277,62,39.4,12,0)
INSERT OrderDetails VALUES(10278,44,15.5,16,0)
INSERT OrderDetails VALUES(10278,59,44,15,0)
go
INSERT OrderDetails VALUES(10278,63,35.1,8,0)
INSERT OrderDetails VALUES(10278,73,12,25,0)
INSERT OrderDetails VALUES(10279,17,31.2,15,0.25)
INSERT OrderDetails VALUES(10280,24,3.6,12,0)
INSERT OrderDetails VALUES(10280,55,19.2,20,0)
INSERT OrderDetails VALUES(10280,75,6.2,30,0)
INSERT OrderDetails VALUES(10281,19,7.3,1,0)
INSERT OrderDetails VALUES(10281,24,3.6,6,0)
INSERT OrderDetails VALUES(10281,35,14.4,4,0)
INSERT OrderDetails VALUES(10282,30,20.7,6,0)
go
INSERT OrderDetails VALUES(10282,57,15.6,2,0)
INSERT OrderDetails VALUES(10283,15,12.4,20,0)
INSERT OrderDetails VALUES(10283,19,7.3,18,0)
INSERT OrderDetails VALUES(10283,60,27.2,35,0)
INSERT OrderDetails VALUES(10283,72,27.8,3,0)
INSERT OrderDetails VALUES(10284,27,35.1,15,0.25)
INSERT OrderDetails VALUES(10284,44,15.5,21,0)
INSERT OrderDetails VALUES(10284,60,27.2,20,0.25)
INSERT OrderDetails VALUES(10284,67,11.2,5,0.25)
INSERT OrderDetails VALUES(10285,1,14.4,45,0.2)
go
INSERT OrderDetails VALUES(10285,40,14.7,40,0.2)
INSERT OrderDetails VALUES(10285,53,26.2,36,0.2)
INSERT OrderDetails VALUES(10286,35,14.4,100,0)
INSERT OrderDetails VALUES(10286,62,39.4,40,0)
INSERT OrderDetails VALUES(10287,16,13.9,40,0.15)
INSERT OrderDetails VALUES(10287,34,11.2,20,0)
INSERT OrderDetails VALUES(10287,46,9.6,15,0.15)
INSERT OrderDetails VALUES(10288,54,5.9,10,0.1)
INSERT OrderDetails VALUES(10288,68,10,3,0.1)
INSERT OrderDetails VALUES(10289,3,8,30,0)
go
INSERT OrderDetails VALUES(10289,64,26.6,9,0)
INSERT OrderDetails VALUES(10290,5,17,20,0)
INSERT OrderDetails VALUES(10290,29,99,15,0)
INSERT OrderDetails VALUES(10290,49,16,15,0)
INSERT OrderDetails VALUES(10290,77,10.4,10,0)
INSERT OrderDetails VALUES(10291,13,4.8,20,0.1)
INSERT OrderDetails VALUES(10291,44,15.5,24,0.1)
INSERT OrderDetails VALUES(10291,51,42.4,2,0.1)
INSERT OrderDetails VALUES(10292,20,64.8,20,0)
INSERT OrderDetails VALUES(10293,18,50,12,0)
go
INSERT OrderDetails VALUES(10293,24,3.6,10,0)
INSERT OrderDetails VALUES(10293,63,35.1,5,0)
INSERT OrderDetails VALUES(10293,75,6.2,6,0)
INSERT OrderDetails VALUES(10294,1,14.4,18,0)
INSERT OrderDetails VALUES(10294,17,31.2,15,0)
INSERT OrderDetails VALUES(10294,43,36.8,15,0)
INSERT OrderDetails VALUES(10294,60,27.2,21,0)
INSERT OrderDetails VALUES(10294,75,6.2,6,0)
INSERT OrderDetails VALUES(10295,56,30.4,4,0)
INSERT OrderDetails VALUES(10296,11,16.8,12,0)
go
INSERT OrderDetails VALUES(10296,16,13.9,30,0)
INSERT OrderDetails VALUES(10296,69,28.8,15,0)
INSERT OrderDetails VALUES(10297,39,14.4,60,0)
INSERT OrderDetails VALUES(10297,72,27.8,20,0)
INSERT OrderDetails VALUES(10298,2,15.2,40,0)
INSERT OrderDetails VALUES(10298,36,15.2,40,0.25)
INSERT OrderDetails VALUES(10298,59,44,30,0.25)
INSERT OrderDetails VALUES(10298,62,39.4,15,0)
INSERT OrderDetails VALUES(10299,19,7.3,15,0)
INSERT OrderDetails VALUES(10299,70,12,20,0)
go
INSERT OrderDetails VALUES(10300,66,13.6,30,0)
INSERT OrderDetails VALUES(10300,68,10,20,0)
INSERT OrderDetails VALUES(10301,40,14.7,10,0)
INSERT OrderDetails VALUES(10301,56,30.4,20,0)
INSERT OrderDetails VALUES(10302,17,31.2,40,0)
INSERT OrderDetails VALUES(10302,28,36.4,28,0)
INSERT OrderDetails VALUES(10302,43,36.8,12,0)
INSERT OrderDetails VALUES(10303,40,14.7,40,0.1)
INSERT OrderDetails VALUES(10303,65,16.8,30,0.1)
INSERT OrderDetails VALUES(10303,68,10,15,0.1)
go
INSERT OrderDetails VALUES(10304,49,16,30,0)
INSERT OrderDetails VALUES(10304,59,44,10,0)
INSERT OrderDetails VALUES(10304,71,17.2,2,0)
INSERT OrderDetails VALUES(10305,18,50,25,0.1)
INSERT OrderDetails VALUES(10305,29,99,25,0.1)
INSERT OrderDetails VALUES(10305,39,14.4,30,0.1)
INSERT OrderDetails VALUES(10306,30,20.7,10,0)
INSERT OrderDetails VALUES(10306,53,26.2,10,0)
INSERT OrderDetails VALUES(10306,54,5.9,5,0)
INSERT OrderDetails VALUES(10307,62,39.4,10,0)
go
INSERT OrderDetails VALUES(10307,68,10,3,0)
INSERT OrderDetails VALUES(10308,69,28.8,1,0)
INSERT OrderDetails VALUES(10308,70,12,5,0)
INSERT OrderDetails VALUES(10309,4,17.6,20,0)
INSERT OrderDetails VALUES(10309,6,20,30,0)
INSERT OrderDetails VALUES(10309,42,11.2,2,0)
INSERT OrderDetails VALUES(10309,43,36.8,20,0)
INSERT OrderDetails VALUES(10309,71,17.2,3,0)
INSERT OrderDetails VALUES(10310,16,13.9,10,0)
INSERT OrderDetails VALUES(10310,62,39.4,5,0)
go
INSERT OrderDetails VALUES(10311,42,11.2,6,0)
INSERT OrderDetails VALUES(10311,69,28.8,7,0)
INSERT OrderDetails VALUES(10312,28,36.4,4,0)
INSERT OrderDetails VALUES(10312,43,36.8,24,0)
INSERT OrderDetails VALUES(10312,53,26.2,20,0)
INSERT OrderDetails VALUES(10312,75,6.2,10,0)
INSERT OrderDetails VALUES(10313,36,15.2,12,0)
INSERT OrderDetails VALUES(10314,32,25.6,40,0.1)
INSERT OrderDetails VALUES(10314,58,10.6,30,0.1)
INSERT OrderDetails VALUES(10314,62,39.4,25,0.1)
go
INSERT OrderDetails VALUES(10315,34,11.2,14,0)
INSERT OrderDetails VALUES(10315,70,12,30,0)
INSERT OrderDetails VALUES(10316,41,7.7,10,0)
INSERT OrderDetails VALUES(10316,62,39.4,70,0)
INSERT OrderDetails VALUES(10317,1,14.4,20,0)
INSERT OrderDetails VALUES(10318,41,7.7,20,0)
INSERT OrderDetails VALUES(10318,76,14.4,6,0)
INSERT OrderDetails VALUES(10319,17,31.2,8,0)
INSERT OrderDetails VALUES(10319,28,36.4,14,0)
INSERT OrderDetails VALUES(10319,76,14.4,30,0)
go
INSERT OrderDetails VALUES(10320,71,17.2,30,0)
INSERT OrderDetails VALUES(10321,35,14.4,10,0)
INSERT OrderDetails VALUES(10322,52,5.6,20,0)
INSERT OrderDetails VALUES(10323,15,12.4,5,0)
INSERT OrderDetails VALUES(10323,25,11.2,4,0)
INSERT OrderDetails VALUES(10323,39,14.4,4,0)
INSERT OrderDetails VALUES(10324,16,13.9,21,0.15)
INSERT OrderDetails VALUES(10324,35,14.4,70,0.15)
INSERT OrderDetails VALUES(10324,46,9.6,30,0)
INSERT OrderDetails VALUES(10324,59,44,40,0.15)
go
INSERT OrderDetails VALUES(10324,63,35.1,80,0.15)
INSERT OrderDetails VALUES(10325,6,20,6,0)
INSERT OrderDetails VALUES(10325,13,4.8,12,0)
INSERT OrderDetails VALUES(10325,14,18.6,9,0)
INSERT OrderDetails VALUES(10325,31,10,4,0)
INSERT OrderDetails VALUES(10325,72,27.8,40,0)
INSERT OrderDetails VALUES(10326,4,17.6,24,0)
INSERT OrderDetails VALUES(10326,57,15.6,16,0)
INSERT OrderDetails VALUES(10326,75,6.2,50,0)
INSERT OrderDetails VALUES(10327,2,15.2,25,0.2)
go
INSERT OrderDetails VALUES(10327,11,16.8,50,0.2)
INSERT OrderDetails VALUES(10327,30,20.7,35,0.2)
INSERT OrderDetails VALUES(10327,58,10.6,30,0.2)
INSERT OrderDetails VALUES(10328,59,44,9,0)
INSERT OrderDetails VALUES(10328,65,16.8,40,0)
INSERT OrderDetails VALUES(10328,68,10,10,0)
INSERT OrderDetails VALUES(10329,19,7.3,10,0.05)
INSERT OrderDetails VALUES(10329,30,20.7,8,0.05)
INSERT OrderDetails VALUES(10329,38,210.8,20,0.05)
INSERT OrderDetails VALUES(10329,56,30.4,12,0.05)
go
INSERT OrderDetails VALUES(10330,26,24.9,50,0.15)
INSERT OrderDetails VALUES(10330,72,27.8,25,0.15)
INSERT OrderDetails VALUES(10331,54,5.9,15,0)
INSERT OrderDetails VALUES(10332,18,50,40,0.2)
INSERT OrderDetails VALUES(10332,42,11.2,10,0.2)
INSERT OrderDetails VALUES(10332,47,7.6,16,0.2)
INSERT OrderDetails VALUES(10333,14,18.6,10,0)
INSERT OrderDetails VALUES(10333,21,8,10,0.1)
INSERT OrderDetails VALUES(10333,71,17.2,40,0.1)
INSERT OrderDetails VALUES(10334,52,5.6,8,0)
go
INSERT OrderDetails VALUES(10334,68,10,10,0)
INSERT OrderDetails VALUES(10335,2,15.2,7,0.2)
INSERT OrderDetails VALUES(10335,31,10,25,0.2)
INSERT OrderDetails VALUES(10335,32,25.6,6,0.2)
INSERT OrderDetails VALUES(10335,51,42.4,48,0.2)
INSERT OrderDetails VALUES(10336,4,17.6,18,0.1)
INSERT OrderDetails VALUES(10337,23,7.2,40,0)
INSERT OrderDetails VALUES(10337,26,24.9,24,0)
INSERT OrderDetails VALUES(10337,36,15.2,20,0)
INSERT OrderDetails VALUES(10337,37,20.8,28,0)
go
INSERT OrderDetails VALUES(10337,72,27.8,25,0)
INSERT OrderDetails VALUES(10338,17,31.2,20,0)
INSERT OrderDetails VALUES(10338,30,20.7,15,0)
INSERT OrderDetails VALUES(10339,4,17.6,10,0)
INSERT OrderDetails VALUES(10339,17,31.2,70,0.05)
INSERT OrderDetails VALUES(10339,62,39.4,28,0)
INSERT OrderDetails VALUES(10340,18,50,20,0.05)
INSERT OrderDetails VALUES(10340,41,7.7,12,0.05)
INSERT OrderDetails VALUES(10340,43,36.8,40,0.05)
INSERT OrderDetails VALUES(10341,33,2,8,0)
go
INSERT OrderDetails VALUES(10341,59,44,9,0.15)
INSERT OrderDetails VALUES(10342,2,15.2,24,0.2)
INSERT OrderDetails VALUES(10342,31,10,56,0.2)
INSERT OrderDetails VALUES(10342,36,15.2,40,0.2)
INSERT OrderDetails VALUES(10342,55,19.2,40,0.2)
INSERT OrderDetails VALUES(10343,64,26.6,50,0)
INSERT OrderDetails VALUES(10343,68,10,4,0.05)
INSERT OrderDetails VALUES(10343,76,14.4,15,0)
INSERT OrderDetails VALUES(10344,4,17.6,35,0)
INSERT OrderDetails VALUES(10344,8,32,70,0.25)
go
INSERT OrderDetails VALUES(10345,8,32,70,0)
INSERT OrderDetails VALUES(10345,19,7.3,80,0)
INSERT OrderDetails VALUES(10345,42,11.2,9,0)
INSERT OrderDetails VALUES(10346,17,31.2,36,0.1)
INSERT OrderDetails VALUES(10346,56,30.4,20,0)
INSERT OrderDetails VALUES(10347,25,11.2,10,0)
INSERT OrderDetails VALUES(10347,39,14.4,50,0.15)
INSERT OrderDetails VALUES(10347,40,14.7,4,0)
INSERT OrderDetails VALUES(10347,75,6.2,6,0.15)
INSERT OrderDetails VALUES(10348,1,14.4,15,0.15)
go
INSERT OrderDetails VALUES(10348,23,7.2,25,0)
INSERT OrderDetails VALUES(10349,54,5.9,24,0)
INSERT OrderDetails VALUES(10350,50,13,15,0.1)
INSERT OrderDetails VALUES(10350,69,28.8,18,0.1)
INSERT OrderDetails VALUES(10351,38,210.8,20,0.05)
INSERT OrderDetails VALUES(10351,41,7.7,13,0)
INSERT OrderDetails VALUES(10351,44,15.5,77,0.05)
INSERT OrderDetails VALUES(10351,65,16.8,10,0.05)
INSERT OrderDetails VALUES(10352,24,3.6,10,0)
INSERT OrderDetails VALUES(10352,54,5.9,20,0.15)
go
INSERT OrderDetails VALUES(10353,11,16.8,12,0.2)
INSERT OrderDetails VALUES(10353,38,210.8,50,0.2)
INSERT OrderDetails VALUES(10354,1,14.4,12,0)
INSERT OrderDetails VALUES(10354,29,99,4,0)
INSERT OrderDetails VALUES(10355,24,3.6,25,0)
INSERT OrderDetails VALUES(10355,57,15.6,25,0)
INSERT OrderDetails VALUES(10356,31,10,30,0)
INSERT OrderDetails VALUES(10356,55,19.2,12,0)
INSERT OrderDetails VALUES(10356,69,28.8,20,0)
INSERT OrderDetails VALUES(10357,10,24.8,30,0.2)
go
INSERT OrderDetails VALUES(10357,26,24.9,16,0)
INSERT OrderDetails VALUES(10357,60,27.2,8,0.2)
INSERT OrderDetails VALUES(10358,24,3.6,10,0.05)
INSERT OrderDetails VALUES(10358,34,11.2,10,0.05)
INSERT OrderDetails VALUES(10358,36,15.2,20,0.05)
INSERT OrderDetails VALUES(10359,16,13.9,56,0.05)
INSERT OrderDetails VALUES(10359,31,10,70,0.05)
INSERT OrderDetails VALUES(10359,60,27.2,80,0.05)
INSERT OrderDetails VALUES(10360,28,36.4,30,0)
INSERT OrderDetails VALUES(10360,29,99,35,0)
go
INSERT OrderDetails VALUES(10360,38,210.8,10,0)
INSERT OrderDetails VALUES(10360,49,16,35,0)
INSERT OrderDetails VALUES(10360,54,5.9,28,0)
INSERT OrderDetails VALUES(10361,39,14.4,54,0.1)
INSERT OrderDetails VALUES(10361,60,27.2,55,0.1)
INSERT OrderDetails VALUES(10362,25,11.2,50,0)
INSERT OrderDetails VALUES(10362,51,42.4,20,0)
INSERT OrderDetails VALUES(10362,54,5.9,24,0)
INSERT OrderDetails VALUES(10363,31,10,20,0)
INSERT OrderDetails VALUES(10363,75,6.2,12,0)
go
INSERT OrderDetails VALUES(10363,76,14.4,12,0)
INSERT OrderDetails VALUES(10364,69,28.8,30,0)
INSERT OrderDetails VALUES(10364,71,17.2,5,0)
INSERT OrderDetails VALUES(10365,11,16.8,24,0)
INSERT OrderDetails VALUES(10366,65,16.8,5,0)
INSERT OrderDetails VALUES(10366,77,10.4,5,0)
INSERT OrderDetails VALUES(10367,34,11.2,36,0)
INSERT OrderDetails VALUES(10367,54,5.9,18,0)
INSERT OrderDetails VALUES(10367,65,16.8,15,0)
INSERT OrderDetails VALUES(10367,77,10.4,7,0)
go
INSERT OrderDetails VALUES(10368,21,8,5,0.1)
INSERT OrderDetails VALUES(10368,28,36.4,13,0.1)
INSERT OrderDetails VALUES(10368,57,15.6,25,0)
INSERT OrderDetails VALUES(10368,64,26.6,35,0.1)
INSERT OrderDetails VALUES(10369,29,99,20,0)
INSERT OrderDetails VALUES(10369,56,30.4,18,0.25)
INSERT OrderDetails VALUES(10370,1,14.4,15,0.15)
INSERT OrderDetails VALUES(10370,64,26.6,30,0)
INSERT OrderDetails VALUES(10370,74,8,20,0.15)
INSERT OrderDetails VALUES(10371,36,15.2,6,0.2)
go
INSERT OrderDetails VALUES(10372,20,64.8,12,0.25)
INSERT OrderDetails VALUES(10372,38,210.8,40,0.25)
INSERT OrderDetails VALUES(10372,60,27.2,70,0.25)
INSERT OrderDetails VALUES(10372,72,27.8,42,0.25)
INSERT OrderDetails VALUES(10373,58,10.6,80,0.2)
INSERT OrderDetails VALUES(10373,71,17.2,50,0.2)
INSERT OrderDetails VALUES(10374,31,10,30,0)
INSERT OrderDetails VALUES(10374,58,10.6,15,0)
INSERT OrderDetails VALUES(10375,14,18.6,15,0)
INSERT OrderDetails VALUES(10375,54,5.9,10,0)
go
INSERT OrderDetails VALUES(10376,31,10,42,0.05)
INSERT OrderDetails VALUES(10377,28,36.4,20,0.15)
INSERT OrderDetails VALUES(10377,39,14.4,20,0.15)
INSERT OrderDetails VALUES(10378,71,17.2,6,0)
INSERT OrderDetails VALUES(10379,41,7.7,8,0.1)
INSERT OrderDetails VALUES(10379,63,35.1,16,0.1)
INSERT OrderDetails VALUES(10379,65,16.8,20,0.1)
INSERT OrderDetails VALUES(10380,30,20.7,18,0.1)
INSERT OrderDetails VALUES(10380,53,26.2,20,0.1)
INSERT OrderDetails VALUES(10380,60,27.2,6,0.1)
go
INSERT OrderDetails VALUES(10380,70,12,30,0)
INSERT OrderDetails VALUES(10381,74,8,14,0)
INSERT OrderDetails VALUES(10382,5,17,32,0)
INSERT OrderDetails VALUES(10382,18,50,9,0)
INSERT OrderDetails VALUES(10382,29,99,14,0)
INSERT OrderDetails VALUES(10382,33,2,60,0)
INSERT OrderDetails VALUES(10382,74,8,50,0)
INSERT OrderDetails VALUES(10383,13,4.8,20,0)
INSERT OrderDetails VALUES(10383,50,13,15,0)
INSERT OrderDetails VALUES(10383,56,30.4,20,0)
go
INSERT OrderDetails VALUES(10384,20,64.8,28,0)
INSERT OrderDetails VALUES(10384,60,27.2,15,0)
INSERT OrderDetails VALUES(10385,7,24,10,0.2)
INSERT OrderDetails VALUES(10385,60,27.2,20,0.2)
INSERT OrderDetails VALUES(10385,68,10,8,0.2)
INSERT OrderDetails VALUES(10386,24,3.6,15,0)
INSERT OrderDetails VALUES(10386,34,11.2,10,0)
INSERT OrderDetails VALUES(10387,24,3.6,15,0)
INSERT OrderDetails VALUES(10387,28,36.4,6,0)
INSERT OrderDetails VALUES(10387,59,44,12,0)
go
INSERT OrderDetails VALUES(10387,71,17.2,15,0)
INSERT OrderDetails VALUES(10388,45,7.6,15,0.2)
INSERT OrderDetails VALUES(10388,52,5.6,20,0.2)
INSERT OrderDetails VALUES(10388,53,26.2,40,0)
INSERT OrderDetails VALUES(10389,10,24.8,16,0)
INSERT OrderDetails VALUES(10389,55,19.2,15,0)
INSERT OrderDetails VALUES(10389,62,39.4,20,0)
INSERT OrderDetails VALUES(10389,70,12,30,0)
INSERT OrderDetails VALUES(10390,31,10,60,0.1)
INSERT OrderDetails VALUES(10390,35,14.4,40,0.1)
go
INSERT OrderDetails VALUES(10390,46,9.6,45,0)
INSERT OrderDetails VALUES(10390,72,27.8,24,0.1)
INSERT OrderDetails VALUES(10391,13,4.8,18,0)
INSERT OrderDetails VALUES(10392,69,28.8,50,0)
INSERT OrderDetails VALUES(10393,2,15.2,25,0.25)
INSERT OrderDetails VALUES(10393,14,18.6,42,0.25)
INSERT OrderDetails VALUES(10393,25,11.2,7,0.25)
INSERT OrderDetails VALUES(10393,26,24.9,70,0.25)
INSERT OrderDetails VALUES(10393,31,10,32,0)
INSERT OrderDetails VALUES(10394,13,4.8,10,0)
go
INSERT OrderDetails VALUES(10394,62,39.4,10,0)
INSERT OrderDetails VALUES(10395,46,9.6,28,0.1)
INSERT OrderDetails VALUES(10395,53,26.2,70,0.1)
INSERT OrderDetails VALUES(10395,69,28.8,8,0)
INSERT OrderDetails VALUES(10396,23,7.2,40,0)
INSERT OrderDetails VALUES(10396,71,17.2,60,0)
INSERT OrderDetails VALUES(10396,72,27.8,21,0)
INSERT OrderDetails VALUES(10397,21,8,10,0.15)
INSERT OrderDetails VALUES(10397,51,42.4,18,0.15)
INSERT OrderDetails VALUES(10398,35,14.4,30,0)
go
INSERT OrderDetails VALUES(10398,55,19.2,120,0.1)
INSERT OrderDetails VALUES(10399,68,10,60,0)
INSERT OrderDetails VALUES(10399,71,17.2,30,0)
INSERT OrderDetails VALUES(10399,76,14.4,35,0)
INSERT OrderDetails VALUES(10399,77,10.4,14,0)
INSERT OrderDetails VALUES(10400,29,99,21,0)
INSERT OrderDetails VALUES(10400,35,14.4,35,0)
INSERT OrderDetails VALUES(10400,49,16,30,0)
INSERT OrderDetails VALUES(10401,30,20.7,18,0)
INSERT OrderDetails VALUES(10401,56,30.4,70,0)
go
INSERT OrderDetails VALUES(10401,65,16.8,20,0)
INSERT OrderDetails VALUES(10401,71,17.2,60,0)
INSERT OrderDetails VALUES(10402,23,7.2,60,0)
INSERT OrderDetails VALUES(10402,63,35.1,65,0)
INSERT OrderDetails VALUES(10403,16,13.9,21,0.15)
INSERT OrderDetails VALUES(10403,48,10.2,70,0.15)
INSERT OrderDetails VALUES(10404,26,24.9,30,0.05)
INSERT OrderDetails VALUES(10404,42,11.2,40,0.05)
INSERT OrderDetails VALUES(10404,49,16,30,0.05)
INSERT OrderDetails VALUES(10405,3,8,50,0)
go
INSERT OrderDetails VALUES(10406,1,14.4,10,0)
INSERT OrderDetails VALUES(10406,21,8,30,0.1)
INSERT OrderDetails VALUES(10406,28,36.4,42,0.1)
INSERT OrderDetails VALUES(10406,36,15.2,5,0.1)
INSERT OrderDetails VALUES(10406,40,14.7,2,0.1)
INSERT OrderDetails VALUES(10407,11,16.8,30,0)
INSERT OrderDetails VALUES(10407,69,28.8,15,0)
INSERT OrderDetails VALUES(10407,71,17.2,15,0)
INSERT OrderDetails VALUES(10408,37,20.8,10,0)
INSERT OrderDetails VALUES(10408,54,5.9,6,0)
go
INSERT OrderDetails VALUES(10408,62,39.4,35,0)
INSERT OrderDetails VALUES(10409,14,18.6,12,0)
INSERT OrderDetails VALUES(10409,21,8,12,0)
INSERT OrderDetails VALUES(10410,33,2,49,0)
INSERT OrderDetails VALUES(10410,59,44,16,0)
INSERT OrderDetails VALUES(10411,41,7.7,25,0.2)
INSERT OrderDetails VALUES(10411,44,15.5,40,0.2)
INSERT OrderDetails VALUES(10411,59,44,9,0.2)
INSERT OrderDetails VALUES(10412,14,18.6,20,0.1)
INSERT OrderDetails VALUES(10413,1,14.4,24,0)
go
INSERT OrderDetails VALUES(10413,62,39.4,40,0)
INSERT OrderDetails VALUES(10413,76,14.4,14,0)
INSERT OrderDetails VALUES(10414,19,7.3,18,0.05)
INSERT OrderDetails VALUES(10414,33,2,50,0)
INSERT OrderDetails VALUES(10415,17,31.2,2,0)
INSERT OrderDetails VALUES(10415,33,2,20,0)
INSERT OrderDetails VALUES(10416,19,7.3,20,0)
INSERT OrderDetails VALUES(10416,53,26.2,10,0)
INSERT OrderDetails VALUES(10416,57,15.6,20,0)
INSERT OrderDetails VALUES(10417,38,210.8,50,0)
go
INSERT OrderDetails VALUES(10417,46,9.6,2,0.25)
INSERT OrderDetails VALUES(10417,68,10,36,0.25)
INSERT OrderDetails VALUES(10417,77,10.4,35,0)
INSERT OrderDetails VALUES(10418,2,15.2,60,0)
INSERT OrderDetails VALUES(10418,47,7.6,55,0)
INSERT OrderDetails VALUES(10418,61,22.8,16,0)
INSERT OrderDetails VALUES(10418,74,8,15,0)
INSERT OrderDetails VALUES(10419,60,27.2,60,0.05)
INSERT OrderDetails VALUES(10419,69,28.8,20,0.05)
INSERT OrderDetails VALUES(10420,9,77.6,20,0.1)
go
INSERT OrderDetails VALUES(10420,13,4.8,2,0.1)
INSERT OrderDetails VALUES(10420,70,12,8,0.1)
INSERT OrderDetails VALUES(10420,73,12,20,0.1)
INSERT OrderDetails VALUES(10421,19,7.3,4,0.15)
INSERT OrderDetails VALUES(10421,26,24.9,30,0)
INSERT OrderDetails VALUES(10421,53,26.2,15,0.15)
INSERT OrderDetails VALUES(10421,77,10.4,10,0.15)
INSERT OrderDetails VALUES(10422,26,24.9,2,0)
INSERT OrderDetails VALUES(10423,31,10,14,0)
INSERT OrderDetails VALUES(10423,59,44,20,0)
go
INSERT OrderDetails VALUES(10424,35,14.4,60,0.2)
INSERT OrderDetails VALUES(10424,38,210.8,49,0.2)
INSERT OrderDetails VALUES(10424,68,10,30,0.2)
INSERT OrderDetails VALUES(10425,55,19.2,10,0.25)
INSERT OrderDetails VALUES(10425,76,14.4,20,0.25)
INSERT OrderDetails VALUES(10426,56,30.4,5,0)
INSERT OrderDetails VALUES(10426,64,26.6,7,0)
INSERT OrderDetails VALUES(10427,14,18.6,35,0)
INSERT OrderDetails VALUES(10428,46,9.6,20,0)
INSERT OrderDetails VALUES(10429,50,13,40,0)
go
INSERT OrderDetails VALUES(10429,63,35.1,35,0.25)
INSERT OrderDetails VALUES(10430,17,31.2,45,0.2)
INSERT OrderDetails VALUES(10430,21,8,50,0)
INSERT OrderDetails VALUES(10430,56,30.4,30,0)
INSERT OrderDetails VALUES(10430,59,44,70,0.2)
INSERT OrderDetails VALUES(10431,17,31.2,50,0.25)
INSERT OrderDetails VALUES(10431,40,14.7,50,0.25)
INSERT OrderDetails VALUES(10431,47,7.6,30,0.25)
INSERT OrderDetails VALUES(10432,26,24.9,10,0)
INSERT OrderDetails VALUES(10432,54,5.9,40,0)
go
INSERT OrderDetails VALUES(10433,56,30.4,28,0)
INSERT OrderDetails VALUES(10434,11,16.8,6,0)
INSERT OrderDetails VALUES(10434,76,14.4,18,0.15)
INSERT OrderDetails VALUES(10435,2,15.2,10,0)
INSERT OrderDetails VALUES(10435,22,16.8,12,0)
INSERT OrderDetails VALUES(10435,72,27.8,10,0)
INSERT OrderDetails VALUES(10436,46,9.6,5,0)
INSERT OrderDetails VALUES(10436,56,30.4,40,0.1)
INSERT OrderDetails VALUES(10436,64,26.6,30,0.1)
INSERT OrderDetails VALUES(10436,75,6.2,24,0.1)
go
INSERT OrderDetails VALUES(10437,53,26.2,15,0)
INSERT OrderDetails VALUES(10438,19,7.3,15,0.2)
INSERT OrderDetails VALUES(10438,34,11.2,20,0.2)
INSERT OrderDetails VALUES(10438,57,15.6,15,0.2)
INSERT OrderDetails VALUES(10439,12,30.4,15,0)
INSERT OrderDetails VALUES(10439,16,13.9,16,0)
INSERT OrderDetails VALUES(10439,64,26.6,6,0)
INSERT OrderDetails VALUES(10439,74,8,30,0)
INSERT OrderDetails VALUES(10440,2,15.2,45,0.15)
INSERT OrderDetails VALUES(10440,16,13.9,49,0.15)
go
INSERT OrderDetails VALUES(10440,29,99,24,0.15)
INSERT OrderDetails VALUES(10440,61,22.8,90,0.15)
INSERT OrderDetails VALUES(10441,27,35.1,50,0)
INSERT OrderDetails VALUES(10442,11,16.8,30,0)
INSERT OrderDetails VALUES(10442,54,5.9,80,0)
INSERT OrderDetails VALUES(10442,66,13.6,60,0)
INSERT OrderDetails VALUES(10443,11,16.8,6,0.2)
INSERT OrderDetails VALUES(10443,28,36.4,12,0)
INSERT OrderDetails VALUES(10444,17,31.2,10,0)
INSERT OrderDetails VALUES(10444,26,24.9,15,0)
go
INSERT OrderDetails VALUES(10444,35,14.4,8,0)
INSERT OrderDetails VALUES(10444,41,7.7,30,0)
INSERT OrderDetails VALUES(10445,39,14.4,6,0)
INSERT OrderDetails VALUES(10445,54,5.9,15,0)
INSERT OrderDetails VALUES(10446,19,7.3,12,0.1)
INSERT OrderDetails VALUES(10446,24,3.6,20,0.1)
INSERT OrderDetails VALUES(10446,31,10,3,0.1)
INSERT OrderDetails VALUES(10446,52,5.6,15,0.1)
INSERT OrderDetails VALUES(10447,19,7.3,40,0)
INSERT OrderDetails VALUES(10447,65,16.8,35,0)
go
INSERT OrderDetails VALUES(10447,71,17.2,2,0)
INSERT OrderDetails VALUES(10448,26,24.9,6,0)
INSERT OrderDetails VALUES(10448,40,14.7,20,0)
INSERT OrderDetails VALUES(10449,10,24.8,14,0)
INSERT OrderDetails VALUES(10449,52,5.6,20,0)
INSERT OrderDetails VALUES(10449,62,39.4,35,0)
INSERT OrderDetails VALUES(10450,10,24.8,20,0.2)
INSERT OrderDetails VALUES(10450,54,5.9,6,0.2)
INSERT OrderDetails VALUES(10451,55,19.2,120,0.1)
INSERT OrderDetails VALUES(10451,64,26.6,35,0.1)
go
INSERT OrderDetails VALUES(10451,65,16.8,28,0.1)
INSERT OrderDetails VALUES(10451,77,10.4,55,0.1)
INSERT OrderDetails VALUES(10452,28,36.4,15,0)
INSERT OrderDetails VALUES(10452,44,15.5,100,0.05)
INSERT OrderDetails VALUES(10453,48,10.2,15,0.1)
INSERT OrderDetails VALUES(10453,70,12,25,0.1)
INSERT OrderDetails VALUES(10454,16,13.9,20,0.2)
INSERT OrderDetails VALUES(10454,33,2,20,0.2)
INSERT OrderDetails VALUES(10454,46,9.6,10,0.2)
INSERT OrderDetails VALUES(10455,39,14.4,20,0)
go
INSERT OrderDetails VALUES(10455,53,26.2,50,0)
INSERT OrderDetails VALUES(10455,61,22.8,25,0)
INSERT OrderDetails VALUES(10455,71,17.2,30,0)
INSERT OrderDetails VALUES(10456,21,8,40,0.15)
INSERT OrderDetails VALUES(10456,49,16,21,0.15)
INSERT OrderDetails VALUES(10457,59,44,36,0)
INSERT OrderDetails VALUES(10458,26,24.9,30,0)
INSERT OrderDetails VALUES(10458,28,36.4,30,0)
INSERT OrderDetails VALUES(10458,43,36.8,20,0)
INSERT OrderDetails VALUES(10458,56,30.4,15,0)
go
INSERT OrderDetails VALUES(10458,71,17.2,50,0)
INSERT OrderDetails VALUES(10459,7,24,16,0.05)
INSERT OrderDetails VALUES(10459,46,9.6,20,0.05)
INSERT OrderDetails VALUES(10459,72,27.8,40,0)
INSERT OrderDetails VALUES(10460,68,10,21,0.25)
INSERT OrderDetails VALUES(10460,75,6.2,4,0.25)
INSERT OrderDetails VALUES(10461,21,8,40,0.25)
INSERT OrderDetails VALUES(10461,30,20.7,28,0.25)
INSERT OrderDetails VALUES(10461,55,19.2,60,0.25)
go
