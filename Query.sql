-- Return orders placed on June 2007

/* SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders 
WHERE orderdate BETWEEN '2007/06/01' AND '2007/07/01'; */

-- Return orders placed on the last day of the month
/* SELECT orderid, orderdate, custid, empid
FROM Sales.Orders 
WHERE orderdate = EOMONTH(orderdate) */

-- Return employees with last name containing the letter 'a' twice or more
/* SELECT empid, firstname, lastname
FROM HR.Employees
WHERE LEN(lastname)-LEN(REPLACE(lastname,'a','')) >= 2; */

-- 4 
-- Return orders with total value(qty*unitprice) greater than 10000
-- sorted by total value
-- Tables involved: Sales.OrderDetails table
/* SELECT orderid, SUM(unitprice*qty) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid 
HAVING SUM(unitprice*qty) >= 10000
ORDER BY totalvalue DESC; */