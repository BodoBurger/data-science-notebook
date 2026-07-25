---
# Core page metadata
title: 1 - SQL for Analytics Engineering
short_title: 1 - SQL Basics
description: A concise summary of the topic and scope of these notes.
date: 2026-07-19
tags:
  - dbt
  - SQL
keywords:
  - SQL best practices
---

## What dbt does

*dbt* (data build tool) is responsible fo the **transformation** layer in data pipelines.


## Learning objectives

- Write readable, modular SQL using CTEs.
- Choose the appropriate type of join.
- Use window functions confidently.
- Aggregate data at different granularities.
- Handle missing values correctly.
- Understand when to use subqueries versus CTEs.
- Write SQL that's easy to maintain in a dbt project.


## Writing readable SQL


### Use Common table expressions (CTEs)

One of dbt's core philosophies: **SQL is code**. Break the code into logical steps using CTEs, e.g. one CTE each for *collecting data*, *aggregating data* and *returning the result*.

```sql
WITH completed_orders AS (
SELECT
    customer_id,
    amount
FROM
    orders
WHERE
    status = 'completed'
),
customer_orders AS (
SELECT
    customers.customer_id,
    customers.name,
    completed_orders.amount
FROM
    customers
INNER JOIN completed_orders
        ON
    customers.customer_id = completed_orders.customer_id
)
SELECT
    customer_id,
    name,
    SUM(amount) AS revenue
FROM
    customer_orders
GROUP BY
    customer_id,
    name;
```


### `SELECT` only what you need

Avoid:

```sql
SELECT *
FROM orders;
```

Do:

```sql
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM orders;
```

Only use `SELECT *` in the final step of a model after the data is shaped.

### Use meaningful aliases

Avoid aliases like `a`, `b`, and `t1` unless they're truly local and obvious.

### Formatting matters

Instead of one line, use:

```sql
SELECT
    customer_id,
    SUM(price) AS revenue
FROM orders
WHERE status = 'completed'
GROUP BY customer_id;
```

### Think in transformations

Break transformation in single steps. Each step can become a CTE - and later, in dbt, its own model.


## Window functions

A window function computes aggregates without collapsing rows.

```sql
SELECT
    order_id,
    customer_id,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
    ) AS customer_revenue
FROM orders;
```

### `PARTITION BY`

Temporarily split table in to groups, calculate something for each group, but don't merge the rows.

### `ORDER BY` inside a window

Using `ORDER BY` you can calculate a running total:

```sql
SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
)
```

### Ranking functions

Using `ROW_NUMBER()`, `RANK()` and `DENSE_RANK()` combined with `ORDER BY` allows to rank values:

```sql
SELECT
    customer,
    amount,
    ROW_NUMBER() OVER (
        ORDER BY amount DESC
    ) AS rank
FROM customers;
```

### Exercise: window functions

Create a `running_total` column. Use a window function with both `PARTITION BY` and `ORDER BY`.

`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO orders (
    order_id,
    customer_id,
    order_date,
    amount
)
VALUES
    (101, 1, '2025-01-01', 100.00),
    (102, 1, '2025-01-05', 40.00),
    (103, 1, '2025-01-10', 60.00),
    (104, 2, '2025-01-03', 80.00),
    (105, 2, '2025-01-08', 50.00);
```
````
````{tab-item} Solution
```{code-block} sql
SELECT
    order_id,
    customer_id,
    order_date,
    amount,
    SUM(amount) over (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM
    orders
```
````
`````

## `ROW_NUMBER()` and deduplication

### Exercise

Write a query that returns only the latest record for each customer.

- Use a CTE.
- Use ROW_NUMBER().
- Make the ordering deterministic by including record_id as a secondary sort key.
- Return only:
  - customer_id
  - city
  - updated_at

`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS customer_updates;

CREATE TABLE customer_updates (
    record_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    city VARCHAR(100) NOT NULL,
    updated_at DATE NOT NULL
);

INSERT INTO customer_updates (
    record_id,
    customer_id,
    city,
    updated_at
)
VALUES
    (1, 1, 'Berlin',  '2025-01-01'),
    (2, 1, 'Munich',  '2025-03-15'),
    (3, 2, 'Hamburg', '2025-02-01'),
    (4, 2, 'Hamburg', '2025-04-01'),
    (5, 3, 'Cologne', '2025-01-20');
