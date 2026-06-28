-- CREATING SCHEMA
-- DIMENSION TABLES
-- DATA TABLE
CREATE TABLE dim_date(
	date_id INT IDENTITY(1,1) PRIMARY KEY,
	Full_Date DATE,
	Year INT,
	Month INT, 
	Month_Name Varchar(20),
	Quarter INT,
	Day INT,
	Week INT
	)

--DIM LOCATION
CREATE TABLE dim_location(
	Location_id INT IDENTITY(1,1) PRIMARY KEY,
	State Varchar(150),
	City Varchar(100),
	Location Varchar(200)
	)


--DIM RESTAURANT
CREATE TABLE dim_restaurant(
	Restaurant_id INT IDENTITY (1,1) PRIMARY KEY,
	Restaurant_Name Varchar(200)
	)



--DIM CATEGORY 
CREATE TABLE dim_category(
	Category_id INT IDENTITY (1,1) PRIMARY KEY,
	Category Varchar(200)
	)



--DIM DISH
CREATE TABLE dim_dish(
	Dish_id INT IDENTITY(1,1) PRIMARY KEY,
	Dish_Name Varchar(200)
	)