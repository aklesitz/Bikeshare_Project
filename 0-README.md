# Conversion Campaign Incentives for Bluebikes rideshare
Analysis of rider data from Bluebikes using PostgreSQL and Tableau. Full presentation is located [here](https://medium.com/@aklesitz/conversion-campaign-incentives-for-bluebikes-242be42e055) on medium.
# Project Overview
The purpose of the Conversion Campaign is to see the popular routes among both short-term customers and subscription based riders in order to find areas where subscriptions could be increased. In order to find
these areas, I have used available demographics data as well as frequently used locations, stations, and routes.
# Data Sources
This data was collected from [Bluebikes System Data](https://bluebikes.com/system-data) and contains records of 6,840,320 rides from 2016-2019. There is a unique numerical id for the bike used, the date and time the ride started and ended, and whether or not the rider purchased a one time use pass (referred to as customer) or holds a subscription (called a subscriber). Demographic information about riders is also included in this dataset, with self-reported columns for birth year and gender. All of this data was stored in seperate databases for each year, so for my EDA I used a CTE to combine them all. <br>

### Rides Data
Most important to this project was the user_type column, which denotes whether a rider is a one time use customer or a long term subscriber. Subscribers accounted for 80% of riders in this dataset, so the remaining 20% is the demographic I am most concerned about, as I look for potential ways to get these riders to sign up for long term subscriptions. <br>
Then I looked at the average length of time a rider takes out a bike. First I filtered out rides over 5 hours, as these are likely unreturned or lost bikes, as well as rides under one minute, which are likely user mistakes. Among subscribers, the average length of a ride is 12.61 minutes. Among customers, it is 30.01 minutes. <br>
The subscription model allows for rides up to 45 minutes in length, so I filtered the data to look at rides no longer than that to find our target demographic of local commuters who do not currently have subscriptions. Tourists are able to buy 24 hour day passes when visiting the city, but are unlikely to sign up for yearly subscriptions. <br>
For the user_birth_year column, some were stored as text and some were stored as floating point integers, so I used a CASE statement and a regex expression to search for the entries with a decimal. I then removed the decimal and cast the datatype to numeric. Any nulls were converted to 0's. This will allow me to perform arithmetic later in my analysis and find the ages of users based on their birth year. Bike_id, start_station_id, end_station_id, and user_gender are all unique signifiers and will require no math, but I kept them as integers in order to save space.
This gave me a dataset of 1,090,446 rides in our target demographic to analyze, so I imported the results of this query into a table named 'bluebikes_customers'. <br>
I applied the same criteria to create a table of commuters who do have subscriptions (for rides between 1 and 45 minutes long) in order to compare the demographics and riding habits of our two datasets, which gave me a dataset of 5,451,967 records. In all, the cleaned dataset contains 6,542,413 records. <br>
[SQL CODE](https://github.com/aklesitz/Bikeshare_Project/blob/main/Bluebikes_rides_data.sql) <br>




### Customer Demographic Data Cleaning
To clean the customer's demographic data, I filtered out riders over 75 as calculated by the last year of data available for this project: 2019. There were reported birth years as far back as 1863, which was obviously unreliable data. This filtered out 9,143 reported rides. I also filtered out the 447,149 unreported birth years. In total 6.67% of the data on riders' birth years was unreliable. The earliest reported birth year was 2003, and a 16 year old rider seemed likely.  <br><br>
[SQL CODE](https://github.com/aklesitz/Bikeshare_Project/blob/main/Bluebikes_customer_demographics.sql) <br> <br>
Visualizing the age distribution of riders revealed another problem: <br><br>
![Age Distribution](Visualizations/customer_age_viz.png) <br>
There is a huge spike among riders aged 50? More likely that riders are reporting their year of birth as 1969. Cute... <br><br>
So I took the average amount of riders in a six year span to smooth out the distribution: <br><br>
![Age Distribution Cleaned](Visualizations/rider_age_viz_cleaned.png) <br><br>
[SQL code](https://github.com/aklesitz/Bikeshare_Project/blob/main/Bluebikes_rider_age_distribution_cleaned.sql) <br><br>
Lastly for demographic data, 64% of riders identified as male, 22% female, and around 14% unknown or unreported. <br><br>
![Gender makeup of riders](Visualizations/gender_viz_of_total_riders.png) <br><br>
This was to get an idea of demographics for the entire dataset. For my analysis, I applied this same criteria to clean the demographic data for the customer and subscriber tables. <br>



### Bike Docking Stations
This table contains the latitude and longtitude, district, total number of bike docks, and numerical id for each of the 339 stations across Boston. It is straightforward and needed no cleaning. The latitude and longtitude columns were very helpful in creating visualizations for this project.

