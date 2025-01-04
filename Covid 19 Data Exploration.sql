SELECT * FROM covid19;

---Checking the null values in the columns 

SELECT * FROM covid19
WHERE total_recovered IS NULL
   OR total_deaths IS NULL
   OR total_tests IS NULL;
   
---Deleting the null values from the columns

DELETE FROM covid19
WHERE total_recovered IS NULL
   OR total_deaths IS NULL
   OR total_tests IS NULL;
   
---Top 10 countries by confirmed cases, deaths, and recovery rates

SELECT country_region, continent, total_cases, total_deaths, total_recovered, 
ROUND((total_recovered :: NUMERIC * 100/ total_cases :: NUMERIC), 1) AS Recovery_Rate
FROM covid19
ORDER BY total_cases DESC
LIMIT 10;

---Analyze cases and deaths relative to population

SELECT country_region, population, total_cases, total_deaths,
ROUND((total_cases :: NUMERIC * 100/ population :: NUMERIC), 4) AS Cases_Percentage,
ROUND((total_deaths :: NUMERIC * 100/ population :: NUMERIC), 4) AS Deaths_Percentage
FROM covid19
ORDER BY population DESC;

---Identify countries with high testing rates but low confirmed cases

SELECT country_region, continent, tests_1mpop AS tests_per_million, total_cases_1mpop AS cases_per_million
FROM covid19
WHERE tests_1mpop > (SELECT AVG(tests_1mpop) FROM covid19)  -- Above average testing rate
  AND total_cases_1mpop < (SELECT AVG(total_cases_1mpop) FROM covid19)  -- Below average confirmed cases
ORDER BY continent DESC;

---Total Cases, Deaths, and Recoveries by Continent

SELECT continent, SUM(total_cases) AS cases, SUM(total_deaths) AS deaths, SUM(total_recovered) AS recovered
FROM covid19
GROUP BY continent 
ORDER BY cases DESC;
       
---Recovery Rate for Countries and Continents

SELECT continent, country_region,  ROUND((total_recovered :: NUMERIC * 100/ total_cases :: NUMERIC), 1) AS Recovery_Rate
FROM covid19
ORDER BY continent, recovery_rate DESC;

---Active Cases as a Percentage of Total Cases

SELECT * FROM covid19;

SELECT country_region, ROUND((active_cases :: NUMERIC *100 / total_cases), 5) AS active_cases_percentage
FROM covid19
ORDER BY active_cases_percentage DESC;

---Testing Efficiency

SELECT country_region, total_cases_1mpop, tests_1mpop 
FROM covid19
ORDER BY tests_1mpop DESC; 

---Countries with Low Testing but High Confirmed Cases

SELECT country_region, continent, tests_1mpop AS tests_per_million, total_cases_1mpop AS cases_per_million
FROM covid19
WHERE tests_1mpop < (SELECT AVG(tests_1mpop) FROM covid19)  -- Below average testing rate
  AND total_cases_1mpop > (SELECT AVG(total_cases_1mpop) FROM covid19)  -- Above average confirmed cases
ORDER BY cases_per_million DESC;

---Identify countries with high fatality rates and rank them by testing rates

WITH cte AS 
(
SELECT country_region, ROUND((total_deaths :: NUMERIC / total_cases :: NUMERIC * 100), 1) AS case_fatality_rate,
        tests_1mpop AS tests_per_million, population
FROM covid19
)
SELECT country_region, case_fatality_rate, tests_per_million, 
       RANK() OVER (ORDER BY case_fatality_rate DESC) AS fatality_rank
FROM cte
WHERE case_fatality_rate >= 10
ORDER BY fatality_rank;


---Global Situation

SELECT 'Global' AS region, SUM(total_cases) AS global_cases, SUM(total_deaths) AS global_deaths, SUM(active_cases) AS global_active_cases, SUM(total_recovered) AS global_recovered
FROM covid19;










