-- =========================================
-- CART ABANDONMENT ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- How severe is cart abandonment behavior?

-- INSIGHT GOAL:
-- Identify users removing products before checkout
-- and estimate purchase recovery opportunities.


-- Remove From Cart Rate
WITH base AS (

SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'remove_from_cart' THEN user_id END) AS removed_users,

    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) AS cart_users

FROM ecommerce

)

SELECT *,
    ROUND(removed_users * 100.0 / cart_users,2) AS remove_from_cart_rate

FROM base;


-- Users Who Removed Products But Still Purchased
SELECT COUNT(DISTINCT user_id) AS removed_but_purchased_users

FROM ecommerce

WHERE user_id IN (
    SELECT user_id
    FROM ecommerce
    WHERE event_type = 'remove_from_cart'
)

AND user_id IN (
    SELECT user_id
    FROM ecommerce
    WHERE event_type = 'purchase'
);