```
````
````{tab-item} Solution
```{code-block} sql
WITH latest_updates AS (
    SELECT
        customer_id,
        city,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
        ORDER BY
                updated_at DESC,
                record_id DESC
        ) AS row_num
    FROM
        customer_updates
)
SELECT
    customer_id,
    city,
    updated_at
FROM
    latest_updates
WHERE
    row_num = 1
```
````
`````


## `LAG()` and `LEAD()`

`LAG()` and `LEAD()` appear frequently in analytics models:

- Month-over-month growth
- Year-over-year comparisons
- Detecting changes in customer status
- Comparing current and previous prices
- Identifying gaps in time series
- Calculating durations between events

### Exercise

Write a query that returns `previous_revenue` and `change` columns:

- Use LAG().
- Calculate the previous month's revenue.
- Calculate the absolute change (revenue - previous_revenue).


`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS monthly_sales;

CREATE TABLE monthly_sales (
    month DATE,
    revenue DECIMAL(10,2)
);

INSERT INTO monthly_sales (
    month,
    revenue
)
VALUES
    ('2025-01-01', 100),
    ('2025-02-01', 120),
    ('2025-03-01', 90),
    ('2025-04-01', 150);
```
````
````{tab-item} Solution
```{code-block} sql
WITH previous_sales AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
        ORDER BY
            MONTH
        ) AS previous_revenue
    FROM
        monthly_sales
)
SELECT
    month,
    revenue,
    previous_revenue,
    revenue - previous_revenue AS change
FROM
    previous_sales
```
````
`````

## Joins

You should be able to answer these questions before writing a join:

- How many rows should the result have?
- Can this join duplicate rows?
- Can this join lose rows?
- Is the relationship one-to-one, one-to-many, or many-to-many?

A join does not duplicate rows, it returns one output row for every matching pair.
So determine the cardinality (uniqueness of data values) before joining.

- customer_id --> high cardinality
- status_flag --> low cardinality

### Grain

Grain means: one row represents what?

So the grain of a table of customers is one customer. The grain of an orders table is one order.

### Exercise

`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    amount DECIMAL(10,2)
);

INSERT INTO customers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO orders VALUES
(101, 1, 100),
(102, 1, 50),
(103, 2, 80);

SELECT * FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id

-- Exercise 5.2
DROP TABLE IF EXISTS customer_tags;

CREATE TABLE customer_tags (
    customer_id INTEGER,
    tag TEXT
);

INSERT INTO customer_tags VALUES
    (1, 'premium'),
    (1, 'newsletter'),
    (2, 'newsletter');

SELECT
    *
FROM
    orders
LEFT JOIN customer_tags
ON orders.customer_id = customer_tags.customer_id
```
````
`````

## Advanced Aggregations

### Exercise: `HAVING`

Write a query returning only customers whose total revenue is at least 150:

`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    amount DECIMAL(10,2)
);

INSERT INTO orders VALUES
(101,1,100),
(102,1,50),
(103,2,80),
(104,3,300),
(105,3,50);
```
````
````{tab-item} Solution
```{code-block} sql
SELECT
    customer_id,
    SUM(amount) AS revenue
FROM
    orders
GROUP BY
    customer_id
HAVING
    sum(amount) >= 150
```
````
`````

### Exercise: Conditional Aggregation

Return table with the columns `total_orders`, `completed_orders` and `cancelled_orders` for each customer:

`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    amount DECIMAL(10,2),
    status TEXT
);

