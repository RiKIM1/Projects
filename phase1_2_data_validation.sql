
-- Phase 1: Sanity Check
-- Confirming data loads correctly and previewing structure
select * from "BudgetAnalyserSet"."data" d 
limit 10;

-- Counting the total number of rows in the table
SELECT COUNT(*) AS "Total Number of Rows" FROM "BudgetAnalyserSet"."data";

--Dimensions 
SELECT DISTINCT "Department" FROM "BudgetAnalyserSet"."data" ORDER BY 1;
SELECT DISTINCT "Labels" FROM "BudgetAnalyserSet"."data" ORDER BY 1;

-- Extracting, ordering, and making sure all the calendar months are listed
select distinct("Month"), extract(month from TO_DATE("Month", 'Month')) AS "Month Number"
from "BudgetAnalyserSet"."data" d
order by 2; 

-- NULL checks: Looking for NULL values in every column
SELECT
    COUNT(*) - COUNT("idx") AS "null_idx",
    COUNT(*) - COUNT("Department") AS "null_department",
    COUNT(*) - COUNT("Month") AS "null_month",
    COUNT(*) - COUNT("ProjectedExpenses") AS "null_projected",
    COUNT(*) - COUNT("ActualExpenses") AS "null_actual",
    COUNT(*) - COUNT("Variance") AS "null_variance",
    COUNT(*) - COUNT("Labels") AS "null_labels"
FROM "BudgetAnalyserSet"."data" d;

-- Looking for duplicates in the primary key "idx"
SELECT COUNT(*) AS "Number of Distinct IDs with Duplicates"
FROM (
    SELECT "idx"
    FROM "BudgetAnalyserSet"."data"
    GROUP BY "idx"
    HAVING COUNT(*) > 1
) AS duplicate_ids;

============================================
-- PHASE 2: DATA PROFILING (Finance Hygiene Check)
-- ============================================

-- Measures (numeric) - summary stats
SELECT
    MIN("ProjectedExpenses") AS "Min_Projected",
    MAX("ProjectedExpenses") AS "Max_Projected",
    AVG("ProjectedExpenses") AS "Avg_Projected",
    MIN("ActualExpenses") AS "Min_Actual",
    MAX("ActualExpenses") AS "Max_Actual",
    AVG("ActualExpenses") AS "Avg_Actual",
    MIN("Variance") as "Minimum Variance", 
	MAX("Variance") as "Maximum Variance",
	AVG("Variance") as "Average Variance"
FROM "BudgetAnalyserSet"."data";

-- Making sure Projected and Actual Expenses are valid valued, superior or equal to 0
-- using <= 0 to catch both negative values and zeros,
-- as zero expenses may indicate missing data rather than genuine zero spend
select COUNT(*) as "Occurences of negative or zero Projected Expenses"
from "BudgetAnalyserSet".data d
where "ProjectedExpenses" <= 0;

select COUNT(*) as "Occurences of negative or zero Actual Expenses"
from "BudgetAnalyserSet".data d
where "ActualExpenses" <= 0;

-- First Variance check: Checking logical consistency of Variance column
-- Variance should equal ProjectedExpenses minus ActualExpenses
SELECT COUNT(*) AS "Convention Check - Projected minus Actual"
FROM "BudgetAnalyserSet"."data"
WHERE ("ProjectedExpenses" - "ActualExpenses") != "Variance";

-- First check reveals that nearly half (49 out of 100) 
--the variance values are not equal to Projection minus Actual 
--Second check: Data quality note: The Variance column appears to be ABS(Projected - Actual).
-- 99 out of 100 variance records are ABS(Projected - Actual)
SELECT COUNT(*) AS "Rows where Variance = ABS(Projected - Actual)"
FROM "BudgetAnalyserSet"."data"
where ABS("ProjectedExpenses" - "ActualExpenses") = "Variance";

select COUNT(*) AS "Rows where Variance =/= ABS (Projected- Actual)"
FROM "BudgetAnalyserSet"."data"
WHERE ABS("ProjectedExpenses" - "ActualExpenses") != "Variance";
-- Only one row follow the convention Projection - Actual: idx = 24. 
select * FROM "BudgetAnalyserSet"."data"
WHERE ABS("ProjectedExpenses" - "ActualExpenses") != "Variance";
-- All downstream analysis will calculate variance directly from source columns
