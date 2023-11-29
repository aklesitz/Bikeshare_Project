-- Finding number of users from each birth year across all years of data
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
SELECT user_birth_year::numeric AS birth_year,  -- user_birth_years is recorded as text and must be cast to numeric 
	COUNT(*) AS riders
FROM bluebikes_all
GROUP BY birth_year
ORDER BY birth_year;

-- Count of riders "over 75"
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
WHERE round(user_birth_year::numeric, 0) < 1948
OR user_birth_year is null;

-- Finding gender makeup among all riders
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