-- Number of users from each birth year across all years of data
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
SELECT user_birth_year::numeric AS birth_year,  -- user_birth_year for 2018 has some trailing .0's for some years
	COUNT(*) AS riders		-- casting to numeric takes care of them
FROM bluebikes_all
GROUP BY birth_year
ORDER BY birth_year;

-- Count and percentage of riders "over 75" or birth year not reported
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
ride_total AS (
	SELECT COUNT(*) as total_rides
	FROM bluebikes_all
)
SELECT CASE
	WHEN user_birth_year::numeric < 1948
	OR user_birth_year is null THEN 'unreliable_data'
	ELSE 'demographic_data' END AS data_viability,
	COUNT(*) AS total,
	ROUND(COUNT(*) * 100.0 / rt.total_rides, 2) AS percentage
FROM bluebikes_all,
	ride_total rt
GROUP BY 1, rt.total_rides

-- Removing unreliable data from first query for visualization
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
SELECT (2023 - user_birth_year::numeric) AS rider_age,   
	COUNT(*) AS riders
FROM bluebikes_all
WHERE user_birth_year::numeric > 1948
AND user_birth_year is not null
GROUP BY rider_age
ORDER BY rider_age;

-- Finding makeup of self-reported gender among all riders
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
SELECT 
	CASE
		WHEN user_gender = 1 THEN 'Male'
		WHEN user_gender = 2 THEN 'Female'
		WHEN user_gender = 0 THEN 'Unknown'
	END AS Gender,
	COUNT(*) AS ride_count,
	ROUND(COUNT(*) * 100.0 / rt.total_rides, 2) AS percentage
FROM bluebikes_all,
	ride_totals rt
GROUP BY user_gender, rt.total_rides;
