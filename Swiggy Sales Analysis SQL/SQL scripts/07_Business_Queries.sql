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