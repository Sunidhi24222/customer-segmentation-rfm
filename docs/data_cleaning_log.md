# Data Cleaning Log

This log records how the raw data was reduced to the clean dataset used for analysis.
The raw table (`retail.online_retail_raw`) was never modified. All cleaning happens when
building `retail.online_retail_clean`.

| Step | Rule | Rows removed | Rows remaining |
|---|---|---|---|
| 0 | Raw data loaded from `online_retail.csv` | 0 | 541,909 |
| 1 | Removed rows with no CustomerID | 135,080 | 406,829 |
| 2 | Removed cancelled invoices (InvoiceNo starts with C) | 
| 3 | Removed returns (Quantity ≤ 0) | 
| 4 | Removed zero or negative prices |
| 5 | Removed non-product stock codes (no digits) | 
| 6 | Removed exact duplicate rows | 
| Final | Clean table `online_retail_clean` | 



