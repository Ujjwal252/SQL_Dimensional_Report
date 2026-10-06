USE sql_dimensional_report;

-- ============================================
-- RECURSIVE CTE
-- ============================================

-- 1. Generate numbers from 1 to 10

WITH RECURSIVE numbers AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT n
FROM numbers;


-- 2. Generate months from January to June

WITH RECURSIVE months AS (
    SELECT 1 AS month_number

    UNION ALL

    SELECT month_number + 1
    FROM months
    WHERE month_number < 6
)
SELECT month_number
FROM months;


-- ============================================
-- UNION
-- ============================================

-- 3. Customers who bought Electronics
--    or Furniture

SELECT DISTINCT
    c.customer_name
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id
WHERE p.category = 'Electronics'

UNION

SELECT DISTINCT
    c.customer_name
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id
WHERE p.category = 'Furniture';


-- ============================================
-- INTERSECT
-- ============================================

-- 4. Customers who bought both Electronics
--    and Furniture

SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id
WHERE p.category = 'Electronics'

INTERSECT

SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id
WHERE p.category = 'Furniture';


-- ============================================
-- EXCEPT
-- ============================================

-- 5. Customers who bought Electronics
--    but did not buy Furniture

SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id
WHERE p.category = 'Electronics'

EXCEPT

SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id
WHERE p.category = 'Furniture';


-- ============================================
-- ROLLUP
-- ============================================

-- 6. Sales by category with grand total

SELECT
    p.category,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.category WITH ROLLUP;


-- 7. Sales by year and month with subtotals

SELECT
    d.year,
    d.month,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
GROUP BY
    d.year,
    d.month WITH ROLLUP;


-- ============================================
-- CUBE / GROUPING SETS EQUIVALENT
-- ============================================

-- MySQL does not support standard CUBE or
-- GROUPING SETS syntax.
--
-- We can reproduce common grouping-set reports
-- using UNION ALL.


-- 8. Category total + grand total

SELECT
    p.category,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.category

UNION ALL

SELECT
    'ALL CATEGORIES' AS category,
    SUM(amount) AS total_sales
FROM fact_sales;


-- ============================================
-- CTE - MONTHLY SALES
-- ============================================

-- 9. Monthly sales report

WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        SUM(fs.amount) AS total_sales
    FROM fact_sales fs
    JOIN dim_date d
        ON fs.date_id = d.date_id
    GROUP BY d.year, d.month
)
SELECT *
FROM monthly_sales
ORDER BY year, month;


-- ============================================
-- CTE + LAG - MOM GROWTH
-- ============================================

-- 10. Month-over-month sales growth

WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        SUM(fs.amount) AS total_sales
    FROM fact_sales fs
    JOIN dim_date d
        ON fs.date_id = d.date_id
    GROUP BY d.year, d.month
),

monthly_comparison AS (
    SELECT
        year,
        month,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year, month
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    year,
    month,
    total_sales,
    previous_month_sales,
    ROUND(
        (
            (total_sales - previous_month_sales)
            / previous_month_sales
        ) * 100,
        2
    ) AS mom_growth_percentage
FROM monthly_comparison
ORDER BY year, month;


-- ============================================
-- VIEWS
-- ============================================

-- 11. Create a view for product sales

CREATE OR REPLACE VIEW product_sales_view AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category;


-- 12. Query the view

SELECT *
FROM product_sales_view
ORDER BY total_sales DESC;


-- 13. Create a monthly sales view

CREATE OR REPLACE VIEW monthly_sales_view AS
SELECT
    d.year,
    d.month,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
GROUP BY d.year, d.month;


-- 14. Query monthly sales view

SELECT *
FROM monthly_sales_view
ORDER BY year, month;