-- ROLE: Data Engineer / Systems Analyst
-- OBJECTIVE: Structural and Integrity Verification

-- 1. Global Count Audit
SELECT 'Staging Projects' AS Metric, COUNT(*) FROM staging.raw_nyc_projects
UNION ALL
SELECT 'Dimension Assets', COUNT(*) FROM asset_intelligence.dim_assets
UNION ALL
SELECT 'Fact Telemetry', COUNT(*) FROM asset_intelligence.fact_telemetry;

-- 2. Data Quality: The 'Orphan' Check
-- Ensures 100% relational integrity for the .NET service.
SELECT COUNT(*) AS orphaned_telemetry_rows
FROM asset_intelligence.fact_telemetry t
LEFT JOIN asset_intelligence.dim_assets a ON t.asset_id = a.asset_id
WHERE a.asset_id IS NULL;

-- 3. Status Distribution (The 'Executive' View)
SELECT status_code, COUNT(*) AS count, 
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM asset_intelligence.fact_telemetry
GROUP BY status_code;