-- =========================================
-- CATEGORY ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- Which categories show strongest customer purchase intent?

-- INSIGHT GOAL:
-- Compare category-level engagement and conversion efficiency.


WITH base AS (

SELECT 
    category_id,

    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS category_view_users,

    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS category_purchase_users

FROM ecommerce

GROUP BY category_id

)

SELECT 
    category_id,
    category_view_users,
    category_purchase_users,

    ROUND(
        category_purchase_users * 100.0
        / NULLIF(category_view_users,0),
        2
    ) AS category_conversion_rate

FROM base

ORDER BY category_view_users DESC,
category_purchase_users ASC

LIMIT 10;