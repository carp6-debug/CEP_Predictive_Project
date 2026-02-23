"""
predictive_ingestion.py
---------------------------------------------------------------------------------
PROJECT: Construction Predictive Maintenance & Vendor Intelligence
ROLE: Data Engineering (ETL) & Systems Analysis
---------------------------------------------------------------------------------
SUMMARY: 
This script implements the automated data pipeline between the NYC Capital 
Project source and the PostgreSQL Staging/Core schemas. 

OBJECTIVES:
1. Implement Cross-Platform Path Handling for 'data' directory access.
2. Normalize NYC Project Schedules into the 'staging' schema.
3. Perform 'Asset Synthesis' to map equipment to specific project IDs.
---------------------------------------------------------------------------------
"""

import pandas as pd
import numpy as np
import os
from sqlalchemy import create_engine, text

# --- 1. SETUP: Professional Connection & Pathing ---
# Database URL utilizing your project-specific naming convention
DB_URL = "postgresql://postgres:Lr591T66@localhost:5432/cep_predictive_project"
engine = create_engine(DB_URL)

# Simplified Relative Path Logic: Normalized for Windows/Linux/GitHub
# This moves up from /scripts to the project root and into /data
base_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.normpath(os.path.join(base_dir, "../../data/capital-project-schedules-and-budgets.csv"))

def clean_nyc_dates(date_str):
    """
    TRANSFORMATION LOGIC: Handles the 'Dirty Data' problem.
    Converts various NYC date formats to standard SQL YYYY-MM-DD.
    """
    try:
        return pd.to_datetime(date_str).date()
    except:
        return None # Graceful failure for missing/malformed dates

def ingest_baseline_data():
    """
    STEP 1: Load the NYC Static Schedules.
    ROLE: Data Engineer - Handles the Raw-to-Staging migration.
    """
    print(f"🚀 Attempting to load: {csv_path}")
    
    try:
        # Extraction
        df_nyc = pd.read_csv(csv_path)
        print(f"✅ File read successfully. Record count: {len(df_nyc)}")

        # Selection & Transformation
        # index 0: Project ID | index 1: Project Name | index 3: Borough | index 5: Target Date
        df_nyc_clean = pd.DataFrame()
        df_nyc_clean['project_id'] = df_nyc.iloc[:, 0].astype(str)
        df_nyc_clean['project_name'] = df_nyc.iloc[:, 1]
        df_nyc_clean['borough'] = df_nyc.iloc[:, 3] # <--- Added for Regional Analytics
        
        # Applying the date cleaning logic to the standard 'Current End Date' column
        df_nyc_clean['target_date'] = df_nyc.iloc[:, 5].apply(clean_nyc_dates)
        
        # Load into Staging
        # Note: We replace the staging table each run to maintain a clean baseline
        df_nyc_clean.to_sql('raw_nyc_projects', engine, schema='staging', if_exists='replace', index=False)
        print("✅ NYC Staging Complete: Table 'staging.raw_nyc_projects' updated with Borough data.")

    except FileNotFoundError:
        print(f"❌ ERROR: File not found. Verify the file is in: {csv_path}")
    except Exception as e:
        print(f"❌ ERROR during ingestion: {e}")

def synthesize_assets():
    """
    STEP 2: The 'Bridge'. 
    ROLE: Systems Analyst - Defining the logical relationship between Project and Machine.
    """
    print("🏗️ Synthesizing Asset Registry...")
    # Logic: Bridge distinct project IDs to Asset Tags (e.g., MACH-12345)
    # This populates our core dimension table for use in the .NET dashboard
    with engine.begin() as conn:
        conn.execute(text("""
            INSERT INTO asset_intelligence.dim_assets (asset_tag, nyc_project_id, asset_type)
            SELECT 'MACH-' || project_id, project_id, 'Heavy Equipment'
            FROM staging.raw_nyc_projects
            ON CONFLICT (asset_tag) DO NOTHING;
        """))
    print("✅ Asset Synthesis Complete: 'asset_intelligence.dim_assets' populated.")

if __name__ == "__main__":
    # Standard Professional Execution Flow
    print("--- Starting Ingestion Pipeline ---")
    ingest_baseline_data()
    synthesize_assets()
    print("--- Pipeline Execution Finished ---")