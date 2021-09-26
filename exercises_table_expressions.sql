USE TSQLFundamentals2008

-- 1-1
-- Write a query that returns the maximum order date for each employee
-- Tables involved: TSQLFundamentals2008 database, Sales.Orders table
SELECT empid, MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid

-- SELECT empid, maxorderdate
-- FROM (
--     SELECT MAX(orderdate) AS maxorderdate, empid
--     FROM Sales.Orders
--     GROUP BY empid
-- ) AS M


-- 1-2
-- Encapsulate the query from exercise 1-1 in a derived table
-- Write a join query between the derived table and the Sales.Orders
-- table to return the Sales.Orders with the maximum order date for 
-- each employee
-- Tables involved: Sales.Orders
SELECT O.empid, orderdate, orderid, custid
FROM Sales.Orders AS O
JOIN (
    SELECT empid, MAX(orderdate) AS maxorderdate
    FROM Sales.Orders
    GROUP BY empid
) AS M 
ON O.empid = M.empid
WHERE O.orderdate = M.maxorderdate


-- 2-1
-- Write a query that calculates a row number for each order
-- based on orderdate, orderid ordering
-- Tables involved: Sales.Orders
SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER(ORDER BY orderdate) AS rownum
FROM Sales.Orders
ORDER BY orderid


-- 2-2
-- Write a query that returns rows with row numbers 11 through 20
-- based on the row number definition in exercise 2-1
-- Use a CTE to encapsulate the code from exercise 2-1
-- Tables involved: Sales.Orders
WITH rownumberbydate
AS
(
   SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER(ORDER BY orderdate) AS rownum
    FROM Sales.Orders
)
SELECT *
FROM rownumberbydate
WHERE rownum BETWEEN 11 AND 20


-- 3
-- Write a solution using a recursive CTE that returns the 
-- management chain leading to Zoya Dolgopyatova (employee ID 9)
-- Tables involved: HR.Employees
WITH managementchain
AS (
    SELECT empid, mgrid, firstname, lastname
    FROM HR.Employees
    WHERE empid = 9

    UNION ALL

    SELECT E.empid, E.mgrid, E.firstname, E.lastname
    FROM HR.Employees AS E
    JOIN managementchain AS M
    ON E.empid = M.mgrid
)
SELECT empid, mgrid, firstname, lastname
FROM managementchain

GO
-- 4-1
-- Create a view that returns the total qty
-- for each employee and year
-- Tables involved: Sales.Orders and Sales.OrderDetails
IF OBJECT_ID('Sales.QtyPerEmployeeAndYear') IS NOT NULL
    DROP VIEW Sales.QtyPerEmployeeAndYear
GO

CREATE VIEW Sales.QtyPerEmployeeAndYear
AS (
    SELECT empid, YEAR(orderdate) AS orderyear, SUM(qty) AS totalqty
    FROM Sales.Orders AS O
    JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid
    GROUP BY empid, YEAR(orderdate)
)
GO
-- 4-2 (Optional, Advanced)
-- Write a query against Sales.VEmpOrders
-- that returns the running qty for each employee and year
-- Tables involved: TSQLFundamentals2008 database, Sales.VEmpOrders view
SELECT empid, orderyear, totalqty, SUM(totalqty) OVER(PARTITION BY empid ORDER BY orderyear) AS runqty
FROM Sales.QtyPerEmployeeAndYear

GO
-- 5-1
-- Create an inline function that accepts as inputs
-- a supplier id (@supid AS INT), 
-- and a requested number of products (@n AS INT)
-- The function should return @n products with the highest unit prices
-- that are supplied by the given supplier id
-- Tables involved: Production.Products
IF OBJECT_ID('dbo.fn_HighestPrices') IS NOT NULL
    DROP FUNCTION dbo.fn_HighestPrices
GO

CREATE FUNCTION dbo.fn_HighestPrices
    (@supid AS INT, @n AS INT) RETURNS TABLE
AS
RETURN
    SELECT TOP(@n) productid, productname, unitprice
    FROM Production.Products
    WHERE supplierid = @supid
    ORDER BY unitprice DESC
GO

SELECT * FROM dbo.fn_HighestPrices(5, 2)


-- 5-2
-- Using the CROSS APPLY operator
-- and the function you created in exercise 5-1,
-- return, for each supplier, the two most expensive products
SELECT DISTINCT S.supplierid, companyname, F.productid, F.productname, F.unitprice
FROM Production.Products AS P
JOIN Production.Suppliers AS S
ON S.supplierid = P.supplierid
CROSS APPLY dbo.fn_HighestPrices(S.supplierid, 2) AS F
