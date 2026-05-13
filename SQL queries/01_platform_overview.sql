-- =========================================
-- DATASET OVERVIEW
-- =========================================

-- BUSINESS QUESTION:
-- Understand overall ecommerce platform scale and activity volume.

-- INSIGHT GOAL:
-- Measure total users, sessions, events, purchases, and revenue.


-- Total Users
SELECT COUNT(DISTINCT user_id) AS total_users
FROM ecommerce;

-- Total Sessions
SELECT COUNT(DISTINCT user_session) AS total_sessions
FROM ecommerce;

-- Total Events
SELECT COUNT(*) AS total_events
FROM ecommerce;

-- Total Purchase Events
SELECT COUNT(*) AS total_purchase_events
FROM ecommerce
WHERE event_type = 'purchase';

-- Total Revenue
SELECT ROUND(SUM(price),2) AS total_revenue
FROM ecommerce
WHERE event_type = 'purchase';