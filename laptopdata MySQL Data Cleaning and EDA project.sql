SELECT * 
FROM data_cleaning_datasets.laptopdata;

CREATE TABLE laptop_temp
LIKE laptopdata;

SELECT *
FROM data_cleaning_datasets.laptop_temp;

INSERT laptop_temp
SELECT *
FROM laptopdata;

SELECT *
FROM laptop_temp;

SELECT 
    ROW_NUMBER() OVER (
        PARTITION BY Laptop_Company, Laptop_TypeName, Laptop_Inches, Laptop_ScreenResolution, Laptop_Cpu, Laptop_Ram, Laptop_Memory, Laptop_Gpu, Laptop_OpSys, Laptop_Weight, Laptop_Price
        ORDER BY Laptop_Price DESC
    ) AS RowNumber,
    Laptop_Company, 
    Laptop_TypeName, 
    Laptop_Inches, 
    Laptop_ScreenResolution, 
    Laptop_Cpu, 
    Laptop_Ram, 
    Laptop_Memory, 
    Laptop_Gpu, 
    Laptop_OpSys, 
    Laptop_Weight, 
    Laptop_Price
FROM laptop_temp;

-- Below syntax finds any record with > 1 as rowNumber should be deemed as a duplicate
WITH duplicate_cte AS 
(
SELECT 
    ROW_NUMBER() OVER (
        PARTITION BY Laptop_Company, Laptop_TypeName, Laptop_Inches, Laptop_ScreenResolution, Laptop_Cpu, Laptop_Ram, Laptop_Memory, Laptop_Gpu, Laptop_OpSys, Laptop_Weight, Laptop_Price
        ORDER BY Laptop_Price DESC
    ) AS RowNumber,
    Laptop_Company, 
    Laptop_TypeName, 
    Laptop_Inches, 
    Laptop_ScreenResolution, 
    Laptop_Cpu, 
    Laptop_Ram, 
    Laptop_Memory, 
    Laptop_Gpu, 
    Laptop_OpSys, 
    Laptop_Weight, 
    Laptop_Price
FROM laptop_temp
)
SELECT *
FROM duplicate_cte
WHERE RowNumber > 1;

