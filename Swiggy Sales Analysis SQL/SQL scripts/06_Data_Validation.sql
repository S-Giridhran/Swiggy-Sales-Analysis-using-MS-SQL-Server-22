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