select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..Coviddeaths
where continent is not null
order by 1,2


--Total cases vs Total deaths in India

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..Coviddeaths
--where location like '%india%'
where continent is not null
order by 1,2

-- Looking at Total cases vs population
-- Shows what %age of population got covid

select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..Coviddeaths
--where location like '%india%'
where continent is not null
order by 1,2

-- Looking at countries with highest infection rate compared to the population

select location,population,max (total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..Coviddeaths
--where location like '%india%'
where continent is not null
group by location,population
order by PercentPopulationInfected desc

-- Showing countries with the Highest Death Rates per population

select location, max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..Coviddeaths
--where location like '%india%'
where continent is not null
group by location
order by TotalDeathCount desc


--Lets break things down by continent
-- Showing continents with the Highest death counts per population


select continent, max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..Coviddeaths
--where location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers


select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..Coviddeaths
--where location like '%india%'
where continent is not null
--group by date
order by 1,2 

-- Looking at total population vs vaccination


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


--Use CTE


With PopvsVac (continent, location, date, population,new_vaccinations, PeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *,(PeopleVaccinated/population)*100 from PopvsVac

-- Temp table


drop table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
PeopleVaccinated numeric
)
insert into #PercentPeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 1,2,3
select *,(PeopleVaccinated/population)*100 from #PercentPeopleVaccinated

-- Creating view to store data for visualizations

create view #PercentPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3














