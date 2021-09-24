USE TSQLFundamentals2008

-- 1 
-- Write a query that returns all orders placed on the last day of
-- activity that can be found in the Orders table
-- Tables involved: TSQLFundamentals2008 database, Orders table
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate)
                    FROM Sales.Orders);


-- 2 (Optional, Advanced)
-- Write a query that returns all orders placed
-- by the customer(s) who placed the highest number of orders
-- * Note: there may be more than one customer
--   with the same number of orders
-- Tables involved: TSQLFundamentals2008 database, Orders table
DECLARE @max INT = 
(
    SELECT MAX(custidcount.count)
    FROM (
        SELECT COUNT(custid) AS count
        FROM Sales.Orders
        GROUP BY custid
    ) AS custidcount
)

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN (
    SELECT custid
    FROM Sales.Orders as Q
    GROUP BY custid
    HAVING COUNT(Q.custid) = @max
)
ORDER BY custid;


-- 3
-- Write a query that returns employees
-- who did not place orders on or after May 1st, 2008
-- Tables involved: TSQLFundamentals2008 database, Employees and Orders tables
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE empid NOT IN (
    SELECT O.empid
    FROM Sales.Orders as O
    WHERE O.orderdate >= '20080501'
);


-- 4
-- Write a query that returns
-- countries where there are customers but not employees
-- Tables involved: TSQLFundamentals2008 database, Customers and Employees tables
SELECT country
FROM Sales.Customers
WHERE country NOT IN (
    SELECT E.country
    FROM HR.Employees as E
)
GROUP BY country;


-- 5
-- Write a query that returns for each customer
-- all orders placed on the customer's last day of activity
-- Tables involved: TSQLFundamentals2008 database, Orders table
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders as O1
WHERE orderdate = (
    SELECT MAX(customerorderdates.orderdate)
    FROM (
        SELECT O2.orderdate
        FROM Sales.Orders as O2
        WHERE O2.custid = O1.custid
        GROUP BY O2.orderdate
    ) AS customerorderdates
)
ORDER BY custid;


-- 6
-- Write a query that returns customers
-- who placed orders in 2007 but not in 2008
-- Tables involved: TSQLFundamentals2008 database, Customers and Orders tables
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
WHERE C.custid IN (
    SELECT O.custid
    FROM Sales.Orders as O
    WHERE YEAR(O.orderdate) = '2007'
) AND C.custid NOT IN (
    SELECT O.custid
    FROM Sales.Orders as O
    WHERE YEAR(O.orderdate) = '2008'
)


-- 7 (Optional, Advanced)
-- Write a query that returns customers
-- who ordered product 12
-- Tables involved: TSQLFundamentals2008 database,
-- Customers, Orders and OrderDetails tables
SELECT custid, companyname
FROM Sales.Customers
WHERE custid IN (
    SELECT custid
    FROM Sales.Orders
    WHERE orderid IN (
        SELECT orderid
        FROM Sales.OrderDetails
        WHERE productid = '12'
    )
);


-- 8 (Optional, Advanced)
-- Write a query that calculates a running total qty
-- for each customer and month
-- Tables involved: TSQLFundamentals2008 database, Sales.CustOrders view
SELECT custid, ordermonth, qty, SUM(qty) OVER (PARTITION BY custid ORDER BY ordermonth) AS runqty
FROM Sales.CustOrders
ORDER BY custid