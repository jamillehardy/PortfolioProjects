Select *
From PortfolioProject4.dbo.CovidDeaths4


Select *
From PortfolioProject4.dbo.CovidDeaths4
Order by 3,4


Select *
From PortfolioProject4.dbo.CovidVaccinations4


Select *
From PortfolioProject.dbo.CovidVaccinations
Order by 3,4



              --SELECT DATA THAT WE ARE GOING TO BE USING--

Select location, date,total_cases, new_cases, total_deaths, population
From PortfolioProject4.dbo.CovidDeaths4
Order by 1,2


              --LOOKING AT TOTAL CASES VS TOTAL DEATHS--
			  --Shows likihood of dying if you contract covid in your courtry
			  --Invalid for divide operator

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
--From PortfolioProject4.dbo.CovidDeaths4
--Order by 1,2


--Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
--From PortfolioProject4.dbo.CovidDeaths4
--Where location like '%states%'
--Order by 1,2




               --LOOKING AT TOTAL CASES VS POPULATION--
			   --Shows what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population) * 100 as DeathPercentage
From PortfolioProject.dbo.CovidVaccinations
Where location like '%states%'
Order by 1,2

								--Looking at Countries with Highest Infection Rate
								--Compared to Population

Select Location, Population, Max(Total_cases) as HighestInfectionCount, Max(total_cases/population) * 100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidVaccinations
Where location like '%states%'
Group by location, population
Order by 1,2


								--Showing Countries with Highest Death Count Per Population


Select location, max(total_deaths) as totaldeathcount
From PortfolioProject4..CovidDeaths4
--where location like '%states%'
where continent is not null
Group by location
--order by totaldeathcount desc





								 --LET'S BREAK THINGS DOWN BY CONTINENT--

Select Continent, Max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject4.dbo.CovidDeaths4
		--Where location like '%states%'
Where continent is not null
Group by continent
Order by totaldeathcount desc


Select location, Max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject4.dbo.CovidDeaths4
   --Where location like '%states%'
      Where Continent is null
   Group by location
   Order by totaldeathcount desc
   
                 --SHOWING CONTINENTS WITH THE HIGHSET DEATH COUNT PER POPULATION--
                                    --GLOBAL NUMBERS--

--Select date, Sum(new_cases) as total_cases,
--				Sum(cast(new_deaths as int)) as total_deaths,
--				Sum(cast(new_deaths as int)) / SUM(New_Cases)*100 as DeathPercentage 

--From PortfolioProject4.dbo.CovidDeaths4
----Where location like '%states%'
--Where continent is not  null
--Group by date
--Order by 1,2
----Note: Divide by zero error message, Warning: Null value is eliminated


                                 --NOTE:LEAVE OUT DATE

Select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int)) / sum(new_cases) * 100 as DeathPercentage

From PortfolioProject.dbo.CovidDealths
--Where location like '%states%'
Where continent is not null
--Group by date
Order by 1,2

                                       
									   --REFRESH MEMORY
Select *
From PortfolioProject..CovidVaccinations

                                       --JOINING TABLES
Select *
From PortfolioProject4..CovidDeaths4 dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

                                      --LOOKING AT TOTAL POPULATION VS VACCINATIONS
Select dea.continent, dea.location, dea.date, vac.new_vaccinations
From PortfolioProject4..CovidDeaths4 dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

                                         
										 --57 MARK
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--		sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date)
--From PortfolioProject4..CovidDeaths4 dea
--Join PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location
--Where dea.continent is not null
--Order by 2,3

                                        --USE CTE
										--QUERY COMPLETED WITH ERROR MESSAGE

With PopvsVac(Continent, Location, Date, population, New_Vaccinations, RollingPoepleVaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.date)
		as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population) * 100
From PortfolioProject4..CovidDeaths4 dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *
From PopvsVac

										--TEMP TABLE
										--ERROR MESSAGE: CAN NOT FIGURE OUT PROBLEM

--Drop table if exists #PercentPopulationVaccinated
--Create table #PercentPopulationVaccinated
--(
--Continent nvarchar (255),
--Location nvarchar (255),
--Date datetime,
--Population numeric,
--New_vaccinated numeric
--)
--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population,
--vac.new_vaccinations, sum(convert(int, vac.new_vaccinations))
--over (Partition by dea.location order by dea.location,
--dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/Population) * 100
--From PortfolioProject4..CovidDeaths4 dea
--Join PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
----Where dea.continent is not null
----order by 2,3

--Select *, (RollingPeopleVaccinated/Population)*100
--From  #PercentPopulationVaccinated



                                      --CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS
									  --Ran but still could not view after refreshing in View
									  --Warning: Null value is eliminated by an aggregate or other SET operations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations))
	over (Partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated / Population) * 100
From PortfolioProject4..CovidDeaths4 dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
		--order by 2,3


								--Query completed with error message
	Select *
	From PercentPopulationVaccinated



												--Me Creating Views	


Create View CountriesTotalDe3athCount as
Select location, max(total_deaths) as totaldeathcount
From PortfolioProject4..CovidDeaths4
--where location like '%states%'
where continent is not null
Group by location
--order by totaldeathcount desc


Select *
From CountriesTotalDe3athCount




Create View ContinentTotalDeathCount as
Select Continent, Max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject4.dbo.CovidDeaths4
		--Where location like '%states%'
Where continent is not null
Group by continent
--Order by totaldeathcount desc

Select *
From ContinentTotalDeathCount