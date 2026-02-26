-- STEP 7: SILVER LAYER - BIKES 
-- AE Note: The Bronze table contains raw strings from the CSV. 
-- In this Silver model, I am adding data contracts:
USE ROLE SYSADMIN;
CREATE SCHEMA IF NOT EXISTS nyc_taxi_project.silver_clean;
GRANT ALL PRIVILEGES ON SCHEMA nyc_taxi_project.silver_clean TO ROLE role_analytics_engineer;

USE ROLE role_analytics_engineer;
USE WAREHOUSE wh_transform;
USE SCHEMA nyc_taxi_project.silver_clean;

CREATE OR REPLACE VIEW silver_nyc_bikes AS
WITH casted_data AS (
    SELECT 
        TRY_CAST(starttime AS TIMESTAMP_NTZ) AS pickup_timestamp,
        TRY_CAST(stoptime AS TIMESTAMP_NTZ) AS dropoff_timestamp,
        TRY_CAST(tripduration AS INTEGER) AS trip_duration_seconds,
        TRY_CAST(start_station_id AS INTEGER) AS start_station_id,
        start_station_name::STRING AS start_station_name,
        TRY_CAST(start_station_latitude AS NUMBER(10,6)) AS start_latitude,
        TRY_CAST(start_station_longitude AS NUMBER(10,6)) AS start_longitude,
        membership_type::STRING AS user_type,
        TRY_CAST(birth_year AS INTEGER) AS birth_year,
        CASE 
            WHEN TRY_CAST(gender AS INTEGER) = 1 THEN 'Male'
            WHEN TRY_CAST(gender AS INTEGER) = 2 THEN 'Female'
            ELSE 'Unknown'
        END AS gender
    FROM nyc_taxi_project.bronze_raw.raw_nyc_bikes
)
SELECT * FROM casted_data WHERE trip_duration_seconds > 0 AND pickup_timestamp IS NOT NULL;