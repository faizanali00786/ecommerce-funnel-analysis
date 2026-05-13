-- =========================================
-- FUNNEL ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- Where are users dropping off in the ecommerce conversion funnel?

-- INSIGHT GOAL:
-- Measure view-to-cart and cart-to-purchase conversion efficiency.


-- Users Who Viewed Products
SELECT COUNT(DISTINCT user_id) AS users_viewed_products
FROM ecommerce
WHERE event_type = 'view';


-- Users Who Added Products to Cart
SELECT COUNT(DISTINCT user_id) AS users_added_to_cart
FROM ecommerce
WHERE event_type = 'cart';


-- Users Who Purchased
SELECT COUNT(DISTINCT user_id) AS users_purchased
FROM ecommerce
WHERE event_type = 'purchase';


-- Funnel Conversion Rates

WITH base AS (

SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS view_users,

    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) AS cart_users,

    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase_users

FROM ecommerce

)

SELECT *,
    ROUND(cart_users * 100.0 / view_users,2) AS view_to_cart_conversion,
    ROUND(purchase_users * 100.0 / cart_users,2) AS cart_to_purchase_conversion,
    ROUND(purchase_users * 100.0 / view_users,2) AS overall_conversion

FROM base;