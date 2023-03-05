SELECT *
FROM CovidDeathsUpdated
ORDER BY 3, 4

SELECT *
FROM CovidVacinationsUpdated


-- Total cases vs total deaths
-- Shows likliehood of death from infection
Select Location, date, total_cases, total_deaths, (cast(total_deaths as decimal)/total_cases)*100 as DeathPecentage
FROM CovidDeathsUpdated
WHERE Location LIKE '%states%'
order by 1,2

-- Looking at Total cases vs population
-- Total population getting infected
Select Location, date, total_cases, population, (cast(total_cases as decimal)/population)*100 as InfectedPopulation
FROM CovidDeathsUpdated
WHERE Location LIKE '%states%'
order by 1,2

-- Looking at countries with highest infection rate vs population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((cast(total_cases as decimal)/population))*100 as PercentPopulationInfected
FROM CovidDeathsUpdated
GROUP BY population, Location
order by PercentPopulationInfected DESC

-- Countries with the highest death count per population
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeathsUpdated
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- Broken down by Continent
SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM CovidDeathsUpdated
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Better numbers for previous query

SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeathsUpdated
WHERE continent is null
GROUP BY Location 
ORDER BY TotalDeathCount DESC

-- Global numbers
Select date, SUM(new_cases) as NewCases, SUM(new_deaths) as NewDeaths, SUM(cast(new_deaths as decimal))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeathsUpdated
WHERE continent is not NULL
GROUP BY date
ORDER BY 1, 2
-- Total population vs vacinations
SELECT dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) as RollingVax
FROM CovidDeathsUpdated dea 
JOIN CovidVacinationsUpdated vac 
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not NULL
ORDER BY 2,3

-- Total vaccination percentage
SELECT dea.Location, MAX(vac.new_vaccinations) AS TotalVaxxed
FROM CovidDeathsUpdated dea 
JOIN CovidVacinationsUpdated vac 
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not NULL AND vac.new_vaccinations is not NULL
GROUP BY dea.location

-- CTE United States vs vaccination 
WITH PopvsVax (Continent, Location, date, population, new_vaccinations, RollingVax)
as
(
SELECT dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as decimal)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) as RollingVax
FROM CovidDeathsUpdated dea 
JOIN CovidVacinationsUpdated vac 
    ON dea.Location = vac.location
    AND dea.date = vac.date
-- WHERE dea.continent is not NULL
WHERE dea.Location = 'United States'
)
SELECT *, (CONVERT(decimal, RollingVax)/population)*100 as VacinnatedPopulation
FROM PopvsVax
-- Temp TABLE
DROP TABLE IF EXISTS #PercentPopulationVaxxed
CREATE TABLE #PercentPopulationVaxxed
(
    Continent NVARCHAR(255)
    Location NVARCHAR(255)
    date DATETIME
    Population NUMERIC
    new_vaccinations NUMERIC
    RollingVax NUMERIC
)

INSERT INTO #PercentPopulationVaxxed
SELECT dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as decimal)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) as RollingVax
FROM CovidDeathsUpdated dea 
JOIN CovidVacinationsUpdated vac 
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not NULL

SELECT *, (CONVERT(decimal, RollingVax)/population)*100 as VacinnatedPopulation
FROM #PercentPopulationVaxxed

-- Create view for Vizualization
-- Comeback and make multiple
CREATE VIEW PopulationVaxxed AS
SELECT dea.Location, MAX(vac.new_vaccinations) AS TotalVaxxed
FROM CovidDeathsUpdated dea 
JOIN CovidVacinationsUpdated vac 
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not NULL AND vac.new_vaccinations is not NULL
GROUP BY dea.location

