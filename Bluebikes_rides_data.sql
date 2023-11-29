--Count of rides over 5 hours
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
SELECT COUNT(*)
FROM bluebikes_all
WHERE end_time - start_time > INTERVAL '5 hours';

-- Looking at number of rides in time intervals
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
	CASE
		WHEN end_time - start_time <= INTERVAL '2 minutes' THEN 'Likely Too Short'
		WHEN end_time - start_time > INTERVAL '2 minutes'
			AND end_time - start_time <= INTERVAL '10 minutes' THEN 'Short Ride'
		WHEN end_time - start_time > INTERVAL '10 minutes' 
			AND end_time - start_time <= '45 minutes' THEN 'Regular Ride'
		WHEN end_time - start_time > INTERVAL '45 minutes' 
			AND end_time - start_time <= INTERVAL '5 hours' THEN 'Long Ride'
		WHEN end_time - start_time > INTERVAL '5 hours' THEN 'Likely Too Long'
	END AS ride_category,
	COUNT(*) AS ride_count
FROM bluebikes_all
GROUP BY ride_category
ORDER BY ride_category;

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