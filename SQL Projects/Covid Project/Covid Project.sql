SELECT *
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- SELECT *
-- FROM covid_vacc
-- WHERE continent IS NOT NULL
-- ORDER BY location, date;

-- Select data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
WHERE location = 'United States'
ORDER BY location, date;

--Looking at the total cases vs population
--Shows what percentage of population got Covid
SELECT location, date, population, total_cases,(total_cases/population)*100 AS percent_pop_infected
FROM covid_deaths
-- WHERE location = 'United States'
WHERE continent IS NOT NULL
ORDER BY location, date;

--Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_pop_infected
FROM covid_deaths
WHERE total_cases IS NOT NULL AND population IS NOT NULL ANDontinent IS NOT NULL
GROUP BY location, population
ORDER BY percent_pop_infected desc;

-- Showing Countries with highest death count per pop
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count desc;

-- By continent/region
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE total_deaths IS NOT NULL AND continent IS NULL
GROUP BY location
ORDER BY total_death_count desc;

SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count desc;

-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
From covid_deaths
--WHERE location = 'United States'
WHERE continent IS NOT null 
--GROUP By date
ORDER BY 1, 2;



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From covid_deaths dea
JOIN covid_vacc vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null --AND dea.location = 'Canada'
ORDER BY location, date;



-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITTION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
FROM covid_deaths dea
JOIN covid_vacc vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null 
--ORDER BY 2,3
)

SELECT *, (rolling_people_vaccinated/Population)*100
FROM PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS percentPopulationVaccinated

CREATE TABLE percentPopulationVaccinated
(
continent varchar,
location varchar,
date date,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

INSERT INTO percentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
--, (RollingPeopleVaccinated/population)*100
FROM covid_deaths dea
JOIN covid_vacc vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER by location, date

SELECT *, (rolling_people_vaccinated/Population)*100
FROM percentPopulationVaccinated




-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated_VIEW AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
--, (RollingPeopleVaccinated/population)*100
FROM covid_deaths dea
JOIN covid_vacc vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER by location, date

