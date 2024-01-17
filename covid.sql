Select*
From [Portfolio Project]..coviddeaths
where continent is not null


---select the data we are using from covid deaths

SELECT
    location,
    date,
    total_cases,
 new_cases,
 total_deaths,
population_density
FROM [Portfolio Project]..coviddeaths
WHERE continent IS NOT NULL

---Total cases vs total deaths
Select location, date, total_cases,total_deaths, (total_cases/population_density)*100 As percentageinfection
From [Portfolio Project]..coviddeaths
where continent is not null
order by 1,2

---looking at countries with highest infection rate compared to the population

SELECT
    location,
    MAX(population_density) as population_density,
    MAX(total_cases) as Highestinfectioncount,
    MAX((total_cases) / (population_density)) * 100 as percentagepopulationinfected
FROM [Portfolio Project]..coviddeaths
where continent is not null
GROUP BY location
ORDER BY percentagepopulationinfected desc

---showing countries with the highest death count per population
SELECT
    location,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..coviddeaths
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

--- Let us break it down by continent

SELECT
    location,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..coviddeaths
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

---Global number
SELECT
    MAX(population_density) as population_density,
    MAX(total_cases) as Highestinfectioncount,
    MAX((total_cases) / (population_density)) * 100 as percentagepopulationinfected
FROM [Portfolio Project]..coviddeaths
where continent is not null
ORDER BY percentagepopulationinfected desc

Select date, total_cases,total_deaths, (total_cases/population_density)*100 As percentageinfection
From [Portfolio Project]..coviddeaths
where continent is not null
order by 1,2

Select date, Sum(new_cases) as totalnewcases, sum(new_deaths) as totalnewdeaths, sum(new_deaths)/Sum(new_cases)*100 As deathpercentageofnewcases
From [Portfolio Project]..coviddeaths
where continent is not null
group by date
order by 1,2

---looking at total vaccination in the world
Select*
From [Portfolio Project]..coviddeaths dea
join [Portfolio Project]..vaccine vac
on dea.location= vac.location
and dea.date= vac.date

Select dea.continent, dea.location, dea.date, dea.population_density
From [Portfolio Project]..coviddeaths dea
join [Portfolio Project]..vaccine vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2, 3

Select dea.continent, dea.location, dea.date, dea.population_density
From [Portfolio Project]..coviddeaths dea
join [Portfolio Project]..vaccine vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2, 3

SELECT dea.continent, dea.location, dea.date, dea.population_density, CAST(vac.new_vaccinations AS INT) as new_vacc
FROM [Portfolio Project]..coviddeaths dea
JOIN [Portfolio Project]..vaccine vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

SELECT dea.continent, dea.location, dea.date, dea.population_density, CAST(vac.new_vaccinations AS INT) as new_vacc,
sum( CAST(vac.new_vaccinations AS INT)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinated
FROM [Portfolio Project]..coviddeaths dea
JOIN [Portfolio Project]..vaccine vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

---use cte
WITH PopvsVac (continent, Location, date, population_density, Rolling_Vaccinated)
AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population_density,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinated
    FROM 
        [Portfolio Project]..coviddeaths dea
    JOIN 
        [Portfolio Project]..vaccine vac
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
SELECT 
    continent, 
    Location, 
    date, 
    population_density, 
    Rolling_Vaccinated,
    (Rolling_Vaccinated / NULLIF(population_density, 0)) * 100 AS Vaccination_Percentage
FROM 
    PopvsVac;



	---create Tmp Table

	
DROP TABLE IF EXISTS #percentagepopulationvaccinated;

CREATE TABLE #percentagepopulationvaccinated
(
    continent NVARCHAR(255), 
    location NVARCHAR(255), 
    date DATETIME,
    population_density NUMERIC,
    new_vaccinations NUMERIC,
    Rolling_Vaccinated NUMERIC
);

INSERT INTO #percentagepopulationvaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population_density,
    CAST(vac.new_vaccinations AS INT) AS new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinated
FROM 
    [Portfolio Project]..coviddeaths dea
JOIN 
    [Portfolio Project]..vaccine vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

SELECT *, (Rolling_Vaccinated / NULLIF(population_density, 0)) * 100
FROM #percentagepopulationvaccinated;

---creating view for visualization 

create view percentagepopulationvaccinated as
 SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population_density,
    CAST(vac.new_vaccinations AS INT) AS new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinated
FROM 
    [Portfolio Project]..coviddeaths dea
JOIN 
    [Portfolio Project]..vaccine vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

	Select*
	From percentagepopulationvaccinated