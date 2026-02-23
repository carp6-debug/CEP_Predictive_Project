# 🏗️ Construction Predictive Maintenance Portal
### Smart Infrastructure & Asset Management: Multi-Tiered Reliability Study

[![Stack: .NET 9](https://img.shields.io/badge/.NET-9.0-blue.svg)](https://dotnet.microsoft.com/)
[![Database: PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-336791.svg)](https://www.postgresql.org/)
[![Analysis: Python](https://img.shields.io/badge/Analytics-Python-3776AB.svg)](https://www.python.org/)

## 📝 Project Overview
This project demonstrates the transition from **Legacy Static Maintenance** (calendar-based) to **Predictive Service Operations** (telemetry-based). By synthesizing NYC Capital Project schedules with high-frequency equipment performance data (50,000+ records), this system predicts failure windows before they impact construction deadlines.

## 🎯 Role-Based Skill Mapping
To demonstrate senior-level competency, the project is segmented into three professional domains:

* **Systems Analyst:** Performed the architectural mapping of "Scheduled Milestones" against "Mechanical Reality." Defined the N-Tier communication protocols between the .NET UI and Python Analytical Core.
* **Data Engineer:** Built the PostgreSQL Star Schema. Developed the ETL pipeline to ingest raw NYC schedules and generate high-fidelity synthetic telemetry for Mean Time Between Failure (MTBF) modeling.
* **Programmer Analyst:** Developed the Predictive Engine using Python. Authored the .NET logic for "In-The-Red" status alerting and real-time interactive stress-testing.

## 🏛️ System Architecture (N-Tier)
1.  **Presentation Tier:** .NET 8/9 Blazor WASM (Operational Dashboard).
2.  **Logic Tier:** Python FastAPI / Analytical Notebook (Predictive Core).
3.  **Data Tier:** PostgreSQL (Asset Registry & Telemetry Fact Tables).