
CREATE DATABASE day10_sql;
USE day10_sql;
-- =========================================================
-- 1. CTE (WITH Clause)
-- Calculate total revenue for each country
-- =========================================================

WITH CountryRevenue AS
(
    SELECT
        Country,
        ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
    FROM online_retail
    GROUP BY Country
)

SELECT *
FROM CountryRevenue
ORDER BY Total_Revenue DESC;


-- =========================================================
-- 2. Window Function - RANK()
-- Rank customers based on revenue within each country
-- =========================================================

SELECT

    Country,

    CustomerID,

    ROUND(SUM(Quantity * UnitPrice),2) AS Revenue,

    RANK() OVER
    (
        PARTITION BY Country
        ORDER BY SUM(Quantity * UnitPrice) DESC
    ) AS Customer_Rank

FROM online_retail

WHERE CustomerID IS NOT NULL

GROUP BY Country, CustomerID;


-- =========================================================
-- 3. Running Total
-- Calculate cumulative daily revenue
-- =========================================================

SELECT

    DATE(InvoiceDate) AS Sales_Date,

    ROUND(SUM(Quantity * UnitPrice),2) AS Daily_Revenue,

    ROUND(

        SUM(SUM(Quantity * UnitPrice))

        OVER(
            ORDER BY DATE(InvoiceDate)
        )

    ,2) AS Running_Total

FROM online_retail

GROUP BY DATE(InvoiceDate);


-- =========================================================
-- 4. CASE Statement
-- Categorize each transaction
-- =========================================================

SELECT

    InvoiceNo,

    CustomerID,

    Quantity,

    UnitPrice,

    ROUND(Quantity * UnitPrice,2) AS Revenue,

    CASE

        WHEN Quantity * UnitPrice >= 1000 THEN 'High'

        WHEN Quantity * UnitPrice >= 500 THEN 'Medium'

        ELSE 'Low'

    END AS Revenue_Category

FROM online_retail;


-- =========================================================
-- 5. Subquery in WHERE Clause
-- Products whose price is above average price
-- =========================================================

SELECT *

FROM online_retail

WHERE UnitPrice >

(
    SELECT AVG(UnitPrice)

    FROM online_retail
);


-- =========================================================
-- 6. Subquery in SELECT Clause
-- Show average unit price with every record
-- =========================================================

SELECT

    InvoiceNo,

    StockCode,

    Description,

    UnitPrice,

    (
        SELECT ROUND(AVG(UnitPrice),2)

        FROM online_retail

    ) AS Average_UnitPrice

FROM online_retail;


-- =========================================================
-- 7. Date Functions
-- Monthly Sales Report
-- =========================================================

SELECT

    YEAR(InvoiceDate) AS Sales_Year,

    MONTH(InvoiceDate) AS Sales_Month,

    COUNT(DISTINCT InvoiceNo) AS Total_Orders,

    ROUND(SUM(Quantity * UnitPrice),2) AS Revenue

FROM online_retail

GROUP BY

    YEAR(InvoiceDate),

    MONTH(InvoiceDate)

ORDER BY

    Sales_Year,

    Sales_Month;


-- =========================================================
-- 8. Combined Query
-- CTE + Window Function
-- Rank countries by total revenue
-- =========================================================

WITH RevenueSummary AS
(
    SELECT

        Country,

        ROUND(SUM(Quantity * UnitPrice),2) AS Revenue

    FROM online_retail

    GROUP BY Country
)

SELECT

    Country,

    Revenue,

    RANK() OVER
    (
        ORDER BY Revenue DESC
    ) AS Country_Rank

FROM RevenueSummary;
