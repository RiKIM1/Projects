Welcome to my project repository. I am a recent graduate from the University of Nottingham with strong analytical, financial modelling, and data analysis skills. This repository contains a collection of projects I have built as part of my self‑directed study, virtual job simulations, and independent research.


📁 Project Directory
# 1. Tesla 3-Statement Financial Model

   File: Tesla_3StatementModelDCF.xlsx
   
Built a full 3-statement financial model (Income Statement, Cash Flow  Statement, Balance Sheet, as well as complementary schedules) for Tesla Inc. using historical 10-K data from 2018-2025, with forward projections to 2031.

Methodology follows Paul Pignataro's Financial Modeling & Valuation (Wiley Finance).

## Key features:
- Revenue breakdown by segment (Automotive, Energy Generation, Services)
- EBITDA/EBIT/EBT margin analysis
- Working capital and CAPEX modeling
- Forward projections using historical averages, analyst consensus, and key assumptions supported by institution reports (like JPMorgan) and professional investors who are closely monitoring Tesla. 

# 2. SQL-based FP&A Budget vs. Actual 

## Phase 1 and 2: Data Validation

📌 Project Overview

These are the first and second phases of a financial planning and analysis (FP&A) project designed to showcase data validation, SQL proficiency, and business acumen. 

The objective of these two phases was to **inspect, validate, and profile** the raw financial dataset before performing any analytical reporting. In a real-world finance environment, trusting data blindly leads to bad decisions. This phase ensures that the foundation is solid before building any executive dashboards or variance reports

Dataset: 'BudgetAnalyzerSet' (100 records, 5 departments), source: HuggingFace.

### Validation Checks Performed
- **Null Values** – Scanned `ProjectedExpenses` and `ActualExpenses` for missing data.
- **Duplicate IDs** – Verified primary key uniqueness.
- **Logical Consistency** – Checked if `Variance = Projected - Actual`.
- **Edge Cases** – Searched for negative expenses and invalid month entries.
- **Temporal Validation** – Verified that all month entries were spelled correctly and could be accurately sorted chronologically for future trend analysis.
   
### Key Discovery & Resolution
**Issue:** The provided 'Variance' column stores the **absolute** difference ('ABS(Proj - Actual)') rather than the signed difference. 

In FP&A, the sign determines if we're underspending (positive) or overspending (negative). By storing only the absolute value, the dataset effectively removes the ability to distinguish between good performance and bad performance.

**Resolution:** Raw data is preserved (audit trail is critical in finance). All downstream reporting will calculate variance directly as '(ProjectedExpenses - ActualExpenses)', bypassing the flawed column entirely.

### Results Summary:
Nulls (Projected / Actual):  0 
Duplicate IDs : 0 
Negative Expenses: 0 
Month Formatting:Valid 
Variance Consistency: ⚠️ Flagged (Absolute vs. Signed)

### Tools & Next Steps
Stack: PostgreSQL  
Next: Proceed to Phase 3 – Executive Summary (Company-wide KPIs, total variance, and variance percentage).

## Phase 3: Executive Summary: 
Aggregated company-wide KPIs, department performance rankings, and monthly spend trends. Calculated corrected variance and identified performance status for all dimensions. Used ROLLUP to generate an automatic grand total row alongside monthly and department breakdowns.


# 3. EWT and MAT Dashboard

File: EWT and MAT dashboard.xlsx

Context: Based on the Citi Finance Virtual Job Simulation (Forage, 2026). In this simulation, I reviewed financial data provided by the "Deposits & Loans" team, identified breaches of Early Warning Triggers (EWT) and Management Action Triggers (MAT), and prepared a slide deck for the Country Treasurer team and CFO summarising the findings.


What's in the workbook:

- Structured financial data tracking key risk indicators.
- Breach identification and escalation framework.
- Clear visualisation of financial risk triggers.
