-- Creating table for customers (target demographic)
CREATE TABLE public.bluebikes_customers
(
    bike_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    start_station_id integer
	starting_lat numeric(15, 10),
	starting_long numeric(15, 10),
    end_station_id integer,
	ending_lat numeric(15, 10),
	ending_long numeric(15, 10),
    user_type text,
    user_birth_year integer,
    user_gender integer
);

ALTER TABLE IF EXISTS public.bluebikes_customers
    OWNER to postgres;
	
-- Creating table for subscribers
CREATE TABLE public.bluebikes_subscribers
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

ALTER TABLE IF EXISTS public.bluebikes_subscribers
    OWNER to postgres;