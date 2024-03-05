--CREATE A TABLE FOR COVIDDEATHS

CREATE TABLE coviddeaths(
    iso_code VARCHAR(50),
	continent	VARCHAR(50),
	place VARCHAR(50),	
	dateofdata	DATE,
	population	numeric,
	total_cases	numeric,
	new_cases	numeric,
	new_cases_smoothed	numeric,
	total_deaths	numeric,
	new_deaths	numeric,
	new_deaths_smoothed	numeric,
	total_cases_per_million	numeric,
	new_cases_per_million	numeric,
	new_cases_smoothed_per_million	numeric,
	total_deaths_per_million numeric,	
	new_deaths_per_million	numeric,
	new_deaths_smoothed_per_million	numeric,
	reproduction_rate	numeric,
	icu_patients	numeric,
	icu_patients_per_million	numeric,
	hosp_patients	numeric,
	hosp_patients_per_million	numeric,
	weekly_icu_admissions	numeric,
	weekly_icu_admissions_per_million numeric,	
	weekly_hosp_admissions numeric,	
	weekly_hosp_admissions_per_million numeric
)

--COPY DATA FROM EXCEL TO TABLE

COPY covidDEATHS FROM 'C:\Repos\DataAnalysis\portfolioprojects\CovidDeaths.csv' DELIMITER ',' CSV HEADER;

SELECT *FROM coviddeaths

----CREATE A TABLE FOR COVIDDEATHS

CREATE TABLE covidvaccines (
    iso_code VARCHAR(50),
	continent	VARCHAR(50),
	place VARCHAR(50),	
	dateofdata	DATE,
	population	numeric,
	new_tests	numeric,
	total_tests	numeric,
	total_tests_per_thousand numeric,	
	new_tests_per_thousand	numeric,
	new_tests_smoothed	numeric,
	new_tests_smoothed_per_thousand	numeric,
	positive_rate numeric,
	tests_per_case	numeric,
	tests_units	varchar(50),
	total_vaccinations	numeric,
	people_vaccinated	numeric,
	people_fully_vaccinated	numeric,
	new_vaccinations	numeric,
	new_vaccinations_smoothed	numeric,
	total_vaccinations_per_hundred	numeric,
	people_vaccinated_per_hundred	numeric,
	people_fully_vaccinated_per_hundred numeric,
	new_vaccinations_smoothed_per_million numeric,
	stringency_index	numeric,
	population_density	numeric,
	median_age	numeric,
	aged_65_older	numeric,
	aged_70_older	numeric,
	gdp_per_capita	numeric,
	extreme_poverty	numeric,
	cardiovasc_death_rate	numeric,
	diabetes_prevalence numeric,
	female_smokers	numeric,
	male_smokers	numeric,
	handwashing_facilities	numeric,
	hospital_beds_per_thousand	numeric,
	life_expectancy	numeric,
	human_development_index numeric
)

--COPY DATA FROM EXCEL TO TABLE

COPY covidvaccines FROM 'C:\Repos\DataAnalysis\portfolioprojects\Covidvaccination.csv' DELIMITER ',' CSV HEADER;

SELECT *FROM covidvaccines

----------------------------------------SOME DATA ANALYSIS-----------------------------------------

-----------LOOKING TOTAL COVID CASES VS TOTAL COVID DEATHS BASED ON COUNTRY AND DATE-----------

SELECT  place, dateofdata, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT null 
ORDER BY 1,2

---------TOTAL COVID CASE VS TOTAL COVID DEATHS ON EACH DATE IN UNITED STATESS--------------------

SELECT  place, dateofdata, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE LOWER(place) LIKE '%states%'
AND continent IS NOT NULL
order by 1,2

----------LOOKING AT COUTRIES WITH HIGHEST COVID INFECTION RATE COMPARED TO POPULATION-------------

SELECT  place AS Country,MAX(total_cases) AS InfectioCount,MAX(total_cases/population) as InfectionRate
FROM CovidDeaths
WHERE continent IS NOT null 
GROUP BY place ORDER BY 3 DESC

-----------------LOOKING AT COUTRIES WITH HIGHEST COVID DEATH COUNT----------------------------

SELECT  place AS Country,MAX(total_deaths) AS DeathCount
FROM CovidDeaths
WHERE continent IS NOT null 
GROUP BY place HAVING MAX(total_deaths) IS NOT NULL ORDER BY 2 DESC 

--optimized version of above query. filether the data before applying aggregrate
SELECT place AS Country, MAX(total_deaths) AS DeathCount
FROM CovidDeaths
WHERE continent IS NOT null AND total_deaths IS NOT NULL
GROUP BY place
ORDER BY DeathCount DESC;

SELECT  place AS Country,MAX(total_deaths) AS DeathCount,MAX(total_deaths/population) AS DeathRate
FROM CovidDeaths
WHERE continent IS NOT null 
GROUP BY place ORDER BY 3 DESC

