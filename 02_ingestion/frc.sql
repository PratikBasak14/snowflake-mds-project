USE ROLE SYSADMIN;
CREATE DATABASE IF NOT EXISTS nyc_taxi_project;
CREATE SCHEMA IF NOT EXISTS nyc_taxi_project.bronze_raw;
GRANT USAGE ON DATABASE nyc_taxi_project TO ROLE role_analytics_engineer;
GRANT USAGE ON SCHEMA nyc_taxi_project.bronze_raw TO ROLE role_analytics_engineer;
GRANT ALL PRIVILEGES ON SCHEMA nyc_taxi_project.bronze_raw TO ROLE role_analytics_engineer;
USE ROLE role_analytics_engineer;
USE SCHEMA nyc_taxi_project.bronze_raw;