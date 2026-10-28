# Methodology

This document explains how the RFM scores and customer segments were calculated.

## 1. Snapshot Date

Recency is measured from a fixed reference date: one day after the latest transaction
in the data (9 December 2011, so the snapshot is 10 December 2011). Using a fixed date
means every customer is measured from the same point in time.

## 2. RFM Definitions

| Metric | Definition | Better value |
|---|---|---|
| Recency | Days between the snapshot date and the customer's last purchase | Lower |
| Frequency | Number of distinct invoices per customer | Higher |
| Monetary | Total amount spent per customer | Higher |

## 3. Scoring

Each metric is scored from 1 to 5, where 5 is the best.

**Recency:** scored in reverse, so the most recent buyers receive a 5. Quintiles
(`NTILE(5)`) split customers into five equal groups.

**Frequency:** scored with fixed thresholds. Most customers order only once or twice,
so quintiles would split customers with the same number of orders into different groups.

| Score | Orders |
|---|---|
| 5 | 10 or more |
| 4 | 5 to 9 |
| 3 | 3 to 4 |
| 2 | 2 |
| 1 | 1 |

**Monetary:** quintiles (`NTILE(5)`), where 5 is the highest spend.

## 4. Segment Rules

Segments are assigned by checking the rules in order. The first match wins.

| Order | Segment | Rule |
|---|---|---|
| 1 | Champions | R ≥ 4 and F ≥ 4 |
| 2 | Loyal Customers | R ≥ 3 and F ≥ 3 |
| 3 | Potential Loyalists | R ≥ 4 and F = 2 |
| 4 | New Customers | R ≥ 4 and F = 1 |
| 5 | At Risk | R ≤ 2 and F ≥ 3 |
| 6 | Lost / Hibernating | R ≤ 2 and F ≤ 2 |
| 7 | Needs Attention | R = 3 and F ≤ 2 |

## 5. Limitations

- Thresholds were chosen to suit the distribution of this dataset. They are not
  industry standards.
- Monetary quintiles are relative to this customer base. A customer's score can change
  if the dataset changes.
