-- Google Data Analytics Certificate
-- Bike Sharing Case Study

-- Cleaning data using SQl queries before analysis

-- 2020-08

SELECT *
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardise the dates: started_at & ended_at

SELECT started_at, CONVERT (Date, started_at), ended_at, CONVERT (Date, ended_at)
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

ALTER TABLE ['2020#08-divvy-tripdata']
ADD started_at_date DATE,
    ended_at_date DATE;

UPDATE ['2020#08-divvy-tripdata']
SET started_at_date = CONVERT (Date, started_at),
    ended_at_date = CONVERT (Date, ended_at)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Convert the started_at & ended_at column to date format.

SELECT started_at, CONVERT (Date, started_at), ended_at, CONVERT (Date, ended_at)
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

ALTER TABLE ['2020#08-divvy-tripdata']
ADD start_date DATE,
    end_date DATE;

UPDATE ['2020#08-divvy-tripdata']
SET start_date = CONVERT (Date, started_at),
    end_date = CONVERT (Date, started_at)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardise ride_length format

SELECT ride_length,	CONVERT (time, ride_length)
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

ALTER TABLE ['2020#08-divvy-tripdata']
ADD ride_length_time TIME

UPDATE ['2020#08-divvy-tripdata']
SET ride_length_time = CONVERT (time, ride_length)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Round off to one decimal place: start_lat, start_lng, end_lat, end_lng.

SELECT start_lat, start_lng, end_lat, end_lng
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

SELECT ROUND(start_lat, 1) AS start_lat_1,  ROUND(start_lng, 1) AS start_lng_1,  ROUND(end_lat, 1) AS  end_lat_1, ROUND(end_lng, 1) AS end_lng_1
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

UPDATE ['2020#08-divvy-tripdata']
SET start_lat = ROUND(start_lat, 1),
    start_lng =  ROUND(start_lng, 1),
	end_lat = ROUND(end_lat, 1),
	end_lng = ROUND(end_lng, 1) 


-- Combine start_lat and start_lng into one column. Do the same for end_lat and end_lng.

SELECT *,
CONCAT (start_lat, ' , ', start_lng),
CONCAT (end_lat, ' , ', end_lng)
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']

ALTER TABLE ['2020#08-divvy-tripdata']
ADD start_location TEXT, 
    end_location TEXT

UPDATE ['2020#08-divvy-tripdata']
SET start_location = CONCAT (start_lat, ' , ', start_lng),
    end_location = CONCAT (end_lat, ' , ', end_lng)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  Remove columns which are not required.

ALTER TABLE ['2020#08-divvy-tripdata']
DROP COLUMN started_at, ended_at, ride_length, start_lat, start_lng, end_lat, end_lng

ALTER TABLE ['2020#08-divvy-tripdata']
DROP COLUMN start_date, end_date



-- Basic data exploration
-- Running some simple summary statistics

-- The MAX of ride_length_time

SELECT MAX(ride_length_time)
FROM PortfolioProjects.dbo.['2020#12-divvy-tripdata']

-- The AVERAGE of ride_length_time

SELECT cast(cast(avg(cast(CAST(ride_length_time as datetime) as float)) as datetime) as time) AvgTime
FROM PortfolioProjects.dbo.['2020#12-divvy-tripdata']


-- The MODE of day_of_week

SELECT COUNT(DISTINCT(day_of_week))
FROM PortfolioProjects.dbo.['2020#12-divvy-tripdata']
GROUP BY day_of_week

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Cleaning and exploration for other tables was done seperately
-- To have a full year view now, combining the data of all the months together


-- Combining the records from all the tables
-- Applying the UNION function

SELECT *
FROM PortfolioProjects.dbo.['2020#08-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2020#09-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2020#10-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2020#11-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2020#12-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#01-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#02-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#03-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#04-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#05-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#06-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#07-divvy-tripdata']
UNION ALL
SELECT *
FROM PortfolioProjects.dbo.['2021#08-divvy-tripdata']