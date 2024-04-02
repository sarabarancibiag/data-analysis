
SELECT *
FROM covid_deaths cd 
WHERE continent IS NOT NULL AND cd.continent <> ''
ORDER BY 3


SELECT cd.location , cd.date , cd.total_cases , cd.new_cases , cd.total_deaths , cd.population 
FROM covid_deaths cd 
WHERE continent IS NOT NULL AND cd.continent <> ''
ORDER BY 1,2

-- Let's take a look at total cases

SELECT cd.location , cd.date , cd.total_cases , cd.total_deaths  , (cd.total_deaths * 1.0 / cd.total_cases) * 100 AS DeathPercentage
FROM covid_deaths cd 
WHERE cd.location = "Chile"
ORDER BY 1

-- What % of the population got Covid?

SELECT cd.location , cd.date , cd.total_cases , cd.population,  (cd.total_cases * 1.0 / cd.population) * 100 AS InfectionPercentage
FROM covid_deaths cd 
WHERE cd.location = "Chile"
ORDER BY 1

-- What countries had the highest infection rate?

SELECT cd.location , cd.population, MAX(cd.total_cases) AS HighestInfection , MAX((cd.total_cases * 1.0 / cd.population) * 100) AS InfectionPercentage
FROM covid_deaths cd 
WHERE continent is not NULL AND cd.continent <> ''
GROUP BY cd.location , cd.population
ORDER BY InfectionPercentage DESC 

-- Which country had the highest DeathPercentage?

SELECT cd.location, MAX(cast (cd.total_deaths AS int)) AS TotalDeathCount
FROM covid_deaths cd
WHERE continent is not NULL AND cd.continent <> ''
GROUP BY location 
ORDER BY TotalDeathCount DESC 

-- Let's break this down by continent 

SELECT cd.continent , MAX(cast (cd.total_deaths AS int)) AS TotalDeathCount
FROM covid_deaths cd
WHERE continent is not NULL AND cd.continent <> ''
GROUP BY continent  
ORDER BY TotalDeathCount DESC

-- Global numbers

SELECT cd.date, SUM(cast(cd.new_cases as int)) , SUM(cast(cd.new_deaths AS int)), (SUM(cd.new_deaths) / SUM(cd.new_cases * 1.0) * 100) AS DeathPercentage
FROM covid_deaths cd 
WHERE continent is NOT NULL and cd.continent <> '' 
GROUP BY cd.date


-- Now, let's check vaccinations 

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
ORDER BY 2,3

-- CTE

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


-- Creating view for later

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


