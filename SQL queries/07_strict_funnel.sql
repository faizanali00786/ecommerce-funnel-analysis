-- =========================================
-- STRICT FUNNEL VALIDATION
-- =========================================

-- BUSINESS QUESTION:
-- How many sessions follow the correct sequential funnel flow?

-- INSIGHT GOAL:
-- Validate true conversion paths:
-- view → cart → purchase.


WITH base AS (

SELECT 
    user_session,

    MIN(CASE WHEN event_type = 'view' THEN event_time END) AS view_time,

    MIN(CASE WHEN event_type = 'cart' THEN event_time END) AS cart_time,

    MIN(CASE WHEN event_type = 'purchase' THEN event_time END) AS purchase_time

FROM ecommerce

GROUP BY user_session

)

SELECT COUNT(*) AS correct_funnel_sessions

FROM base

WHERE view_time IS NOT NULL
AND cart_time IS NOT NULL
AND purchase_time IS NOT NULL
AND view_time < cart_time
AND cart_time < purchase_time;