CREATE TABLE `laptop_temp2` (
  `Laptop_Company` text,
  `Laptop_TypeName` text,
  `Laptop_Inches` double DEFAULT NULL,
  `Laptop_ScreenResolution` text,
  `Laptop_Cpu` text,
  `Laptop_Ram` text,
  `Laptop_Memory` text,
  `Laptop_Gpu` text,
  `Laptop_OpSys` text,
  `Laptop_Weight` text,
  `Laptop_Price` double DEFAULT NULL,
  `RowNumber` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM laptop_temp2;

INSERT INTO laptop_temp2 (
    RowNumber, 
    Laptop_Company, 
    Laptop_TypeName, 
    Laptop_Inches, 
    Laptop_ScreenResolution, 
    Laptop_Cpu, 
    Laptop_Ram, 
    Laptop_Memory, 
    Laptop_Gpu, 
    Laptop_OpSys, 
    Laptop_Weight, 
    Laptop_Price
)
SELECT 
    ROW_NUMBER() OVER (
        PARTITION BY Laptop_Company, Laptop_TypeName, Laptop_Inches, Laptop_ScreenResolution, Laptop_Cpu, Laptop_Ram, Laptop_Memory, Laptop_Gpu, Laptop_OpSys, Laptop_Weight, Laptop_Price
        ORDER BY Laptop_Price DESC
    ) AS RowNumber,
    Laptop_Company, 
    Laptop_TypeName, 
    Laptop_Inches, 
    Laptop_ScreenResolution, 
    Laptop_Cpu, 
    Laptop_Ram, 
    Laptop_Memory, 
    Laptop_Gpu, 
    Laptop_OpSys, 
    Laptop_Weight, 
    Laptop_Price
FROM laptop_temp;

-- Counting the number of duplicates found
SELECT COUNT(Laptop_Company)
FROM laptop_temp2
WHERE RowNumber > 1;

SELECT *
FROM laptop_temp2
WHERE RowNumber > 1;

-- Deleting duplicate records
DELETE
FROM laptop_temp2
WHERE RowNumber > 1;

SELECT *
FROM laptop_temp2;

-- Data Standardization
SELECT Laptop_Company, Laptop_TypeName, Laptop_Inches, Laptop_ScreenResolution, 
		Laptop_Cpu, Laptop_Ram, Laptop_Memory, Laptop_Gpu, Laptop_OpSys, Laptop_Weight, Laptop_Price,
		TRIM(Laptop_Company), TRIM(Laptop_TypeName), TRIM(Laptop_Inches), TRIM(Laptop_ScreenResolution), 
        TRIM(Laptop_Cpu), TRIM(Laptop_Ram), TRIM(Laptop_Memory), TRIM(Laptop_Gpu), TRIM(Laptop_OpSys), 
        TRIM(Laptop_Weight), TRIM(Laptop_Price)
FROM laptop_temp2;

UPDATE laptop_temp2
SET Laptop_Company = TRIM(Laptop_Company), Laptop_TypeName = TRIM(Laptop_TypeName), 
	Laptop_Inches = TRIM(Laptop_Inches), Laptop_ScreenResolution = TRIM(Laptop_ScreenResolution), 
	Laptop_Cpu = TRIM(Laptop_Cpu), Laptop_Ram = TRIM(Laptop_Ram), Laptop_Memory = TRIM(Laptop_Memory), 
    Laptop_Gpu = TRIM(Laptop_Gpu), Laptop_OpSys = TRIM(Laptop_OpSys), 
    Laptop_Weight = TRIM(Laptop_Weight), Laptop_Price = TRIM(Laptop_Price);

SELECT *
FROM laptop_temp2
WHERE Laptop_Weight LIKE '4kg%' OR Laptop_Weight LIKE '0.920%' OR Laptop_OpSys LIKE 'Mac OS X%' OR Laptop_Memory LIKE '1.0TB HDD%';

UPDATE laptop_temp2
SET 
	Laptop_weight = '4.0kg'
WHERE 
    Laptop_Weight LIKE '4kg%';
UPDATE laptop_temp2
SET 
	Laptop_weight = '0.92kg'
WHERE 
    Laptop_Weight LIKE '0.920kg%';
UPDATE laptop_temp2
SET 
	Laptop_OpSys = 'macOS X'
WHERE 
    Laptop_OpSys LIKE 'Mac OS X%';
UPDATE laptop_temp2
SET 
	Laptop_Memory = '1TB HDD'
WHERE 
    Laptop_Weight LIKE '1.0TB HDD%';
  
SELECT *
FROM laptop_temp2
WHERE Laptop_Memory LIKE '?%';

SELECT *
FROM laptop_temp2
WHERE Laptop_Company LIKE 'Dell%' AND Laptop_Ram LIKE '16GB%' AND Laptop_Gpu LIKE 'AMD Radeon R7 M445%' AND Laptop_Cpu LIKE 'Intel Core i7 7500U 2.7GHz%';

UPDATE laptop_temp2
SET  Laptop_Memory = '1TB HDD'
WHERE Laptop_Memory LIKE '?%';

-- Setting the Price column to 2 decimal places for consistency
UPDATE laptop_temp2
SET Laptop_Price = ROUND(laptop_price, 2);

SELECT DISTINCT(Laptop_Price)
FROM laptop_temp2;

SELECT *, FORMAT(Laptop_Price, 2) AS Laptop_Price
FROM laptop_temp2;

ALTER TABLE laptop_temp2
DROP Standardized_Price;

SELECT *
FROM laptop_temp2;

UPDATE laptop_temp2
SET Laptop_Inches = ROUND(laptop_Inches, 2);

SELECT *
FROM laptop_temp2
WHERE 11 IS NULL;

ALTER TABLE laptop_temp2
DROP RowNumber;

SELECT *
FROM laptop_temp2;

-- Performing Exploratory Data Analysis (EDA)

-- A. Dataset Summary

-- 1. The Distribution of Laptop Prices
SELECT MAX(Laptop_Price) as maxPrice,
		MIN(Laptop_Price) as minPrice,
        AVG(Laptop_Price) as avgPrice
FROM laptop_temp2;

-- Grouping Prices into Bins
SELECT 
    CASE 
        WHEN Laptop_Price BETWEEN 0 AND 75000 THEN 'A' -- 900 laptops
        WHEN Laptop_Price BETWEEN 75001 AND 150000 THEN 'B' -- 315 laptops
        WHEN Laptop_Price BETWEEN 150001 AND 225000 THEN 'C' -- 24 laptops
        WHEN Laptop_Price > 225001 THEN 'D' -- 4 laptops
    END AS Price_Range,
    COUNT(*) AS Number_Of_Laptops,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Laptop_temp2) AS Percentage_of_Total
