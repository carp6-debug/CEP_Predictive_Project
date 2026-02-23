/* PROJECT: CEP PREDICTIVE MAINTENANCE FOR NYC CAPITAL PROJECTS
   FILE: 01_setup_schema.sql
   
   DATA PROVENANCE:
   - Primary Source: NYC Capital Projects
   - Refined Dataset: 'Construction Performance Indicators' (Cleaned by Alex Teboul)
   - Scale: 50,000+ records across 3 years (2019-2021)
   
   DESCRIPTION:
   Establishes the Star Schema normalization. Converts flat-file indicators 
   into a Relational Model (Fact/Dimensions) to optimize query performance 
   for .NET 9 Service layers and Python Analytics.
*/

-- ROLE: Data Engineer
-- OBJECTIVE: Multi-schema architecture for Staging and Production.

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS asset_intelligence;

-- 1. STAGING: Raw import from NYC Capital Projects
CREATE TABLE staging.raw_nyc_schedules (
    project_id TEXT,
    project_name TEXT,
    agency_name TEXT,
    borough TEXT,
    original_end_date TEXT, -- Imported as TEXT to prevent crash on 'N/A' or empty strings
    current_end_date TEXT,
    total_budget TEXT
);

-- 2. CORE: The 'Truth' tables for our Predictive Model
CREATE TABLE asset_intelligence.dim_assets (
    asset_id SERIAL PRIMARY KEY,
    asset_tag VARCHAR(50) UNIQUE, -- e.g., 'CRANE-01'
    nyc_project_id TEXT,          -- Foreign reference to NYC data
    asset_type TEXT,              -- 'Heavy Equipment', 'HVAC', 'Generator'
    mtbf_threshold_hours INT DEFAULT 500
);

CREATE TABLE asset_intelligence.fact_telemetry (
    log_id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES asset_intelligence.dim_assets(asset_id),
    timestamp TIMESTAMP,
    vibration_level FLOAT,        -- From Construction Performance CSV
    temperature_c FLOAT,          -- From Construction Performance CSV
    status_code TEXT              -- 'Operational', 'Warning', 'Failure'
);

-- ROLE: Data Engineer
-- INTENT: Environment Reset / Clean State Maintenance
-- ---------------------------------------------------------------------------------------

-- 1. Truncate fact tables first (they depend on dimensions)
TRUNCATE TABLE asset_intelligence.fact_telemetry RESTART IDENTITY CASCADE;

-- 2. Truncate dimension tables
TRUNCATE TABLE asset_intelligence.dim_assets RESTART IDENTITY CASCADE;

-- 3. Staging is usually handled by Python 'if_exists=replace', 
-- but a manual wipe ensures no schema residuals.
DROP TABLE IF EXISTS staging.raw_nyc_projects;

-- Restarting identities is crucial for consistent testing and development. 
-- RESTART IDENTITY ensures your Serial IDs (1, 2, 3...) start back at 1.