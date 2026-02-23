#### `DEVELOPER.md` (The Architect & Programmer View)
---
*Detailed technical documentation replacing the standard Architecture file.*

# 🛠️ Developer & Architectural Deep-Dive

## 🏗️ N-Tier Implementation
This system is architected as a **Decoupled 3-Tier Environment** to ensure maintainability and separation of concerns.

### Tier 1: Presentation Layer (Blazor Components)
We moved away from traditional MVC patterns to a modern **Component-Based Architecture**. This allows for a reactive user experience where the Risk Assessment UI communicates directly with our encapsulated C# services.

### Tier 2: Application Logic (C# & Python)
* **.NET Service Layer:** Implements `IHealthRiskService` to calculate risk percentiles. By using Dependency Injection, we ensure the UI is never "hard-coded" to the data source.
* **Python Analytics Engine:** Utilizes Pandas and Seaborn to perform complex data aggregations that are too heavy for the web layer.

### Tier 3: Data Management (PostgreSQL Star Schema)
The data is normalized into a **Star Schema** to optimize query performance:
* `fact_diabetes_survey`: Central hub for clinical telemetry (BMI, BP, Chol).
* `dim_demographics`: Socioeconomic stratification (Age, Income, Education).
* `dim_lifestyle`: Behavioral indicators (Smoking, Alcohol, Activity).

## 🔄 The ETL Pipeline (Data Engineering)
The `health_diabetes_ingestion.py` script executes a hardened migration process:
1.  **Extraction:** Reads 253,680 records from the BRFSS CSV.
2.  **Transformation:** Maps integer codes (e.g., 1.0, 2.0) to Boolean (True/False) or Descriptive strings for the SQL Star Schema.
3.  **Loading:** Performs a bulk transaction into PostgreSQL, utilizing serial IDs to maintain strict relational links between dimensions and facts.

## ✅ Quality Assurance Audit
We enforce a **"Golden Count"** policy. Our `02_data_verification.sql` script confirms:
- **Relational Integrity:** 100% of Fact records are successfully joined to Dimensions.
- **Orphan Prevention:** 0 records exist without a valid Demographic or Lifestyle ID.















