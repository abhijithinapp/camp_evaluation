
--------------------------------------------------------------------------------------------------------------------------------
------Question 2---------------------
--------------------------------------------------------------------------------------------------------------------------------
--We need seperate tables for storing customer details and product details

--Customer Table 
CREATE TABLE CustomerDetails (
CustomerID INT PRIMARY KEY IDENTITY,
CustomerName VARCHAR(50) NOT NULL,
)

INSERT INTO CustomerDetails(CustomerName) 
VALUES ('Jayesh'),
('Abhilash'),
('Lily'),
('Aswathy');

---Database ProductNames
CREATE TABLE ProductNames (
productID INT PRIMARY KEY IDENTITY,
ProductName VARCHAR(50) NOT NULL,
)

INSERT INTO ProductNames(ProductName) 
VALUES ('MobilePhone'),
('LED TV'),
('Laptop'),
('HeadPhone'),
('PowerBank');

--create manufacturer table
CREATE TABLE ManufacturerDetails (
ManufacturerID INT PRIMARY KEY IDENTITY,
ManufacturerName VARCHAR(50) NOT NULL,
)

INSERT INTO ManufacturerDetails(ManufacturerName) 
VALUES ('Samsung'),
('Sony'),
('MI'),
('Boat');

SELECT * FROM CustomerDetails
SELECT * FROM ProductNames
SELECT * FROM ManufacturerDetails

--OrderDetails Table
CREATE TABLE OrderDetails(
OrderID INT IDENTITY PRIMARY KEY,
OrderDate DATE NOT NULL,
OrderPrice INT,
OrderQuanitity INT NOT NULL, 
CustomerID INT NOT NULL,
CONSTRAINT fk_cust_id
	FOREIGN KEY (CustomerID)
	REFERENCES CustomerDetails (CustomerID)
);

--Insert into table customer details
INSERT INTO OrderDetails (OrderDate, OrderPrice, OrderQuanitity, CustomerID)
VALUES ('2020-12-22', 270, 2, 1),
( '2019-08-10', 280, 4, 2),
( '2019-07-13', 600, 5, 3),
( '2020-07-15', 520, 1, 1),
('2020-12-22', 1200, 4, 4),
('2019-10-02', 720, 3, 1),
('2020-11-03', 3000, 2, 3),
( '2020-12-22', 1100, 4, 4),
( '2019-12-29', 5500, 2, 1);

CREATE TABLE ProductDetails(
    Product_id INT PRIMARY KEY,
    OrderId INT FOREIGN KEY REFERENCES OrderDetails(OrderId),
    Mnufacture_Date DATE,
    productID INT FOREIGN KEY REFERENCES ProductNames(productID),
    ManufacturerID INT FOREIGN KEY REFERENCES ManufacturerDetails(ManufacturerID),
);

INSERT INTO ProductDetails VALUES
(145, 2, '2019-12-23', 001, 1),
(147, 6, '2019-08-15', 001, 3),
(435, 5, '2018-11-04', 001, 1),
(783, 1, '2017-11-03', 002, 2),
(784, 4, '2019-11-28', 002, 2),
(123, 2, '2019-10-03', 003, 2),
(267, 5, '2019-03-21', 004, 4),
(333, 9, '2017-12-12', 003, 1),
(344, 3, '2018-11-03', 003, 1),
(233, 3, '2019-11-30', 005, 2),
(567, 6, '2019-09-03', 005, 2);

--1) Total number of orders placed in each year.
SELECT COUNT(OrderID) AS Number_of_Orders, YEAR(OrderDate) AS Financial_year FROM OrderDetails GROUP BY YEAR(OrderDate)

--2) Total number of orders placed in each year by Jayesh.
SELECT COUNT(OrderID) AS Number_of_Orders, YEAR(OrderDate) AS Financial_year FROM OrderDetails WHERE  CustomerID = (SELECT CustomerID from CustomerDetails WHERE CustomerName= 'Jayesh')  GROUP BY YEAR(OrderDate)

--3) Products which are ordered in the same year of its manufacturing year.
SELECT ProductNames.ProductName,ProductDetails.Mnufacture_Date, OrderDetails.OrderDate FROM
OrderDetails JOIN ProductDetails ON ProductDetails.OrderID = OrderDetails.OrderId 
JOIN ProductNames ON ProductNames.productID = ProductDetails.productID WHERE YEAR(ProductDetails.Mnufacture_Date) = YEAR(OrderDetails.OrderDate);

--4) Products which is ordered in the same year of its manufacturing year where the
--Manufacturer is ‘Samsung’.
SELECT ProductNames.ProductName,ProductDetails.Mnufacture_Date, OrderDetails.OrderDate, ManufacturerDetails.ManufacturerName FROM
OrderDetails JOIN ProductDetails ON ProductDetails.OrderID = OrderDetails.OrderId 
JOIN ProductNames ON ProductNames.productID = ProductDetails.productID 
JOIN ManufacturerDetails ON ManufacturerDetails.ManufacturerID = ProductDetails.ManufacturerID
WHERE YEAR(ProductDetails.Mnufacture_Date) = YEAR(OrderDetails.OrderDate) AND ManufacturerName = 'Samsung';

--5) Total number of products ordered every year.
SELECT SUM(OrderQuanitity) AS order_qty, YEAR(OrderDate) AS financial_year FROM OrderDetails GROUP BY YEAR(OrderDate)


--6) Display the total number of products ordered every year made by sony.
SELECT SUM(OrderQuanitity) AS order_qty, YEAR(OrderDate)  AS financial_year FROM 
OrderDetails JOIN ProductDetails ON ProductDetails.OrderID = OrderDetails.OrderId 
JOIN ProductNames ON ProductNames.productID = ProductDetails.productID 
JOIN ManufacturerDetails ON ManufacturerDetails.ManufacturerID = ProductDetails.ManufacturerID
WHERE YEAR(ProductDetails.Mnufacture_Date) = YEAR(OrderDetails.OrderDate) AND ManufacturerName = 'Sony'  GROUP BY YEAR(OrderDate);


--7) All customers who are ordering mobile phone by samsung.
SELECT CustomerDetails.CustomerName, ManufacturerDetails.ManufacturerName, ProductNames.ProductName FROM 
OrderDetails JOIN ProductDetails ON ProductDetails.OrderID = OrderDetails.OrderId 
JOIN ProductNames ON ProductNames.productID = ProductDetails.productID 
JOIN ManufacturerDetails ON ManufacturerDetails.ManufacturerID = ProductDetails.ManufacturerID
JOIN CustomerDetails ON OrderDetails.CustomerID = CustomerDetails.CustomerID
WHERE ManufacturerName = 'Samsung' AND ProductName= 'MobilePhone';

--8) Total number of orders got by each Manufacturer every year.
SELECT COUNT(*) AS 'Total Orders', Year(OrderDate) AS Year, ManufacturerName FROM 
OrderDetails JOIN ProductDetails ON ProductDetails.OrderID = OrderDetails.OrderId 
JOIN ManufacturerDetails ON ManufacturerDetails.ManufacturerID = ProductDetails.ManufacturerID
GROUP BY ManufacturerName, Year(OrderDate)

--9) All Manufacturers whose products were sold more than 1500 Rs every year.
SELECT SUM(OrderPrice) AS TotalOrderPrice, ManufacturerName FROM 
OrderDetails JOIN ProductDetails ON ProductDetails.OrderID = OrderDetails.OrderId 
JOIN ManufacturerDetails ON ManufacturerDetails.ManufacturerID = ProductDetails.ManufacturerID
GROUP BY ManufacturerName   HAVING SUM(OrderPrice)>1500 

