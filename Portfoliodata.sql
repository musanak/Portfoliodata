 SELECT * 
from PortfolioData..Coviddeaths
--WHERE continent is not null
order by 3,4

SELECT * 
from PortfolioData..Covidvaccs
order by 3,4

--SELECT Location, date, total_cases, new_cases, total_deaths, population
--from PortfolioData..Coviddeaths
--order by 1,2

--Looking at cases vs deaths  
--Likely of dieing if covid is contracted


SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioData..Coviddeaths
WHERE location like '%states%'
order by 1,2

--Total cases vs Population

SELECT Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage
from PortfolioData..Coviddeaths
WHERE location like '%germany%'
order by 1,2

--Looking at Countries with highest infection rate compared to population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioData..Coviddeaths
--WHERE location like '%germany%'
Group by Location,Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per population

SELECT Location, Max(total_deaths) as TotalDeathCount
from PortfolioData..Coviddeaths
--WHERE location like '%Trinidad%'
WHERE continent is not null
Group by Location
order by TotalDeathCount desc

--Breaking things down by continent


SELECT continent, Max(total_deaths) as TotalDeathCount
from PortfolioData..Coviddeaths
--WHERE location like '%Trinidad%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0)*100 as DeathPercentage
from PortfolioData..Coviddeaths
--WHERE location like '%states%'
WHERE continent is not null
--Group by date
order by 1,2 

--Looking at total vaccinations vs Population

ALTER TABLE PortfolioData..Coviddeaths
ALTER COLUMN location nvarchar(150)
 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Rollingpplvaccs
FROM PortfolioData..Coviddeaths dea
JOIN PortfolioData..CovidVaccs vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--Group by dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
order by 2,3

--Use CTE

WITH PopvsVac (continent,location,date, Population,new_vaccinations, Rollingpplvaccs)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Rollingpplvaccs
FROM PortfolioData..Coviddeaths dea
JOIN PortfolioData..CovidVaccs vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
SELECT *, (Rollingpplvaccs/Population)*100
FROM PopvsVac



--Temp Table


DROP Table if exists #Percentpopvaccinated
Create Table #Percentpopvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
Rollingpplvaccs numeric
)

INSERT INTO #Percentpopvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Rollingpplvaccs
FROM PortfolioData..Coviddeaths dea
JOIN PortfolioData..CovidVaccs vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

SELECT *, (Rollingpplvaccs/Population)*100
FROM #Percentpopvaccinated


--Create view to store for later visualisation 

USE PortfolioData
GO
Create View Percentpopvaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Rollingpplvaccs
FROM PortfolioData..Coviddeaths dea
JOIN PortfolioData..CovidVaccs vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3