# Conversion Campaign Incentives for Bluebikes rideshare
Analysis of rider data from Bluebikes using PostgreSQL and Tableau. Full presentation is located [here](https://medium.com/@aklesitz/conversion-campaign-incentives-for-bluebikes-242be42e055) on medium.
# Project Overview
The purpose of the Conversion Campaign is to see the popular routes among both short-term customers and subscription based riders in order to find areas where subscriptions could be increased. In order to find
these areas, I have used available demographics data as well as frequently used locations, stations, and routes.
# Data Sources
This data was collected from [Bluebikes System Data](https://bluebikes.com/system-data) and contains records of 6,840,320 rides from 2016-2019. Demographic information about riders is also included in this dataset, with self-reported columns for birth year and gender as well as whether the rider is a one time customer or a subscription holder.  The seperate datasets for all four years were cleaned and combined and then joined with another table containing data on the docking stations.
### Customer Demographic Data
In analyzing the demographic data, I filtered out riders over 75, as there was a lot of unreliable data in this category. This filtered out 26,033 reported riders, with birth years going back as far as 1863, as well as 447,149 unreported birth years. The inverse of that was not a problem. The earliest reported birth year was 2003, and a twenty year old rider seems very likely. 64% of riders identified as male, 22% female, and around 14% unknown or unreported. <br>
[SQL CODE](https://github.com/aklesitz/Bikeshare_Project/blob/main/Bluebikes_rider_demographics.sql)
### Bike Docking Stations
This table contains the latitude and longtitude, district, total number of bike docks, and numerical id for each of the 339 stations across Boston. It is straightforward and needed no cleaning. The latitude and longtitude columns were very helpful in creating visualizations for this project.
### Rides Data
For the data on the rides themselves, I assumed that bikes weren't out for longer than 5 hours. Unreturned or stolen bikes skew the ridership data. This filtered out 16,211 rides across all of the years of data. Perhaps most important to this project was the user_type column, which denotes whether a rider is a one time use customer or a long term subscriber. Subscribers accounted for 80% of riders in this dataset, so the remaining 20% is the demographic I am most concerned about, as I look for potential ways to get these riders to sign up for long term subscriptions.
