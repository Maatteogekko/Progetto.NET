-- DRIVE: https://drive.google.com/drive/folders/1iY9iuX45v-G-uRMLF-ZVa9nXgBtxCzzl
USE TSQLFundamentals2008

-- 1 
-- Return orders placed on June 2007
-- Tables involved: TSQLFundamentals2008 database, Sales.Orders table
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '2007/06/01' AND '2007/06/30';


-- 2 (Optional, Advanced)
-- Return orders placed on the last day of the month
-- Tables involved: Sales.Orders table
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);


-- 3 
-- Return employees with last name containing the letter 'a' twice or more
-- Tables involved: HR.Employees table
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE LEN(lastname) - LEN(REPLACE(lastname, 'a', '')) >= 2;
-- WHERE lastname LIKE '%a%a%';


-- 4 
-- Return orders with total value(qty*unitprice) greater than 10000
-- sorted by total value
-- Tables involved: Sales.OrderDetails table
SELECT orderid, SUM(qty*unitprice) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty*unitprice) > 10000
ORDER BY totalvalue DESC;


-- 5 
-- Return the three ship countries with the highest average freight in 2007
-- Tables involved: Sales.Orders table
SELECT TOP(3) shipcountry, AVG(freight) AS averagefreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY averagefreight DESC;


-- 6 
-- Calculate row numbers for orders
-- based on order date ordering (using order id as tiebreaker)
-- for each customer separately
-- Tables involved: Sales.Orders table
SELECT custid, orderdate, orderid, 
    ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum 
FROM Sales.Orders;


-- 7
-- Figure out and return for each employee the gender based on the title of courtesy
-- Ms., Mrs. - Female, Mr. - Male, Dr. - Unknown
-- Tables involved: HR.Employees table
SELECT empid, firstname, lastname, titleofcourtesy,
    CASE titleofcourtesy
        WHEN 'Ms.' THEN 'female'
        WHEN 'Mrs.' THEN 'female'
        WHEN 'Mr.' THEN 'male'
        ELSE 'unknown'
    END AS gender
FROM HR.Employees;


-- 8
-- Return for each customer the customer ID and region
-- sort the rows in the output by region
-- having NULLs sort last (after non-NULL values)
-- Note that the default in T-SQL is that NULL sort first
-- Tables involved: Sales.Customers table
SELECT custid, region
FROM Sales.Customers
ORDER BY
    CASE
        WHEN region IS NULL THEN 1
        ELSE 0
    END, region;
