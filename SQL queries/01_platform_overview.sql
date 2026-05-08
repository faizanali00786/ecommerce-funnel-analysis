-- =========================================================
-- PLATFORM OVERVIEW
-- =========================================================

-- Total Users
SELECT COUNT(DISTINCT user_id) AS total_users
FROM ecommerce;

-- Total Sessions
SELECT COUNT(DISTINCT user_session) AS total_sessions
FROM ecommerce;

-- Total Events
SELECT COUNT(*) AS total_events
FROM ecommerce;

-- Total Purchases
SELECT COUNT(*) AS total_purchases
FROM ecommerce
WHERE event_type = 'purchase';

-- Total Revenue
SELECT SUM(price) AS total_revenue
FROM ecommerce
WHERE event_type = 'purchase';