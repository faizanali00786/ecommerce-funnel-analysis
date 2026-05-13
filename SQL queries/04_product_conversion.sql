-- =========================================
-- PRODUCT PERFORMANCE ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- Which products attract traffic but fail to convert?

-- INSIGHT GOAL:
-- Identify high-view low-conversion products
-- and measure SKU-level conversion efficiency.


-- Top Viewed Products
SELECT 
    product_id,
    COUNT(*) AS total_view_events,
    COUNT(DISTINCT user_id) AS unique_viewing_users

FROM ecommerce

WHERE event_type = 'view'

GROUP BY product_id

ORDER BY total_view_events DESC
LIMIT 10;


-- Product-Level Conversion Rates
WITH product_base AS (

SELECT 
    product_id,

    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS unique_viewing_users,

    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS unique_purchasing_users

FROM ecommerce

GROUP BY product_id

)

SELECT
    product_id,
    unique_viewing_users,
    unique_purchasing_users,

    ROUND(
        unique_purchasing_users * 100.0
        / NULLIF(unique_viewing_users,0),
        2
    ) AS product_conversion_rate

FROM product_base

WHERE unique_viewing_users > 0

ORDER BY product_conversion_rate DESC;