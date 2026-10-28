-- Feature Engineering 

-- Adds calculated columns and indexes to the cleaned table.

-- Revenue per line item: quantity x unit price
ALTER TABLE online_retail_clean
ADD COLUMN IF NOT EXISTS total_amount NUMERIC(12,2);

UPDATE online_retail_clean
SET total_amount = quantity * unit_price;

-- Index to speed up grouping by customer
CREATE INDEX IF NOT EXISTS idx_clean_customer
ON online_retail_clean (customer_id);

-- Index to speed up date-based queries
CREATE INDEX IF NOT EXISTS idx_clean_invoice_date
ON online_retail_clean (invoice_date);

-- Check: total revenue should match the sum of line items
SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM online_retail_clean;