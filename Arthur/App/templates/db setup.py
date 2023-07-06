#databases
import sqlite3
conn = sqlite3.connect('INARD.db')
print ("Opened database successfully")

conn.execute('''CREATE TABLE forSale(
   Property_ID INT PRIMARY KEY     NOT NULL,
   Title           TEXT    NOT NULL,
   Address        CHAR(50),
   Surbub         CHAR(50),
   City		      CHAR(50),
   Property_Type  TEXT,
   Area_Land		DOUBLE,
   Area_Office		DOUBLE,
   Area_Warehouse	DOUBLE,
   Beds			INTEGER,
   Baths                INTEGER,
   Description		TEXT,
   InternalFeatures	TEXT,
   ExternalFeatures	TEXT,
   Amenities		TEXT,
   Pics				TEXT,
   src				TEXT,
   Date_Added		DATE,
   Status			TEXT,
   Price           DOUBLE
);
''')

conn.execute('''CREATE TABLE forRent(
   Property_ID INT PRIMARY KEY     NOT NULL,
   Title           TEXT    NOT NULL,
   Address        CHAR(50),
   Surbub         CHAR(50),
   City		      CHAR(50),
   Property_Type  TEXT,
   Area_Land		DOUBLE,
   Area_Office		DOUBLE,
   Area_Warehouse	DOUBLE,
   Beds			INTEGER,
   Baths                INTEGER,
   Description		TEXT,
   InternalFeatures	TEXT,
   ExternalFeatures	TEXT,
   Amenities		TEXT,
   Pics				TEXT,
   src				TEXT,
   Date_Added		DATE,
   Status			TEXT,
   Price            DOUBLE
);
''')
print ("Table created successfully")

conn.close()



# Location:-address,surbub, city/town(a table with cities and region)

# Property Type:House,flat,land


# Status:sold or not


# Area: office,land, warehouse, building,

# Beds:

# Baths:


# Property Description:

# InternalFeatures:[]
# ExternalFeatures:[]



# Amenities

# pics:[]

# src:

# Date added:
