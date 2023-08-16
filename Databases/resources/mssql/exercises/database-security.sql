-- 2
/*Create a login student1. Do not assign any permissions yet.*/
CREATE LOGIN student1
    WITH PASSWORD ='TI_student' MUST_CHANGE,
    CHECK_EXPIRATION = ON,
    CHECK_POLICY = ON;

-- 3
/*Grant student1 access to the database
school, no other permissions.*/
USE school;
CREATE USER student1;

/* Add student1 to the db_datareader role
of the database school */
ALTER ROLE db_datareader
    ADD MEMBER [student1];

/*Allow student1 to add, update and delete
data in all tables of the database school
(db_datawriter). */
ALTER ROLE db_datawriter
    ADD MEMBER [student1];

/*Ensure that student1 can also execute
DDL statements in the database school*/
ALTER ROLE db_ddladmin
    ADD MEMBER [student1];

/*Remove permissions of student1 to the
database school. Only allow student1 to
read in this database.*/
ALTER ROLE db_datawriter
    DROP MEMBER [student1];
ALTER ROLE db_ddladmin
    DROP MEMBER [student1];

/*Make sure student1 can perform
INSERTs on the students table.*/
GRANT INSERT ON students TO student1;

/*Grant student1 the UPDATE permission
on all tables*/
GRANT UPDATE TO student1

/*Take away access to the database
school fot student1.*/
DROP USER student1;

/*Again, give student1 access to the
school database. Add student1 to the
database roles db_datareader,
db_datawriter and db_ddladmin*/
CREATE USER student1;

ALTER ROLE db_datareader
    ADD MEMBER [student1];

ALTER ROLE db_datawriter
    ADD MEMBER [student1];
ALTER ROLE db_ddladmin
    ADD MEMBER [student1];

-- 4
/*Create a login student2. Do not assign any permissions yet.*/
CREATE LOGIN student2
    WITH PASSWORD ='MCT_student' MUST_CHANGE,
    CHECK_EXPIRATION = ON,
    CHECK_POLICY = ON

-- 5

-- 6
/*Give student1 the database role db_owner for the database school.*/
ALTER ROLE db_owner
    ADD MEMBER [student1]

-- 7

-- 8
/*Create a login JohnSales and give that login access to the database BikeStores.*/
CREATE LOGIN johnsales
    WITH PASSWORD ='johnsales' MUST_CHANGE, CHECK_EXPIRATION = ON, CHECK_POLICY = ON
GO
USE bikestores
GO
CREATE USER johnsales
GO

-- 9
/*Give the user JohnSales the read permission on all the objects of the schema sales.*/
GRANT SELECT ON SCHEMA::sales TO johnsales

-- 10
/*Verify that JohnSales can read data from the table Customers, but not from the table
products.
Also, verify that JohnSales cannot add a new row to the table Customers.*/

--Login as johnsales
USE bikestores
GO
SELECT *
FROM sales.customers
GO
SELECT *
FROM production.products
-- The SELECT permission was denied on the object 'products', database 'BikeStores',  schema 'production'.
GO
INSERT INTO sales.customers(customer_id, first_name, last_name)
VALUES (2000, 'John', 'Taylor')
-- The INSERT permission was denied on the object 'customers', database 'BikeStores', schema 'sales'
