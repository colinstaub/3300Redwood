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
	(Date_SK INT IDENTITY(1,1) CONSTRAINT pk_dimdate PRIMARY KEY,
	 [Date] DATETIME NOT NULL,
	 [DateName] NVARCHAR(50) NOT NULL,
	 [Month] INT NOT NULL,
	 [MonthName] VARCHAR(9) NOT NULL,
	 [Quarter] CHAR(2) NOT NULL,
	 [QuarterName] VARCHAR(9) NOT NULL,
	 [Year] INT NOT NULL,
	 [YearName] CHAR(7) NOT NULL,
	 [Season] VARCHAR(10) NOT NULL,
	 [Holiday] VARCHAR(50) NOT NULL
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
	 Gender		NCHAR(1) CONSTRAINT ck_agents_gender CHECK ((Gender = 'M') OR (Gender = 'F'))
	);
-- 
CREATE TABLE FactListings
	(Agent_SK		INT CONSTRAINT fk_agent_factlistings 
						FOREIGN KEY REFERENCES DimAgent(Agent_SK),
	 Property_SK    INT CONSTRAINT fk_property_factlistings 
						FOREIGN KEY REFERENCES DimProperty(Property_SK),
	 SaleStatus_SK  INT CONSTRAINT fk_salestatus_factlistings
					    FOREIGN KEY REFERENCES DimSaleStatus(SaleStatus_SK),
	 Date_SK	    INT CONSTRAINT fk_date_factlistings
					    FOREIGN KEY REFERENCES DimDate(Date_SK),
	 BeginListDate  DATETIME DEFAULT GETDATE(),
	 EndListDate    DATETIME DEFAULT GETDATE() + 150,
	 AskingPrice    MONEY,
	 ActualSalesPrice MONEY
	);
--


