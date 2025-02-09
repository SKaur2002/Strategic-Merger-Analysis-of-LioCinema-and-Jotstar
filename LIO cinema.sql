SELECT COUNT(*) AS total_content_items FROM contents;

SELECT COUNT(*) AS total_users FROM subscribers;

SELECT COUNT(*) AS paid_users 
FROM subscribers where subscription_plan = 'VIP' or 'Premium';

SELECT 
    (COUNT(CASE WHEN subscription_plan = 'VIP' or 'Premium' THEN 1 END) * 100.0 / COUNT(*)) AS paid_users_percentage
FROM subscribers;


SELECT COUNT(DISTINCT user_id) AS active_users 
FROM subscribers
WHERE last_active_date >= DATE_SUB(CURDATE(), INTERVAL 405 DAY);


SELECT COUNT(*) AS inactive_users 
FROM subscribers 
WHERE user_id NOT IN (
    SELECT DISTINCT user_id FROM subscribers 
    WHERE last_active_date >= DATE_SUB(CURDATE(), INTERVAL 405 DAY)
);

SELECT 
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM subscribers)) AS inactive_rate 
FROM subscribers 
WHERE user_id NOT IN (
    SELECT DISTINCT user_id FROM subscribers 
    WHERE last_active_date >= DATE_SUB(CURDATE(), INTERVAL 405 DAY)
);

SELECT 
    (COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(*) FROM subscribers)) AS active_rate 
FROM subscribers 
WHERE last_active_date >= DATE_SUB(CURDATE(), INTERVAL 405 DAY);

SELECT SUM(total_watch_time_mins) / 60 AS total_watch_time_hours 
FROM content_consumption;

SELECT 
    (SUM(total_watch_time_mins) / 60.0) / COUNT(DISTINCT user_id) AS avg_watch_time_per_user 
FROM content_consumption ;


SELECT 
    YEAR(subscription_date) AS year,
    MONTH(subscription_date) AS month,
    COUNT(user_id) AS new_users,
    (COUNT(user_id) - LAG(COUNT(user_id), 1, 0) OVER (ORDER BY YEAR(subscription_date), MONTH(subscription_date))) * 100.0 /
    NULLIF(LAG(COUNT(user_id), 1, 0) OVER (ORDER BY YEAR(subscription_date), MONTH(subscription_date)), 0) 
    AS growth_rate 
FROM subscribers 
GROUP BY year, month 
ORDER BY year, month;



SELECT 
    genre, 
    COUNT(content_id) AS total_content_items 
FROM contents 
GROUP BY genre 
ORDER BY total_content_items DESC;



SELECT 
    language, 
    COUNT(content_id) AS language_count 
FROM contents 
GROUP BY language 
ORDER BY language_count DESC;
