/* ROLE: Data Engineer
   OBJECTIVE: Multi-schema architecture for Staging and Production.
*/

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS asset_intelligence;

-- 1. STAGING: Raw import from NYC Capital Projects
CREATE TABLE IF NOT EXISTS staging.raw_nyc_projects (
    project_id TEXT,
    project_name TEXT,
    agency_name TEXT,
    borough TEXT,
    original_end_date TEXT, 
    current_end_date TEXT,
    total_budget TEXT
);

-- 2. CORE: Dimension Table
CREATE TABLE IF NOT EXISTS asset_intelligence.dim_assets (
    asset_id SERIAL PRIMARY KEY,
    asset_tag VARCHAR(50) UNIQUE,
    nyc_project_id TEXT,
    asset_type TEXT,
    mtbf_threshold_hours INT DEFAULT 500
);

-- 3. CORE: Fact Table with Performance Indexes
CREATE TABLE IF NOT EXISTS asset_intelligence.fact_telemetry (
    log_id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES asset_intelligence.dim_assets(asset_id) ON DELETE CASCADE,
    timestamp TIMESTAMP NOT NULL,
    vibration_level FLOAT,
    temperature_c FLOAT,
    status_code TEXT
);

-- PERFORMANCE: Optimized for Dapper Service Layer Lookups
CREATE INDEX IF NOT EXISTS idx_telemetry_asset_id ON asset_intelligence.fact_telemetry(asset_id);
CREATE INDEX IF NOT EXISTS idx_telemetry_status ON asset_intelligence.fact_telemetry(status_code);