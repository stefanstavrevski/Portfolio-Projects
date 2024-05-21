SELECT 
		pc.ProductCategoryID,
		psub.ProductSubcategoryID  AS SubCategoryID,
		pc.Name AS ProductName,
		psub.Name  AS Subcategory,
		pm.Name  AS ProductModel,
		pd.Description  AS ProductDescription,
		pin.Quantity  AS ProductQuantity,
		pp.StandardCost,
		pp.ListPrice
		


  FROM Production.ProductCategory as pc
  JOIN Production.ProductSubcategory psub 
  ON pc.ProductCategoryID = psub.ProductCategoryID
  JOIN Production.ProductDescription AS pd 
  ON psub.ProductSubcategoryID = pd.ProductDescriptionID
  JOIN Production.ProductModel AS pm
  ON  psub.ProductSubcategoryID = pm.ProductModelID
  JOIN Production.ProductInventory  AS pin
  ON pc.ProductCategoryID = pin.ProductID
  JOIN Production.Product AS pp
  ON pin.ProductID = pp.ProductID
