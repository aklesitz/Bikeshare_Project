import pandas as pd

# import CSV
orgDestCSV = pd.read_csv("bluebikes_origin_destination.csv")
orgDestCSV.columns

# Create origin csv and rename columns (prep for union)
origin = orgDestCSV.drop(columns=["Destination", "End Station Lat", "End Station Long", "End Station"])
origin.rename(columns={'Origin':'Origin/Destination','Start ID':'Station','Start Latitude':'Latitude',
                       'Start Longtitude':'Longtitude'}, inplace=True)
origin.drop(columns=['Start Name'], inplace=True)
origin.columns

# Create destination csv and rename columns
destination = orgDestCSV.drop(columns=["Origin", "Start ID", "Start Name", "Start Latitude", "Start Longtitude"])
destination.rename(columns={'Destination':'Origin/Destination','End Station':'Station','End Station Lat':'Latitude',
                       'End Station Long':'Longtitude'}, inplace=True)
destination = destination.iloc[:,[0,2,3,1,4,5,6]]
destination.columns

# Combine into one file
origin_destination = pd.concat([origin, destination])
origin_destination.columns
origin_destination.head

# Split origin/destination into two columns
origin_destination[["Origin/Destination", "Station"]] = \
    origin_destination['Origin/Destination'].str.split(' ', expand=True)
origin_destination.columns
origin_destination = origin_destination.iloc[:,[0,3,2,5,6,1,4]]


origin_destination.to_csv("origin_destination.csv")