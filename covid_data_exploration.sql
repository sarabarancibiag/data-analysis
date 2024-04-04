
-- GENERAL DATA
-- All data ordered by country

SELECT *
FROM covid_deaths cd 
WHERE continent IS NOT NULL AND cd.continent <> ''
ORDER BY 3

-- Let's just work  with the number of cases, deaths and population

SELECT cd.location , cd.date , cd.total_cases , cd.new_cases , cd.total_deaths , cd.population 
FROM covid_deaths cd 
WHERE continent IS NOT NULL AND cd.continent <> ''
ORDER BY 1,2


-- BY COUNTRY
-- What percentage of the cases died in Chile?

SELECT cd.location , cd.date , cd.total_cases , cd.total_deaths  , (cd.total_deaths * 1.0 / cd.total_cases) * 100 AS DeathPercentage
FROM covid_deaths cd 
WHERE cd.location = "Chile"
ORDER BY 1

-- What percentage of the population in Chile got Covid?

SELECT cd.location , cd.date , cd.total_cases , cd.population,  (cd.total_cases * 1.0 / cd.population) * 100 AS InfectionPercentage
FROM covid_deaths cd 
WHERE cd.location = "Chile"
ORDER BY 1

-- Whicht 20 countries had the highest InfectionPercentage?

SELECT cd.continent , cd.location , cd.population, cd.date, MAX(cast(cd.total_cases as int)) AS HighestInfection , MAX((cd.total_cases * 1.0 / cd.population) * 100) AS InfectionPercentage
FROM covid_deaths cd 
WHERE continent is not NULL AND cd.continent <> ''
GROUP BY cd.location
ORDER BY InfectionPercentage DESC 
LIMIT 20

-- Which 20 countries had the highest DeathPercentage?

SELECT cd.location, MAX(cast (cd.total_deaths AS int)) AS TotalDeathCount
FROM covid_deaths cd
WHERE continent is not NULL AND cd.continent <> ''
GROUP BY location 
ORDER BY TotalDeathCount DESC 
LIMIT 20


-- BY CONTINENT
-- What continent had the highest number of deaths?

SELECT cd.continent , MAX(cast (cd.total_deaths AS int)) AS TotalDeathCount
FROM covid_deaths cd
WHERE continent is not NULL AND cd.continent <> ''
GROUP BY continent  
ORDER BY TotalDeathCount DESC

-- TOTAL NUMBERS 
-- Global numbers of cases and deaths (all continents)

SELECT SUM(cast(cd.new_cases as int)) as total_cases , SUM(cast(cd.new_deaths AS int)) as total_deaths, (SUM(cd.new_deaths) / SUM(cd.new_cases * 1.0) * 100) AS DeathPercentage
FROM covid_deaths cd 
WHERE continent is NOT NULL and cd.continent <> '' 


-- VACCINATIONS
-- Now, let's check vaccinations 

SELECT cd.continent ,  
		cd.location , 
		cd.population,
		cd.date, 
		cv.new_vaccinations, 
		SUM(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON cd.date = cv.date 
AND cd.location = cv.location 
WHERE cd.continent is NOT NULL and cd.continent <> ''
ORDER BY 2,3


-- VaccinationPercentage

SELECT cd.continent, 
		cd.location , 
		cd.population, 
		cd.date, 
		MAX(cast(cv.people_vaccinated as int)) AS PeopleVaccinated , 
		MAX((cv.people_vaccinated  * 1.0 / cd.population) * 100) AS VaccinationPercentage 
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON cd.date = cv.date
WHERE cv.continent is not NULL AND cd.continent <> '' AND cd.continent = "South America"
GROUP BY cd.location , cd.population, cd.date 
ORDER BY VaccinationPercentage DESC


-- Another way to get the vaccination Percentage (CTE)

WITH PopVsVac (Continent, Location, Date, Population, New_vaccinations , RollingPeopleVaccinated)
AS 
(
SELECT cd.continent , 
		cd.location , 
		cd.date, 
		cd.population, 
		cv.new_vaccinations, 
		SUM(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated 
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON cd.date = cv.date 
AND cd.location = cv.location 
WHERE cd.continent is NOT NULL and cd.continent <> '' 
)
SELECT * , (RollingPeopleVaccinated * 1.0 /Population ) * 100
FROM PopVsVac


-- To finish, let's create a view for later

CREATE VIEW ONE AS
SELECT cd.continent , 
		cd.location , 
		cd.date, 
		cd.population, 
		cv.new_vaccinations, 
		SUM(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated 
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON cd.date = cv.date 
AND cd.location = cv.location 
WHERE cd.continent is NOT NULL and cd.continent <> '' 
--ORDER BY 2,3


