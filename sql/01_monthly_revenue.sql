WITH payments AS (SELECT order_id,SUM(payment_value) revenue FROM order_payments GROUP BY order_id)
SELECT strftime('%Y-%m',order_purchase_timestamp) month,
SUM(revenue) revenue,
LAG(SUM(revenue)) OVER(ORDER BY strftime('%Y-%m',order_purchase_timestamp)) prev
FROM orders o JOIN payments p USING(order_id)
GROUP BY month;
