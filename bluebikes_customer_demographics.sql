-- Cleaning bluebikes customers table for demographics analysis
SELECT 
	2019 - user_birth_year as user_age, 
	COUNT(*) AS riders
FROM bluebikes_customers
WHERE user_birth_year > 0
AND (2019 - user_birth_year) <= 75
GROUP BY user_birth_year
ORDER BY user_age;


-- Finding average of 6 year span surrounding 1969 birth year
SELECT user_birth_year,
	COUNT(*) AS riders
FROM bluebikes_customers
WHERE 
	CASE
		WHEN user_birth_year ilike 'NULL' THEN '0'
		ELSE user_birth_year::numeric >= 1966
		AND user_birth_year::numeric <= 1972
		AND user_birth_year::numeric != 1969
	END
GROUP BY user_birth_year

-- Making visualization of customer's age distribution
SELECT user_birth_year,
	COUNT(*)
FROM bluebikes_customers
WHERE 
	CASE
		WHEN user_birth_year ilike 'NULL' THEN '0'
		ELSE user_birth_year::integer > 1944
	END
GROUP BY user_birth_year