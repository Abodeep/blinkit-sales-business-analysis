-- ** BLINKIT DATA CLEANING & QUALITY CHECK **

-- Objective:
-- Validate data quality, standardize categorical values,
-- handle missing values, and validate numerical fields.
-- -----------------------------------------

SELECT COUNT(*) AS Total_Rows
FROM Blinkit_data;

-- -----------------------------------------
-- STANDARDIZE ITEM FAT CONTENT
-- -----------------------------------------

SELECT DISTINCT Item_Fat_Content
FROM Blinkit_data;

UPDATE Blinkit_data
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat')
            THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg'
            THEN 'Regular'
        ELSE Item_Fat_Content
    END;

SELECT DISTINCT Item_Fat_Content
FROM Blinkit_data;

-- -----------------------------------------
-- NULL VALUE CHECK
-- -----------------------------------------

SELECT
    SUM(CASE WHEN Item_Identifier IS NULL THEN 1 ELSE 0 END) AS Null_Item_Identifier,
    SUM(CASE WHEN Item_Weight IS NULL THEN 1 ELSE 0 END) AS Null_Item_Weight,
    SUM(CASE WHEN Item_Fat_Content IS NULL THEN 1 ELSE 0 END) AS Null_Item_Fat_Content,
    SUM(CASE WHEN Item_Visibility IS NULL THEN 1 ELSE 0 END) AS Null_Item_Visibility,
    SUM(CASE WHEN Item_Type IS NULL THEN 1 ELSE 0 END) AS Null_Item_Type,
    SUM(CASE WHEN Outlet_Identifier IS NULL THEN 1 ELSE 0 END) AS Null_Outlet_Identifier,
    SUM(CASE WHEN Outlet_Establishment_Year IS NULL THEN 1 ELSE 0 END) AS Null_Establishment_Year,
    SUM(CASE WHEN Outlet_Size IS NULL THEN 1 ELSE 0 END) AS Null_Outlet_Size,
    SUM(CASE WHEN Outlet_Location_Type IS NULL THEN 1 ELSE 0 END) AS Null_Outlet_Location_Type,
    SUM(CASE WHEN Outlet_Type IS NULL THEN 1 ELSE 0 END) AS Null_Outlet_Type,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS Null_Rating
FROM Blinkit_data;

-- -----------------------------------------
-- ITEM WEIGHT IMPUTATION
-- -----------------------------------------

-- Level 1 Imputation:
-- Recover missing Item_Weight values using the known
-- weight associated with the same Item_Identifier.

UPDATE b
SET b.Item_Weight = w.Known_Weight
FROM Blinkit_data b
INNER JOIN (
    SELECT
        Item_Identifier,
        MAX(Item_Weight) AS Known_Weight
    FROM Blinkit_data
    WHERE Item_Weight IS NOT NULL
    GROUP BY Item_Identifier
) w
    ON b.Item_Identifier = w.Item_Identifier
WHERE b.Item_Weight IS NULL;

SELECT COUNT(*) AS Remaining_Null_Weights
FROM Blinkit_data
WHERE Item_Weight IS NULL;

-- Level 2 Imputation:
-- For items with no known historical weight, use the
-- median Item_Weight within the same Item_Type
-- and Item_Fat_Content group.

WITH MedianWeights AS (
    SELECT DISTINCT
        Item_Type,
        Item_Fat_Content,
        PERCENTILE_CONT(0.5)
            WITHIN GROUP (ORDER BY Item_Weight)
            OVER (
                PARTITION BY Item_Type, Item_Fat_Content
            ) AS Median_Item_Weight
    FROM Blinkit_data
    WHERE Item_Weight IS NOT NULL
)
UPDATE b
SET b.Item_Weight =
    CAST(m.Median_Item_Weight AS DECIMAL(10,2))
FROM Blinkit_data b
INNER JOIN MedianWeights m
    ON b.Item_Type = m.Item_Type
    AND b.Item_Fat_Content = m.Item_Fat_Content
WHERE b.Item_Weight IS NULL;

SELECT COUNT(*) AS Remaining_Null_Weights
FROM Blinkit_data
WHERE Item_Weight IS NULL;
-- Expected result: 0 remaining NULL values.

-- -----------------------------------------
-- DUPLICATE CHECK
-- -----------------------------------------

SELECT 
    Item_Identifier,
    Outlet_Identifier,
    COUNT(*) AS Record_Count
FROM Blinkit_data
GROUP BY
    Item_Identifier,
    Outlet_Identifier
HAVING COUNT(*) > 1;

-- -----------------------------------------
-- CATEGORICAL VALUE VALIDATION
-- -----------------------------------------

SELECT DISTINCT Item_Type
FROM Blinkit_data
ORDER BY Item_Type;

SELECT DISTINCT Outlet_Size
FROM Blinkit_data;

SELECT DISTINCT Outlet_Location_Type
FROM Blinkit_data;

SELECT DISTINCT Outlet_Type
FROM Blinkit_data;

SELECT DISTINCT Outlet_Establishment_Year
FROM Blinkit_data
ORDER BY Outlet_Establishment_Year;

-- -----------------------------------------
-- NUMERICAL DATA VALIDATION
-- -----------------------------------------

SELECT
    MIN(Sales) AS Min_Sales,
    MAX(Sales) AS Max_Sales,
    AVG(Sales) AS Avg_Sales,
    MIN(Rating) AS Min_Rating,
    MAX(Rating) AS Max_Rating,
    MIN(Item_Visibility) AS Min_Visibility,
    MAX(Item_Visibility) AS Max_Visibility
FROM Blinkit_data;