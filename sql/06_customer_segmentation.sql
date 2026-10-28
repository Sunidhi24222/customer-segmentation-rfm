-- Customer Segmentation

-- Combines R, F, and M scores into an RFM code and a named segment.
-- CASE checks rules from top to bottom and stops at the first match, so the order of the rules matters.

DROP TABLE IF EXISTS customer_segments;

CREATE TABLE customer_segments AS
SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score::text || f_score::text || m_score::text) AS rfm_code,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score = 2  THEN 'Potential Loyalists'
        WHEN r_score >= 4 AND f_score = 1  THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost / Hibernating'
        WHEN r_score = 3  AND f_score <= 2 THEN 'Needs Attention'
        ELSE 'Other'
    END AS segment
FROM customer_rfm_scored;

-- Check: customers per segment
SELECT segment, COUNT(*) AS customers
FROM customer_segments
GROUP BY segment
ORDER BY customers DESC;