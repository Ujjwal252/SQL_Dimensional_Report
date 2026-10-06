USE sql_dimensional_report;

-- ============================================
-- EXPLAIN
-- ============================================

-- 1. Explain a basic sales query

EXPLAIN
SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_id, p.product_name;


-- 2. Explain customer sales analysis

EXPLAIN
SELECT
    c.customer_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_customer c
    ON fs.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name;


-- ============================================
-- INDEXES
-- ============================================

-- 3. Create indexes on foreign-key columns

CREATE INDEX idx_fact_sales_customer
ON fact_sales(customer_id);

CREATE INDEX idx_fact_sales_product
ON fact_sales(product_id);

CREATE INDEX idx_fact_sales_date
ON fact_sales(date_id);


-- 4. Explain the query again after indexing

EXPLAIN
SELECT
    p.product_name,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_product p
    ON fs.product_id = p.product_id
GROUP BY p.product_id, p.product_name;


-- 5. Explain a date-based query

EXPLAIN
SELECT
    d.year,
    d.month,
    SUM(fs.amount) AS total_sales
FROM fact_sales fs
JOIN dim_date d
    ON fs.date_id = d.date_id
WHERE d.year = 2026
GROUP BY d.year, d.month;