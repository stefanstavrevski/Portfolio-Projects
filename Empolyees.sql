--The query is designed to extract key insights about employees, their roles,
-- experience, and leave balances.
-- It combines data from multiple tables using joins and employs various functions 
--to calculate meaningful metrics. 


SELECT 
    COALESCE(pp.FirstName + ' ' + pp.MiddleName + ' ' + pp.LastName, pp.FirstName + ' ' + pp.LastName) AS FullName,
    e.JobTitle AS JobTitle,
    e.Gender AS Gender,
    DATEDIFF(Year, e.HireDate, CURRENT_TIMESTAMP) AS YearsExperience,
    (e.VacationHours - e.SickLeaveHours) AS LeaveHoursLeft,
    CASE 
        WHEN dh.EndDate IS NULL THEN 'Former Employee'
        ELSE COALESCE(CAST(DATEDIFF(Year, dh.StartDate, dh.EndDate) AS NVARCHAR(50)), 'Former Employee')
    END AS CurrentYearsInThisJob
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory dh ON e.BusinessEntityID = dh.BusinessEntityID
JOIN HumanResources.Department d ON d.DepartmentID = dh.DepartmentID
JOIN Person.Person pp ON pp.BusinessEntityID = e.BusinessEntityID
ORDER BY CurrentYearsInThisJob;