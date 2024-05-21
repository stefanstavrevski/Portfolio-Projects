
--Retrieve the names of all products in the "Product" table along with their list prices.

Select 
Name,
ListPrice
from Production.Product
ORDER BY ListPrice DESC;

--List the names of products from the "Product" table that belong to the category with CategoryID 4.

Select 
Name,
ListPrice
from Production.Product
WHERE ProductSubcategoryID = 4
ORDER BY ListPrice DESC;


--Find the average order quantity for each product in the "SalesOrderDetail" table. Display the product names and their average order quantities.

Select 
pp.Name AS ProductName,
AVG(sod.OrderQTY) AS AverageQuantity
from Sales.SalesOrderDetail sod
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
Group by OrderQty,Name

--Retrieve the names of customers who have placed orders with a total amount greater than $5,000. 
--Include the customer names and their corresponding total order amounts.

Select 
  COALESCE(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS CustomerName,
  soh.TotalDue
from  Person.Person	pp
JOIN Sales.SalesOrderHeader soh ON pp.BusinessEntityID = soh.CustomerID
WHERE EXISTS ( 
Select 1
from Sales.SalesOrderHeader 
where TotalDue > 5000)


--Calculate the total sales amount for each year and month from the "SalesOrderHeader" table.
--Display the results with columns for year, month, and total sales amount.

SELECT 
  YEAR(Orderdate) AS  year,
  MONTH(OrderDate) as month,
          SUM(TotalDue) OVER (ORDER BY Year(OrderDate),Month(OrderDate) ) AS TotalSalesAmount
   FROM Sales.SalesOrderHeader
   order by OrderDate


--Basic Retrieval (Beginner): Retrieve the names and list prices of all products in the "Product" table.Select 
Select
Name,ListPrice
from Production.Product

--Filtering and Sorting (Beginner): List the names of products that have a list price greater than $500 and sort them in descending order of list price.

Select 
Name,
ListPrice
from Production.Product
Where ListPrice > 500
order by ListPrice desc;


--Joins (Intermediate): Retrieve the names of customers who have placed orders, along with the total number of orders they have placed.

Select 
COALESCE(pp.FirstName + pp.MiddleName + pp.LastName , pp.FirstName + pp.LastName) AS FullName,
COUNT(soh.SalesOrderID) AS OrdersTotalNumber
from Sales.SalesOrderHeader soh
JOIN  Sales.SalesPerson  sp ON  soh.TerritoryID = sp.TerritoryID
JOIN  Person.Person pp   ON sp.BusinessEntityID = pp.BusinessEntityID
Group by FirstName,MiddleName,LastName;



--Subqueries (Intermediate): Find the products with the highest and lowest list prices, and then list the names of customers who have purchased these products.



WITH HighestAndLowestPrices AS (
  SELECT
    MAX(ListPrice) AS MaxPrice,
    MIN(ListPrice) AS MinPrice
  FROM Production.Product
)

SELECT
  COALESCE(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS CustomerName,
  pr.Name AS ProductName,
  pr.ListPrice
FROM Person.Person pp
JOIN Sales.SalesOrderHeader soh ON pp.BusinessEntityID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN HighestAndLowestPrices hlp ON pr.ListPrice = hlp.MaxPrice OR pr.ListPrice = hlp.MinPrice;


--Window Functions : Calculate the running total of sales amounts for each sales order in the "SalesOrderHeader" table, 
--and order the results by the sales order date.

   SELECT 
  SalesOrderID,
          SUM(TotalDue) OVER (ORDER BY SalesOrderID ) AS RunningTotal
   FROM Sales.SalesOrderHeader
   order by OrderDate
