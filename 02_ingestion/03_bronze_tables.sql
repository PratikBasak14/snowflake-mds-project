-- STEP 6: BRONZE LAYER INGESTION
-- Here we are keeping it simple and just loading the raw data as-is into Snowflake. 
--We will do all the heavy lifting of parsing and transforming in the Silver layer.

USE ROLE role_analytics_engineer;
USE WAREHOUSE wh_transform;
USE SCHEMA nyc_taxi_project.bronze_raw;

-- 1. Create and Load the Bronze Weather Table (JSON)
-- Because weather data is nested JSON, we load the ENTIRE row into a single column called 'raw_payload' using Snowflake's powerful VARIANT data type.

CREATE OR REPLACE TABLE raw_weather (
    raw_payload VARIANT,
    ingested_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) COMMENT = 'Bronze table containing raw JSON weather payloads.';

-- Load the data from the S3 stage into our Bronze table
COPY INTO raw_weather (raw_payload)
FROM @stage_weather_data
FILE_FORMAT = (FORMAT_NAME = 'format_json');


-- 2. Create and Load the Bronze CitiBike Table (CSV)
-- For CSVs, best practice in the Bronze layer is to load everything as strings 

CREATE OR REPLACE TABLE raw_nyc_bikes (
    tripduration VARCHAR,
    starttime VARCHAR,
    stoptime VARCHAR,
    start_station_id VARCHAR,
    start_station_name VARCHAR,
    start_station_latitude VARCHAR,
    start_station_longitude VARCHAR,
    end_station_id VARCHAR,
    end_station_name VARCHAR,
    end_station_latitude VARCHAR,
    end_station_longitude VARCHAR,
    bikeid VARCHAR,
    membership_type VARCHAR,
    birth_year VARCHAR,
    gender VARCHAR,
    ingested_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) COMMENT = 'Bronze table containing raw NYC CitiBike rides from CSV.';

-- Load the CSV data from the S3 stage
COPY INTO raw_nyc_bikes (
    tripduration, starttime, stoptime, start_station_id, start_station_name, 
    start_station_latitude, start_station_longitude, end_station_id, end_station_name, 
    end_station_latitude, end_station_longitude, bikeid, membership_type, birth_year, gender
)
FROM @stage_nyc_bikes
FILE_FORMAT = (FORMAT_NAME = 'format_csv');