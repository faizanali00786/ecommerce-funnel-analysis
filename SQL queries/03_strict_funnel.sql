-- =========================================================
-- STRICT FUNNEL ANALYSIS
-- =========================================================
-- Objective:
-- Identify sessions completing funnel in correct sequence:
-- View → Cart → Purchase

WITH base AS (
    SELECT
        user_session,

        MIN(CASE
            WHEN event_type = 'view'
            THEN event_time
        END) AS view_time,

        MIN(CASE
            WHEN event_type = 'cart'
            THEN event_time
        END) AS cart_time,

        MIN(CASE
            WHEN event_type = 'purchase'
            THEN event_time
        END) AS purchase_time

    FROM ecommerce
    GROUP BY user_session
)

SELECT
    COUNT(*) AS correct_funnel_sessions
FROM base
WHERE view_time IS NOT NULL
  AND cart_time IS NOT NULL
  AND purchase_time IS NOT NULL
  AND view_time < cart_time
  AND cart_time < purchase_time;



-- =========================================================
-- STRICT FUNNEL CONVERSION RATES
-- =========================================================

WITH session_times AS (
    SELECT
        user_session,

        MIN(CASE
            WHEN event_type = 'view'
            THEN event_time
        END) AS view_time,

        MIN(CASE
            WHEN event_type = 'cart'
            THEN event_time
        END) AS cart_time,

        MIN(CASE
            WHEN event_type = 'purchase'
            THEN event_time
        END) AS purchase_time

    FROM ecommerce
    GROUP BY user_session
)

SELECT

    COUNT(CASE
        WHEN view_time IS NOT NULL
        THEN 1
    END) AS view_sessions,

    COUNT(CASE
        WHEN view_time < cart_time
        THEN 1
    END) AS view_to_cart_sessions,

    COUNT(CASE
        WHEN view_time < cart_time
         AND cart_time < purchase_time
        THEN 1
    END) AS full_funnel_sessions,

    COUNT(CASE
        WHEN view_time < cart_time
        THEN 1
    END) * 100.0
    /
    NULLIF(
        COUNT(CASE
            WHEN view_time IS NOT NULL
            THEN 1
        END),
        0
    ) AS view_to_cart_conversion,

    COUNT(CASE
        WHEN view_time < cart_time
         AND cart_time < purchase_time
        THEN 1
    END) * 100.0
    /
    NULLIF(
        COUNT(CASE
            WHEN view_time < cart_time
            THEN 1
        END),
        0
    ) AS cart_to_purchase_conversion

FROM session_times;