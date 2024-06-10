-- Combining customer and subscriber ride data
CREATE VIEW combined_rides AS
SELECT
	bike_id,
	start_time,
	end_time,
	start_station_id,
	starting_lat,
	starting_long,
	end_station_id,
	ending_lat,
	ending_long,
	user_type,
	user_birth_year,
	user_gender
FROM bluebikes_customers
UNION ALL
SELECT
	bike_id,
	start_time,
	end_time,
	start_station_id,
	starting_lat,
	starting_long,
	end_station_id,
	ending_lat,
	ending_long,
	user_type,
	user_birth_year,
	user_gender
FROM bluebikes_subscribers;

-- Creating table for popular routes
CREATE TABLE bluebikes_routes AS
SELECT
	start_station_id,
	starting_lat,
	starting_long,
	end_station_id,
	ending_lat,
	ending_long,
	COUNT(*) AS ride_count,
	user_type
FROM
	combined_rides
GROUP BY
	start_station_id,
	starting_lat,
	starting_long,
	end_station_id,
	ending_lat,
	ending_long,
	user_type
ORDER BY
	ride_count DESC;