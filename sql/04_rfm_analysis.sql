-- RFM Analysis

-- Builds one row per customer with raw Recency, Frequency, and Monetary values.

-- Recency  = days since last purchase, measured from a snapshot date
--            (one day after the latest transaction in the data)
-- Frequency = number of distinct invoices
-- Monetary  = total amount spent

DROP TABLE IF EXISTS customer_rfm;

CREATE TABLE customer_rfm AS
WITH snapshot AS (
    SELECT (MAX(invoice_date)::date + 1) AS snapshot_date
    FROM online_retail_clean
)
SELECT
    c.customer_id,
    (s.snapshot_date - MAX(c.invoice_date)::date) AS recency_days,
    COUNT(DISTINCT c.invoice_no)                  AS frequency,
    ROUND(SUM(c.total_amount), 2)                 AS monetary
FROM online_retail_clean AS c
CROSS JOIN snapshot AS s
GROUP BY c.customer_id, s.snapshot_date;

-- Preview: top 10 customers by spend
SELECT * FROM customer_rfm
ORDER BY monetary DESC
LIMIT 10;

-- Check: number of customers should match the clean table
SELECT COUNT(*) AS rfm_customers
FROM customer_rfm;

