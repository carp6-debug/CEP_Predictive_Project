/* ROLE: Data Engineer / Database Architect
   OBJECTIVE: Idempotent Environment Reset
   INTENT: Clears all telemetry and asset data to ensure a "Clean State" 
           before running Python ingestion and simulation cycles.
*/

-- ---------------------------------------------------------------------------------------
-- START TRANSACTION
-- ---------------------------------------------------------------------------------------
BEGIN;

-- 1. Wipe Fact Table (Child records must be deleted first to avoid FK errors)
-- RESTART IDENTITY is critical for consistent ID mapping (1, 2, 3...) in UI/ORM tests.
TRUNCATE TABLE asset_intelligence.fact_telemetry RESTART IDENTITY CASCADE;

-- 2. Wipe Dimension Table
TRUNCATE TABLE asset_intelligence.dim_assets RESTART IDENTITY CASCADE;

-- 3. Clear Staging Buffer
-- Ensures the Python ETL starts with a 0-record landing zone.
DELETE FROM staging.raw_nyc_projects;

COMMIT;
-- ---------------------------------------------------------------------------------------
-- SUCCESS: The Data Tier is now in a Zero-State.
-- ---------------------------------------------------------------------------------------