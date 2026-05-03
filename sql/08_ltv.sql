WITH payments AS (SELECT order_id,SUM(payment_value) revenue FROM order_payments GROUP BY order_id)
SELECT c.customer_unique_id,
SUM(revenue) ltv
FROM orders o JOIN customers c USING(customer_id)
JOIN payments p USING(order_id)
GROUP BY c.customer_unique_id;
