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
