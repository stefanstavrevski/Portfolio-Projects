
--  Write a query to retrieve the first name, last name, and email address of all employees.
select 
Coalesce(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS FullName,
ea.EmailAddress
from Person.Person pp
JOIN Person.EmailAddress ea ON pp.BusinessEntityID = ea.BusinessEntityID
ORDER BY pp.LastName

--Write a query to find the total sales amount for each product.

Select 
sod.ProductID AS id,
COUNt(sod.OrderQty) AS qty,
pp.Name AS ProductName,
sod.LineTotal AS TotalSalesAmount,
pp.StandardCost AS Cost,
SUM(sod.LineTotal - pp.StandardCost) AS Profit,
Concat(((sod.LineTotal  - pp.StandardCost) / sod.LineTotal  * 100), + ' ' +  '%') AS ProfitMargin
from Sales.SalesOrderDetail sod
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
GROUP BY OrderQty,Name,LineTotal,StandardCost, sod.ProductID
ORDER BY TotalSalesAmount DESC



--Inner Join: Write a query to list all customers along with the total number of orders they have placed.

select 
COALESCE(pp.FirstName + ' '  + pp.MiddleName + ' ' + pp.LastName, pp.LastName) As CustomersName,
COUNT(soh.SalesOrderNumber) AS TotalNumberOfOrders
from Person.Person pp 
JOIN  Sales.SalesPerson sp ON pp.BusinessEntityID = sp.BusinessEntityID 
JOIN Sales.SalesOrderHeader soh ON soh.TerritoryID = sp.TerritoryID
JOIN Sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID
Group by pp.FirstName,pp.MiddleName,pp.LastName,sod.SalesOrderID
ORDER BY TotalNumberOfOrders DESC

 --Write a query to find the names of employees who have not made any sales.


SELECT 
    e.BusinessEntityID,
    COALESCE(p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName, p.FirstName + ' ' + p.LastName) AS FullName
FROM 
    HumanResources.Employee e
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE  e.BusinessEntityID NOT IN (
        SELECT 
            SalesPersonID 
        FROM 
            Sales.SalesOrderHeader 
        WHERE 
            SalesPersonID IS NOT NULL
 )


 -- Create a view that shows the total sales amount for each employee.

	CREATE VIEW  Employee_View AS  

	SELECT 
    pp.BusinessEntityID,
    COALESCE(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS FullName,
	SUM(sod.LineTotal) AS TotalSalesAmount
FROM  Person.Person pp 
					JOIN Sales.SalesPerson sp ON pp.BusinessEntityID = sp.BusinessEntityID
					JOIN Sales.SalesOrderHeader soh ON sp.TerritoryID = soh.TerritoryID 
					JOIN Sales.SalesOrderDetail sod ON sod.SalesOrderID  = soh.SalesOrderID
	GROUP BY pp.FirstName,pp.MiddleName,pp.LastName,sod.LineTotal,pp.BusinessEntityID



--  Create a view that summarizes the number of purchases and the total amount spent by each customer.


	CREATE VIEW Customer_Purchase_History_View AS
SELECT 
    c.CustomerID,
    COALESCE(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS FullName,
    COUNT(DISTINCT soh.SalesOrderID) AS NumberOfPurchases,
    SUM(sod.LineTotal) AS TotalSalesAmount
FROM 
    Sales.Customer c
    JOIN Person.Person pp ON c.PersonID = pp.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    c.CustomerID,
    pp.FirstName, 
    pp.MiddleName, 
    pp.LastName;


-- Write a stored procedure that accepts a date range as parameters and returns the total sales within that period.

CREATE PROCEDURE GetTotalSalesWithinDateRange

    @StartDate Date = '2011-01-01',
    @EndDate Date = '2014-01-01'
AS
BEGIN
    SELECT ROUND(SUM(sod.LineTotal),2) AS TotalSalesAmount
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    WHERE soh.OrderDate BETWEEN @StartDate AND @EndDate
END;

drop procedure GetTotalSalesWithinDateRange
exec GetTotalSalesWithinDateRange


--Write a stored procedure that accepts a product ID and returns detailed sales information for that product, including total sales amount, 
--number of orders, and average order value.


CREATE PROCEDURE GetProductSalesDetails
    @ProductID INT
AS
BEGIN
    SELECT 
        pp.Name AS ProductName,
        SUM(sod.LineTotal) AS TotalSalesAmount,
        COUNT(DISTINCT sod.SalesOrderID) AS NumberOfOrders,
        AVG(sod.LineTotal) AS AverageOrderValue
    FROM Production.Product pp
    JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
    WHERE pp.ProductID = @ProductID
    GROUP BY pp.Name;
END;


EXEC GetProductSalesDetails @productID = 25
drop procedure GetProductSalesDetails

















\
