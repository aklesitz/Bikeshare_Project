-- Percentages of subscribers vs customers
WITH bluebikes_all AS (
	SELECT *
	FROM bluebikes_2016
	UNION ALL
	SELECT *
	FROM bluebikes_2017
	UNION ALL
	SELECT *
	FROM bluebikes_2018
	UNION ALL
	SELECT *
	FROM bluebikes_2019
),
ride_totals AS (
	SELECT COUNT(*) AS total_rides
	FROM bluebikes_all
)
SELECT user_type,
	COUNT(*),
	COUNT(*) * 100 / rt.total_rides AS percentage
FROM bluebikes_all,
	ride_totals rt
GROUP BY user_type, rt.total_rides;

-- Finding the average length of a bluebikes ride for both customers and subscribers
WITH bluebikes_all AS (
	SELECT *
	FROM bluebikes_2016
	UNION ALL
	SELECT *
	FROM bluebikes_2017
	UNION ALL
	SELECT *
	FROM bluebikes_2018
	UNION ALL
	SELECT *
	FROM bluebikes_2019
)
SELECT 
	ROUND(
        AVG(CASE WHEN user_type ILIKE 'subscriber' THEN EXTRACT(EPOCH FROM (end_time - start_time))/60 END)::numeric, 
        2
    ) AS subscriber_duration,
	ROUND(
        AVG(CASE WHEN user_type ILIKE 'customer' THEN EXTRACT(EPOCH FROM (end_time - start_time))/60 END)::numeric, 
        2
    ) AS customer_duration
FROM bluebikes_all
WHERE
	end_time - start_time < interval '5 hours'
	AND end_time - start_time > interval '5 minute';

-- Rides under 45 min (demographic of local commuters who are not signed up for subscriptions)
WITH bluebikes_all AS (
	SELECT *
	FROM bluebikes_2016
	UNION ALL
	SELECT *
	FROM bluebikes_2017
	UNION ALL
	SELECT *
	FROM bluebikes_2018
	UNION ALL
	SELECT *
	FROM bluebikes_2019
)
SELECT *
FROM bluebikes_all
WHERE end_time - start_time < interval '45 minutes'
AND end_time - start_time > interval '1 minutes'
AND user_type ilike 'customer';