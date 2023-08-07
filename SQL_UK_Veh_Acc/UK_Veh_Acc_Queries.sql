--- UK Vehicle and Accident EDA using SQL
--- By SHAHIN KARAMI

--- First I clean both data sets in a jupyter notebook (see git hub repo)
--- Next I create a database, "VehicleAccident". Then, I import the CSV files to this database as tables.
--- Now, I will write 8 queries to conduct EDA and provide some insight into the data.
------------------------------------------------------------------------------------
use [VehicleAccident]
select * from [dbo].[accidents]
select * from [dbo].[vehicles]


--Question 1: How many accidents have occurred in urban areas versus rural areas? How many have occured in the Day time versus Night time?
SELECT
	[Area],
	COUNT([AccidentIndex]) AS 'Total Accident'
FROM 
	[dbo].[accidents]
GROUP BY 
	[Area];


SELECT
	[LightConditions],
	COUNT([AccidentIndex]) AS 'Total Accident'
FROM 
	[dbo].[accidents]
GROUP BY 
	[LightConditions];

--Question 2: Which day of the week has the highest number of accidents?
SELECT 
	[Day],
	COUNT([AccidentIndex]) 'Total Accident'
FROM 
	[dbo].[accidents]
GROUP BY 
	[Day]
ORDER BY 
	'Total Accident' DESC;

--Question 3: What is the average age of vehicles involved in accidents based on their type?
SELECT 
	[VehicleType], 
	COUNT([AccidentIndex]) AS 'Total Accident', 
	AVG([AgeVehicle]) AS 'Average Age'
FROM 
	[dbo].[vehicles]
WHERE 
	[AgeVehicle] IS NOT NULL
GROUP BY 
	[VehicleType]
ORDER BY 
	'Total Accident' DESC;

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
SELECT 
	VehicleAgeGroup,
	COUNT([AccidentIndex]) AS 'Total Accident',
	AVG([AgeVehicle]) AS 'Average Year'
FROM (
	SELECT
		[AccidentIndex],
		[AgeVehicle],
		CASE
			WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN '0-5 Years Old'
			WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN '6-10 Years Old'
			WHEN [AgeVehicle] BETWEEN 11 AND 15 THEN '11-15 Years Old'
			ELSE '15+ Years'
		END AS VehicleAgeGroup
	FROM [dbo].[vehicles]
) AS SubQuery
GROUP BY 
	VehicleAgeGroup;

--Question 5: Are there any specific weather conditions that contribute to fatal accidents?
DECLARE @Sevierity varchar(100)
SET @Sevierity = 'Fatal' -- Sevierity values: Serious, Fatal, Slight

SELECT 
	[WeatherConditions],
	COUNT([Severity]) AS 'Total Accident'
FROM 
	[dbo].[accidents]
WHERE 
	[Severity] = @Sevierity
GROUP BY 
	[WeatherConditions]
ORDER BY 
	'Total Accident' DESC;

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
SELECT 
	[LeftHand], 
	COUNT([AccidentIndex]) AS 'Total Accident'
FROM 
	[dbo].[vehicles]
GROUP BY 
	[LeftHand]
HAVING
	[LeftHand] IS NOT NULL

--Question 7: Are there any relationships between journey purposes and the severity of accidents?
SELECT 
	V.[JourneyPurpose], 
	COUNT(A.[Severity]) AS 'Total Accident',
	CASE 
		WHEN COUNT(A.[Severity]) BETWEEN 0 AND 15000 THEN 'Low'
		WHEN COUNT(A.[Severity]) BETWEEN 15001 AND 30000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM 
	[dbo].[accidents] A
JOIN 
	[dbo].[vehicles] V ON A.[AccidentIndex] = V.[AccidentIndex]
GROUP BY 
	V.[JourneyPurpose]
ORDER BY 
	'Total Accident' DESC;

--Question 8: Calculate the total number of accidents and average age of vehicles involved in accidents, based on wether it was day time of not and point of impact:

--- If You want to query a specific set of condition uncomment the DECLARE, SET, and HAVING script chunks
---DECLARE @Impact varchar(100)
---DECLARE @Light varchar(100)
---SET @Impact = 'Offside' --Did not impact, Nearside, Front, Offside, Back
---SET @Light = 'Darkness' --Daylight, Darkness

SELECT 
	A.[LightConditions], 
	V.[PointImpact], 
	COUNT(V.[PointImpact]) AS 'Total Accident',
	AVG(V.[AgeVehicle]) AS 'Average Vehicle Year'
	
FROM 
	[dbo].[accidents] A
JOIN 
	[dbo].[vehicles] V ON A.[AccidentIndex] = V.[AccidentIndex]
GROUP BY 
	V.[PointImpact], A.[LightConditions]
ORDER BY
	'Total Accident' DESC

---HAVING 
	---V.[PointImpact] = @Impact AND A.[LightConditions] = @Light;