FROM laptop_temp2
GROUP BY Price_Range;

CREATE TABLE laptop_prices_bin (
    Price_Range VARCHAR(50),
    Number_Of_Laptops INT,
    Percentage_of_Total FLOAT
);

INSERT INTO laptop_prices_bin (Price_Range, Number_Of_Laptops, Percentage_Of_Total)
SELECT 
    CASE 
        WHEN Laptop_Price BETWEEN 0 AND 75000 THEN 'A'
        WHEN Laptop_Price BETWEEN 75001 AND 150000 THEN 'B'
        WHEN Laptop_Price BETWEEN 150001 AND 225000 THEN 'C'
        WHEN Laptop_Price > 225001 THEN 'D'
    END AS Price_Range,
    COUNT(*) AS Number_Of_Laptops,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Laptop_temp2) AS Percentage_Of_Total
FROM laptop_temp2
GROUP BY Price_Range;

SELECT *
FROM laptop_temp2;

-- 2. What are the most common laptop companies and types

-- a. Top 5 most common laptop companies
SELECT 
    Laptop_Company, 
    COUNT(*) AS Count
FROM 
    laptop_temp2
GROUP BY 
    Laptop_Company
ORDER BY 
    Count DESC
   LIMIT 5;
   
-- b. Top 5 most common laptop types
SELECT 
	Laptop_TypeName,
    COUNT(*) AS Count
FROM laptop_temp2
GROUP BY Laptop_TypeName
ORDER BY Count DESC
LIMIT 5;

-- 2. Top 10 most common laptop companies by types
SELECT Laptop_Company,
		Laptop_TypeName,
        COUNT(*) AS Count
FROM laptop_temp2
GROUP BY Laptop_Company,
		Laptop_TypeName
ORDER BY Count DESC
LIMIT 10;

CREATE TABLE top10_laptop_types (
    laptopCompany VARCHAR(50),
    laptopType VARCHAR(50),
    laptopCount INT
);

INSERT INTO top10_laptop_types (laptopCompany, laptopType, laptopCount)
SELECT Laptop_Company,
		Laptop_TypeName,
        COUNT(*) AS Count
FROM laptop_temp2
GROUP BY Laptop_Company,
		Laptop_TypeName
ORDER BY Count DESC
LIMIT 10;

SELECT *
FROM top10_laptop_types;

-- 3. Which is the most common laptop screen resolution
SELECT Laptop_Company,
		Laptop_ScreenResolution,
		COUNT(*) Count
FROM laptop_temp2
GROUP BY Laptop_Company,
		Laptop_ScreenResolution
ORDER BY Count DESC
LIMIT 10;

CREATE TABLE top10common_screenResolution (
			company VARCHAR(50),
            screenResolution VARCHAR(50),
            count INT
);
INSERT INTO top10common_screenResolution (company, screenResolution, count)
SELECT Laptop_Company,
		Laptop_ScreenResolution,
		COUNT(*) Count
FROM laptop_temp2
GROUP BY Laptop_Company,
		Laptop_ScreenResolution
ORDER BY Count DESC
LIMIT 10;

SELECT *
FROM top10common_screenresolution;

