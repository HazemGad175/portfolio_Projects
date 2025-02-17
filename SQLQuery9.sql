--SELECT 
--    TRY_CAST(total_cases AS FLOAT) / NULLIF(TRY_CAST(total_deaths AS FLOAT), 0) AS result
--FROM CovidDeath

--select location, date, total_cases, total_deaths,
--( TRY_CAST(total_deaths AS FLOAT) / NULLIF(TRY_CAST(total_cases AS FLOAT), 0) )*100 AS DeathPercanatge
--from CovidDeath
--where location like '%states%'
--order by 1,2 desc


--select location, date,  population, total_cases,
--( TRY_CAST(total_cases AS FLOAT) / NULLIF(TRY_CAST(population AS FLOAT), 0) )*100 AS percent_Population_infected
--from CovidDeath
----where location like '%states%'
--order by 1,4 asc
------


--select location, population, max(total_cases) as Highst_infection,
--(max( TRY_CAST(total_cases AS FLOAT) / NULLIF(TRY_CAST(population AS FLOAT), 0) ))*100 AS percent_Population_infected
--from CovidDeath
----where location like '%states%'
--group by location, population
--order by percent_Population_infected desc



--select location,  max(CAST(total_deaths as int)) as total_deaths_count
--from CovidDeath
--where continent <> ''
--group by location
--order by total_deaths_count desc



select continent,  sum(CAST(total_deaths as int)) as total_deaths_count
from CovidDeath
where continent <> ''
group by continent
order by total_deaths_count desc

,-- total_cases, total_deaths, (try_cast(total_cases as float)/ nullif(try_cast(total_deaths as float),0))*100 as DeathPers
----
select date, SUM(try_cast(new_cases as float ))
from CovidDeath
where continent <> ''
group by date
order by 1,2


SELECT 
    date,  
    NULLIF(SUM(TRY_CAST(new_cases AS FLOAT)), 0) AS total_cases
FROM CovidDeath
WHERE continent <> ''
GROUP BY date 
ORDER BY date




select SUM(try_cast(new_cases as float)) as total_cases,SUM(try_cast(new_deaths as float)) as total_Deaths,
(SUM(try_cast(new_deaths as float))/ nullif(SUM(try_cast(new_cases as float)),0))*100 as Death_P_Cases
from CovidDeath
where continent <> ' '
--group by date 
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, con.new_vaccinations,
SUM(convert(int,con.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
from CovidDeath dea
join Covidconvinace  con
 on dea.location = con.location
 and dea.date =con.date
 where dea.continent <>' '
 order by 1,2,6

 ----1.00.19-----