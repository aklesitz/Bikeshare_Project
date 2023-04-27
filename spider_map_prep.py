# Import data into SQL database
import os
import numpy as np
import pandas as pd
import psycopg2

# import csv into pandas df
df = pd.read_csv('all_routes.csv')
df.head()


df.dtypes

# dictionary to replace Pandas dtypes with sql dtypes
replacements = {
    'object': 'varchar',
    'float64': 'float',
    'int64': 'int'
}

# format columns for sql
col_str = ', '.join('{} {}'.format(n, d) for (n, d) in zip(df.columns, df.dtypes.replace(replacements)))
col_str

# open a database connection
host = input('host: ')
dbname = input('dbname: ')
port = input('port: ')
user = input('user: ')
pw = input('password: ')
conn_string = "host dbname port pw"
#conn_string = "host = localhost \
#                dbname = 'bluebikes_all' \
#                port = '5433' \
#                user = 'postgres' password = 'a'"
conn = psycopg2.connect(conn_string)
cursor = conn.cursor()
print('opened database successfully')

# drop tables with same name
cursor.execute("drop table if exists bluebikes_routes;")

# create table
col_str
cursor.execute("create table bluebikes_routes \
(start_station_id int, end_station_id int, path_id varchar, latitude float, longtitude float, \
user_type varchar, duration varchar)")

# insert values to table

# save df to csv (didn't change anything, don't need here)
#df.to_csv('all_routes.csv', header=df.columns, index=False, encoding='utf-8')

# open csv file, save as an object, upload to db
my_file = open('all_routes.csv')
print('file opened in memory')

# upload to db
SQL_STATEMENT = """
COPY bluebikes_routes FROM STDIN WITH
    CSV
    HEADER
    DELIMITER AS ','
"""

cursor.copy_expert(sql=SQL_STATEMENT, file=my_file)
print('file copied to db')

cursor.execute("grant select on table bluebikes_routes to public")
conn.commit()

cursor.close()
print('table bluebikes_routes imported to db completed')