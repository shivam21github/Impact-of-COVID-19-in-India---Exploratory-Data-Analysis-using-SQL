---------------------------------------------

-- Portfolio Project 2

-- Data Exploration Using SQl
-- Analysing the Covid-19 pandemic for India

------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM PortfolioProjects..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 3, 4

SELECT location, date, people_fully_vaccinated
FROM PortfolioProjects..Covid_Vaccinations
WHERE location = 'India'
ORDER BY 2

-- Viewing only the required/necessary data

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProjects..Covid_Deaths
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1,2

------------------------------------------------------------------------------------------------------------------------------------

-- Looking at the Mortality Rate by comparing total cases and total deaths

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS case_fatality_rate
FROM PortfolioProjects..Covid_Deaths
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1,2


-- So, as of 23rd October 2021, you would have a 1.33 % chance of dying if you contracted the coronavirus, generally speaking.
-- Case fatality rate is the proportion of people who die who have tested positive for the disease. It is different from 'infection fatality rate' that is 
-- the proportion of people who die after having the infection overall; as many of these will never be picked up, this figure has to be an estimate.

-- As of 23rd October 2021, more than 4,50,00 people have died due to the coronavirus. And this is just the official number. 

------------------------------------------------------------------------------------------------------------------------------------

-- Ascertaining the infection rate

SELECT location, date, total_cases, population, ROUND((total_cases/population)*100, 3) AS infection_rate
FROM PortfolioProjects..Covid_Deaths
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1,2

-- Infection rate as of 23rd October 2021 is around 2.4 %

------------------------------------------------------------------------------------------------------------------------------------

-- Countries with highest infection rate as compared to its population

SELECT location, population, MAX(total_cases) AS highest_infection_count,  MAX(total_cases/population)*100 AS highest_infection_rate
FROM PortfolioProjects..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC

-- Countries like the US and the UK fall in the top 20

------------------------------------------------------------------------------------------------------------------------------------

-- Countries with the highest death percentage

SELECT location, population, MAX(ROUND(CAST(total_deaths AS int)/population *100, 4)) AS highest_death_percentage
FROM PortfolioProjects..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_death_percentage DESC

-- India is at the 108th position

------------------------------------------------------------------------------------------------------------------------------------

-- Now, let's bring vaccinations into the picture...
-- Joining the two tables first

SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations
FROM PortfolioProjects..Covid_Deaths AS CD
JOIN PortfolioProjects..Covid_Vaccinations AS CV
    ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
AND CD.location = 'India'
ORDER BY CD.location, CD.date

------------------------------------------------------------------------------------------------------------------------------------

-- Converting the daily vaccinations into a rolling count; or a cumulative frequency

SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, SUM(CONVERT(INT, CV.new_vaccinations)) OVER (ORDER BY CD.date) AS cumulative_vaccinations
FROM PortfolioProjects..Covid_Deaths AS CD
JOIN PortfolioProjects..Covid_Vaccinations AS CV
    ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
AND CD.location = 'India'
ORDER BY CD.location, CD.date


-- Using CTE

WITH vaccinated_population (continent, location, date, population, new_vaccinations, people_fully_vaccinated, cumulative_vaccinations) AS
(
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.people_fully_vaccinated, SUM(CONVERT(INT, CV.new_vaccinations)) OVER (ORDER BY CD.date) AS cumulative_vaccinations
FROM PortfolioProjects..Covid_Deaths AS CD
JOIN PortfolioProjects..Covid_Vaccinations AS CV
    ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.location = 'India'
AND CD.continent IS NOT NULL
)
SELECT *, (cumulative_vaccinations/population)*100 AS cumulative_vaccinations_perc, SUM(people_fully_vaccinated/population) OVER (ORDER BY date) AS fully_vaccinated_pop
FROM vaccinated_population

-- As of 23rd October 2021, around 15% people are vaccinated

------------------------------------------------------------------------------------------------------------------------------------

-- Accomplishing the same by using a TEMP table

DROP TABLE IF EXISTS #Vaccinated_Population
CREATE TABLE #Vaccinated_Population
(
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 people_fully_vaccinated numeric,
 cumulative_vaccinations numeric
 )

INSERT INTO #Vaccinated_Population
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.people_fully_vaccinated, SUM(CONVERT(INT, CV.new_vaccinations)) OVER (ORDER BY CD.date) AS cumulative_vaccinations
FROM PortfolioProjects..Covid_Deaths AS CD
JOIN PortfolioProjects..Covid_Vaccinations AS CV
    ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.location = 'India'
AND CD.continent IS NOT NULL

SELECT *, (cumulative_vaccinations/population)*100 AS cumulative_vaccinations_perc, SUM(people_fully_vaccinated/population) OVER (ORDER BY date) AS fully_vaccinated_pop
FROM #Vaccinated_Population

------------------------------------------------------------------------------------------------------------------------------------

-- Creating views for visualisind the data later

CREATE VIEW Highest_Death_Percentage AS
SELECT location, population, MAX(ROUND(CAST(total_deaths AS int)/population *100, 4)) AS highest_death_percentage
FROM PortfolioProjects..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location, population
