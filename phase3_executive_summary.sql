-- Phase 3: Executive Summary

-- General overview of aggregated company-wide KPIs
select 
	SUM ("ProjectedExpenses") as "Total Budget", 
	SUM("ActualExpenses") as "Total Actuals",
	SUM (("ProjectedExpenses")-("ActualExpenses")) as "Total Variance"
from "BudgetAnalyserSet"."data" d;

--Monthly spend trend, including variance percentage and its interpretation, as well as grand total.
SELECT 
    COALESCE("Month", 'Overall') AS "Month",
    CASE 
        WHEN "Month" IS NULL THEN 13 
        ELSE extract(month FROM TO_DATE("Month", 'Month')) 
    END AS "Month Number",
    SUM("ProjectedExpenses") AS "Total Budget",
    SUM("ActualExpenses") AS "Total Actuals",
    SUM("ProjectedExpenses" - "ActualExpenses") AS "Total Variance",
    ROUND(100 * SUM("ProjectedExpenses" - "ActualExpenses") / SUM("ProjectedExpenses"), 2) AS "Variance %",
    CASE 
        WHEN SUM("ProjectedExpenses" - "ActualExpenses") > 0 THEN 'Underspent (Favourable)'
        WHEN SUM("ProjectedExpenses" - "ActualExpenses") < 0 THEN 'Overspent (Unfavourable)'
        ELSE 'On budget'
    END AS "Interpretation"
FROM "BudgetAnalyserSet"."data"
GROUP BY ROLLUP("Month")
ORDER BY CASE 
    WHEN "Month" IS NULL THEN '13' 
    ELSE extract(month FROM TO_DATE("Month", 'Month')) 
END;

-- Department performance ranking (from best to worst) with respect to variance. 
select 
	COALESCE("Department", 'Overall') AS "Department",
	SUM ("ProjectedExpenses") as "Total Budget", 
	SUM("ActualExpenses") as "Total Actuals",
	SUM (("ProjectedExpenses")-("ActualExpenses")) as "Total Variance", 
	ROUND(100* SUM(("ProjectedExpenses")-("ActualExpenses")) / SUM ("ProjectedExpenses"), 2)  as "Variance %",
	case 
		when SUM (("ProjectedExpenses")-("ActualExpenses")) > 0 then 'Underspent (Favourable)'
		when SUM (("ProjectedExpenses")-("ActualExpenses")) < 0 then 'Overspent (Unfavourable)'
		else 'On budget'
		end as "Performance Status"	
	from "BudgetAnalyserSet"."data" d 
	group by rollup ("Department")
	ORDER by CASE 
    WHEN "Department" IS NULL THEN '-1000' 
    ELSE ROUND(100* SUM(("ProjectedExpenses")-("ActualExpenses")) / SUM ("ProjectedExpenses"), 2) 
end DESC;