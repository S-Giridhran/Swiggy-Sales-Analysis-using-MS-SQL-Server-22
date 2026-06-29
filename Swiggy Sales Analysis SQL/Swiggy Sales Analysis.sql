SELECT * FROM Swiggy_data

--Data Cleaning & Validation
--Null Check 

SELECT 
	SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS null_state,
	SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
	SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
	SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) null_restaurant_name,
	SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location,
	SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
	SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS null_dish_name,
	SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS null_price_inr,
	SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
	SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM Swiggy_data





--Blank or Empty Strings Checking 

SELECT * FROM Swiggy_data
WHERE State='' OR City='' OR Order_Date='' OR Restaurant_Name='' OR Location='' OR Category='' OR Dish_Name=''




--Duplicate Detection 

SELECT 
State, City, Order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count, Count(*) AS CNT
FROM Swiggy_data

GROUP BY 
State, City, Order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count HAVING Count(*)>1



--Delete Duplicates

WITH CTE AS (
SELECT *, ROW_NUMBER() OVER ( 
	PARTITION BY State, City, Order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count
	ORDER BY (SELECT NULL)
	) AS rn
	FROM Swiggy_data
	)
	DELETE FROM CTE WHERE rn>1




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



--FACT TABLE
CREATE TABLE fact_swiggy_orders(
	Order_id INT IDENTITY (1,1) PRIMARY KEY,

	Date_id INT, 
	Price_INR DECIMAL (10,2),
	Rating DECIMAL (4,2),
	Rating_Count INT,

	Location_id INT,
	Restaurant_id INT,
	Category_id INT,
	Dish_id INT,

	FOREIGN KEY (Date_id) REFERENCES dim_date(Date_id),
	FOREIGN KEY (Location_id) REFERENCES dim_location(Location_id),
	FOREIGN KEY (Restaurant_id) REFERENCES dim_restaurant(Restaurant_id),
	FOREIGN KEY (Category_id) REFERENCES dim_category(Category_id),
	FOREIGN KEY (Dish_id) REFERENCES dim_dish(Dish_id)
	)



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





--FACT TABLE
INSERT INTO fact_swiggy_orders
(
	Date_id,
	Price_INR,
	Rating,
	Rating_Count,
	Location_id,
	Restaurant_id,
	Category_id,
	Dish_id
)
SELECT 
	dd.date_id,
	s.Price_INR,
	s.Rating,
	s.Rating_Count,

	dl.Location_id,
	dr.Restaurant_id,
	dc.Category_id,
	dsh.Dish_id
FROM Swiggy_data s





JOIN dim_date dd
	ON dd.Full_Date = s.Order_Date

JOIN dim_location dl
	ON dl.State = s.State
	AND dl.City = s.City
	AND dl.Location = s.Location

JOIN dim_restaurant dr
	ON dr.Restaurant_Name =s.Restaurant_Name

JOIN dim_category dc
	ON dc.Category = s.Category

JOIN dim_dish dsh
	ON dsh.Dish_Name = s.Dish_Name;





SELECT * FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_location l ON f.Location_id = l.Location_id
JOIN dim_restaurant r ON f.Restaurant_id = r.Restaurant_id
JOIN dim_category c ON f.Category_id = c.Category_id
JOIN dim_dish di ON f.Dish_id = di.Dish_id;





---KPI's
---TOTAL ORDERS
SELECT COUNT(*) AS Total_Orders
FROM fact_swiggy_orders


---TOTAL REVENUE (INR MILLION)
SELECT FORMAT(SUM(CONVERT(FLOAT, Price_INR))/ 1000000, 'N2') + ' INR MILLION'
AS Total_Revenue
FROM fact_swiggy_orders


---AVERAGE DISH PRICE
SELECT FORMAT(AVG(CONVERT(FLOAT, Price_INR)), 'N2') + ' INR '
AS Total_Revenue
FROM fact_swiggy_orders


---AVERAGE RATINGS
SELECT AVG(Rating) AS Average_Rating
FROM fact_swiggy_orders