-- B. Relationship between variables

-- 1. How does RAM affect laptop Price
SELECT Laptop_Ram AS RAM,
		AVG(Laptop_Price) AS AvgPrice,
        COUNT(*) AS Count
FROM Laptop_temp2
GROUP BY 
	Laptop_Ram
ORDER BY
	AvgPrice DESC;

CREATE TABLE laptopRAMbyPrice (
		RAM VARCHAR (50),
        AvgPrice FLOAT,
        Count INT
);
INSERT INTO laptopRAMbyPrice (RAM, AvgPrice, Count)
SELECT Laptop_Ram AS RAM,
		AVG(Laptop_Price) AS AvgPrice,
        COUNT(*) AS Count
FROM Laptop_temp2
GROUP BY 
	Laptop_Ram
ORDER BY
	AvgPrice DESC;
    
SELECT *
FROM laptoprambyprice;

-- 2. Is there a relationship between CPU type and laptop performance (e.g., price, weight)?
SELECT Laptop_Cpu,
		AVG(Laptop_Price) AS AvgPrice,
        AVG(Laptop_Weight) AvgWeight,
        COUNT(*) AS count
FROM laptop_temp2
GROUP BY 
	Laptop_Cpu
ORDER BY
	AvgPrice DESC;

CREATE TABLE laptopPerformance (
	laptopCPU VARCHAR (100),
    AvgPrice FLOAT,
    AVgWeight FLOAT,
    Count INT
);
INSERT INTO laptopPerformance (laptopCPU, AvgPrice, AvgWeight, Count)
SELECT Laptop_Cpu,
		AVG(Laptop_Price) AS AvgPrice,
        AVG(Laptop_Weight) AvgWeight,
        COUNT(*) AS count
FROM laptop_temp2
GROUP BY 
	Laptop_Cpu
ORDER BY
	AvgPrice DESC;

SELECT *
FROM laptopPerformance;

-- How does Screen resolution impacts Sales Price
SELECT Laptop_ScreenResolution AS screenResolution,
		AVG(Laptop_Price) AS AvgPrice,
        COUNT(*) AS Count
FROM laptop_temp2
GROUP BY 
	screenResolution
ORDER BY 
	AvgPrice;

CREATE TABLE screenresolution (
	resolution VARCHAR(50),
    AvgPrice FLOAT,
    Count INT
);

INSERT INTO screenresolution (resolution, AvgPrice, Count)
SELECT Laptop_ScreenResolution AS screenResolution,
		AVG(Laptop_Price) AS AvgPrice,
        COUNT(*) AS Count
FROM laptop_temp2
GROUP BY 
	screenResolution
ORDER BY 
	AvgPrice;

SELECT *
FROM screenresolution;

SELECT 
    CASE 
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) < 900 THEN 'HD (<900p)'
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) BETWEEN 900 AND 1080 THEN 'Full HD (900-1080p)'
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) BETWEEN 1081 AND 1440 THEN '2K (1081-1440p)'
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) > 1440 THEN '4K+ (>1440p)'
        ELSE 'Unknown'
    END AS Resolution_Bucket,
    AVG(AvgPrice) AS AvgPrice,
    COUNT(*) AS Count
FROM 
    screenresolution
WHERE 
    resolution REGEXP '[0-9]{3,5}x[0-9]{3,5}'
GROUP BY 
    Resolution_Bucket
ORDER BY 
    AvgPrice DESC;

CREATE TABLE SresolutionBucket (
	resolutionBin VARCHAR(50),
    AvgPrice FLOAT,
	Count INT
);
INSERT INTO SresolutionBucket (resolutionBin, AvgPrice, Count)
SELECT 
    CASE 
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) < 900 THEN 'HD (<900p)'
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) BETWEEN 900 AND 1080 THEN 'Full HD (900-1080p)'
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) BETWEEN 1081 AND 1440 THEN '2K (1081-1440p)'
        WHEN CAST(SUBSTRING_INDEX(REGEXP_SUBSTR(resolution, '[0-9]{3,5}x[0-9]{3,5}'), 'x', -1) AS UNSIGNED) > 1440 THEN '4K+ (>1440p)'
        ELSE 'Unknown'
    END AS Resolution_Bucket,
    AVG(AvgPrice) AS AvgPrice,
    COUNT(*) AS Count
