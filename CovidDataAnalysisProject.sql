select *
from PortifolioCovidProject.dbo.CovidDeaths
where continent is not null
order by 3,4


--select *
--from PortifolioCovidProject.dbo.CovidVaccinations
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
from PortifolioCovidProject.dbo.CovidDeaths
where continent is not null
order by 1,2


-- looking at total cases vs total deaths
-- likelihood of dying if you contract covid in your country
Select location, date, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortifolioCovidProject.dbo.CovidDeaths
where location like '%kingdom%' and continent is not null
order by 1,2


-- looking at the total cases vs population
-- shows the percentage of population got covid
Select location, date,population,total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS CasesPercentage
from PortifolioCovidProject.dbo.CovidDeaths
where location like '%kingdom%' and continent is not null
order by 1,2



-- looking at countries with highest infection rate compared to population
Select location ,population, MAX(total_cases) as HighestInfectionCount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS percentpopulationInfected
from PortifolioCovidProject.dbo.CovidDeaths

where continent is not null
Group by location, population
order by percentpopulationInfected desc


-- lets break things down by continent


-- showing continents with the highest death count per population

Select continent , MAX(cast(total_deaths as bigint)) as TotalDeathCount
from PortifolioCovidProject.dbo.CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases , SUM(cast(new_deaths as bigint)) as total_deaths ,  SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as Deathpercentage

from PortifolioCovidProject.dbo.CovidDeaths
-- where location like '%kingdom%' 
where continent is not null
group by date
order by 1,2







Select SUM(new_cases) as total_cases , SUM(cast(new_deaths as bigint)) as total_deaths ,  SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as Deathpercentage
from PortifolioCovidProject.dbo.CovidDeaths
-- where location like '%kingdom%' 
where continent is not null
--group by date
order by 1,2



-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition  by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortifolioCovidProject.dbo.CovidDeaths dea
join PortifolioCovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- using cte

with PopvsVac (continent, location, date , population ,new_vaccinations, rollingpeoplevaccinated)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition  by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortifolioCovidProject.dbo.CovidDeaths dea
join PortifolioCovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select * , (rollingpeoplevaccinated/population)*100
from PopvsVac








-- temp table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, rollingpeoplevaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition  by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortifolioCovidProject.dbo.CovidDeaths dea
join PortifolioCovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select * , (rollingpeoplevaccinated/population)*100
from #PercentPopulationVaccinated



-- creating view to store data for visualizations

USE PortifolioCovidProject
GO
Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition  by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortifolioCovidProject.dbo.CovidDeaths dea
join PortifolioCovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3



select *
from PercentPopulationVaccinated





