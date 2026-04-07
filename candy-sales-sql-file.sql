USE US_CD;
DESC CD_SALES;
 
 -- After performing the necessary cleaning & transformation tasks on the tables like renaming, changing datatypes
 -- Lets check if there are any Duplicate values.
 
SELECT 
    ROW_ID, COUNT(*)
FROM
    CD_SALES
GROUP BY ROW_ID
HAVING COUNT(*) > 1;
 
 -- Now check if there are any Null values
 
SELECT 
    *
FROM
    cd_sales
WHERE
    Units IS NULL;
 
 -- As there are no duplicates and null values
 -- We can move towards the analysis of data


-- REVENUE ANALYSIS PER PRODUCT

SELECT 
    s.product_name, ROUND(SUM(s.units * p.unit_price),2) AS Revenue
FROM
    cd_sales s
        JOIN
    cd_products p ON s.product_id = p.product_id
GROUP BY Product_Name
ORDER BY Revenue DESC;


-- TOTAL UNITS SOLD PER YEAR
 
SELECT 
    YEAR(Order_Date) AS Year, SUM(Units) AS Total_Units_Sold
FROM
    cd_sales
GROUP BY Year;


-- ANALYSIS OF SEASONAL TRENDS(Per month)

SELECT 
    MONTH(Order_Date) AS Month,
    SUM(Units) AS Sales
FROM cd_sales
GROUP BY Month
ORDER BY Sales DESC;


-- ANALYSIS OF TARGET SALES VS ACTUAL SALES

SELECT 
    t.Division,
    SUM(s.Units) AS Actual,
    t.Target,
    CONCAT(ROUND((SUM(s.Units) / t.Target) * 100, 2),'%') AS Achievement
FROM
    cd_sales s
        JOIN
    cd_targets t ON s.Division = t.Division
GROUP BY t.Division , t.Target;


-- TOTAL UNITS SOLD PER FACTORY

SELECT 
    f.Factory, SUM(s.Units) AS Total_Sales
FROM
    cd_sales s
        JOIN
    cd_products p ON s.product_id = p.product_id
        JOIN
    cd_factories f ON f.factory = p.factory
GROUP BY f.Factory
ORDER BY Total_Sales DESC;


-- PROFIT MARGIN PER PRODUCT

SELECT 
    s.Product_Name,
    CONCAT(ROUND(SUM(s.Gross_Profit) / SUM(s.Units * p.Unit_Price) * 100,2),'%') AS Profit_Margin
FROM
    cd_sales s
        JOIN
    cd_products p ON s.product_id = p.product_id
GROUP BY s.Product_Name
ORDER BY Profit_Margin DESC;


-- SEGMENTATION ANALYSIS PER PRODUCT

SELECT 
    Product_Name,
    SUM(Units) AS Total_Sales,
    CASE 
        WHEN SUM(Units) >= 7000 THEN 'High'
        WHEN SUM(Units) BETWEEN 1000 AND 7000 THEN 'Medium'
        ELSE 'Low'
    END AS Segment
FROM cd_sales
GROUP BY Product_Name;




 