FROM 
    screenresolution
WHERE 
    resolution REGEXP '[0-9]{3,5}x[0-9]{3,5}'
GROUP BY 
    Resolution_Bucket
ORDER BY 
    AvgPrice DESC;

SELECT *
FROM Sresolutionbucket;

-- C. Correlations

-- 1. Are there any correlations between laptop Price and Weight?
SELECT AVG(Laptop_Price) AS Avgprice,
		Laptop_Weight AS weight,
        COUNT(*)
FROM laptop_temp2
GROUP BY weight
ORDER BY Avgprice DESC;

UPDATE laptop_temp2
SET Laptop_Weight = REPLACE(Laptop_Weight, 'kg', '');

SELECT Laptop_Weight
FROM laptop_temp2
WHERE Laptop_Weight NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

UPDATE laptop_temp2
SET Laptop_Weight = NULL
WHERE Laptop_Weight NOT REGEXP '^[0-9]+(\.[0-9]+)?$';


ALTER TABLE laptop_temp2
MODIFY COLUMN Laptop_Weight FLOAT;

SELECT Laptop_Weight
FROM laptop_temp2
LIMIT 10;

SELECT AVG(Laptop_Price) AS Avgprice,
		Laptop_Weight AS weight,
        COUNT(*)
FROM laptop_temp2
GROUP BY weight
ORDER BY Avgprice DESC;

CREATE TABLE laptopWeight (
	AvgPrice FLOAT,
    Weight VARCHAR (50),
    Count int
);

INSERT INTO laptopWeight (AvgPrice, Weight, Count)
SELECT AVG(Laptop_Price) AS Avgprice,
		Laptop_Weight AS weight,
        COUNT(*)
FROM laptop_temp2
GROUP BY weight
ORDER BY Avgprice DESC;

SELECT *
FROM laptopWeight;

-- 2. Do laptops with higher-end GPUs tend to have higher prices?
SELECT Laptop_Gpu AS GPU,
	AVG(Laptop_Price) AS AvgPrice,
    COUNT(*) AS Count
FROM Laptop_temp2
GROUP BY GPU
ORDER BY AvgPrice;

-- Grouping GPU into categories
SELECT 
    CASE 
        WHEN Laptop_Gpu LIKE '%NVIDIA GTX%' THEN 'NVIDIA GTX Series'
        WHEN Laptop_Gpu LIKE '%NVIDIA Qua%' THEN 'NVIDIA Quadro Series'
        WHEN Laptop_Gpu LIKE '%NVIDIA GeForce%' THEN 'NVIDIA GeForce Series'
        WHEN Laptop_Gpu LIKE '%NVIDIA RTX%' THEN 'NVIDIA RTX Series'
        WHEN Laptop_Gpu LIKE '%Intel HD%' THEN 'Intel HD Graphics'
        WHEN Laptop_Gpu LIKE '%Intel Graphics%' THEN 'Intel Graphics'
        WHEN Laptop_Gpu LIKE '%Intel UHD%' THEN 'Intel UHD Graphics'
        WHEN Laptop_Gpu LIKE '%Intel Iris%' THEN 'Intel Iris Plus Graphics'
        WHEN Laptop_Gpu LIKE '%ARM Mali%' THEN 'ARM Mali T860 Series'
        WHEN Laptop_Gpu LIKE '%AMD Radeon%' THEN 'AMD Radeon Series'
		WHEN Laptop_Gpu LIKE '%AMD Fire%' THEN 'AMD  FirePro Series'
        WHEN Laptop_Gpu LIKE '%AMD R%' THEN 'AMD R Series'
        ELSE 'Other'
    END AS GPU_Category,
    AVG(Laptop_Price) AS AvgPrice,
    COUNT(*) AS Count
