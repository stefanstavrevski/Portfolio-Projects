-- Basic Retrival
Select TOP 10 * from Sales.SalesOrderHeader;

SELECT TOP 20 FirstName + ' ' + Coalesce(LastName, ' ') AS FullName
from HumanResources.vEmployee


--Aggregation And Calculation:

SELECT 
    pp.FirstName + ' ' + Coalesce(pp.LastName,' ') AS FullName,
    SUM(sod.OrderQty * sod.UnitPrice) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Person.Person pp
    ON soh.CustomerID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName
ORDER BY TotalSales DESC

-------------------------------------------------
Select AVG(ListPrice) AS AverageListPrice 
from Production.Product



----Joining Tables
Select DISTINCT
pp.FirstName + ' ' + Coalesce(pp.LastName, ' ') AS FullName,
pr.Name	
												AS ProductName,
pr.ListPrice
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Person.Person pp
    ON soh.CustomerID = pp.BusinessEntityID
JOIN Production.Product							 AS pr
	ON sod.ProductID = pr.ProductID
Order by pr.ListPrice DESC

------------------------------------------------------------

Select DISTINCT
hr.FirstName + ' ' + COALESCE(hr.LastName, ' ') AS FullName,
cr.StateProvinceName + ' - ' + cr.CountryRegionName AS CountryRegion
from HumanResources.vEmployeeDepartment AS hr
JOIN Sales.SalesPerson AS sp
	ON	hr.BusinessEntityID = sp.BusinessEntityID
JOIN Person.vStateProvinceCountryRegion AS cr
	ON sp.TerritoryID = cr.TerritoryID


--Filtering with Conditions:


Select DISTINCT
pp.Name AS ProductName,
pp.ListPrice,
pp.StandardCost,
pp.ListPrice - pp.StandardCost AS Profit,
Concat(ROUND((pp.ListPrice - pp.StandardCost) / (sod.OrderQty * sod.UnitPrice),2) * 100, '%') AS ProfitMargin
From Production.Product pp
JOIN Sales.SalesOrderDetail sod
	ON pp.ProductID = sod.ProductID
WHERE pp.ListPrice - pp.StandardCost > 500
Order by Profit DESC,ProfitMargin

----------------------------------------------------------------------------------------------------------------

SELECT DISTINCT
    pp.FirstName + ' ' + pp.LastName AS FullName,
    cr.CountryRegionName
FROM Person.Person pp
CROSS JOIN Person.vStateProvinceCountryRegion cr
WHERE cr.StateProvinceID = pp.BusinessEntityID
    AND cr.CountryRegionCode <> 'US';

	----------------------------------------------------------------------------------------------------------------

--Subqueries:

--Find the names of products that have been included in sales orders more than 50 times.


Select  
Name
From Production.Product
Where ProductID IN  (
Select ProductID
From sales.SalesOrderDetail 
Group by  ProductID
HAVING COUNT(*) > 50)

--------------------------------------------------------------------------------------------------------------------
Select Distinct
COALESCE(p.FirstName + ' ' + p.MiddleName + '.' + p.LastName, p.FirstName + p.LastName) AS Fullname
from Person.Person p
Where EXISTS  ( Select  1  from Production.Product 
Where ListPrice > ( select AVG(ListPrice)  from Production.Product)
)


	SELECT DISTINCT
    COALESCE(p.FirstName + ' ' + p.MiddleName + '.' + p.LastName, p.FirstName + p.LastName) AS Fullname
FROM Person.Person p
WHERE EXISTS (
    SELECT 1
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product pd ON sod.ProductID = pd.ProductID
    WHERE p.BusinessEntityID = c.PersonID
      AND pd.ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)
);

--Grouping and Aggregating:
--Calculate the total sales amount for each year and month from the Sales.SalesOrderHeader table.

Select 
SubTotal AS TotalSalesAmount,
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month
 from Sales.SalesOrderHeader
 GROUP BY Subtotal,
 YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

----Find the average order quantity and total sales amount for each product category.

SELECT
    pp.Name,
    CONCAT(ROUND(pp.StandardCost, 2), ' $') AS StandardCost,
    CONCAT(ROUND(pp.ListPrice, 2), ' $') AS ListPrice,
    CONCAT(ROUND(MAX(pp.ListPrice - pp.StandardCost), 2), ' $') AS Profit,
    MIN(pp.DaysToManufacture) AS MinManufactureDays,
    MIN(DATEDIFF(DAY, soh.OrderDate, soh.ShipDate)) AS MinOrderToShipDays,
    MAX(DATEDIFF(DAY, soh.OrderDate, soh.ShipDate)) AS MaxOrderToShipDays,
    CONCAT(ROUND(MAX(sod.UnitPriceDiscount), 2), ' $') AS MaxDiscount
FROM Production.Product pp
JOIN Sales.SalesOrderDetail sod ON sod.ProductID = pp.ProductID
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY pp.Name, pp.Size, pp.StandardCost, pp.ListPrice
ORDER BY pp.Name, pp.Size, MinManufactureDays, MaxOrderToShipDays DESC;


-------------------------------------------------------------------------------------

---List the names of customers who placed online orders in 2022 and have an annual income greater than $70,000.
SELECT
    COALESCE(pp.FirstName + ' ' + pp.MiddleName + '. ' + pp.LastName, pp.FirstName + pp.LastName) AS Fullname
FROM
    Person.Person pp
JOIN
    Sales.SalesPerson sp ON pp.BusinessEntityID = sp.BusinessEntityID
JOIN
    sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
WHERE
    Year(soh.OrderDate) = 2022
    AND sp.SalesYTD > 70000

----------------------------------------------------------------------------------------------------------------------
---Retrieve the names of employees who work in the United Kingdom (CountryRegionCode = 'GB') and have a job title of 'Sales Representative'



SELECT
    COALESCE(pp.FirstName + ' ' + pp.MiddleName + '. ' + pp.LastName, pp.FirstName + pp.LastName) AS Fullname
FROM
    Person.Person pp
WHERE EXISTS (
    SELECT 1
    FROM HumanResources.Employee
    WHERE JobTitle = 'Sales Representative' 
    AND EXISTS (
        SELECT 1
        FROM Person.vStateProvinceCountryRegion
        WHERE CountryRegionCode = 'GB'
        AND pp.BusinessEntityID = BusinessEntityID
    )
)



--Calculate the running total of sales amounts for each sales order in the Sales.SalesOrderHeader table.
SELECT 
    soh.SalesOrderID AS SalesOrder,
    SUM(sod.OrderQty * sod.UnitPrice) AS RunningTotal
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    soh.SalesOrderID
ORDER BY 
    soh.SalesOrderID


--Identify the top 10 products with the highest number of sales orders.


SELECT TOP 10 
    pp.Name,
    COUNT(DISTINCT sod.SalesOrderID) AS SalesOrders
FROM 
    Production.Product pp
JOIN  
    Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
GROUP BY 
    pp.Name
ORDER BY 
    SalesOrders DESC












