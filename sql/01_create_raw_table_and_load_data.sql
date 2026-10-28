--- Customer Segmentation and RFM Analysis Project 

-- Create Raw Table

DROP TABLE IF EXISTS online_retail_raw;

CREATE TABLE online_retail_raw (
    InvoiceNo    TEXT,
    StockCode    TEXT,
    Description  TEXT,
    Quantity     TEXT,
    InvoiceDate  TEXT,
    UnitPrice    TEXT,
    CustomerID   TEXT,
    Country      TEXT
);

-- Load data
-- Databases -> Customer_Segmentation_and_RFM_Analysis_Project -> Schemas -> Tables -> right click on online_retail_raw -> Import/Export data -> import file   

--Check the raw count

SELECT COUNT(*) AS raw_rows FROM online_retail_raw;






















