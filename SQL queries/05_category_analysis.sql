-- =========================================================
-- CATEGORY CONVERSION ANALYSIS
-- =========================================================
-- Objective:
-- Analyze category-level conversion performance.

WITH base AS (
    SELECT
        category_id,

        COUNT(DISTINCT CASE
            WHEN event_type = 'view'
            THEN user_id
        END) AS viewed_users,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase'
            THEN user_id
        END) AS purchased_users

    FROM ecommerce
    GROUP BY category_id
)

SELECT
    category_id,
    viewed_users,
    purchased_users,

    purchased_users * 100.0 /
    NULLIF(viewed_users, 0) AS conversion_rate

FROM base
ORDER BY viewed_users DESC,
         purchased_users ASC
LIMIT 10;