-- Finding percentage of subscribers vs customers across total dataset
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
	COUNT(*) AS total_rides,
	COUNT(*) * 100 / rt.total_rides AS percentage
FROM bluebikes_all,
	ride_totals rt
GROUP BY user_type, rt.total_rides;

