-- Number of distinct Countries 

SELECT * 
FROM (
	SELECT COUNT(DISTINCT public.international_debt.country_name) AS total_distinct_countries
	FROM public.international_debt 
) AS num_distinct_countries


-- Country with the highest debt 

SELECT *
FROM (
	SELECT public.international_debt.country_name, SUM(public.international_debt.debt) AS total_debt
	FROM public.international_debt
	GROUP BY public.international_debt.country_name
	ORDER BY total_debt DESC
	LIMIT 1
) AS highest_debt_country


-- Country with the lowest repayment 

SELECT *
FROM (
	SELECT public.international_debt.country_name , public.international_debt.indicator_name, public.international_debt.debt AS lowest_repayment
	FROM public.international_debt
	WHERE public.international_debt.indicator_code = 'DT.AMT.DLXF.CD'
	ORDER BY public.international_debt.debt
	LIMIT 1
) AS lowest_principal_repayment
