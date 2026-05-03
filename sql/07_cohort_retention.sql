WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        MIN(strftime('%Y-%m', o.order_purchase_timestamp)) AS cohort_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

orders_monthly AS (
    SELECT 
        c.customer_unique_id,
        fp.cohort_month,
        strftime('%Y-%m', o.order_purchase_timestamp) AS order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN first_purchase fp ON c.customer_unique_id = fp.customer_unique_id
),

cohort_calc AS (
    SELECT *,
        (CAST(substr(order_month,1,4) AS INT) - CAST(substr(cohort_month,1,4) AS INT)) * 12 +
        (CAST(substr(order_month,6,2) AS INT) - CAST(substr(cohort_month,6,2) AS INT)) AS period_number
    FROM orders_monthly
),

cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS total_customers
    FROM first_purchase
    GROUP BY cohort_month
)

SELECT 
    c.cohort_month,
    c.period_number,
    COUNT(DISTINCT c.customer_unique_id) * 1.0 / s.total_customers AS retention_rate
FROM cohort_calc c
JOIN cohort_size s ON c.cohort_month = s.cohort_month
GROUP BY c.cohort_month, c.period_number;