---DEEP DIVE BUSINESS ANALYSIS
---Montly Order Trends
SELECT 
d.year,
d.month,
d.month_name,
count(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY 
	d.year,
	d.month,
	d.month_name



---Month-Wise Revenue
SELECT 
d.year,
d.month,
d.month_name,
FORMAT(SUM(CONVERT(FLOAT, Price_INR))/1000000, 'N2')+ ' INR MILLION' AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY 
	d.year,
	d.month,
	d.month_name
ORDER BY SUM(Price_INR) DESC





---Quarterly Trend 
SELECT 
d.year,
d.Quarter,
count(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY 
	d.year,
	d.Quarter





---Yearly Trend
SELECT 
d.year,
count(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY 
	d.year





---Orders by Day of Week (MON-SUN)
SELECT 
	DATENAME(WEEKDAY, d.full_date) AS day_name,
	COUNT (*) AS total_orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY DATENAME (WEEKDAY, d.full_date), DATEPART(WEEKDAY, d.full_date)
ORDER BY DATEPART (WEEKDAY, d.full_date);




---Top 10 Cities by Orders Volume
SELECT TOP 10
l.city,
COUNT(*) AS Total_Orders FROM fact_swiggy_orders f
JOIN dim_location l ON l.location_id = f.location_id
GROUP BY l.city
ORDER BY COUNT(*) DESC




---Revenue Contribution by States
SELECT
l.State,
FORMAT(SUM(CONVERT(FLOAT, f.Price_INR))/ 1000000, 'N2') + ' INR MILLION' AS Total_Revenue FROM fact_swiggy_orders f
JOIN dim_location l ON l.location_id = f.location_id 
GROUP BY l.State
ORDER BY SUM (f.Price_INR) DESC




---FOOD PERFORMANCES
---Top 10 restaurants by orders
SELECT TOP 10
r.Restaurant_Name,
COUNT(*) AS Total_Orders,
SUM(f.Price_INR) AS Total_Revenue FROM fact_swiggy_orders f
JOIN dim_restaurant r ON r.Restaurant_id = f.Restaurant_id
GROUP BY r.Restaurant_Name





---Top categories (Indian, Chinese, etc.)
SELECT
c.Category,
COUNT(*) AS Total_Orders,
SUM (f.Price_INR) AS Total_Revenue FROM fact_swiggy_orders f
JOIN dim_category c ON c.Category_id = f.Category_id
GROUP BY c.Category
ORDER BY Total_Orders DESC;





---Most ordered dishes
SELECT 
di.Dish_Name,
COUNT(*) AS Most_Ordered_Dish,
SUM(f.Price_INR) AS Total_Revenue FROM fact_swiggy_orders f
JOIN dim_dish di ON di.Dish_id = f.Dish_id
GROUP BY di.Dish_Name
ORDER BY Most_Ordered_Dish DESC;





---Cuisine performance → Orders + Avg Rating
SELECT
c.Category,
COUNT(*) AS Total_Orders,
AVG(f.rating) AS Avg_Rating,
SUM (f.Price_INR) AS Total_Revenue FROM fact_swiggy_orders f
JOIN dim_category c ON c.Category_id = f.Category_id
GROUP BY c.Category
ORDER BY Total_Orders DESC;





---Total Orders by Price Range 
SELECT 
	CASE 
		WHEN CONVERT(FLOAT, Price_INR) < 100 THEN 'Under 100'
		WHEN CONVERT(FLOAT, Price_INR)  BETWEEN 100 AND 199 THEN 'Under 100 - 199'
		WHEN CONVERT(FLOAT, Price_INR)  BETWEEN 200 AND 299 THEN 'Under 200 - 299'
		WHEN CONVERT(FLOAT, Price_INR)  BETWEEN 300 AND 499 THEN 'Under 300 - 499'
		ELSE '500+'
	END AS Price_Range,
	COUNT (*) AS Total_Orders,
	SUM(Price_INR) AS Total_Revenue FROM fact_swiggy_orders
GROUP BY 
	CASE 
		WHEN CONVERT(FLOAT, Price_INR) < 100 THEN 'Under 100'
		WHEN CONVERT(FLOAT, Price_INR)  BETWEEN 100 AND 199 THEN 'Under 100 - 199'
		WHEN CONVERT(FLOAT, Price_INR)  BETWEEN 200 AND 299 THEN 'Under 200 - 299'
		WHEN CONVERT(FLOAT, Price_INR)  BETWEEN 300 AND 499 THEN 'Under 300 - 499'
		ELSE '500+'
	END
ORDER BY Total_Orders DESC;





---Rating Count Distribution (1-5)
SELECT 
Rating,
COUNT(*) AS Rating_Count FROM fact_swiggy_orders
GROUP BY Rating
ORDER BY Rating_Count DESC;



	