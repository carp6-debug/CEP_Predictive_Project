using Dapper;
using Npgsql;
using CEP_Predictive_Dashboard.Models;

namespace CEP_Predictive_Dashboard.Services
{
    public class MaintenanceService
    {
        private readonly string _connectionString;

        // Constructor pulls the connection string from appsettings.json
        public MaintenanceService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("PostgresConnection") ?? "";
        }

        public async Task<List<AssetStatus>> GetLatestFleetHealthAsync()
        {
            using var conn = new NpgsqlConnection(_connectionString);
            
            // Programmer Analyst Note: This SQL joins staging, dimensions, and facts 
            // to provide a 'Live' snapshot of asset health.
            const string sql = @"
                SELECT DISTINCT ON (a.asset_id)
                    a.asset_id as AssetId,
                    a.asset_tag as AssetTag,
                    p.project_name as ProjectName,
                    p.borough as Borough,
                    t.vibration_level as VibrationLevel,
                    t.status_code as StatusCode
                FROM asset_intelligence.dim_assets a
                JOIN staging.raw_nyc_projects p ON a.nyc_project_id = p.project_id
                JOIN asset_intelligence.fact_telemetry t ON a.asset_id = t.asset_id
                ORDER BY a.asset_id, t.timestamp DESC";

            var result = await conn.QueryAsync<AssetStatus>(sql);
            return result.ToList();
        }
    }
}