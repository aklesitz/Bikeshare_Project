# Conversion Campaign Incentives for Bluebikes rideshare
Analysis of rider data from Bluebikes using PostgreSQL and Tableau. Full presentation is located [here](https://medium.com/@aklesitz/conversion-campaign-incentives-for-bluebikes-242be42e055) on Medium.

# Project Overview
The purpose of this project is to create an interactive map dashboard in Tableau that visualizes the most popular bike routes from each station among both one time use "customers" and subscription-based "subscribers" in order to find areas where subscription rates could be increased. In order to find these areas, I have used available demographics data as well as frequently used locations, stations, and routes sourced from data stored in PostgreSQL databases.

# Project Goals
* Analyze bike share usage patterns
* Visualize most popular routes from each station
* Enable filtering by user type (customers or subscribers), gender, and age group
* Create an interactive map dashboard in Tableau

# Data Sources
## Datasets
* Bluebikes Rides: Contains records of individual bike rides.
  * 4 seperate tables, one for each year 2016-2019
* Bluebikes Stations: Contains information on bike docking stations

## Database Schema
Rides Data
* 'bike_id': unique numerical identifier for each bike
* 'start_time': date and time of ride start
* 'end_time': date and time of ride end
* 'start_station_id': numerical identifier of station bike was rented from
* 'end_station_id': numerical identifier of station bike was returned to
* 'user_type': denotes whether user is customer or subscriber
* 'user_birth_year': user's year of birth (stored as text)
* 'user_gender': integer reflecting user's self-reported gender (0=unknown, 1=male, 2=female)
* 'ride_id': I added a primary key for each ride across all four years of data using a global sequence
  * I did this so that I can find and remove the outliers and errors based off ride duration and then add the demographic data back in after
  * [SQL ADD PRIMARY KEY](https://github.com/aklesitz/Bikeshare_Project/blob/main/add_primary_key.sql) <br>

Stations Data
* 'number': unique alphanumeric identifier for each bike-docking station
* 'name': name of station
* 'latitude'
* 'longitude'
* 'district': neighborhood where station is located
* 'public': denotes if station is available to public (all stations are public, this is useless data)
* 'total_docks': total number of bike docks available at station
* 'id': numerical identifier of bike station (Foreign Key to rides data)

## Rides Data EDA
* Used CTE to combine all four years of data and find:
  * Percentage of Subscribers vs. Customers across total dataset
  * 80% of users are already subscribers
  * The 19% of users who are not signed up for a subscription plan is our target demographic <br>
[SQL CODE USER TYPE MAKEUP](https://github.com/aklesitz/Bikeshare_Project/blob/main/cust_type_percentage.sql) <br>

* Average ride duration for customers and subscribers (in minutes)
  * Created temporary tables containing just ride durations for both customers and subscribers
  * Identified quartiles to find and exclude outliers 
    * Average subscriber ride length: 11.23 minutes
    * Average customer ride length: 20.21 minutes <br>
[SQL CODE OUTLIER IDENTIFICATION AND AVG RIDE TIME](https://github.com/aklesitz/Bikeshare_Project/blob/main/sub_cust_avg_duration.sql) <br>


### Customer And Subscriber Demographic Data Cleaning And EDA
To clean the customer's demographic data, I filtered out riders over 75 as calculated by the last year of data available for this project: 2019. There were reported birth years as far back as 1863, which was obviously unreliable data. This filtered out 9,143 reported rides. I also filtered out the 447,149 unreported birth years. In total 6.67% of the demographics data on riders' birth years was unreliable. The earliest reported birth year was 2003, and a 16 year old rider seemed likely.  <br><br>
There is a large outlier in the age distribution as seen in this visualization: <br><br>
![Age Distribution](Visualizations/customer_age_viz.png) <br>
There is a huge spike among riders aged 50? More likely that riders are reporting their year of birth as 1969. Cute... <br><br>
So I took the average amount of riders in a six year span to smooth out the distribution: <br><br>
![Age Distribution Cleaned](Visualizations/customer_age_viz_cleaned.png) <br><br>
[SQL CODE](https://github.com/aklesitz/Bikeshare_Project/blob/main/bluebikes_customer_demographics.sql) <br>

The age distribution of the subscription customers had no such problem, although there is a small uptick of users reporting their birth year as 2019: <br><br>
![Age Distribution](Visualizations/subscriber_age_viz.png) <br>
It is not too surprising that the demographics data for the one time use customers is far less reliable than those who hold a subscription, as people are more hesitant to give their personal data out for a single use ride. Even though the demographics data for customers is largely unreliable, I still want to analyze the routes taken, as demographics data is only a part of my analysis. So I will keep my two datasets as is to load into Tableau. For the demographics visualizations I will need to filter the outliers using Tableau.




### Bike Docking Stations
This table contains the latitude and longtitude, district, total number of bike docks, and numerical id for each of the 339 stations across Boston. It is straightforward and needed no cleaning. The latitude and longtitude columns were very helpful in creating visualizations for this project.

