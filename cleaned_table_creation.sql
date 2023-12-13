-- Creating table for customers (target demographic)
CREATE TABLE public.bluebikes_customers
(
    bike_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    start_station_id integer,
    end_station_id integer,
    user_type text,
    user_birth_year text,
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
    end_station_id integer,
    user_type text,
    user_birth_year text,
    user_gender integer
);

ALTER TABLE IF EXISTS public.bluebikes_subscribers
    OWNER to postgres;