INSERT INTO orders VALUES
(101,1,100,'completed'),
(102,1,50,'cancelled'),
(103,2,80,'completed'),
(104,2,30,'completed'),
(105,3,60,'cancelled');
```
````
````{tab-item} Solution
```{code-block} sql
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN status = 'completed'
            THEN 1
            ELSE 0
        END
    ) AS completed_orders,
    SUM(
        CASE
            WHEN status = 'cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_orders
FROM
    orders
GROUP BY
    customer_id
```
````
`````

### Exercise: Combined Analytical Patterns

Write one query that returns one row per customer with `completed_orders`, `completed_revenue`, `first_completed_order`and `latest_completed_order`.

Requirements:

- Keep all customers that occur in orders.
- Count only completed orders.
- Sum only completed revenue.
- Return the first and latest completed-order dates.
- Use conditional aggregation.
- Use COALESCE so customer 3 gets revenue 0.

`````{tab-set}
````{tab-item} Create data
```{code-block} sql
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

INSERT INTO orders VALUES
    (101, 1, '2025-01-05', 100.00, 'completed'),
    (102, 1, '2025-02-10',  50.00, 'completed'),
    (103, 1, '2025-03-01',  30.00, 'cancelled'),
    (104, 2, '2025-01-15',  80.00, 'completed'),
    (105, 2, '2025-04-20', 120.00, 'completed'),
    (106, 3, '2025-02-01',  60.00, 'cancelled');
```
````
````{tab-item} Solution
```{code-block} sql
SELECT
    customer_id,
    SUM(
    CASE
        WHEN status = 'completed'
        THEN 1
        ELSE 0
    END
    ) AS completed_orders,
    SUM(
    CASE
        WHEN status = 'completed'
        THEN amount
        ELSE 0
    END
    ) AS completed_revenue,
    MIN(CASE WHEN status = 'completed' THEN order_date END),
    MAX(CASE WHEN status = 'completed' THEN order_date END)
FROM
    orders
GROUP BY
    customer_id
ORDER BY
    customer_id
```
````
`````

## Building a small analytics model

Expected result with one row per cusomter:

| customer_id | customer_name | completed_orders | completed_revenue | first_completed_order | latest_completed_order | latest_completed_amount | customer_rank |
| ----------: | ------------- | ---------------: | ----------------: | --------------------- | ---------------------- | ----------------------: | ------------: |
|           2 | Bob           |                2 |               200 | 2025-01-15            | 2025-04-20             |                     120 |             1 |
|           1 | Alice         |                2 |               150 | 2025-01-05            | 2025-02-10             |                      50 |             2 |
|           3 | Charlie       |                0 |                 0 | NULL                  | NULL                   |                    NULL |             3 |
|           4 | Diana         |                0 |                 0 | NULL                  | NULL                   |                    NULL |             3 |


- at least two CTEs
- conditional aggregation
- ROW_NUMBER() to identify the latest completed order
- a LEFT JOIN so customers without completed orders remain
- COALESCE for counts and revenue
- DENSE_RANK() for customer_rank

`````{tab-set}
````{tab-item} Setup
```{code-block} sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    signup_date DATE NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

INSERT INTO customers VALUES
    (1, 'Alice',   '2024-12-10'),
    (2, 'Bob',     '2025-01-05'),
    (3, 'Charlie', '2025-02-01'),
    (4, 'Diana',   '2025-02-15');

INSERT INTO orders VALUES
    (101, 1, '2025-01-05', 100.00, 'completed'),
    (102, 1, '2025-02-10',  50.00, 'completed'),
    (103, 1, '2025-03-01',  30.00, 'cancelled'),
    (104, 2, '2025-01-15',  80.00, 'completed'),
    (105, 2, '2025-04-20', 120.00, 'completed'),
    (106, 2, '2025-05-01',  40.00, 'cancelled'),
    (107, 3, '2025-02-20',  60.00, 'cancelled');
```
````
````{tab-item} Solution
```{code-block} sql
WITH ordered_amount AS (
    SELECT
        customer_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
        ORDER BY
            order_date DESC,
            order_id DESC
        ) AS row_num
    FROM
        orders
    WHERE
        status = 'completed'
),
latest_completed_amounts AS (
    SELECT
        *
    FROM
        ordered_amount
    WHERE
        row_num = 1
),
-- Values of completed orders:
completed_orders AS (
    SELECT
        customer_id,
        SUM(
    CASE
        WHEN status = 'completed'
        THEN 1
        ELSE 0
    END
    ) AS completed_orders,
        SUM(
    CASE
        WHEN status = 'completed'
        THEN amount
        ELSE 0
    END
    ) AS completed_revenue,
        MIN(CASE WHEN status = 'completed' THEN order_date END) AS first_completed_order,
        MAX(CASE WHEN status = 'completed' THEN order_date END) AS last_completed_order
    FROM
        orders
    GROUP BY
        customer_id
    ORDER BY
        customer_id
)
-- Main select & join
SELECT
    customers.customer_id,
    customers.customer_name,
    latest_completed_amounts.amount AS 
FROM
    customers
LEFT JOIN latest_completed_amounts
ON
    customers.customer_id = latest_completed_amounts.customer_id
```
````
`````