FROM 
    Laptop_temp2
GROUP BY 
    GPU_Category
ORDER BY 
    AvgPrice DESC;

CREATE TABLE GPUcategory (
	GPU VARCHAR(100),
    AvgPrice FLOAT,
    Count INT
);

INSERT INTO gpucategory (GPU, AvgPrice, Count)
SELECT 
    CASE 
        WHEN Laptop_Gpu LIKE '%NVIDIA GTX%' THEN 'NVIDIA GTX Series'
        WHEN Laptop_Gpu LIKE '%NVIDIA Qua%' THEN 'NVIDIA Quadro Series'
        WHEN Laptop_Gpu LIKE '%NVIDIA GeForce%' THEN 'NVIDIA GeForce Series'
        WHEN Laptop_Gpu LIKE '%NVIDIA RTX%' THEN 'NVIDIA RTX Series'
        WHEN Laptop_Gpu LIKE '%Intel HD%' THEN 'Intel HD Graphics'
        WHEN Laptop_Gpu LIKE '%Intel Graphics%' THEN 'Intel Graphics'
        WHEN Laptop_Gpu LIKE '%Intel UHD%' THEN 'Intel UHD Graphics'
        WHEN Laptop_Gpu LIKE '%Intel Iris%' THEN 'Intel Iris Plus Graphics'
        WHEN Laptop_Gpu LIKE '%ARM Mali%' THEN 'ARM Mali T860 Series'
        WHEN Laptop_Gpu LIKE '%AMD Radeon%' THEN 'AMD Radeon Series'
		WHEN Laptop_Gpu LIKE '%AMD Fire%' THEN 'AMD  FirePro Series'
        WHEN Laptop_Gpu LIKE '%AMD R%' THEN 'AMD R Series'
        ELSE 'Other'
    END AS GPU_Category,
    AVG(Laptop_Price) AS AvgPrice,
    COUNT(*) AS Count
FROM 
    Laptop_temp2
GROUP BY 
    GPU_Category
ORDER BY 
    AvgPrice DESC;

SELECT *
FROM gpucategory;

-- Are there any patterns in laptop prices based on operating system (OS)?
SELECT AVG(Laptop_Price) AS AvgPrice,
	Laptop_OpSys AS OS,
    COUNT(*) AS Count
FROM laptop_temp2
GROUP BY OS
ORDER BY AvgPrice DESC;

SELECT 
    CASE 
        WHEN Laptop_OpSys LIKE '%macOS%' THEN 'macOS Series'
        WHEN Laptop_OpSys LIKE '%Windows%' THEN 'Windows OS Series'
        WHEN Laptop_OpSys LIKE '%Linux%' THEN 'Linux OS Series'
        WHEN Laptop_OpSys LIKE '%Chrome%' THEN 'Chrome OS Series'
        WHEN Laptop_OpSys LIKE '%Android%' THEN 'Android OS Series'
        WHEN Laptop_OpSys LIKE '%No OS%' THEN 'No OS'
		ELSE 'Other'
    END AS OS_Category,
    AVG(Laptop_Price) AS AvgPrice,
    COUNT(*) AS Count
FROM 
    Laptop_temp2
GROUP BY 
    OS_Category
ORDER BY 
    AvgPrice DESC;

CREATE TABLE OS (
OS VARCHAR(50),
AvgPrice FLOAT,
Count INT
);

INSERT INTO OS (OS, AvgPrice, Count)
SELECT 
    CASE 
        WHEN Laptop_OpSys LIKE '%macOS%' THEN 'macOS Series'
        WHEN Laptop_OpSys LIKE '%Windows%' THEN 'Windows OS Series'
        WHEN Laptop_OpSys LIKE '%Linux%' THEN 'Linux OS Series'
        WHEN Laptop_OpSys LIKE '%Chrome%' THEN 'Chrome OS Series'
        WHEN Laptop_OpSys LIKE '%Android%' THEN 'Android OS Series'
        WHEN Laptop_OpSys LIKE '%No OS%' THEN 'No OS'
		ELSE 'Other'
    END AS OS_Category,
    AVG(Laptop_Price) AS AvgPrice,
    COUNT(*) AS Count
