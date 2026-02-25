-- ==============================================================================
-- STEP 2: WAREHOUSES
-- ==============================================================================
-- One of Snowflake's biggest advantages is the separation of storage and compute.
-- Here, I am creating two distinct "Warehouses" (which are just compute clusters).
-- Why? Because we don't want heavy data transformations hogging resources and 
-- slowing down the business dashboards. They should run independently.

USE ROLE SYSADMIN;

-- I'm setting AUTO_SUSPEND to 60 seconds. As soon as my pipeline finishes running, 
-- this cluster shuts off instantly so we stop paying for it.
CREATE OR REPLACE WAREHOUSE wh_transform
    WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Dedicated compute for transforming raw data into business models.';

-- 2. The Reporting Warehouse
-- This allows BI Tools to query the final data without interfering with my ETL jobs.
CREATE OR REPLACE WAREHOUSE wh_reporting
    WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Dedicated compute for BI tools and end-user queries.';

-- Finally, I'm giving my AE role permission to use the transformation warehouse.
GRANT USAGE ON WAREHOUSE wh_transform TO ROLE role_analytics_engineer;