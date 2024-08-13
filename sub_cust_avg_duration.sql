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
	
-- Identifying and removing outliers for subscriber rides

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

-- Creating new table for subscriber rides with outliers removed
CREATE TABLE sub_outlier_removed AS 
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
	SELECT 
		ROUND((EXTRACT(EPOCH FROM end_time - start_time) / 60), 2) AS duration,
		ride_id
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

-- Creating table for customer ride durations with outliers removed
CREATE TABLE cust_outlier_removed AS
WITH cust_outlier_removed AS (
	SELECT ride_id
	FROM cust_duration 
	WHERE duration NOT IN (SELECT * FROM cust_outliers)
)
SELECT *
FROM bluebikes_all
RIGHT JOIN cust_outlier_removed
USING(ride_id);

-- Finding descriptive statistics for ride durations
-- Both user segments, outliers removed
WITH all_ride_duration AS (
    SELECT
        user_type,
        ROUND(EXTRACT(EPOCH FROM end_time - start_time) / 60, 2) AS duration
    FROM cust_outlier_removed
    UNION ALL
    SELECT
        user_type,
        ROUND(EXTRACT(EPOCH FROM end_time - start_time) / 60, 2) AS duration
    FROM sub_outlier_removed
),
ranked_durations AS (
    SELECT
        user_type,
        duration,
        ROW_NUMBER() OVER (PARTITION BY user_type ORDER BY duration) AS row_num,
        COUNT(*) OVER (PARTITION BY user_type) AS total_count
    FROM all_ride_duration
),
median_value AS (
    SELECT 
        user_type,
        duration AS median
    FROM ranked_durations
    WHERE row_num = (total_count + 1) / 2
),
mean_value AS (
    SELECT 
        user_type, 
        ROUND(AVG(duration), 2) AS mean
    FROM all_ride_duration
    GROUP BY user_type
),
mode_value AS (
    SELECT 
        user_type,
        duration AS mode,
        COUNT(*) AS frequency
    FROM all_ride_duration
    GROUP BY user_type, duration
    ORDER BY user_type, frequency DESC
),
mode_value_ranked AS (
    SELECT
        user_type,
        mode,
        ROW_NUMBER() OVER (PARTITION BY user_type ORDER BY frequency DESC) AS rank
    FROM mode_value
)
-- Pivoting the data
SELECT
    'mean' AS statistic,
    MAX(CASE WHEN user_type ILIKE 'customer' THEN mean END) AS customer,
    MAX(CASE WHEN user_type ILIKE 'subscriber' THEN mean END) AS subscriber
FROM mean_value
UNION ALL
SELECT
    'median' AS statistic,
    MAX(CASE WHEN user_type ILIKE 'customer' THEN median END) AS customer,
    MAX(CASE WHEN user_type ILIKE 'subscriber' THEN median END) AS subscriber
FROM median_value
UNION ALL
SELECT
    'mode' AS statistic,
    MAX(CASE WHEN user_type ILIKE 'customer' THEN mode END) AS customer,
    MAX(CASE WHEN user_type ILIKE 'subscriber' THEN mode END) AS subscriber
FROM mode_value_ranked
WHERE rank = 1;
