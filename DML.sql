
/*							
							SQL Project Name : E-Commerce Management Systems 
							     Name : Akter Hossain  																	*/

--START OF DML SCRIPT--

USE EcommerceManagement
GO

INSERT INTO CUSTOMERS 
VALUES 
(04,'Akter','Hossain','','','','','') 
select * from customers
go 

INSERT INTO Employees 
VALUES
(1201,'romj','Ramgonj','Luxmipur','Bangladesh','1991-01-01','2014-02-01','12345678','N/A','018765××××','akbar@gmil.com')
GO
select * from Employees

INSERT INTO Supliers
VALUES
('Walton','Mr. Zamal','Sales Manager','Bola','Barisal',default),
('Sony','Abul hasan','Sales Manager','Jassor','Khulna',default),
('BRB','Md. Rafik','Manager','Laksam','Cumilla',default),
('Vision','abdul kader','Production Manager','Jatrabari','Dhaka',default),
('Super stare','Md,khalek','Sales Manager','Nawga','Rajshahi',default)
GO
SELECT * FROM Supliers
GO

INSERT INTO Products
VALUES
(1,'6" Refregerator',150000.00,100),
(2,'Air Condition',170000.00,50),
(3,'Telivion',40000.00,20),
(4,'Fan BRB',30000.00,30),
(5,'Water heater',8000.00,70),
(6,'Mini fen',20000.00,80),
(7,'Ironmisin',18000.00,35),
(8,'Mobaile',60000.00,40),
(9,'Wash Misin',7000.00,50),
(10,'Microwave',15000.00,60),
(11,'SMART PHONE',20000.00,50),
(12,'Rice cooker',30000.00,90),
(13,'Kettle',3500.00,20),
(14,'Pressure cooker',38000.00,10),
(15,'Blender',2700.00,15)
GO
SELECT * FROM Products
GO

INSERT INTO Category
VALUES
(DEFAULT,'Refrigerator'),
(DEFAULT,'Air condition'),
(DEFAULT,'BRB fan'),
(DEFAULT,'Ironmisin'),
(DEFAULT,'Telivision')
GO
SELECT * FROM Category
GO

INSERT INTO Shippers
VALUES
('REDX','01745670970'),
('SUNDORBAN','01635466789'),
('SA','01854664547')
SELECT * FROM Shippers
GO


INSERT INTO Orders
VALUES
(1,101,201,'2022-01-01','2022-01-15',1,50000.00),
(2,102,201,'2022-01-10','2022-01-20',2,30000.00),
(3,103,202,'2022-02-01','2022-02-15',3,34000.00),
(4,104,203,'2021-012-20','2021-02-15',2,5500.00),
(5,105,204,'2022-03-01','2022-03-15',3,74500.00),
(6,106,205,'2022-03-15','2022-03-15',2,42500.00),
(7,107,201,'2022-04-01','2022-04-15',1,38000.00),
(8,108,202,'2021-04-05','2021-04-15',1,21200.00),
(9,109,203,'2021-05-01','2021-05-15',2,42000.00),
(10,110,204,'2021-05-25','2021-06-15',3,88000.00),
(11,101,205,'2021-06-01','2021-06-15',1,78500.00),
(12,102,201,'2021-07-10','2021-07-15',1,95000.00),
(13,102,202,'2020-08-15','2020-08-15',3,14000.00),
(14,103,203,'2020-09-01','2020-09-15',1,25500.00),
(15,104,201,'2020-10-30','2020-11-15',3,31200.00),
(16,105,202,'2020-11-01','2020-11-15',1,53000.00),
(17,105,204,'2020-12-15','2020-12-15',2,20500.00),
(18,106,203,'2021-01-01','2021-01-16',3,26700.00),
(19,107,202,'2021-01-15','2021-01-25',2,30600.00),
(20,108,201,'2021-02-01','2021-02-15',3,31800.00)	
GO		
SELECT * FROM Orders
GO


INSERT INTO OrdersDetails
VALUES
(1,1,13000.00,5,.05),
(2,2,15000.00,4,.05),
(3,3,14000.00,10,.05),
(4,3,15000.00,12,.05),
(5,4,17000.00,20,.05),
(6,4,16000.00,7,.05),
(7,5,15000.00,8,.05),
(8,1,14000.00,10,.05),
(9,6,17000.00,20,.05),
(12,7,18000.00,25,.10),
(14,8,13000.00,30,.10),
(15,1,14000.00,10,.05)
GO
SELECT * FROM OrdersDetails
GO
 

--simple query
SELECT * FROM orders
GO

--JOIN QUARY 
SELECT * FROM Orders O
JOIN OrdersDetails OD ON OD.OrderId=O.OrderId
WHERE O.CustomerId = 105
GO

go
/*  
JOIN QUARY WITH AGGREGATE COLUMN WITH GROUP BY,ORDERBY CLAUSE
TO FIND OUT CUSTOMER WISE TOTAL DISCOUNT 
*/
			
SELECT O.CustomerId,SUM(od.UnitPrice*od.Quantity* OD.Discount) 'Discount_per_Customer' FROM Orders O
JOIN OrdersDetails OD ON OD.OrderId=O.OrderId
GROUP BY O.CustomerId
ORDER BY O.CustomerId DESC
GO

--SUBQUERY TO FIND OUT THE ORDERS DETAILS OF 
SELECT * FROM Orders O
JOIN Customers C ON C.CustomerId = O.CustomerId
WHERE O.CustomerId=(SELECT CustomerId FROM Customers WHERE Customer_First_Name='Akter')
GO

--USING ROLLUP IN QUERY WITH HAVING CLAUSE
SELECT CUSTOMERID,PRODUCTID,SUM(UnitPrice*Quantity*(1-DISCOUNT)) AS 'NET_ORDER_AMOUNT' FROM Orders O
JOIN OrdersDetails OD ON O.OrderId=OD.OrderId
GROUP BY ROLLUP (CustomerId,PRODUCTID)
HAVING SUM(UnitPrice*Quantity*(1-DISCOUNT)) >=50000
ORDER BY CustomerId
GO


-- CASE FUNCTION

SELECT ORDERID,SUM(Quantity*UnitPrice) AS 'Total Amount ordered',
CASE
WHEN SUM(Quantity*UnitPrice)>= 100000
	THEN '25% DISCOUNT'
WHEN SUM(Quantity*UnitPrice)>= 75000
	THEN '20% DISCOUNT'
	ELSE 'DEFAULT DISCOUNT'
END AS DISCOUNT
FROM OrdersDetails
GROUP BY OrderId

--Check for view
select * from OrdersDetails
GO  