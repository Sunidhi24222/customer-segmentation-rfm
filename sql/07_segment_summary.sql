-- Segment Summary

-- Summarizes each segment. This is the main table for the Power BI dashboard.

SELECT
    segment,
    COUNT(*)                                                       AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)             AS customer_pct,
    ROUND(AVG(recency_days), 0)                                    AS avg_recency_days,
    ROUND(AVG(frequency), 1)                                       AS avg_frequency,
    ROUND(AVG(monetary), 2)                                        AS avg_monetary,
    ROUND(SUM(monetary), 2)                                        AS total_revenue,
    ROUND(100.0 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 2)   AS revenue_pct
FROM customer_segments
GROUP BY segment
ORDER BY total_revenue DESC;