# SQL Dimensional Report

A MySQL-based sales analytics project demonstrating **dimensional modeling and advanced SQL techniques**.

## 🗂️ Project Structure

```text
SQL_Dimensional_Report/
│
├── README.md
├── schemas/
│   ├── database.sql
│   └── insert_data.sql
│
└── queries/
    ├── analysis.sql
    ├── window_functions.sql
    ├── advanced_sql.sql
    └── optimization.sql
```

## ⭐ Database Design

The project follows a simple **Star Schema**:

```text
dim_customer ──┐
dim_product  ──┼──> fact_sales <── dim_date
```

### Tables

- `dim_customer` — Customer details
- `dim_product` — Product and category details
- `dim_date` — Date information
- `fact_sales` — Sales transactions

## 🛠️ Technologies

- MySQL
- SQL
- Git & GitHub

## 📚 SQL Concepts

- Subqueries
- `EXISTS` / `NOT EXISTS`
- `RANK()` / `DENSE_RANK()`
- `LAG()` / `LEAD()`
- `NTILE()`
- Window Frames
- CTEs & Recursive CTEs
- `UNION` / `INTERSECT` / `EXCEPT`
- `ROLLUP`
- Views
- `EXPLAIN`
- Indexing & Query Optimization

## 📊 Dataset

- 8 Customers
- 8 Products
- 12 Dates
- 25 Sales Transactions

## 🚀 How to Run

Create the database:

```sql
SOURCE path/to/schemas/database.sql;
```

Insert the data:

```sql
SOURCE path/to/schemas/insert_data.sql;
```

Run the analysis files:

```sql
SOURCE path/to/queries/analysis.sql;
SOURCE path/to/queries/window_functions.sql;
SOURCE path/to/queries/advanced_sql.sql;
SOURCE path/to/queries/optimization.sql;
```

## ✅ Status

**Completed and tested successfully.**

All major SQL queries, window functions, CTEs, advanced SQL operations, views, and query optimization scripts have been verified.