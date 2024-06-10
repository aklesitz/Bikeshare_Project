-- Creating table for customers (target demographic)
CREATE TABLE bluebikes_customers
(
    bike_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    start_station_id integer,
	starting_lat numeric(15, 10),
	starting_long numeric(15, 10),
    end_station_id integer,
	ending_lat numeric(15, 10),
	ending_long numeric(15, 10),
    user_type text,
    user_birth_year integer,
    user_gender integer
);

COPY bluebikes_customers (
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
	user_gender)
FROM 'C:\Bikeshare_Project\bluebikes_customers.csv'
WITH (format csv, HEADER true);

-- Creating table for subscribers
CREATE TABLE bluebikes_subscribers
(
    bike_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    start_station_id integer,
    starting_lat numeric(15, 10),
	starting_long numeric(15, 10),
    end_station_id integer,
    ending_lat numeric(15, 10),
	ending_long numeric(15, 10),
    user_type text,
    user_birth_year integer,
    user_gender integer
);

COPY bluebikes_subscribers (
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
	user_gender)
FROM 'C:\Bikeshare_Project\bluebikes_subscribers_2016.csv'
WITH (format csv, HEADER true);

COPY bluebikes_subscribers (
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
	user_gender)
FROM 'C:\Bikeshare_Project\bluebikes_subscribers_2017.csv'
WITH (format csv, HEADER true);

COPY bluebikes_subscribers (
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
	user_gender)
FROM 'C:\Bikeshare_Project\bluebikes_subscribers_2018.csv'
WITH (format csv, HEADER true);

COPY bluebikes_subscribers (
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
	user_gender)
FROM 'C:\Bikeshare_Project\bluebikes_subscribers_2019.csv'
WITH (format csv, HEADER true);
