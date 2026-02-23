-- ROLE: Data Engineer / Systems Analyst
-- OBJECTIVE: Structural and Integrity Verification

-- 1. Check Row Counts (Ensures no data was lost during ETL)
SELECT 'staging.raw_nyc_projects' as table_name, COUNT(*) as record_count FROM staging.raw_nyc_projects
UNION ALL
SELECT 'asset_intelligence.dim_assets' as table_name, COUNT(*) as record_count FROM asset_intelligence.dim_assets;

-- 2. Verify Primary Keys and Constraints
-- This ensures our N-Tier application can uniquely identify records
SELECT 
    tc.table_schema, 
    tc.table_name, 
    kc.column_name, 
    tc.constraint_type
FROM  information_schema.table_constraints tc
JOIN information_schema.key_column_usage kc 
  ON tc.constraint_name = kc.constraint_name
WHERE tc.table_schema IN ('staging', 'asset_intelligence')
  AND tc.constraint_type = 'PRIMARY KEY';

-- 3. Data Sample Check
-- Ensures 'Asset Synthesis' correctly mapped NYC Project IDs to our new Machine Tags
SELECT asset_tag, asset_type, nyc_project_id 
FROM asset_intelligence.dim_assets 
LIMIT 10;

-------------------------------------------------------------------------------------
-- ROLE: Programmer Analyst / Data Engineer
-- OBJECTIVE: Confirm Telemetry Integrity and State Distribution

-- 1. Check the distribution of equipment states
-- This proves your model has 'incidents' to predict.
SELECT status_code, COUNT(*) as reading_count
FROM asset_intelligence.fact_telemetry
GROUP BY status_code;

-- 2. Spot-check a single asset's degradation curve
-- You should see vibration_level increasing over time.
SELECT timestamp, vibration_level, temperature_c, status_code
FROM asset_intelligence.fact_telemetry
WHERE asset_id = (SELECT MIN(asset_id) FROM asset_intelligence.dim_assets)
ORDER BY timestamp ASC;

-- ROLE: Systems Analyst
-- INTENT: Pre-Ingestion Integrity Audit
-- ---------------------------------------------------------------------------------------

SELECT 
    'staging.raw_nyc_projects' AS table_name, COUNT(*) AS current_count FROM staging.raw_nyc_projects
UNION ALL
SELECT 
    'asset_intelligence.dim_assets' AS table_name, COUNT(*) AS current_count FROM asset_intelligence.dim_assets
UNION ALL
SELECT 
    'asset_intelligence.fact_telemetry' AS table_name, COUNT(*) AS current_count FROM asset_intelligence.fact_telemetry;

SELECT 
    (SELECT COUNT(*) FROM staging.raw_nyc_projects) as staging_count,
    (SELECT COUNT(*) FROM asset_intelligence.dim_assets) as asset_count,
    (SELECT COUNT(*) FROM asset_intelligence.fact_telemetry) as telemetry_count;