-- =========================================================
-- FUNNEL ANALYSIS
-- =========================================================
-- Objective:
-- Analyze user and session conversion across
-- View → Cart → Purchase funnel.

WITH base AS (
    SELECT
        COUNT(DISTINCT CASE
            WHEN event_type = 'view'
            THEN user_id
        END) AS view_users,

        COUNT(DISTINCT CASE
            WHEN event_type = 'cart'
            THEN user_id
        END) AS cart_users,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase'
            THEN user_id
        END) AS purchase_users
    FROM ecommerce
)

SELECT *,
    cart_users * 100.0 / view_users AS view_to_cart_conversion,
    purchase_users * 100.0 / cart_users AS cart_to_purchase_conversion,
    purchase_users * 100.0 / view_users AS overall_conversion
FROM base;



-- =========================================================
-- SESSION LEVEL FUNNEL
-- =========================================================

WITH base AS (
    SELECT
        COUNT(DISTINCT CASE
            WHEN event_type = 'view'
            THEN user_session
        END) AS viewed_sessions,

        COUNT(DISTINCT CASE
            WHEN event_type = 'cart'
            THEN user_session
        END) AS cart_sessions,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase'
            THEN user_session
        END) AS purchased_sessions
    FROM ecommerce
)

SELECT *,
    cart_sessions * 100.0 / viewed_sessions AS cart_conversion_rate,
    purchased_sessions * 100.0 / cart_sessions AS purchase_conversion_rate,
    purchased_sessions * 100.0 / viewed_sessions AS full_conversion_rate
FROM base;



-- =========================================================
-- FULL FUNNEL SESSIONS
-- =========================================================

WITH session_flags AS (
    SELECT
        user_session,

        MAX(CASE
            WHEN event_type = 'view'
            THEN 1 ELSE 0
        END) AS viewed,

        MAX(CASE
            WHEN event_type = 'cart'
            THEN 1 ELSE 0
        END) AS carted,

        MAX(CASE
            WHEN event_type = 'purchase'
            THEN 1 ELSE 0
        END) AS purchased

    FROM ecommerce
    GROUP BY user_session
)

SELECT
    COUNT(*) AS full_funnel_sessions
FROM session_flags
WHERE viewed = 1
  AND carted = 1
  AND purchased = 1;