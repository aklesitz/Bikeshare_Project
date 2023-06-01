-- Find number of customer and subscriber rides from each station
SELECT DISTINCT(start_station_id),
	SUM(CASE WHEN user_type ilike 'subscriber' THEN 1 ELSE 0 END) as subscriber_rides,
	SUM(CASE WHEN user_type ilike 'customer' THEN 1 ELSE 0 END) as customer_rides
FROM bluebikes_2016
GROUP BY 1
ORDER BY 2 DESC;

-- Combine for all years
WITH all_years AS(
	SELECT start_station_id, user_type
	FROM bluebikes_2016
	UNION ALL
	SELECT start_station_id, user_type
	FROM bluebikes_2017
	UNION ALL
	SELECT start_station_id, user_type
	FROM bluebikes_2018
	UNION ALL
	SELECT start_station_id, user_type
	FROM bluebikes_2019
)

SELECT DISTINCT(start_station_id),
	SUM(CASE WHEN user_type ilike 'subscriber' THEN 1 ELSE 0 END) as subscriber_rides,
	SUM(CASE WHEN user_type ilike 'customer' THEN 1 ELSE 0 END) as customer_rides
FROM all_years
GROUP BY 1
ORDER BY 2 DESC;

-- Working on seperating it out by year
/*
SELECT DISTINCT CAST(start_station_id AS VARCHAR) || '_2016' as station_year,
	SUM(CASE WHEN user_type ilike 'subscriber' THEN 1 ELSE 0 END) as subscriber_rides,
	SUM(CASE WHEN user_type ilike 'customer' THEN 1 ELSE 0 END) as customer_rides
FROM bluebikes_2016
GROUP BY 1
UNION ALL
SELECT DISTINCT(start_station_id),
	SUM(CASE WHEN user_type ilike 'subscriber' THEN 1 ELSE 0 END) as subscriber_rides,
	SUM(CASE WHEN user_type ilike 'customer' THEN 1 ELSE 0 END) as customer_rides
FROM bluebikes_2017
GROUP BY 1
UNION ALL
SELECT DISTINCT(start_station_id),
	SUM(CASE WHEN user_type ilike 'subscriber' THEN 1 ELSE 0 END) as subscriber_rides,
	SUM(CASE WHEN user_type ilike 'customer' THEN 1 ELSE 0 END) as customer_rides
FROM bluebikes_2018
GROUP BY 1
UNION ALL
SELECT DISTINCT(start_station_id),
	SUM(CASE WHEN user_type ilike 'subscriber' THEN 1 ELSE 0 END) as subscriber_rides,
	SUM(CASE WHEN user_type ilike 'customer' THEN 1 ELSE 0 END) as customer_rides
FROM bluebikes_2019
GROUP BY 1
ORDER BY 2 DESC;
*/