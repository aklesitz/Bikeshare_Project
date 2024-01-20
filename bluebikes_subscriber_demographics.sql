SELECT
	2019 - user_birth_year AS user_age,
	COUNT(*) AS rides
FROM bluebikes_subscribers
GROUP BY user_age;