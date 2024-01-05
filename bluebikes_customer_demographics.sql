-- Finding age distribution of customers
SELECT 
	2019 - user_birth_year as user_age, 
	COUNT(*) AS riders
FROM bluebikes_customers
WHERE user_birth_year > 0
AND (2019 - user_birth_year) <= 75
GROUP BY user_birth_year
ORDER BY user_age;


-- Finding average of 6 year span surrounding 1969 birth year
SELECT COUNT(*) / 6 AS span_avg
FROM bluebikes_customers
WHERE user_birth_year >= 1966
AND user_birth_year <= 1972
AND user_birth_year::numeric != 1969;

-- Cleaning visualization of customer's age distribution
WITH AgeDistribution AS (
	SELECT 
		2019 - user_birth_year AS user_age,
		COUNT(*) AS riders
	FROM bluebikes_customers
	WHERE 
		user_birth_year > 0
		AND (2019 - user_birth_year) <= 75
	GROUP BY user_birth_year
)
SELECT
	user_age,
	CASE
		WHEN user_age != 50 THEN COUNT(*)
		ELSE AVG(riders) OVER (ORDER BY user_age ROWS BETWEEN 3 PRECEDING AND 2 FOLLOWING)
	END AS riders
FROM AgeDistribution
GROUP BY user_age, riders
ORDER BY user_age;