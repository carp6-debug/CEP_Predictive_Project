# 🛠️ Developer & Architectural Deep-Dive

## 🏗️ N-Tier Implementation
This system is architected as a **Decoupled 4-Tier Environment** to ensure industrial-grade maintainability and strict separation of concerns.

### Tier 1: Presentation (Blazor Web UI)
We utilized a **Component-Based Architecture** to replace legacy static views. The dashboard features CSS-isolated cards that react to telemetry states (Red/Yellow/Green), communicating with the backend via encapsulated C# services.

### Tier 2: Application Logic (.NET & Python)
* **.NET Service Layer**: Implements `IMaintenanceService` utilizing **Dapper ORM** for high-performance mapping. Dependency Injection (DI) is used to manage database connections, ensuring the UI remains agnostic of the persistence layer.
* **Python Analytical Core**: Acts as the "Logic Tier" for data science. It performs Gaussian-based telemetry simulation and MTBF (Mean Time Between Failure) trend analysis.

### Tier 3: Data Management (PostgreSQL Star Schema)
The database utilizes a dual-schema approach to optimize both ingestion and analytical reporting:
* **Staging Schema**: Buffer zone for raw `CSV` landing and header sanitization.
* **Star Schema**: Optimized analytical layer consisting of:
    * `Fact_Telemetry`: Central hub for high-frequency vibration and heat logs.
    * `Dim_Asset`: Structural metadata for construction equipment.
    * `Dim_Project`: Mapping assets to NYC Capital Project milestones.

### Tier 4: Ingestion & Simulation (Python ETL)
The `ingest_telemetry.py` pipeline executes a hardened data lifecycle:
1. **Extraction**: Imports project schedules from NYC Open Data.
2. **Synthesis**: Maps 12,000+ project records to 33 distinct mechanical assets with 100% relational fidelity.
3. **Simulation**: Generates 16,500+ telemetry rows with a linear "Wear Slope" to simulate equipment degradation over a 500-hour window.

## ✅ Quality Assurance & Idempotency
We enforce a **"Fresh State"** policy. The `02_data_verification.sql` script and Python reset logic ensure:
- **Transactional Integrity**: Uses `RESTART IDENTITY CASCADE` to ensure a consistent environment for every demo run.
- **Threshold Validation**: 100% of telemetry triggers match the business requirements defined in the **Systems Analyst** phase.