FROM 
    Laptop_temp2
GROUP BY 
    OS_Category
ORDER BY 
    AvgPrice DESC;

SELECT *
FROM OS;

-- D. Insights for Business or Consumers

-- 1. What are the most popular laptop configurations (e.g., RAM, CPU, GPU)?
SELECT Laptop_Ram AS _RAM,
	Laptop_Cpu AS _CPU,
    Laptop_Gpu AS _GPU,
    COUNT(*) AS Count
FROM
	laptop_temp2
GROUP BY 
	_RAM,
    _CPU,
    _GPU
ORDER BY
	Count DESC;

CREATE TABLE popularConfig (
	RAM VARCHAR(10),
    CPU VARCHAR(100),
    GPU VARCHAR(100),
    Count INT
);
INSERT INTO popularConfig (RAM, CPU, GPU, Count)
SELECT Laptop_Ram AS _RAM,
	Laptop_Cpu AS _CPU,
    Laptop_Gpu AS _GPU,
    COUNT(*) AS Count
FROM
	laptop_temp2
GROUP BY 
	_RAM,
    _CPU,
    _GPU
ORDER BY
	Count DESC;
    
SELECT *
FROM popularConfig;
    
-- 2. How do laptop prices vary across different companies?
SELECT Laptop_Company AS Company,
	AVG(Laptop_Price) AS AvgPrice,
    COUNT(*) AS Count
FROM Laptop_temp2
GROUP BY Company
ORDER BY AvgPrice DESC;

-- Calculating the Median Price
WITH RankedPrices AS (
    SELECT 
        Laptop_Company AS Company,
        Laptop_Price AS Price,
        ROW_NUMBER() OVER (PARTITION BY Laptop_Company ORDER BY Laptop_Price) AS RowAsc,
        COUNT(*) OVER (PARTITION BY Laptop_Company) AS TotalCount
    FROM 
        laptop_temp2
),
Medians AS (
    SELECT 
        Company,
        Price,
        RowAsc,
        TotalCount
    FROM 
        RankedPrices
    WHERE 
        -- Handles both even and odd cases by selecting the middle rows
        RowAsc = FLOOR((TotalCount + 1) / 2) OR RowAsc = CEIL((TotalCount + 1) / 2)
)
SELECT 
    Company,
    AVG(Price) AS Median_Price,
    COUNT(*) AS Count
FROM 
    Medians
GROUP BY 
    Company
ORDER BY 
    Median_Price DESC;
    
CREATE TABLE medianPrice (
	company VARCHAR(50),
	medianPrice FLOAT,
    Count INT
);
    
 INSERT INTO medianPrice (company, medianPrice, Count)
 WITH RankedPrices AS (
    SELECT 
        Laptop_Company AS Company,
        Laptop_Price AS Price,
        ROW_NUMBER() OVER (PARTITION BY Laptop_Company ORDER BY Laptop_Price) AS RowAsc,
        COUNT(*) OVER (PARTITION BY Laptop_Company) AS TotalCount
    FROM 
        laptop_temp2
),
Medians AS (
    SELECT 
        Company,
        Price,
        RowAsc,
        TotalCount
    FROM 
        RankedPrices
    WHERE 
        -- Handles both even and odd cases by selecting the middle rows
        RowAsc = FLOOR((TotalCount + 1) / 2) OR RowAsc = CEIL((TotalCount + 1) / 2)
)
SELECT 
    Company,
    AVG(Price) AS Median_Price,
    COUNT(*) AS Count
FROM 
    Medians
GROUP BY 
    Company
ORDER BY 
    Median_Price DESC;

SELECT *
FROM medianprice;

-- Are there any laptops that offer good value for money (e.g., high performance at a lower price)?
SELECT Laptop_Company AS company,
	Laptop_Cpu AS cpu,
    Laptop_Gpu AS gpu,
    Laptop_Memory AS memory,
    Laptop_Ram AS ram,
    Laptop_OpSys AS OS,
    AVG(Laptop_Price) AS Price,
    COUNT(*)
