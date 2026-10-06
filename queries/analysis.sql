USE sql_dimensional_report;

-- ============================================
-- BASIC SALES ANALYSIS
-- ============================================

-- 1. Display all sales with customer and product information

SELECT
    fs.sale_id,
    c.customer_name,
    p.product_name,
    p.category,
    fs.quantity,
    fs.amount
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
JOIN dim_product p
    ON fs.product_id = p.product_id;


-- 2. Total sales revenue

SELECT
    SUM(amount) AS total_sales
FROM fact_sales;


-- 3. Total quantity sold

SELECT
    SUM(quantity) AS total_quantity
FROM fact_sales;


-- 4. Sales by product

SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;


-- 5. Sales by category

SELECT
    p.category,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- 6. Sales by customer

SELECT
    c.customer_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC;


-- ============================================
-- SUBQUERIES
-- ============================================

-- 7. Products whose sales are above
--    the average product sales

SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(fs.amount) > (
    SELECT AVG(product_sales)
    FROM (
        SELECT
            product_id,
            SUM(amount) AS product_sales
        FROM fact_sales
        GROUP BY product_id
    ) AS product_totals
);


-- 8. Customers who have made at least one purchase

SELECT
    c.customer_name
FROM dim_customer c
WHERE EXISTS (
    SELECT 1
    FROM fact_sales fs
    WHERE fs.customer_id = c.customer_id
);


-- 9. Customers who have never made a purchase

SELECT
    c.customer_name
FROM dim_customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_sales fs
    WHERE fs.customer_id = c.customer_id
);


-- 10. Sales greater than the average sale amount

SELECT
    sale_id,
    amount
FROM fact_sales
WHERE amount > (
    SELECT AVG(amount)
    FROM fact_sales
)
ORDER BY amount DESC;


-- 11. Highest individual sale

SELECT
    sale_id,
    amount
FROM fact_sales
WHERE amount = (
    SELECT MAX(amount)
    FROM fact_sales
);


-- 12. Products whose total sales are greater than
--     the average total sales of all products

SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(fs.amount) > (
    SELECT AVG(total_sales)
    FROM (
        SELECT
            product_id,
            SUM(amount) AS total_sales
        FROM fact_sales
        GROUP BY product_id
    ) AS product_summary
)
ORDER BY total_sales DESC;