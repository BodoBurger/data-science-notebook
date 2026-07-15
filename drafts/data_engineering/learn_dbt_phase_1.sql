----------------------
-- Exercise 1: CTEs
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


SELECT * FROM customers


--------------------------------
-- Exercise 2: window functions
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

--------------
-- Exercise 3: 
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

SELECT * FROM customer_updates

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

	
--------------------------
-- Exercise 4: LAG / LEAD
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


------------------------------
-- Exercise 5 - joins
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


------------------------
-- Exercise 10.1: HAVING 
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

-- only select customers whose total revenue is at least 150
SELECT
    customer_id,
    SUM(amount) AS revenue
FROM
    orders
GROUP BY
    customer_id
HAVING
    sum(amount) >= 150

    
-- Exercise 10.2: conditional aggregation
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

-----------------------------------------
-- Module 11: Combined Analytics Patterns

-- Exercise 11.1: customer metrics
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


--------------------------------
-- Capstone: Customer Order Mart
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


WITH completed_orders AS (
    SELECT
        *
    FROM
        orders
    WHERE
        status = 'completed'
),
completed_values_by_customer AS (
SELECT
    customers.customer_id,
    SUM(COALESCE(completed_orders.amount, 0)) AS completed_amount
FROM
    customers
LEFT JOIN completed_orders ON
    completed_orders.customer_id = customers.customer_id
GROUP BY
    customers.customer_id
)
SELECT customer_id, RANK() OVER (ORDER BY completed_amount DESC) AS customer_rank FROM completed_values_by_customer



SELECT
    customers.customer_id,
    SUM(COALESCE(orders.amount, 0)) AS completed_amount
FROM
    customers
LEFT JOIN orders ON
    orders.customer_id = customers.customer_id
GROUP BY
    customers.customer_id
)

SELECT
    customers.customer_id AS customer_id,
    sum(COALESCE(orders.amount, 0)) AS completed_amount
FROM
    customers
LEFT JOIN orders ON
    orders.customer_id = customers.customer_id
WHERE
    orders.status = 'completed'
GROUP BY customers.customer_id



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
    
    
    