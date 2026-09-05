-- --------------------------------------------
-- KEY PERFORMANCE INDICATORS
-- --------------------------------------------

-- Total Sales
SELECT
    CAST(SUM(Sales) / 1000000.0 AS DECIMAL(10,2))
        AS Total_Sales_Millions
FROM Blinkit_data;


-- Average Sales per Record
SELECT
    CAST(AVG(Sales) AS DECIMAL(10,2))
        AS Average_Sales_Per_Record
FROM Blinkit_data;


-- Total Number of Records
SELECT
    COUNT(*) AS Number_Of_Items
FROM Blinkit_data;


-- Average Customer Rating
SELECT
    CAST(AVG(Rating) AS DECIMAL(10,2))
        AS Average_Rating
FROM Blinkit_data;


-- --------------------------------------------
-- SALES PERFORMANCE
-- --------------------------------------------

-- SALES BY ITEM FAT CONTENT
SELECT
    Item_Fat_Content,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER()
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
    COUNT(*) AS Number_Of_Records,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM Blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;


-- TOP 5 ITEM TYPES BY SALES
SELECT TOP 5
    Item_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER()
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
    COUNT(*) AS Number_Of_Records,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM Blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;


-- SALES BY FAT CONTENT ACROSS OUTLET LOCATIONS
SELECT
    Outlet_Location_Type,
    ISNULL([Low Fat], 0) AS Low_Fat_Sales,
    ISNULL([Regular], 0) AS Regular_Sales
FROM (
    SELECT
        Outlet_Location_Type,
        Item_Fat_Content,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM Blinkit_data
    GROUP BY
        Outlet_Location_Type,
        Item_Fat_Content
) AS SourceTable
PIVOT (
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


-- --------------------------------------------
-- OUTLET PERFORMANCE
-- --------------------------------------------

-- SALES PERFORMANCE BY OUTLET ESTABLISHMENT YEAR
SELECT
    Outlet_Establishment_Year,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
    COUNT(*) AS Number_Of_Records,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM Blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;


-- SALES BY OUTLET SIZE
SELECT
    Outlet_Size,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER()
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
    COUNT(*) AS Number_Of_Records,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM Blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


-- SALES PERFORMANCE BY OUTLET LOCATION
SELECT
    Outlet_Location_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER()
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
    COUNT(*) AS Number_Of_Records,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating
FROM Blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;


-- OUTLET PERFORMANCE BY OUTLET TYPE
SELECT
    Outlet_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER()
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Average_Sales,
    COUNT(*) AS Number_Of_Records,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Rating,
    CAST(AVG(Item_Visibility) AS DECIMAL(10,4)) AS Average_Item_Visibility
FROM Blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;


-- --------------------------------------------
-- PRODUCT PERFORMANCE
-- --------------------------------------------

-- ITEM TYPE SALES RANKING
SELECT
    Item_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank
FROM Blinkit_data
GROUP BY Item_Type
ORDER BY Sales_Rank;
