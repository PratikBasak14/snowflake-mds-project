-- STEP 8: SILVER LAYER - WEATHER (Flattening Semi-Structured JSON)

USE ROLE SYSADMIN;
GRANT ALL PRIVILEGES ON SCHEMA nyc_taxi_project.silver_clean TO ROLE role_analytics_engineer;

USE ROLE role_analytics_engineer;
USE WAREHOUSE wh_transform;
USE SCHEMA nyc_taxi_project.silver_clean;

CREATE OR REPLACE VIEW silver_weather AS
SELECT 
    -- Step 1: Pull the JSON node as a STRING (::STRING)
    -- Step 2: TRY_CAST that string into a TIMESTAMP_NTZ
    -- Step 3: Truncate it to the HOUR
    DATE_TRUNC('HOUR', TRY_CAST(raw_payload:t::STRING AS TIMESTAMP_NTZ)) AS weather_hour,
    
    -- Extracting nested text fields
    raw_payload:city.name::STRING AS city_name,
    raw_payload:weather[0].main::STRING AS weather_condition,
    raw_payload:weather[0].description::STRING AS weather_description,
    
    -- Safely casting numeric fields by extracting as STRING first
    TRY_CAST(raw_payload:main.temp::STRING AS NUMBER(10,2)) AS temperature_kelvin,
    TRY_CAST(raw_payload:main.humidity::STRING AS INTEGER) AS humidity_percentage,
    TRY_CAST(raw_payload:wind.speed::STRING AS NUMBER(10,2)) AS wind_speed_mph,
    
    -- Keep ingestion time for data lineage auditing
    ingested_at
    
FROM nyc_taxi_project.bronze_raw.raw_weather

-- Filter out any records that don't have a valid timestamp
WHERE TRY_CAST(raw_payload:t::STRING AS TIMESTAMP_NTZ) IS NOT NULL;