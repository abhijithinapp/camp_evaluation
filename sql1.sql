--create a database for camp1
create database camp1

--use the database
use camp1

--------------------------------
--Inorder to normalise the given table we have to divide the given table into two table 
--with a seperate table for dept with colums dept name and department id and another table for employee details using the employeeid

--Creating table with departnment details
--Table name: Departments
--Columns : 
--DepartmentID (INT)
--DepartmentName (VARCHAR(50)
CREATE TABLE Departments (
	DepartmentID INT IDENTITY PRIMARY KEY,
	DepartmentName VARCHAR(50)
);

--Inserting values into department table
INSERT INTO Departments (DepartmentName)
VALUES ('IT'),
('SALES'),
('MARKETING'),
('HR');

--view department table
SELECT * FROM Departments;

--Create Employee Details Table with DepartmentID as the foriegn key
--Table name: EmployeeDetails
--Columns: 
--emp_id (INT) 
--emp_name (VARCHAR)
--pay (INT)  
--DepartmentID (INT)
CREATE TABLE EmployeeDetails(
emp_id INT IDENTITY PRIMARY KEY,
emp_name VARCHAR(50) NOT NULL,
pay INT,
DepartmentID INT NOT NULL,
CONSTRAINT fk_dept_id
	FOREIGN KEY (DepartmentID)
	REFERENCES Departments (DepartmentID)
);

--Inserting values into the table
INSERT INTO EmployeeDetails(emp_name, pay, DepartmentID)
VALUES ('Dilip' , 3000, 1),
('Fahad' , 4000, 2),
('Lal' , 6000, 3),
('Nivin' , 2000, 1),
('Vijay' , 9000, 2),
('Anu' , 5000, 4),
('Nimisha' , 5000, 2),
('Praveena' , 8000, 3);

--To Display the joined tables
SELECT EmployeeDetails.emp_id,EmployeeDetails.emp_name,EmployeeDetails.pay, Departments.DepartmentName 
FROM EmployeeDetails JOIN Departments 
ON Departments.DepartmentID = EmployeeDetails.DepartmentID;

----------Questions----------------------

--1. Total number of employees
SELECT COUNT(emp_id) FROM EmployeeDetails;

--2. Total amount required to pay all employees.
SELECT SUM(pay) FROM EmployeeDetails

--3. Average, minimum and maximum pay in the organization.SELECT AVG(pay) AS AveragePay, 
MIN(pay) AS MinumPay, 
MAX(PAY) AS MaximumPay FROM EmployeeDetails

 --4. Each Department wise total pay
SELECT SUM(EmployeeDetails.pay), Departments.DepartmentName 
FROM EmployeeDetails JOIN Departments 
ON Departments.DepartmentID = EmployeeDetails.DepartmentID GROUP BY Departments.DepartmentName;

--5. Average, minimum and maximum pay department-wise.SELECT AVG(EmployeeDetails.pay) AS AveragePay, MIN(EmployeeDetails.pay) AS MinimumPay, AVG(EmployeeDetails.pay) AS MaximumPay ,Departments.DepartmentName 
FROM EmployeeDetails JOIN Departments 
ON Departments.DepartmentID = EmployeeDetails.DepartmentID GROUP BY Departments.DepartmentName;

--6. Employee details who earns the maximum pay.SELECT EmployeeDetails.emp_id, EmployeeDetails.emp_name, EmployeeDetails.pay, Departments.DepartmentName
FROM EmployeeDetails JOIN Departments 
ON Departments.DepartmentID = EmployeeDetails.DepartmentID WHERE EmployeeDetails.pay = (SELECT MAX(pay) FROM EmployeeDetails);

--7. Employee details who is having a maximum pay in the department.SELECT EmployeeDetails.emp_id, EmployeeDetails.emp_name, EmployeeDetails.pay, Departments.DepartmentName
FROM EmployeeDetails JOIN Departments 
ON Departments.DepartmentID = EmployeeDetails.DepartmentID WHERE EmployeeDetails.id IN (SELECT emp_id , MAX(PAY) FROM EmployeeDetails
GROUP BY DepartmentID)  ;

--10. Unique departments in the company
SELECT DISTINCT DepartmentName FROM Departments

--11. Employees In increasing order of pay
SELECT emp_name, pay FROM EmployeeDetails ORDER BY pay

--12. Department In increasing order of pay
SELECT Departments.DepartmentName, SUM(EmployeeDetails.pay)
FROM EmployeeDetails JOIN Departments 
ON Departments.DepartmentID = EmployeeDetails.DepartmentID 
GROUP BY DepartmentName ORDER BY SUM(EmployeeDetails.pay)
