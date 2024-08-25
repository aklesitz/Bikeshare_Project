-- Rank routes based off of starting station
CREATE TEMPORARY TABLE customer_ranked AS 
	SELECT
		c.start_station_id,
		s.name AS station_name,
		CONCAT(start_station_id, '_', end_station_id) AS route,
		'Customer' AS user_type,
		ROW_NUMBER() OVER(PARTITION BY start_station_id ORDER BY COUNT(ride_id) DESC) AS rank,
		COUNT(ride_id) AS frequency
	FROM cust_outlier_removed c
	JOIN bluebikes_stations s
		ON c.start_station_id = s.id
	GROUP BY 1, 2, 3;

-- Find top 5 routes from each station
SELECT *
FROM customer_ranked
WHERE rank <= 5;

-- Verify results
WITH cust_top AS (
	SELECT *
	FROM customer_ranked
	WHERE rank <= 5
),
station_routes AS (
	SELECT start_station_id, COUNT(*) AS top_routes
	FROM cust_top
	GROUP BY start_station_id
)
SELECT *
FROM station_routes
WHERE top_routes != 5;

SELECT 
	((COUNT(*) * 5) - (SELECT COUNT(*) FROM customer_ranked WHERE rank <= 5)) AS missing
FROM bluebikes_stations;
-- Missing 55 rows

-- Locate missing records from bluebikes station data
WITH missing_ids AS (
	SELECT *
	FROM bluebikes_stations
	WHERE id NOT IN (SELECT start_station_id FROM customer_ranked)
)
SELECT a.*
FROM cust_outlier_removed a
JOIN missing_ids m
	ON a.start_station_id = m.id
WHERE a.start_station_id IN (SELECT id FROM missing_ids);
-- There are no records of any rides from these 11 stations

-- Find top routes for stations for subscribers
CREATE TEMPORARY TABLE subscriber_ranked AS 
	SELECT
		c.start_station_id,
		s.name AS station_name,
		CONCAT(start_station_id, '_', end_station_id) AS route,
		'Subscriber' AS user_type,
		ROW_NUMBER() OVER(PARTITION BY start_station_id ORDER BY COUNT(ride_id) DESC) AS rank,
		COUNT(ride_id) AS frequency
	FROM sub_outlier_removed c
	JOIN bluebikes_stations s
		ON c.start_station_id = s.id
	GROUP BY 1, 2, 3;
	
SELECT *
FROM subscriber_ranked
WHERE rank <= 5;

-- Verify results
WITH sub_top AS (
	SELECT *
	FROM subscriber_ranked
	WHERE rank <= 5
),
station_routes AS (
	SELECT start_station_id, COUNT(*) AS top_routes
	FROM sub_top
	GROUP BY start_station_id
)
SELECT *
FROM station_routes
WHERE top_routes != 5;
-- One station (station 431), has only 4 ranked routes

SELECT ride_id
FROM sub_outlier_removed
WHERE start_station_id = 431;
-- Looks like there are only 4 recorded subscriber rides from this station

-- Model data for origin-destination map (customers)
WITH cust_top_routes AS (
	SELECT * FROM customer_ranked WHERE rank <= 5
)
SELECT
	'Origin' AS orig_dest,
	r.start_station_id AS station,
	s.name AS station_name,
	CONCAT(start_station_id, '_', end_station_id) AS path_id,
	s.latitude,
	s.longitude
FROM cust_outlier_removed r
JOIN bluebikes_stations s
	ON r.start_station_id = s.id
WHERE CONCAT(start_station_id, '_', end_station_id) IN (SELECT route FROM cust_top_routes)
UNION ALL
SELECT
	'Destination' AS orig_dest,
	r.end_station_id AS station,
	s.name AS station_name,
	CONCAT(start_station_id, '_', end_station_id) AS path_id,
	s.latitude,
	s.longitude
FROM cust_outlier_removed r
JOIN bluebikes_stations s
	ON r.end_station_id = s.id
WHERE CONCAT(start_station_id, '_', end_station_id) IN (SELECT route FROM cust_top_routes)

-- Model data for origin-destination map (subscribers)
WITH sub_top_routes AS (
	SELECT * FROM subscriber_ranked WHERE rank <= 5
)
SELECT
	'Origin' AS orig_dest,
	r.start_station_id AS station,
	s.name AS station_name,
	CONCAT(start_station_id, '_', end_station_id) AS path_id,
	s.latitude,
	s.longitude
FROM sub_outlier_removed r
JOIN bluebikes_stations s
	ON r.start_station_id = s.id
WHERE CONCAT(start_station_id, '_', end_station_id) IN (SELECT route FROM sub_top_routes)
UNION ALL
SELECT
	'Destination' AS orig_dest,
	r.end_station_id AS station,
	s.name AS station_name,
	CONCAT(start_station_id, '_', end_station_id) AS path_id,
	s.latitude,
	s.longitude
FROM sub_outlier_removed r
JOIN bluebikes_stations s
	ON r.end_station_id = s.id
WHERE CONCAT(start_station_id, '_', end_station_id) IN (SELECT route FROM sub_top_routes);