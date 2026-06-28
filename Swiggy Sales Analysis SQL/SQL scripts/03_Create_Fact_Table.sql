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