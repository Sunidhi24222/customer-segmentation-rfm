-- Buisness analysis

-- Additional business queries 

-- 1. Monthly revenue and orders trend
SELECT
    DATE_TRUNC('month', invoice_date)::date   AS month,
    COUNT(DISTINCT invoice_no)                AS orders,
    ROUND(SUM(total_amount), 2)               AS revenue
FROM online_retail_clean
GROUP BY 1
ORDER BY 1;

-- 2. Revenue and customers by country
SELECT
    country,
    COUNT(DISTINCT customer_id)   AS customers,
    ROUND(SUM(total_amount), 2)    AS revenue
FROM online_retail_clean
GROUP BY country
ORDER BY revenue DESC;

-- 3. Top 10 products by revenue
SELECT
    stock_code,
    MAX(description)              AS product,
    SUM(quantity)                 AS units_sold,
    ROUND(SUM(total_amount), 2)   AS revenue
FROM online_retail_clean
GROUP BY stock_code
ORDER BY revenue DESC
LIMIT 10;

-- 4. Average order value
SELECT
    ROUND(SUM(total_amount) / COUNT(DISTINCT invoice_no), 2) AS avg_order_value
FROM online_retail_clean;

-- 5. Repeat purchase rate (share of customers with 2 or more orders)
SELECT
    ROUND(100.0 * COUNT(*) FILTER (WHERE frequency >= 2) / COUNT(*), 2) AS repeat_rate_pct
FROM customer_rfm;

-- 6. Recency buckets for a histogram
SELECT
    CASE
        WHEN recency_days <= 30  THEN '0-30 days'
        WHEN recency_days <= 90  THEN '31-90 days'
        WHEN recency_days <= 180 THEN '91-180 days'
        ELSE '180+ days'
    END AS recency_bucket,
    COUNT(*) AS customers
FROM customer_rfm
GROUP BY 1
ORDER BY MIN(recency_days);

