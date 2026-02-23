"""
predictive_telemetry.py
---------------------------------------------------------------------------------
PROJECT: Construction Predictive Maintenance
ROLE: Programmer Analyst / Data Engineer
---------------------------------------------------------------------------------
SUMMARY: 
Generates synthetic telemetry for 100 assets. Simulates MTBF (Mean Time Between 
Failure) decay by trending vibration and temperature upward over a 500-hour window.
---------------------------------------------------------------------------------
"""

import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
import datetime

# --- CONFIGURATION ---
DB_URL = "postgresql://postgres:Lr591T66@localhost:5432/cep_predictive_project"
engine = create_engine(DB_URL)

def generate_telemetry():
    print("📡 Fetching asset registry from dim_assets...")
    assets = pd.read_sql("SELECT asset_id, asset_tag FROM asset_intelligence.dim_assets", engine)

    if assets.empty:
        print("❌ No assets found. Please run the ingestion script first.")
        return

    telemetry_records = []
    
    print(f"⚙️ Simulating 500 hours of operation for {len(assets)} assets...")

    for _, asset in assets.iterrows():
        # Baseline normal operating conditions
        vibe_base = 1.2
        temp_base = 42.0
        
        for hour in range(500):
            # 'Senior' Logic: Apply a subtle upward slope (Wear & Tear)
            # This ensures the data is 'Predictable' rather than purely random
            slope = hour * 0.004 
            current_vibe = vibe_base + slope + np.random.normal(0, 0.15)
            current_temp = temp_base + (slope * 1.5) + np.random.normal(0, 0.4)
            
            # Determine Status Code based on thresholds
            status = 'Operational'
            if current_vibe > 3.0 or current_temp > 75:
                status = 'Warning'
            if current_vibe > 4.2 or current_temp > 90:
                status = 'Danger'

            telemetry_records.append({
                'asset_id': asset['asset_id'],
                'timestamp': datetime.datetime.now() - datetime.timedelta(hours=(500-hour)),
                'vibration_level': round(current_vibe, 2),
                'temperature_c': round(current_temp, 2),
                'status_code': status
            })

    # LOAD: Push to fact_telemetry
    df_fact = pd.DataFrame(telemetry_records)
    print("📤 Committing telemetry to PostgreSQL...")
    df_fact.to_sql('fact_telemetry', engine, schema='asset_intelligence', if_exists='append', index=False)
    print(f"✅ Success: {len(df_fact)} telemetry records pushed to fact_telemetry.")

if __name__ == "__main__":
    generate_telemetry()