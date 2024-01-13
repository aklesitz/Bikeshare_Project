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

-- Plugging in resulting avg (2980) to remake visualization of distribution
SELECT 
	2019 - user_birth_year as user_age, 
	CASE
		WHEN user_birth_year = 1969 THEN 2980
		ELSE COUNT(*)
	END AS riders
FROM bluebikes_customers
WHERE user_birth_year > 0
AND (2019 - user_birth_year) <= 75
GROUP BY user_birth_year
ORDER BY user_age;	