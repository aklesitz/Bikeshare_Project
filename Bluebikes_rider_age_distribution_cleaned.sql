-- Finding average amount of riders for user_birth_year = 1969
-- Taking average of 6 year span surrounding 1969
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
total_riders AS(
	SELECT 
		user_birth_year::numeric AS birth_year,
		COUNT(*) AS riders
	FROM bluebikes_all
	WHERE user_birth_year::numeric >= 1966
	AND user_birth_year::numeric <= 1972
	AND user_birth_year::numeric != 1969
	GROUP BY birth_year
	ORDER BY birth_year
)
SELECT ROUND(AVG(riders), 0)
FROM total_riders;

-- Remaking visualization
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
SELECT (2019 - user_birth_year::numeric) AS rider_age,
	CASE
		WHEN (2019 - user_birth_year::numeric) = 50 THEN 56825
		ELSE COUNT(*)
	END AS riders
FROM bluebikes_all
WHERE user_birth_year::numeric > 1944
AND user_birth_year is not null
GROUP BY rider_age
ORDER BY rider_age;