-----------------CONTINENT WITH HIGHEST DEATH COUNT---------------------------------------

SELECT  continent AS Continent,sum(new_deaths) AS DeathCount
FROM CovidDeaths
WHERE continent IS NOT null 
GROUP BY continent ORDER BY 2 DESC LIMIT 1

--TO SHOW THE CONTINENT ONLY

SELECT continent
FROM CovidDeaths
WHERE continent IS NOT null
GROUP BY continent
ORDER BY SUM(new_deaths) DESC
LIMIT 1;

 --DATA IS NOT CLEANED.PLACE(COUNTRY) COLUMN HAS A ENTRY FOR CONTINENT TOO.
--AND CONTINENT FIELD HAS SOME WRONG VALUES.

--EACH CONTINENT HAS DIFFRENT COUTRY ENTRIES. EACH COUNTRY HAS COVID CASEES ON FIFFERENT DATES.
--BEST WAY TO APPROACH IS FINE THE MAX COVID CASE IN EACH COUTRY AND SUM THE VALUES GROUP BY CONTINENT.
WITH ContinentDeath AS (
    SELECT 
        continent,
        place,
        MAX(total_deaths) AS maxdeathincountry 
    FROM 
        CovidDeaths 
    WHERE 
        continent IS NOT NULL  
    GROUP BY 
        continent, 
        place 
    HAVING 
        MAX(total_deaths) IS NOT NULL
)
SELECT 
    continent,
    SUM(maxdeathincountry) AS maxdeathincontinent 
FROM 
    ContinentDeath 
GROUP BY 
    continent 
ORDER BY 
    maxdeathincontinent DESC;
	
	
----------------- GLOBAL NUMBERS-COVIND DEATH PERCENTAGE GLOBALLY ON DAILY BASIS-----------------

SELECT dateofdata AS date,SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
SUM(new_deaths)/SUM(New_Cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT  null 
GROUP BY dateofdata HAVING SUM(new_cases) IS NOT NULL
ORDER BY 4 DESC

---------------------OVERALL GLOBAL DEATH PERCENTAGE------------------------------

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
SUM(new_deaths)/SUM(New_Cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT null 
ORDER BY 3 DESC


----------------- FIND THE TOTAL SUM OF PEOPLE VACCINATED ON EVERY DAY-----------------------------------
------------------SHOW THE PERCENTAGE OF PEOPLE VACCINATED ON EVERYDAY-----------------------------------


SELECT d.continent, d.place, d.dateoFdata, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.place ORDER BY d.place, d.dateofdata) as RollingPeopleVaccinated
FROM coviddeaths d
JOIN covidvaccines v
	ON d.place = v.place
	AND d.dateofdata = v.dateofdata
WHERE d.continent is not null 
ORDER BY 2,3

--USING CTE

WITH sumofpeoplevaccinatedeveryday(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS(
	SELECT d.continent, d.place, d.dateoFdata, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.place ORDER BY d.place, d.dateofdata) as RollingPeopleVaccinated
FROM coviddeaths d
JOIN covidvaccines v
	ON d.place = v.place
	AND d.dateofdata = v.dateofdata
WHERE d.continent is not null 
ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS percentageofvaccination
FROM sumofpeoplevaccinatedeveryday

--USING TEMP TABLE

DROP TABLE IF EXISTS PercentPopulationVaccinated
CREATE TEMP TABLE PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO PercentPopulationVaccinated (
	SELECT d.continent, d.place, d.dateoFdata, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.place ORDER BY d.place, d.dateofdata) as RollingPeopleVaccinated
FROM coviddeaths d
JOIN covidvaccines v
	ON d.place = v.place
	AND d.dateofdata = v.dateofdata
WHERE d.continent is not null 
ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS percentageofvaccination
FROM PercentPopulationVaccinated

--

CREATE TEMP TABLE PercentPopulationVaccinatedCOPY AS (
SELECT d.continent, d.place, d.dateoFdata, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.place ORDER BY d.place, d.dateofdata) as RollingPeopleVaccinated
FROM coviddeaths d
JOIN covidvaccines v
	ON d.place = v.place
	AND d.dateofdata = v.dateofdata
WHERE d.continent is not null 
ORDER BY 2,3)

SELECT *FROM PercentPopulationVaccinatedCOPY


--CREATE A VIEW

CREATE VIEW PercentPopulationVaccinated AS 
SELECT d.continent, d.place, d.dateoFdata, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.place ORDER BY d.place, d.dateofdata) as RollingPeopleVaccinated
FROM coviddeaths d
JOIN covidvaccines v
	ON d.place = v.place
	AND d.dateofdata = v.dateofdata
WHERE d.continent is not null 
ORDER BY 2,3

SELECT *FROM PercentPopulationVaccinated

