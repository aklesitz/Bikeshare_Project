-- Creating temporary table for EDA
CREATE TEMPORARY TABLE bluebikes_all AS
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
	FROM bluebikes_2019;
	
-- Finding average subscriber ride duration with outliers excluded

-- Creating temporary table for subscribers duration
-- Formatting duration in minutes rounded to 2 decimal places
-- There were a few rides with negative duration, which are obviously errors
-- Filtering out those with WHERE statement end_time > start_time
CREATE TEMPORARY TABLE sub_duration AS 
	SELECT 
		ROUND((EXTRACT(EPOCH FROM end_time - start_time) / 60), 2) AS duration,
		ride_id
	FROM bluebikes_all
	WHERE user_type ilike 'subscriber'
	AND end_time > start_time;

-- Finding median value
CREATE TEMPORARY TABLE sub_median_value AS 
	SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS median
	FROM sub_duration;

-- Finding lower quartile to identify outliers
CREATE TEMPORARY TABLE sub_first_quartile AS
WITH lower_half AS (
	SELECT *
	FROM sub_duration, sub_median_value
	WHERE duration < median
)
SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS Q1
FROM lower_half;

-- Finding upper quartile
CREATE TEMPORARY TABLE sub_third_quartile AS
WITH upper_half AS (
	SELECT *
	FROM sub_duration, sub_median_value
	WHERE duration > median
)
SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS Q3
FROM upper_half;

-- These are the quartiles for my dataset
-- First quartile = 6.25 minutes
-- Median = 10.06 minutes
-- Third quartile = 16.07 minutes
SELECT
	l.* AS Q1,
	m.* AS median,
	u.* AS Q3
FROM 
	sub_first_quartile l,
	sub_median_value m,
	sub_third_quartile u;

-- With the interquartile range as the difference of the third quartile and first quartile,
-- And outliers identified as 1.5 * the IQR above or below the first or third quartile,
-- I have created a temporary table identifying outliers in the subscriber duration dataset
CREATE TEMPORARY TABLE sub_outliers AS
WITH IQR AS (
	SELECT Q3 - Q1 AS iqr
	FROM sub_third_quartile, sub_first_quartile
)
SELECT duration
FROM sub_duration, IQR, sub_first_quartile, sub_third_quartile
WHERE duration > ((SELECT iqr FROM IQR) * 1.5 + Q3)
OR duration < (Q1 - ((SELECT iqr FROM IQR) * 1.5));

-- Finding average subscriber ride duration excluding identified outliers
SELECT ROUND(AVG(duration), 2) AS subscriber_avg_duration
FROM sub_duration
WHERE duration NOT IN (SELECT * FROM sub_outliers);

-- The average ride time for subscribers (excluding outliers) is 11.23 minutes

-- All subscriber rides with demographic data added
-- Duration outliers removed
WITH sub_outlier_removed AS (
	SELECT ride_id
	FROM sub_duration 
	WHERE duration NOT IN (SELECT * FROM sub_outliers)
)
SELECT *
FROM bluebikes_all
RIGHT JOIN sub_outlier_removed
USING(ride_id);


-- Now to do the same for the customer data

CREATE TEMPORARY TABLE cust_duration AS 
	SELECT ROUND((EXTRACT(EPOCH FROM end_time - start_time) / 60), 2) AS duration
	FROM bluebikes_all
	WHERE user_type ilike 'customer'
	AND end_time > start_time;
	
-- Finding median value
CREATE TEMPORARY TABLE cust_median_value AS 
	SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS median
	FROM cust_duration;
	
-- Finding lower quartile to identify outliers
CREATE TEMPORARY TABLE cust_first_quartile AS
WITH lower_half AS (
	SELECT *
	FROM cust_duration, cust_median_value
	WHERE duration < median
)
SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS Q1
FROM lower_half;

-- Finding upper quartile
CREATE TEMPORARY TABLE cust_third_quartile AS
WITH upper_half AS (
	SELECT *
	FROM cust_duration, cust_median_value
	WHERE duration > median
)
SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration) AS Q3
FROM upper_half;

-- These are the quartiles for my dataset
-- First quartile = 7.12 minutes
-- Median = 21.21 minutes
-- Third quartile = 24.7 minutes
SELECT
	l.* AS Q1,
	m.* AS median,
	u.* AS Q3
FROM 
	cust_first_quartile l,
	cust_median_value m,
	cust_third_quartile u;

-- With the interquartile range as the difference of the third quartile and first quartile,
-- And outliers identified as 1.5 * the IQR above or below the first or third quartile,
-- I have created a temporary table identifying outliers in the subscriber duration dataset
CREATE TEMPORARY TABLE cust_outliers AS
WITH IQR AS (
	SELECT Q3 - Q1 AS iqr
	FROM cust_third_quartile, cust_first_quartile
)
SELECT duration
FROM cust_duration, IQR, cust_first_quartile, cust_third_quartile
WHERE duration > ((SELECT iqr FROM IQR) * 1.5 + Q3)
OR duration < (Q1 - ((SELECT iqr FROM IQR) * 1.5));

-- Finding average subscriber ride duration excluding identified outliers
SELECT ROUND(AVG(duration), 2) AS customer_avg_duration
FROM cust_duration
WHERE duration NOT IN (SELECT * FROM cust_outliers);

-- The average ride time for customers (excluding outliers) is 20.21 minutes

-- All customer rides with demographic data added
-- Duration outliers removed
WITH cust_outlier_removed AS (
	SELECT ride_id
	FROM cust_duration 
	WHERE duration NOT IN (SELECT * FROM cust_outliers)
)
SELECT *
FROM bluebikes_all
RIGHT JOIN cust_outlier_removed
USING(ride_id);