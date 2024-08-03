-- Creating a global sequence to add a unique primary key to all rides
CREATE SEQUENCE global_seq;

ALTER TABLE bluebikes_2016
ADD COLUMN ride_id INT DEFAULT nextval('global_seq') PRIMARY KEY;

ALTER TABLE bluebikes_2017
ADD COLUMN ride_id INT DEFAULT nextval('global_seq') PRIMARY KEY;

ALTER TABLE bluebikes_2018
ADD COLUMN ride_id INT DEFAULT nextval('global_seq') PRIMARY KEY;

ALTER TABLE bluebikes_2019
ADD COLUMN ride_id INT DEFAULT nextval('global_seq') PRIMARY KEY;
