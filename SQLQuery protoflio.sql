select * from [Portfolio Project].[dbo].[CovidDeaths]
select * from [Portfolio Project].[dbo].[CovidVaccinations]


-- Select Data that we are going to be starting with
Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].[dbo].[CovidDeaths]
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project].[dbo].[CovidDeaths]
Where location like '%EGYPT%'
and continent is not null 
order by 1,2


--Count total cases in my country Egypt
SELECT COUNT(*)
FROM [Portfolio Project].[dbo].[CovidDeaths]
WHERE  location = 'Egypt';

--get the number of rotal cases and death of covid for my country Egypt
SELECT sum([total_cases])as total_cases,sum(CAST([total_deaths]as float))as [total_deaths]
FROM[Portfolio Project].[dbo].[CovidDeaths]
--where continent is not null 
where location = 'Egypt';

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project].[dbo].[CovidDeaths]
Where location like 'Egypt'
and continent is not null 
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project].[dbo].[CovidDeaths]
Where location like 'Egypt'
order by 1,2

-- Countries with Highest Infection Rate compared to Population
Select Location,date, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project].[dbo].[CovidDeaths]
--Where location like 'Egypt'
Group by Location, Population,date
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].[dbo].[CovidDeaths]
--Where location like 'Egypt'
Where  continent is not null 
Group by Location
order by TotalDeathCount desc

-- show continent
Select continent From [Portfolio Project].[dbo].[CovidDeaths]
Where continent is not null 
Group by continent

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].[dbo].[CovidDeaths]
--Where location like '%egy%'
where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [Portfolio Project].[dbo].[CovidDeaths]
--Where location like '%egypt%'
Where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project].[dbo].[CovidDeaths] dea
Join [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--The common table expression (CTE) is a powerful construct in SQL that helps simplify a query.
--CTEs work as virtual tables (with records and columns), created during the execution of a query, used by the query, and eliminated after query execution. 
--CTEs often act as a bridge to transform the data in source tables to the format expected by the query.
-- Using CTE to perform Calculation on Partition By in previous query
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project].[dbo].[CovidDeaths] dea
Join [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
 
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Anthor way 
-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project].[dbo].[CovidDeaths] dea
Join [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as percentageRollingPeopleVaccinated
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinate as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project].[dbo].[CovidDeaths] dea
Join [Portfolio Project].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select  * from PercentPopulationVaccinate
