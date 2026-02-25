-- STEP 4: FILE FORMATS

USE ROLE role_analytics_engineer;
USE WAREHOUSE wh_transform;
USE SCHEMA nyc_taxi_project.bronze_raw;

-- 1. Format for NYC CitiBike Data (CSV)
CREATE OR REPLACE FILE FORMAT format_csv
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL', 'null', '')
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    COMMENT = 'Used for parsing massive CSV files from our data lake.';

-- 2. Format for Weather Data (JSON)
CREATE OR REPLACE FILE FORMAT format_json
    TYPE = JSON
    STRIP_OUTER_ARRAY = TRUE
    IGNORE_UTF8_ERRORS = TRUE
    COMMENT = 'Used for parsing nested JSON API payloads.';