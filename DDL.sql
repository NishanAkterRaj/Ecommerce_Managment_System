/*
			Sql Project Name : -- Ecommerce Managment System
			Trainee Name	 : -- Akter Hossain

*/
--- DDL Script Text

Use Master
go

drop database if exists Ecommerce_Managment_System
go

Create Database Ecommerce_Managment_System
go
use Ecommerce_Managment_System
go
create table Customers(
CustomerId int primary key not null,
Customer_First_Name varchar(30) not null,
Customer_Last_Name varchar(30) null,
Customer_Address varchar(100) null,
City varchar(30) null,
Country varchar(40),
PhoneNo varchar(15) default '+8801845797997',
Email varchar(30) default 'computereng2021@gmail.com'
)
go

Create table Employees(
EmployeeId int primary key not null,
Emp_Name varchar(30) default 'Akter Hossain',
Emp_Address varchar(50) default 'Jhenaidah',
Emp_Ciry varchar(30) default 'Khulna',
Emp_Country varchar(40) default 'Canada',
Birthday date not null,
Hiredate date not null,
NID char(13) not null,
EnpImage varchar(max) not null default 'N/A',
PhoneNo varchar(15) default '+8801845797997',
Email varchar(30) default 'computereng2021@gmail.com'
)
go


create table Supliers(
	SupplierId INT PRIMARY KEY IDENTITY,
	Company_Name VARCHAR(40) NOT NULL,
	Contact_Name VARCHAR(30) NULL,
	Contact_Title VARCHAR(30) NULL,
	SupAddress VARCHAR(80) NULL,
	City VARCHAR(20) NULL,
	Country VARCHAR(20) NULL,
	Phone  VARCHAR(20) NOT NULL DEFAULT 'N/A',
	)
	go
create table Products(
	ProductId INT PRIMARY KEY,
	Product_Name VARCHAR(100),
	Unit_Price MONEY,
	Stock INT DEFAULT 0
	)
	go
CREATE TABLE Category
(
	id INT IDENTITY PRIMARY KEY,
	CategoryId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	Category_Name VARCHAR(50) NOT NULL,
	title varchar (40) NOT NULL
)
GO

CREATE TABLE Shippers
(
	ShipperId INT IDENTITY PRIMARY KEY,
	Company_Name VARCHAR(50) NOT NULL,
	Phone NVARCHAR(20)
)
GO



CREATE TABLE Orders
(
	OrderId INT PRIMARY KEY,
	CustomerId INT REFERENCES Customers(Customerid),
	EmployeeId INT REFERENCES Employees(Employeeid),
	OrderDate DATE NOT NULL,
	ShipDate DATE NOT NULL DEFAULT GETDATE(),
	ShippingCompany INT REFERENCES Shippers(Shipperid),
	Freight MONEY NULL,
)
GO

CREATE TABLE OrdersDetails
(
	OrderId INT REFERENCES Orders(Orderid),
	ProductId INT REFERENCES Products(ProductId),
	UnitPrice FLOAT NOT NULL,
	Quantity INT NOT NULL,
	Discount FLOAT NOT NULL DEFAULT 0,
	DiscountedAmount AS UnitPrice*Quantity*Discount,
	PRIMARY KEY(OrderId,ProductId)
)
GO
CREATE TABLE City
(
	CityId INT NOT NULL UNIQUE,
	City_Name VARCHAR(20) NOT NULL
)
GO
CREATE TABLE Inventory
(
	InventoryId INT IDENTITY PRIMARY KEY,
	SupplierId INT REFERENCES Supliers(Supplierid),
	Quantity INT NOT NULL DEFAULT 0,
	PurchaseDate DATE NOT NULL,
	StockOutDate DATE NULL,
	Category INT REFERENCES Category(Id),
	Available BIT NOT NULL,
	PId INT REFERENCES Products(productid)
)
GO

--ALTER TABLE (ADD, DELETE COLUMN, DROP COLUMN)--

-- ADD COLUMN TO A EXISTING TABLE 
ALTER TABLE city
ADD Zipcode VARCHAR(10)
GO
--DELETE COLUMN FROM A EXISTING TABLE
ALTER TABLE city
DROP COLUMN ZipCode
GO

--DROP A TABLE
IF OBJECT_ID('tblcity') IS NOT NULL
DROP TABLE City
GO

-- CREATING INDEX, VIEW, STORED PROCEDURE, FUNTIONS, TRIGGERS --

