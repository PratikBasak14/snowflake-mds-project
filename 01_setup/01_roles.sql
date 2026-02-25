-- STEP 1: 
-- ROLE-BASED ACCESS CONTROL (Security First)
-- Hello! I am Pratik.
-- If you are reviewing my code, this is where I set up the security foundation.
-- I never build pipelines using the ACCOUNTADMIN role because it's too risky. 
-- Instead, I'm creating a dedicated custom role just for my AE workflows.

USE ROLE USERADMIN; -- Using the built-in admin role strictly for role creation.

-- 1. Creating Analytics Engineering role.
CREATE OR REPLACE ROLE role_analytics_engineer
    COMMENT = 'Owns the data pipelines, transformations, and schema creation.';

-- 2. Creating Data Analyst role with read-only access to the Gold layer.
CREATE OR REPLACE ROLE role_data_analyst
    COMMENT = 'Read-only access to the final Gold layer for BI reporting.';

-- 3. Grant the AE role to my personal user account so I can actually build the project!
GRANT ROLE role_analytics_engineer TO USER "PRATIK59";