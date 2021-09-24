SET NOCOUNT ON;
USE TSQLFundamentals2008;
IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL DROP TABLE dbo.Nums;
CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);

DECLARE @i AS INT = 1;
BEGIN TRAN
  WHILE @i <= 100000
  BEGIN
    INSERT INTO dbo.Nums VALUES(@i);
    SET @i = @i + 1;
  END
COMMIT TRAN
SET NOCOUNT OFF;
GO


-- 1-2
-- Write a query that generates 5 copies out of each employee row
-- Tables involved: TSQLFundamentals2008 database, Employees and Nums tables
SELECT E.empid, E.firstname, E.lastname, n
FROM HR.Employees as E
CROSS JOIN dbo.Nums
WHERE n <=5;


-- 1-3. (Optional, Advanced)
-- Write a query that returns a row for each employee and day 
-- in the range June 12, 2009 – June 16 2009.
-- Tables involved: TSQLFundamentals2008 database, Employees and Nums tables
SELECT E.empid, DATEADD(day, n-1, '20090612') AS orderdate
FROM  HR.Employees as E
CROSS JOIN dbo.Nums
WHERE n <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY empid


-- 2
-- Return US customers, and for each customer the total number of orders 
-- and total quantities.
-- Tables involved: TSQLFundamentals2008 database, Customers, Orders and OrderDetails tables
SELECT C.custid, COUNT(DISTINCT O.orderid) as numorders,
SUM(OD.qty) AS totalqty
FROM Sales.Customers as C
JOIN Sales.Orders as O
    ON O.custid = C.custid
JOIN Sales.OrderDetails as OD
    ON OD.orderid = O.orderid
WHERE C.country = 'USA'
GROUP BY C.custid


-- 3
-- Return customers and their orders including customers who placed no orders
-- Tables involved: TSQLFundamentals2008 database, Customers and Orders tables
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders as O
    ON O.custid = C.custid


-- 4
-- Return customers who placed no orders
-- Tables involved: TSQLFundamentals2008 database, Customers and Orders tables
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders as O
    ON O.custid = C.custid
WHERE O.orderid IS NULL


-- 5
-- Return customers with orders placed on Feb 12, 2007 along with their orders
-- Tables involved: TSQLFundamentals2008 database, Customers and Orders tables
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
JOIN Sales.Orders as O
    ON O.custid = C.custid
WHERE O.orderdate = '20070212'


-- 6 (Optional, Advanced)
-- Return customers with orders placed on Feb 12, 2007 along with their orders
-- Also return customers who didn't place orders on Feb 12, 2007 
-- Tables involved: TSQLFundamentals2008 database, Customers and Orders tables
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders as O
    ON O.custid = C.custid AND O.orderdate = '20070212'


-- 7 (Optional, Advanced)
-- Return all customers, and for each return a Yes/No value
-- depending on whether the customer placed an order on Feb 12, 2007
-- Tables involved: TSQLFundamentals2008 database, Customers and Orders tables
SELECT C.custid, C.companyname, O.orderid, O.orderdate,
CASE 
    WHEN O.orderid IS NOT NULL THEN 'Yes'
    ELSE 'No'
END AS 'Has orders that day'
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders as O
    ON O.custid = C.custid AND O.orderdate = '20070212'
