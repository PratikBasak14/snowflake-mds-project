
-- STEP 9: GOLD LAYER (Business Intelligence & Aggregations)


USE ROLE SYSADMIN;
CREATE SCHEMA IF NOT EXISTS nyc_taxi_project.gold_marts;
GRANT ALL PRIVILEGES ON SCHEMA nyc_taxi_project.gold_marts TO ROLE role_analytics_engineer;

USE ROLE role_analytics_engineer;
USE WAREHOUSE wh_transform;
USE SCHEMA nyc_taxi_project.gold_marts;

CREATE OR REPLACE VIEW gold_bike_weather_impact AS
WITH hourly_rides AS (
    SELECT 
        DATE_TRUNC('HOUR', pickup_timestamp) AS ride_hour,
        COUNT(*) AS total_rides,
        AVG(trip_duration_seconds) / 60 AS avg_ride_duration_minutes
    FROM nyc_taxi_project.silver_clean.silver_nyc_bikes
    GROUP BY 1
)
SELECT 
    r.ride_hour,
    r.total_rides,
    ROUND(r.avg_ride_duration_minutes, 2) AS avg_duration_mins,
    w.weather_condition,
    w.weather_description,
    w.temperature_kelvin,
    w.wind_speed_mph
FROM hourly_rides r
LEFT JOIN nyc_taxi_project.silver_clean.silver_weather w 
    ON r.ride_hour = w.weather_hour
ORDER BY r.ride_hour DESC;



SELECT * FROM nyc_taxi_project.gold_marts.gold_bike_weather_impact LIMIT 20;