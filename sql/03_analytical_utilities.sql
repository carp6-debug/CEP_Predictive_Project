-- ROLE: Data Engineer / Programmer Analyst
-- OBJECTIVE: Tier 1 Dashboard Support Utilities

-- 1. Equipment Life Stage Analysis
-- Proves the 'Wear and Tear' trend for the Python Notebook.
SELECT 
    asset_id,
    CASE 
        WHEN hour_count <= 100 THEN '0-100 (New)'
        WHEN hour_count <= 300 THEN '101-300 (Stable)'
        ELSE '301-500 (Wear/Critical)'
    END as life_stage,
    AVG(vibration_level) as avg_vibration
FROM (
    SELECT asset_id, vibration_level, 
           ROW_NUMBER() OVER(PARTITION BY asset_id ORDER BY timestamp ASC) as hour_count
    FROM asset_intelligence.fact_telemetry
) sub
GROUP BY asset_id, life_stage
ORDER BY asset_id, life_stage;

-- 2. Regional Risk View (For Regional Filtering in Blazor)
CREATE OR REPLACE VIEW asset_intelligence.view_regional_risk AS
SELECT 
    p.borough, 
    COUNT(t.log_id) FILTER (WHERE t.status_code = 'Critical') as critical_count,
    COUNT(t.log_id) FILTER (WHERE t.status_code = 'Warning') as warning_count
FROM staging.raw_nyc_projects p
JOIN asset_intelligence.dim_assets a ON p.project_id = a.nyc_project_id
JOIN asset_intelligence.fact_telemetry t ON a.asset_id = t.asset_id
GROUP BY p.borough;