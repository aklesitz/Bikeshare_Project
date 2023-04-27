-- combine routes for all years with user type and duration for filtering

SELECT start_station_id,
	end_station_id,
	(start_station_id, end_station_id) as path_id,
	latitude, longtitude,
	user_type,
	(end_time - start_time) as duration
FROM bluebikes_2016
JOIN bluebikes_stations
ON id = start_station_id
UNION ALL
SELECT start_station_id,
	end_station_id,
	(start_station_id, end_station_id) as path_id,
	latitude, longtitude,
	user_type,
	(end_time - start_time) as duration
FROM bluebikes_2017
JOIN bluebikes_stations
ON id = start_station_id
UNION ALL
SELECT start_station_id,
	end_station_id,
	(start_station_id, end_station_id) as path_id,
	latitude, longtitude,
	user_type,
	(end_time - start_time) as duration
FROM bluebikes_2018
JOIN bluebikes_stations
ON id = start_station_id
UNION ALL
SELECT start_station_id,
	end_station_id,
	(start_station_id, end_station_id) as path_id,
	latitude, longtitude,
	user_type,
	(end_time - start_time) as duration
FROM bluebikes_2019
JOIN bluebikes_stations
ON id = start_station_id;


CREATE VIEW start_station_routes AS
SELECT start_station_id,
	(start_station_id, end_station_id) as route_id
FROM bluebikes_2016
