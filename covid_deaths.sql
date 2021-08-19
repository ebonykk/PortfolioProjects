SELECT *
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
ORDER BY 3,4

-- Select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `sqlfirstproject.covid_data.covid_deaths`
order by 1,2

--Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
FROM `sqlfirstproject.covid_data.covid_deaths`
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
SELECT location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population
SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--Showing Countries with the Highest Death Count per Population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--Break things down by continent
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--Showing continents with the highest death counts
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM `sqlfirstproject.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY date
order by 1,2

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM `sqlfirstproject.covid_data.covid_deaths` dea
JOIN `sqlfirstproject.covid_data.covid_vaccinations` vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

--USE CTE

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM `sqlfirstproject.covid_data.covid_deaths` dea
JOIN `sqlfirstproject.covid_data.covid_vaccinations` vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

