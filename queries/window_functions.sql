USE sql_dimensional_report;

-- ============================================
-- WINDOW FUNCTIONS
-- ============================================

-- 1. Rank products by total sales

SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(fs.amount) DESC
    ) AS sales_rank
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY sales_rank;


-- 2. Rank products within each category

SELECT
    p.category,
    p.product_name,
    SUM(fs.amount) AS total_sales,
    DENSE_RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(fs.amount) DESC
    ) AS category_rank
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.category, p.product_id, p.product_name
ORDER BY p.category, category_rank;


-- 3. Rank customers by total sales

SELECT
    c.customer_name,
    SUM(fs.amount) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(fs.amount) DESC
    ) AS customer_rank
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_rank;


-- 4. Previous sale amount

SELECT
    sale_id,
    sale_date,
    amount,
    LAG(amount) OVER (
        ORDER BY sale_date, sale_id
    ) AS previous_sale
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
ORDER BY sale_date, sale_id;


-- 5. Next sale amount

SELECT
    sale_id,
    sale_date,
    amount,
    LEAD(amount) OVER (
        ORDER BY sale_date, sale_id
    ) AS next_sale
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
ORDER BY sale_date, sale_id;


-- 6. Difference from previous sale

SELECT
    sale_id,
    sale_date,
    amount,
    LAG(amount) OVER (
        ORDER BY sale_date, sale_id
    ) AS previous_sale,
    amount -
    LAG(amount) OVER (
        ORDER BY sale_date, sale_id
    ) AS difference_from_previous
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
ORDER BY sale_date, sale_id;


-- 7. Divide products into 3 sales groups

SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales,
    NTILE(3) OVER (
        ORDER BY SUM(fs.amount) DESC
    ) AS sales_group
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY sales_group;


-- ============================================
-- WINDOW FRAMES
-- ============================================

-- 8. Running total of sales

SELECT
    sale_id,
    sale_date,
    amount,
    SUM(amount) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
ORDER BY sale_date, sale_id;


-- 9. Running average of sales

SELECT
    sale_id,
    sale_date,
    amount,
    AVG(amount) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_average
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
ORDER BY sale_date, sale_id;


-- 10. Three-row moving total

SELECT
    sale_id,
    sale_date,
    amount,
    SUM(amount) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_row_total
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
ORDER BY sale_date, sale_id;