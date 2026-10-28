# Customer Segmentation and RFM Analysis

An end-to-end customer analysis of a UK online retail dataset with 541,909 transactions.
The project cleans the raw data with PostgreSQL, scores customers using RFM
(Recency, Frequency, Monetary) analysis, and presents the results in an interactive
Power BI dashboard.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Tools Used](#tools-used)
- [Project Structure](#project-structure)
- [Methodology](#methodology)
- [How to Run the Project](#how-to-run-the-project)
- [Dashboard](#dashboard)
- [Key Findings](#key-findings)
- [Limitations](#limitations)
- [Author](#author)

---

## Project Overview

Businesses earn most of their revenue from a small share of customers. This project
identifies which customers are most valuable, which are at risk of leaving, and
which can be encouraged to buy again.

The project answers these questions:

- Which customers are our champions, and how much revenue do they generate?
- Which customers have stopped buying, and how long have they been inactive?
- Which products and countries drive the most sales?
- How has revenue changed over time?

---

## Dataset

| Item | Details |
|---|---|
| **Source** | [UCI Machine Learning Repository: Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail) |
| **Rows** | 541,909 |
| **Columns** | 8 (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) |
| **Period** | December 2010 to December 2011 |
| **Business type** | UK-based online retailer selling gift items, many to wholesale customers |
| **Encoding** | LATIN1 |

The raw CSV is not stored in this repository because of its size and licensing.
See [`data/raw/README.md`](data/raw/README.md) for download instructions.

---

## Tools Used

- **PostgreSQL**: data loading, cleaning, RFM calculation, and segmentation
- **SQL**: all transformations and business queries
- **Power BI Desktop**: interactive dashboard with four report pages
- **Git and GitHub**: version control and project hosting

---

## Project Structure

```
customer-segmentation-rfm/
├── data/
│   ├── raw/                  # Original dataset (not committed)
│   └── processed/            # Exported CSVs used by Power BI
├── sql/                      # SQL scripts, run in numeric order
│   ├── 01_create_raw_table_and_load_data.sql
│   ├── ...
│   └── 08_business_analysis.sql
├── powerbi/
│   ├── customer_segmentation.pbix
│   └── screenshots/
├── docs/
│   ├── data_cleaning_log.md
│   ├── methodology.md
    └── key_insights.md
```

---

## Methodology

### 1. Data Cleaning

The following rules were applied to create the clean table. The raw table was not changed.

| Rule | Reason |
|---|---|
| Removed rows with no CustomerID | RFM requires a customer |
| Removed cancelled invoices (InvoiceNo starts with C) | Cancellations reverse earlier sales |
| Removed returns (Quantity ≤ 0) | Returns are not purchases |
| Removed zero or negative prices | Adjustments and free items are not sales |
| Kept only product stock codes (contain a digit) | Removes postage, fees, and manual entries |
| Removed exact duplicate rows | Prevents double counting |

See [`docs/data_cleaning_log.md`](docs/data_cleaning_log.md) for row counts at each step.

### 2. RFM Definitions

| Metric | Definition | Better value |
|---|---|---|
| **Recency** | Days since last purchase, measured from one day after the latest transaction | Lower |
| **Frequency** | Number of distinct invoices | Higher |
| **Monetary** | Total amount spent | Higher |

### 3. Scoring

Each metric is scored from 1 to 5, where 5 is the best. Recency is scored in reverse
so that recent buyers receive high scores. Frequency uses fixed thresholds because
most customers have only one or two orders, and quintile scoring would split
identical values into different groups.

### 4. Segments

| Segment | Rule | Suggested action |
|---|---|---|
| Champions | R ≥ 4 and F ≥ 4 | Reward and ask for reviews |
| Loyal Customers | R ≥ 3 and F ≥ 3 | Upsell and loyalty offers |
| Potential Loyalists | R ≥ 4 and F = 2 | Encourage a second purchase |
| New Customers | R ≥ 4 and F = 1 | Welcome and onboarding offers |
| At Risk | R ≤ 2 and F ≥ 3 | Re-engagement campaigns |
| Lost / Hibernating | R ≤ 2 and F ≤ 2 | Low-cost win-back or stop spending |
| Needs Attention | R = 3 and F ≤ 2 | Targeted offers to move up |

---

## How to Run the Project

### Requirements
- PostgreSQL 13 or later
- psql (command-line client)
- Power BI Desktop (for the dashboard)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/[your-username]/customer-segmentation-rfm.git
   cd customer-segmentation-rfm
   ```

2. **Download the dataset** from the link above and save it as
   `data/raw/online_retail.csv`.

3. **Run the SQL pipeline** from the project root folder:
   ```bash
   psql -d your_database -f sql/00_run_all.sql
   ```

4. **Open the dashboard** by double-clicking `powerbi/customer_segmentation.pbix`
   in Power BI Desktop.

   If the data source path is different on your computer, go to
   **Home → Transform data → Data source settings** and update the connection.

---

## Dashboard

The Power BI report has four pages:

| Page | Purpose |
|---|---|
| **Executive_Overview** | KPIs, monthly revenue and orders, revenue by country |
| **RFM_Segmentation** | Customers and revenue per segment, segment summary table, recency vs monetary |
| **Product_Analysis** | Top 10 products by revenue, Pareto chart of revenue concentration, units sold |
| **Customer_Detail** | Customer-level table with RFM scores, filterable by segment and country |

![Dashboard preview](images/dashboard_preview.png)

---

## Key Findings

- **Champions are the most valuable group.** They make up 26% of customers (1,109 of 4,334)
  but generate about 66% of total revenue. Their average recency is about 13 days, and their
  average frequency is about 10 orders.
- **At Risk customers need attention.** There are 657 At Risk customers (15% of the total).
  Their average recency is about 149 days, so most have not bought in months, even though
  they averaged about 3.4 orders each. This is a large group with significant past value.
- **Loyal Customers form the second tier.** There are 834 of them (19%), and they generate
  roughly 16% of revenue. They are the best group to target with upselling and loyalty offers.
- **Many customers buy only once.** The repeat customer rate is 65%, so about one third of
  customers never return after their first order. Improving the second purchase is the
  biggest opportunity for growth.
- **The United Kingdom dominates sales.** It generates about £7.2M of the £8.74M total,
  roughly 82% of revenue. The Netherlands, Ireland, and Germany are the next largest markets,
  but each contributes well under 5%.
- **Revenue peaks in November.** Monthly revenue is highest in November 2011, which matches
  the pre-holiday gift-buying season. The December 2011 figure is incomplete because the data
  ends on 9 December.
- **Revenue is concentrated in a few products.** The top product earns about £168K, but this
  is inflated by one bulk order of 80,995 units. The top 20 products generate
  [X]% of total revenue according to the Pareto chart.

See [`docs/key_insights.md`](docs/key_insights.md) for recommended actions for each segment.

---

## Limitations

- The dataset covers about one year, so seasonal patterns are based on a single cycle.
- The data ends on 9 December 2011, so December 2011 is a partial month.
- One very large bulk order (80,995 units) is retained in the data. It is documented
  in `docs/data_cleaning_log.md`.
- CustomerIDs were missing for about 25% of rows, which were removed. Customer-level
  results therefore describe only identified customers.
- Power BI reads from a local PostgreSQL database, so the dashboard must be refreshed
  manually after the SQL pipeline is rerun.

---

## Author

**[ Sunidhi Jangid ]**
Data Analyst | [ www.linkedin.com/in/sunidhi-jangid-625318297 ] | [ jangidsunidhi82@gmail.com ]


