-- =========================================================
-- PRODUCT CONVERSION ANALYSIS
-- =========================================================
-- Objective:
-- Identify high-traffic products with low conversion rates.

WITH product_base AS (
    SELECT
        product_id,

        COUNT(DISTINCT CASE
            WHEN event_type = 'view'
            THEN user_id
        END) AS view_users,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase'
            THEN user_id
        END) AS purchase_users

    FROM ecommerce
    GROUP BY product_id
),

product_metrics AS (
    SELECT *,
        purchase_users * 1.0 /
        NULLIF(view_users, 0) AS conversion_rate
    FROM product_base
    WHERE view_users > 10
),

ranked_products AS (
    SELECT *,
        NTILE(10) OVER (
            ORDER BY view_users DESC
        ) AS view_bucket,

        NTILE(10) OVER (
            ORDER BY conversion_rate ASC
        ) AS conversion_bucket

    FROM product_metrics
)

SELECT *
FROM ranked_products
WHERE view_bucket <= 2
  AND conversion_bucket <= 3
ORDER BY view_users DESC;