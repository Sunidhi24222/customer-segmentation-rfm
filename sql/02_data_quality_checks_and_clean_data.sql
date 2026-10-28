-- Data Quality Checks

-- Missing values per column
SELECT
    SUM(CASE WHEN CustomerID IS NULL OR CustomerID = '' THEN 1 ELSE 0 END) AS missing_customer,
    SUM(CASE WHEN Description IS NULL OR Description = '' THEN 1 ELSE 0 END) AS missing_description,
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS cancelled_rows
FROM online_retail_raw;

-- Negative or zero quantity and price
SELECT
    SUM(CASE WHEN Quantity::int < 0 THEN 1 ELSE 0 END) AS negative_qty,
    SUM(CASE WHEN UnitPrice::numeric <= 0 THEN 1 ELSE 0 END) AS zero_or_negative_price
FROM online_retail_raw;

-- Date range
SELECT MIN(InvoiceDate::timestamp) AS first_date,
       MAX(InvoiceDate::timestamp) AS last_date
FROM online_retail_raw;

-- Non-product stock codes (letters only, no digits)
SELECT StockCode, COUNT(*) AS row_count
FROM online_retail_raw
WHERE StockCode !~ '[0-9]'
GROUP BY StockCode
ORDER BY row_count DESC;

-- Exact duplicate rows
SELECT COUNT(*) - COUNT(DISTINCT (InvoiceNo, StockCode, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)) AS duplicate_rows
FROM online_retail_raw;

-- Create a cleaned table

-- Rules applied:
--   1. Remove rows without a CustomerID (RFM needs a customer)
--   2. Remove cancelled invoices (InvoiceNo starts with 'C')
--   3. Remove returns (Quantity <= 0)
--   4. Remove zero or negative prices (adjustments, free items)
--   5. Keep only product stock codes (codes that contain a digit)
--   6. Remove exact duplicate rows (SELECT DISTINCT)

DROP TABLE IF EXISTS online_retail_clean;

CREATE TABLE online_retail_clean AS
SELECT DISTINCT
    TRIM(InvoiceNo)                          AS invoice_no,
    TRIM(StockCode)                          AS stock_code,
    TRIM(Description)                        AS description,
    Quantity::int                            AS quantity,
    InvoiceDate::timestamp                   AS invoice_date,
    UnitPrice::numeric(10,2)                 AS unit_price,
    CustomerID::numeric::int                 AS customer_id,
    TRIM(Country)                            AS country
FROM online_retail_raw
WHERE CustomerID IS NOT NULL AND CustomerID <> ''   -- RFM needs a customer
  AND InvoiceNo NOT LIKE 'C%'                       -- exclude cancellations
  AND Quantity::int > 0                             -- exclude returns
  AND UnitPrice::numeric > 0                        -- exclude adjustments and free items
  AND StockCode ~ '[0-9]';                          -- keep real products only

-- Check how many rows reamin

SELECT COUNT(*) AS clean_rows,
       COUNT(DISTINCT customer_id) AS unique_customers,
       COUNT(DISTINCT invoice_no) AS unique_invoices
FROM online_retail_clean;









































































