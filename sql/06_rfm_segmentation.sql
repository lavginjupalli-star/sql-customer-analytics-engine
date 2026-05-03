WITH payments AS (
    SELECT order_id, SUM(payment_value) AS revenue
    FROM order_payments
    GROUP BY order_id
),

base AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS frequency,
        SUM(p.revenue) AS monetary,
        MAX(o.order_purchase_timestamp) AS last_purchase
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
),

rfm AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY last_purchase ASC) AS recency_score,
           NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
           NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM base
)

SELECT *,
CASE 
    WHEN frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
    WHEN frequency_score >= 3 THEN 'Loyal Customers'
    WHEN recency_score <= 2 THEN 'At Risk'
    ELSE 'Others'
END AS segment
FROM rfm;