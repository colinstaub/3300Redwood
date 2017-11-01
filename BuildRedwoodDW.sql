-- Redwood database developed and written by Amy Phillips
-- Originally Written: September 2005| Updated: April 2017
-----------------------------------------------------------
-- RedwoodDW developed by students of Amy Phillips
-- Updated October 2017
-- Want to measure Time on Market and the difference in Asking Price
-- and Actual Sale Price. Fact Table is for Listings, and 
-- Dimensions include Agent, Property, Sale Status, and Date.
-----------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'RedwoodDW')
	CREATE DATABASE RedwoodDW
GO
USE RedwoodDW

--
-- =======================================
-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactListing'
       )
	DROP TABLE FactListing;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimAgent'
       )
	DROP TABLE DimAgent;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProperty'
       )
	DROP TABLE DimProperty;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimSaleStatus'
       )
	DROP TABLE DimSaleStatus;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;

--
-- Create tables
--
CREATE TABLE DimDate
	(	
	Date_SK INT PRIMARY KEY, 
	Date DATETIME,
	FullDate CHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth INT, -- Field will hold day number of Month
	DayName VARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear INT,
	DayOfQuarter INT,
	DayOfYear INT,
	WeekOfMonth INT,-- Week Number of Month 
	WeekOfQuarter INT, -- Week Number of the Quarter
	WeekOfYear INT,-- Week Number of the Year
	Month INT, -- Number of the Month 1 to 12{}
	MonthName VARCHAR(9),-- January, February etc
	MonthOfQuarter INT,-- Month Number belongs to Quarter
	Quarter CHAR(2),
	QuarterName VARCHAR(9),-- First,Second..
	Year INT,-- Year value of Date stored in Row
	YearName CHAR(7), -- CY 2015,CY 2016
	MonthYear CHAR(10), -- Jan-2016,Feb-2016
	MMYYYY INT,
	FirstDayOfMonth DATE,
	LastDayOfMonth DATE,
	FirstDayOfQuarter DATE,
	LastDayOfQuarter DATE,
	FirstDayOfYear DATE,
	LastDayOfYear DATE,
	IsHoliday BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday BIT,-- 0=Week End ,1=Week Day
	Holiday VARCHAR(50),--Name of Holiday in US
	Season VARCHAR(10)--Name of Season
	);
--
CREATE TABLE DimSaleStatus
	(SaleStatus_SK	INT IDENTITY(1,1) CONSTRAINT pk_dimsalestatus PRIMARY KEY,
	 SaleStatus_AK INT NOT NULL,
	 SaleStatus	NVARCHAR(10) NOT NULL
	);
--
CREATE TABLE DimProperty
	(Property_SK INT IDENTITY(1,1) CONSTRAINT pk_property PRIMARY KEY,
	 Property_AK INT NOT NULL,
	 City	     NVARCHAR(30) NOT NULL,
	 State	     NVARCHAR(20) NOT NULL,
	 Zipcode     NVARCHAR(20) NOT NULL,
	 Bedrooms    INT,
	 Bathrooms   INT,
	 Stories     INT,
	 SqFt	     INT,
	 YearBuilt   NUMERIC(4)
	);
--
CREATE TABLE DimAgent
	(Agent_SK	INT IDENTITY (1,1) CONSTRAINT pk_Agents PRIMARY KEY,
	 Agent_AK	INT NOT NULL,
	 FirstName	NVARCHAR(30) CONSTRAINT nn_agents_fname NOT NULL,
	 LastName	NVARCHAR(30) CONSTRAINT nn_agents_lname NOT NULL,
	 HireDate	DATETIME NOT NULL,
	 BirthDate	DATETIME NOT NULL,
	 Gender		NCHAR(1),
	 StartDate  DATE NULL,
	 EndDate	DATE NULL
	);
-- 
CREATE TABLE FactListing
	(Agent_SK		INT CONSTRAINT fk_agent_factlisting 
						FOREIGN KEY REFERENCES DimAgent(Agent_SK),
	 Property_SK    INT CONSTRAINT fk_property_factlisting 
						FOREIGN KEY REFERENCES DimProperty(Property_SK),
	 SaleStatus_SK  INT CONSTRAINT fk_salestatus_factlisting
					    FOREIGN KEY REFERENCES DimSaleStatus(SaleStatus_SK),
	 BeginListDateKey INT CONSTRAINT fk_beginlistdate_factlisting
						FOREIGN KEY REFERENCES DimDate(Date_SK),
	 EndListDateKey INT CONSTRAINT fk_endlistdate_factlisting
						FOREIGN KEY REFERENCES DimDate(Date_SK),
	 CONSTRAINT pk_factlisting PRIMARY KEY (Agent_SK, Property_SK, SaleStatus_SK, 
											BeginListDateKey),
	 Time_On_Market INT,
	 AskingPrice    MONEY,
	);
--


