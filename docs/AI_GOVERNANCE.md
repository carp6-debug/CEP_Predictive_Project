#### `ARCHITECTURE.md`: AI Roles & Responsibilities ("System Instructions")
---
# 🤖 AI Governance & Compliance Statement

## 📝 Statement of Methodology
This project utilized Large Language Models (LLMs) specifically as a **Senior Data Architect Consultant.** The use of AI was targeted toward accelerating the "Tear Down and Rebuild" cycle during the initial Star Schema drafting and C# boilerplate generation.

## 🛡️ Operational Safeguards
* **Human-In-The-Loop (HITL):** Every SQL constraint, C# Service method, and Python aggregation was manually verified, refactored, and tested by the lead developer. AI was not permitted to execute code or write to the production database directly.
* **Data Integrity:** AI was used to simulate architectural edge cases, but the actual 253,680-record ingestion was managed via a custom-coded Python pipeline to ensure 0% data leakage.
* **PII & Privacy:** No sensitive or personally identifiable information was shared with external AI models. All prompts were restricted to architectural structure and public-domain CDC data attributes.

## 🎯 Professional Value
AI integration allowed for a 40% reduction in development time for structural boilerplate, allowing the developer to focus on **Clinical Insights** and **System Analysis**.