FROM laptop_temp2
GROUP BY 
	company,
    cpu,
    gpu,
    memory,
    ram,
    os
ORDER BY Price DESC;
    
SELECT 
    Laptop_Company AS Company,
    Laptop_Cpu AS CPU,
    Laptop_Gpu AS GPU,
    Laptop_Memory AS Memory,
    Laptop_Ram AS RAM,
    Laptop_OpSys AS OS,
    AVG(Laptop_Price) AS AvgPrice,
    
    -- Simple performance scoring:
    -- +20 if GPU is NVIDIA
    -- +10 if GPU is AMD
    -- +10 if CPU has 'i7', 'Ryzen 7'
    -- +1 per GB of RAM
    (AVG(Laptop_Price) / 
     ( 
        CASE 
            WHEN Laptop_Gpu LIKE '%NVIDIA%' THEN 20
            WHEN Laptop_Gpu LIKE '%AMD%' THEN 10
            ELSE 5
        END
        + CASE 
            WHEN Laptop_Cpu LIKE '%i7%' OR Laptop_Cpu LIKE '%Ryzen 7%' THEN 10
            WHEN Laptop_Cpu LIKE '%i5%' OR Laptop_Cpu LIKE '%Ryzen 5%' THEN 6
            ELSE 3
        END
        + CAST(REPLACE(Laptop_Ram, 'GB', '') AS UNSIGNED)
     )) AS ValueScore,  -- Lower = better value
     
    COUNT(*) AS Count
FROM 
    laptop_temp2
GROUP BY 
    Company, CPU, GPU, Memory, RAM, OS
HAVING Count >= 3 -- Optional: only show configs with at least 3 laptops
ORDER BY 
    ValueScore ASC;  -- Lower score = more value per dollar
    
CREATE TABLE simpleScoringPerformance (
	company VARCHAR(50),
    CPU VARCHAR(50),
    GPU VARCHAR(50),
    Memory VARCHAR(50),
    RAM VARCHAR(50),
    OS VARCHAR(50),
    Avgprice FLOAT,
    ValueScore FLOAT,
    Count INT
);
INSERT INTO simpleScoringPerformance (company, cpu, gpu, memory, ram, os, avgprice, valuescore, count)
SELECT 
    Laptop_Company AS Company,
    Laptop_Cpu AS CPU,
    Laptop_Gpu AS GPU,
    Laptop_Memory AS Memory,
    Laptop_Ram AS RAM,
    Laptop_OpSys AS OS,
    AVG(Laptop_Price) AS AvgPrice,
    
    -- Simple performance scoring:
    -- +20 if GPU is NVIDIA
    -- +10 if GPU is AMD
    -- +10 if CPU has 'i7', 'Ryzen 7'
    -- +1 per GB of RAM
    (AVG(Laptop_Price) / 
     ( 
        CASE 
            WHEN Laptop_Gpu LIKE '%NVIDIA%' THEN 20
            WHEN Laptop_Gpu LIKE '%AMD%' THEN 10
            ELSE 5
        END
        + CASE 
            WHEN Laptop_Cpu LIKE '%i7%' OR Laptop_Cpu LIKE '%Ryzen 7%' THEN 10
            WHEN Laptop_Cpu LIKE '%i5%' OR Laptop_Cpu LIKE '%Ryzen 5%' THEN 6
            ELSE 3
        END
        + CAST(REPLACE(Laptop_Ram, 'GB', '') AS UNSIGNED)
     )) AS ValueScore,  -- Lower = better value
     
    COUNT(*) AS Count
FROM 
    laptop_temp2
GROUP BY 
    Company, CPU, GPU, Memory, RAM, OS
HAVING Count >= 3 -- Optional: only show configs with at least 3 laptops
ORDER BY 
    ValueScore ASC;  -- Lower score = more value per dollar
    
    
SELECT *
FROM simpleScoringPerformance;
    
    
    
    
    
    
    
    
    


