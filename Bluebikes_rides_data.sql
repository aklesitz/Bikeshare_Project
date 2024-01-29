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

-- Finding and creating dataset for the demographic of customers rides under 45 minutes
-- Joining lat and long for creation of origin-destination map
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
	bike_id,
	start_time,
	end_time,
	start_station_id,
	s.latitude as starting_lat,
	s.longitude as starting_long,
	end_station_id,
	e.latitude as ending_lat,
	e.longitude as ending_long,
	user_type,
	 	CASE
        WHEN user_birth_year ~ E'^\\d+\\.0$' THEN TRUNC(CAST(user_birth_year AS numeric))
        WHEN user_birth_year ~ E'^\\d+$' THEN CAST(user_birth_year AS numeric)
        ELSE 0
    END AS user_birth_year,
	user_gender
FROM bluebikes_all a
JOIN bluebikes_stations s
	ON a.start_station_id = s.id
JOIN bluebikes_stations e
	ON a.end_station_id = e.id
WHERE end_time - start_time < interval '45 minutes'
AND end_time - start_time > interval '1 minutes'
AND user_type ilike 'customer';

-- Finding and creating dataset for the demographic of subscribers with rides under 45 minutes
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
	bike_id,
	start_time,
	end_time,
	start_station_id,
	s.latitude as starting_lat,
	s.longitude as starting_long,
	end_station_id,
	e.latitude as ending_lat,
	e.longitude as ending_long,
	user_type,
	 	CASE
        WHEN user_birth_year ~ E'^\\d+\\.0$' THEN TRUNC(CAST(user_birth_year AS numeric))
        WHEN user_birth_year ~ E'^\\d+$' THEN CAST(user_birth_year AS numeric)
        ELSE 0
    END AS user_birth_year,
	user_gender
FROM bluebikes_all a
JOIN bluebikes_stations s
	ON a.start_station_id = s.id
JOIN bluebikes_stations e
	ON a.end_station_id = e.id
WHERE end_time - start_time < interval '45 minutes'
AND end_time - start_time > interval '1 minutes'
AND user_type ilike 'subscriber';