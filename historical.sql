

-- price - cost (profit) historical

Select  DISTINCT
pp.Name														                            AS ProductName,
YEAR(DATEADD(YEAR, -1, GETDATE()))														AS LastYear ,                                                
ph.ListPrice																            AS LastYearPrice,
pc.StandardCost															                AS LastYearCost,
(ph.ListPrice - pc.StandardCost)												        AS LastYearProfit,
FORMAT(Getdate(), 'dd- MM- yyyy')								                        AS CurrentDate,
pp.ListPrice											                                AS ThisYearPrice,
pp.StandardCost																	        AS ThisYearCost,
(pp.ListPrice - pp.StandardCost)								                        AS ThisYearProfit

From Production.Product pp
JOIN  Production.ProductInventory pinv													ON  pp.ProductID = pinv.ProductID
JOIN Production.ProductListPriceHistory ph						                        ON pinv.ProductID = ph.ProductID
JOIN Production.ProductCostHistory  pc							                        ON ph.ProductID = pc.ProductID










