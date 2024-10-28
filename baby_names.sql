-- Use this table for the answer to question 1:
-- List the overall top five names in alphabetical order and find out if each name is "Classic" or "Trendy."

SELECT *
FROM (
    SELECT 
        baby_names.first_name, 
        SUM(baby_names.num),
        CASE
            WHEN COUNT(baby_names.year) > 50 THEN 'Classic'
            ELSE 'Trendy'
        END AS popularity_type
    FROM baby_names
    GROUP BY baby_names.first_name
    ORDER BY baby_names.first_name
) AS name_types
ORDER BY name_types.first_name
LIMIT 5;


-- Use this table for the answer to question 2:
-- What were the top 20 male names overall, and how did the name Paul rank?

SELECT 
	RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
    baby_names.first_name,
    SUM(baby_names.num) AS sum
FROM public.baby_names
WHERE baby_names.sex = 'M'
GROUP BY baby_names.first_name
ORDER BY sum DESC
LIMIT 20;


-- Use this table for the answer to question 3:
-- Which female names appeared in both 1920 and 2020?

SELECT a.first_name, (a.num + b.num) AS total_occurrences
FROM baby_names a
JOIN baby_names b
-- Join on first name
ON a.first_name = b.first_name
-- Filter for the years 1920 and 2020 and sex equals 'F'
WHERE a.year = 1920 AND a.sex = 'F'
AND b.year = 2020 AND b.sex = 'F';
	
