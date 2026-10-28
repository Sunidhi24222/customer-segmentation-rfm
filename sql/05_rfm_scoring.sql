-- RFM Scoring

-- Scores each customer from 1 to 5 on Recency, Frequency, and Monetary
-- using quintiles (NTILE). 5 is always the best score.
-- Recency is reversed: fewer days since purchase = higher score.

SELECT
    percentile_cont(ARRAY[0.2, 0.4, 0.6, 0.8]) WITHIN GROUP (ORDER BY recency_days) AS recency_cutoffs,
    percentile_cont(ARRAY[0.2, 0.4, 0.6, 0.8]) WITHIN GROUP (ORDER BY frequency)    AS frequency_cutoffs,
    percentile_cont(ARRAY[0.2, 0.4, 0.6, 0.8]) WITHIN GROUP (ORDER BY monetary)     AS monetary_cutoffs
FROM customer_rfm;

DROP TABLE IF EXISTS customer_rfm_scored;

CREATE TABLE customer_rfm_scored AS
SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,  -- most recent = 5
    NTILE(5) OVER (ORDER BY frequency ASC)     AS f_score,  -- most orders = 5
    NTILE(5) OVER (ORDER BY monetary ASC)      AS m_score   -- highest spend = 5
FROM customer_rfm;

-- Check: score distribution (each score should have roughly 20% of customers)
SELECT r_score, COUNT(*) AS customers
FROM customer_rfm_scored
GROUP BY r_score
ORDER BY r_score;

