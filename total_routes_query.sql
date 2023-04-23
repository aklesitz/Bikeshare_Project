SELECT bike_id, start_time, end_time, start_station_id, 
		end_station_id, user_type
FROM bluebikes_2016
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, 
		end_station_id, user_type
FROM bluebikes_2017
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, 
		end_station_id, user_type
FROM bluebikes_2018
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, 
		end_station_id, user_type
FROM bluebikes_2019;


SELECT id as station_id, latitude, longtitude, name, total_docks
FROM bluebikes_stations;