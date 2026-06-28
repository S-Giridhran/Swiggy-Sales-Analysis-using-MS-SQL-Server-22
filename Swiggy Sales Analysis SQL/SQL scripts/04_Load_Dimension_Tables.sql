--INSERT DATA IN TABLES
--DIM_DATE
INSERT INTO dim_date (Full_Date, Year, Month, Month_Name, Quarter, Day, Week)
SELECT DISTINCT 
	Order_Date,
	YEAR(Order_Date),
	MONTH(Order_Date),
	DATENAME(MONTH, Order_Date),
	DATEPART(QUARTER, Order_Date),
	DAY(Order_Date),
	DATEPART(WEEK, Order_Date)
FROM Swiggy_data
WHERE Order_Date IS NOT NULL;






--DIM_LOCATION
INSERT INTO dim_location (State, City, Location)
SELECT DISTINCT
	State,
	City,
	Location
FROM Swiggy_data





--DIM_RESTAURANT
INSERT INTO dim_restaurant (Restaurant_Name)
SELECT DISTINCT
	Restaurant_Name
FROM Swiggy_data;





--DIM_CATEGORY
INSERT INTO dim_category (Category)
SELECT DISTINCT
	Category
FROM Swiggy_data;





--DIM_DISH
INSERT INTO dim_dish (Dish_Name)
SELECT DISTINCT
	Dish_Name
FROM Swiggy_data;