-- 01 INDEX --
CREATE UNIQUE NONCLUSTERED INDEX Customer
ON Customers(CUSTOMERID)
GO
--AS CLUSTERED INDEX AUTOMETICALLY CREATED FOR PRIMARY KEY COLUMN, I CAN'T CREATED IT. BECAUSE ALL TABLE HOLD A PRIMARY KEY COLUMN.


--02 VIEW--


--Create a view for update, insert and delete data from base table
SELECT * FROM Supliers
GO

--Inserting data using view
INSERT INTO Supliers VALUES
		('CBEP','MUJIB','Manager','18/BN','','CUMILLA',DEFAULT)
GO

--as suppliers is reference
DELETE FROM Supliers
WHERE Company_Name='CSRM'
GO

--Create a view to find out the customers who have ordered more the 5000 tk

CREATE VIEW OrdersDetail
WITH ENCRYPTION
AS
SELECT TOP 5 PERCENT OD.OrderId,OD.ProductId,O.CustomerId,OD.Quantity,OD.UnitPrice 
FROM OrdersDetails OD
JOIN Orders O ON OD.OrderId=O.OrderId
WHERE (UnitPrice*Quantity) >=3000
WITH CHECK OPTION
GO 

--03 STORED PROCEDURE--

--A STORED PROCEDURE FOR QUERY  DATA

CREATE PROC sp_Customer
WITH ENCRYPTION
AS
SELECT * FROM Customers
WHERE City='Dhaka'
GO

--A Stored Procedure for inserting DATA
CREATE PROC sp_InsertCustomer
			@customerid INT,
			@customerFname VARCHAR(20),
			@customerLname VARCHAR(20)=NULL,
			@address VARCHAR(50)=NULL,
			@city VARCHAR(20),
			@country VARCHAR(20),
			@phoneNo VARCHAR(20),
			@email VARCHAR(50)
AS
BEGIN
	INSERT INTO Customers(CustomerId,Customer_First_Name,Customer_Last_Name,Customer_Address,City,Country,PhoneNo,Email)
	VALUES(@customerid,@customerFname,@customerLname,@address,@city,@country,@phoneNo,@email)
END
GO

--A Stored procedure for deleting data 
CREATE PROC sp_deleteCustomer
						@customerFname VARCHAR(20)
AS 
	DELETE FROM Customers WHERE Customer_First_Name=@customerFname
GO

--A Stored procedure for inserting data with return values
CREATE PROC sp_InsertEmployeeWithReturn
			@employeeid INT,
			@empName VARCHAR(20),
			@empAddress VARCHAR(50),
			@city VARCHAR(20),
			@country VARCHAR(20),
			@birthdate DATE,
			@hiredate DATE,
			@NID CHAR(13),
			@empImage VARCHAR(MAX)='N/A',
			@phone VARCHAR(20),
			@email VARCHAR(50)=NULL
AS
DECLARE @id INT 
INSERT INTO Employees VALUES(@employeeid,@empName,@empAddress,@city,@country,@birthdate,@hiredate,@NID,@empImage,@phone,@email)
SELECT @id=IDENT_CURRENT('Employees')
RETURN @id
GO 

--A Stored procedure for inserting data with output parameter
CREATE PROC sp_InsertEmployeeWithOutPutParameter
			@employeeid INT,
			@empName VARCHAR(20),
			@empAddress VARCHAR(50),
			@city VARCHAR(20),
			@country VARCHAR(20),
			@birthdate DATE,
			@hiredate DATE,
			@NID CHAR(13),
			@empImage VARCHAR(MAX)='N/A',
			@phone VARCHAR(20),
			@email VARCHAR(50)=NULL,
			@Eid INT 
AS
INSERT INTO Employees VALUES(@employeeid,@empName,@empAddress,@city,@country,@birthdate,@hiredate,@NID,@empImage,@phone,@email)
SELECT @Eid=IDENT_CURRENT('tblEmployees')
GO


--04 FUNCTIONS--

--1.Scalar valued function
CREATE FUNCTION fn_OrdersDetails
					(@month int,@year int)
RETURNS INT
AS
 BEGIN
	DECLARE @amount MONEY
	SELECT @amount=SUM(UNITPRICE*QUANTITY) FROM Orders 
	JOIN OrdersDetails ON Orders.OrderId=OrdersDetails.OrderId
	WHERE YEAR(OrderDate)=@year AND MONTH(OrderDate)=@month
	RETURN @amount
 END	
GO

