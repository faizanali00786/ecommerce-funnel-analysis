-- =========================================
-- SESSION ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- How efficiently do sessions move through the funnel?

-- INSIGHT GOAL:
-- Evaluate session-level conversion performance.


WITH base AS (

SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_session END) AS viewed_sessions,

    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_session END) AS cart_sessions,

    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) AS purchased_sessions

FROM ecommerce

)

SELECT *,

    ROUND(cart_sessions * 100.0 / viewed_sessions,2)
    AS session_view_to_cart_conversion,

    ROUND(purchased_sessions * 100.0 / cart_sessions,2)
    AS session_cart_to_purchase_conversion,

    ROUND(purchased_sessions * 100.0 / viewed_sessions,2)
    AS overall_session_conversion

FROM base;