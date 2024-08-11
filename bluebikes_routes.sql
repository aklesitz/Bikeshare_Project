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

-- Creating table for top 5 routes
CREATE TABLE top_routes AS
WITH ranked_routes AS (
	SELECT
		start_station_id,
		end_station_id,
		starting_lat,
		starting_long,
		ending_lat,
		ending_long,
		user_type,
		user_gender,
		user_birth_year,
		COUNT(*) AS trip_count,
		ROW_NUMBER() OVER (PARTITION BY start_station_id ORDER BY COUNT(*) DESC) AS rank
	FROM
		combined_rides
	GROUP BY
		start_station_id,
		end_station_id,
		starting_lat,
		starting_long,
		ending_lat,
		ending_long,
		user_type,
		user_gender,
		user_birth_year
)
SELECT
	start_station_id,
	end_station_id,
	starting_lat,
	starting_long,
	ending_lat,
	ending_long,
	trip_count,
	user_type,
	user_gender,
	user_birth_year
FROM
	ranked_routes
WHERE
	rank <= 5;
	
SELECT * FROM top_routes;