--2.Single-Statement table valued function
CREATE FUNCTION fn_ordersamountPerProduct
					(@productid INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SELECT @amount= SUM(UNITPRICE*QUANTITY)FROM OrdersDetails WHERE ProductId=@productid
	RETURN @amount
END
GO

--3.Multi-Statement table valued function
CREATE FUNCTION fn_OrderdetailsSimpleTable(@customerid INT)
RETURNS TABLE
AS 
RETURN
(
	SELECT SUM(UnitPrice*Quantity) AS 'Total Amount',
	SUM(UnitPrice*Quantity*Discount) AS 'Total Discount',
	SUM(UnitPrice*Quantity*(1-Discount)) AS 'Net Amount'
	FROM Orders O 
	JOIN OrdersDetails OD ON O.OrderId=OD.OrderId
	WHERE O.CustomerId=@CUSTOMERID
)
GO

--4 Multi-Statement table-valued function(More than one statement. So we will use BEGIN AND END STATEMENT)


CREATE FUNCTION fn_InventoryMultiStatement(@purchasedate DATE)
RETURNS @salesDetails TABLE
(
	ProductID INT,
	Totolamount MONEY,
	Category VARCHAR(30)
)
AS
BEGIN
		 INSERT INTO @salesDetails
		 SELECT PId,
		 SUM(Unit_Price*QUANTITY),
		 Category
		 FROM Inventory I
		 JOIN Products P ON P.ProductId=I.PId
		 WHERE PurchaseDate=@purchasedate
		 GROUP BY PId,CATEGORY
		 ORDER BY PId ASC
		 RETURN
END
GO

--05 TRIGGER

--1. AFTER/ FOR TRIGGERS
CREATE TRIGGER tr_orders
ON orders
FOR DELETE
AS
	BEGIN
			PRINT'YOU CAN NOT DELETE AN EMPLOYEE DATA'
			ROLLBACK TRANSACTION
	END
GO



-- AFTER TRIGGER FOR INSERT DATA INTO INVENTORY TABLE --
CREATE TRIGGER tr_InventoryInsert
ON Inventory
FOR INSERT
AS
BEGIN
	DECLARE @pid INT, @Q INT
	SELECT @pid=pid , @q=quantity
	FROM inserted

	UPDATE Products
	SET Stock=Stock+@Q
	WHERE ProductId=@pid
END
GO


--2. INSTEAD OF TRIGGERS
CREATE TRIGGER tr_DeleteInventory
ON Inventory
FOR DELETE
AS
BEGIN
	DECLARE @Pid INT, @q INT
	SELECT @Pid=pid,@q=quantity FROM deleted

	UPDATE Products
	SET Stock=Stock-@q
	WHERE ProductId=@Pid
END
GO




--After triggers for orders and inventory management
CREATE TRIGGER tr_ordersInventory
ON ordersdetails
FOR INSERT 
AS
	BEGIN 
		DECLARE @Q INT,@Pid int
		SELECT @Q=Quantity,@pid=ProductId FROM inserted

		UPDATE Inventory
		SET Quantity=Quantity-@Q
		WHERE PId=@Pid
	END
GO

--Create INSTEAD OF TRIGGERS ON VIEW FOR INSERTING DATA 

CREATE TRIGGER tr_V_tblSuppliers
ON Supliers
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO Supliers(SupplierId,Company_Name,Contact_Name,Contact_Title,SupAddress,City,Country,Phone)
	SELECT SupplierId,Company_Name,Contact_Name,Contact_Title,SupAddress,City,Country,Phone FROM inserted
END
GO


--CREATING AN INSTEAD OF TRIGGER FOR NOT INSERTING ORDERS WHEN STOCK

CREATE TRIGGER tr_OutOfStock
ON OrdersDetails
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @Pid INT, @quantity INT,@stock INT
	SELECT @Pid=ProductId, @quantity=Quantity FROM inserted
	SELECT @stock= SUM(Quantity) FROM Inventory WHERE Pid=@pid
			
IF @stock>=@quantity
	BEGIN 
	INSERT INTO OrdersDetails(OrderId,ProductId,UnitPrice,Quantity,Discount)	
	SELECT OrderId,ProductId,UnitPrice,Quantity,Discount FROM inserted
END

ELSE
 BEGIN
	RAISERROR('SORRY, THERE IS NOT ENOUGH STOCK.',10,1)
	ROLLBACK TRANSACTION
END
END
GO

SELECT * FROM OrdersDetails


