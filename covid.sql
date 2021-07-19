
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
ORDER BY 3,4


SELECT * FROM PortfolioProject.dbo.CovidVaccination
ORDER BY 3,4

SELECT location, total_cases, new_cases, total_deaths, population  
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
 order by 1,2

 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
where location= 'india'
and where continent is not null
 order by 1,2

SELECT location, date, population, total_cases AS HighestInfectionCount,  (total_cases/population)*100 as PercentPopulationInfected 
FROM PortfolioProject.dbo.CovidDeaths
where location= 'india'
 order by 1,2

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected 
FROM PortfolioProject.dbo.CovidDeaths
where location= 'india'
group by location, population
 order by PercentPopulationInfected desc

 SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
where location= 'india'
where continent is not null
group by location 
 order by TotalDeathCount desc


 SELECT continent,  MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--where location= 'india'
where continent is not null
group by continent	
 order by TotalDeathCount desc

 SELECT continent,  MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
where location= 'india'
where continent is not null
group by continent
 order by TotalDeathCount desc

	 SELECT  SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths,  SUM(cast(new_deaths as int))/sum(new_cases) *100  as DeathPercentage
	FROM PortfolioProject.dbo.CovidDeaths
	where location= 'india'
	where continent is not null
 	 order by 1,2

	 select location,sum(cast(new_deaths as int)) as TotalDeathCount
	from PortfolioProject.dbo.CovidDeaths
	where continent is null
	and location not in ('world', 'European Union', 'International') 
	group by location
	order by TotalDeathCount desc

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int, vac.new_vaccinations)) 
OVER(partition by dea.location order by dea.location, dea.Date) as RollingPeoplevaccinated
from PortfolioProject.dbo.CovidDeaths  dea
Join  PortfolioProject.dbo.CovidVaccination  vac
on  dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

with PopvsVac ( continent, location, Date, population, new_vaccination, RollingPeoplevaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int, vac.new_vaccinations)) 
OVER(partition by dea.location order by dea.location, dea.Date) as RollingPeoplevaccinated
from PortfolioProject.dbo.CovidDeaths  dea	
Join  PortfolioProject.dbo.CovidVaccination  vac
on  dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3 
)
select  * ,( RollingPeoplevaccinated/population)*100
from PopvsVac


Temp table    

Drop Table if exists  #populationpercentageVaccinated
Create Table #populationpercentageVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeoplevaccinated numeric
)

Insert into #populationpercentageVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int, vac.new_vaccinations)) 
OVER(partition by dea.location order by dea.location, dea.Date) as RollingPeoplevaccinated
from PortfolioProject.dbo.CovidDeaths  dea
Join  PortfolioProject.dbo.CovidVaccination  vac
on  dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3 

select  * ,(RollingPeoplevaccinated/population)*100	
from  #populationpercentageVaccinated


Create View populationpercentageVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int, vac.new_vaccinations)) 
OVER(partition by dea.location order by dea.location, dea.Date) as RollingPeoplevaccinated
from PortfolioProject.dbo.CovidDeaths  dea
Join  PortfolioProject.dbo.CovidVaccination  vac
on  dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3 

select * from populationpercentageVaccinated