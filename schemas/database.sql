CREATE DATABASE IF NOT EXISTS sql_dimensional_report;

USE sql_dimensional_report;

-- Dimension: Customers
CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);

-- Dimension: Products
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL
);

-- Dimension: Dates
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL
);

-- Fact: Sales
CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    date_id INT NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES dim_customer(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES dim_product(product_id),

    FOREIGN KEY (date_id)
        REFERENCES dim_date(date_id)
);