-- Step 5: Reading data from external source (AWS S3)

USE ROLE role_analytics_engineer;
USE WAREHOUSE wh_transform;
USE SCHEMA nyc_taxi_project.bronze_raw;

-- 1. Create a stage pointing to the official Snowflake public CitiBike S3 bucket
CREATE OR REPLACE STAGE stage_nyc_bikes
    URL = 's3://snowflake-workshop-lab/citibike-trips-csv/'
    FILE_FORMAT = format_csv
    COMMENT = 'External stage pointing to the raw CSV bike records in AWS S3.';

-- 2. Create a stage pointing to the official Snowflake public Weather S3 bucket
CREATE OR REPLACE STAGE stage_weather_data
    URL = 's3://snowflake-workshop-lab/weather-nyc/'
    FILE_FORMAT = format_json
    COMMENT = 'External stage pointing to the raw JSON weather records in AWS S3.';

-- 3. Quick test to ensure the bridge works
LIST @stage_nyc_bikes;