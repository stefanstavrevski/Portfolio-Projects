Select 
SUM(sod.LineTotal) AS sales_amount,
pps.Name AS product_category,
st.Name AS Region
from Production.Product pp
JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID 
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
JOIN Production.ProductSubcategory pps ON pps.ProductSubcategoryID = pp.ProductSubcategoryID 
JOIN Production.ProductCategory pc ON pc.ProductCategoryID = pps.ProductCategoryID
Group by pps.Name,st.Name
Order by sales_amount Desc

---


-- Advanced Level: Exercise 13 - Employee Sales Performance Metrics (Revised)

SELECT 
    COALESCE(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS EmployeeName,
    SUM(sod.LineTotal) AS SalesAmount,
    AVG(sod.LineTotal) AS AverageOrderValue,
    COUNT(DISTINCT soh.CreditCardApprovalCode) AS SuccessfulTransactions,
    RANK() OVER (ORDER BY SUM(sod.LineTotal) DESC) AS Rank
FROM 
    Sales.SalesOrderDetail sod 
JOIN 
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN 
    Sales.SalesPerson sp ON soh.TerritoryID = sp.TerritoryID 
JOIN 
    Person.Person pp ON pp.BusinessEntityID = sp.BusinessEntityID
GROUP BY 
    pp.FirstName, pp.MiddleName, pp.LastName;



