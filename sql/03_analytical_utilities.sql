-- ROLE: Data Engineer
-- OBJECTIVE: Prove the 'Wear and Tear' trend exists in the data.

SELECT 
    asset_id,
    CASE 
        WHEN hour_count <= 100 THEN '0-100 (New)'
        WHEN hour_count <= 200 THEN '101-200 (Stable)'
        WHEN hour_count <= 300 THEN '201-300 (Wear)'
        WHEN hour_count <= 400 THEN '301-400 (Warning)'
        ELSE '401-500 (Critical)'
    END as life_stage,
    AVG(vibration_level) as avg_vibration,
    AVG(temperature_c) as avg_temp
FROM (
    SELECT asset_id, vibration_level, temperature_c,
           ROW_NUMBER() OVER(PARTITION BY asset_id ORDER BY timestamp ASC) as hour_count
    FROM asset_intelligence.fact_telemetry
) sub
GROUP BY asset_id, life_stage
ORDER BY asset_id, life_stage;




SELECT p.borough, t.status_code, COUNT(*) as count
        FROM staging.raw_nyc_projects p
        JOIN asset_intelligence.dim_assets a ON p.project_id = a.nyc_project_id
        JOIN asset_intelligence.fact_telemetry t ON a.asset_id = t.asset_id
        WHERE t.status_code != 'Operational'
        GROUP BY p.borough, t.status_code
        
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'raw_nyc_projects' AND table_schema = 'staging';