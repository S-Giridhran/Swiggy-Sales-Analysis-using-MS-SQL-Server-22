## 1. Project Overview


> This project demonstrates how to design a SQL Server Data Warehouse using a Star Schema for Swiggy sales data. The project includes data cleaning, dimension table creation, fact table loading, ETL process, and business analysis queries.

---

## 2. Business Problem


> The raw Swiggy dataset contains repeated values for restaurants, locations, dishes, and categories, making analysis inefficient. The goal is to normalize the data using a Star Schema and perform analytical queries.

---

## 3. Project Workflow


```text
Raw Swiggy Dataset
        │
        ▼
Data Cleaning
(Remove Duplicates)

        │
        ▼
Create Dimension Tables

        │
        ▼
Create Fact Table

        │
        ▼
Load Dimension Tables

        │
        ▼
Load Fact Table

        │
        ▼
Validation

        │
        ▼
Business Analysis
```

---

## 4. Database Design


* Star Schema
* Fact Table
* Dimension Tables

```text
           dim_date

dim_location    fact_orders     dim_restaurant

         dim_category

            dim_dish
```

---

## 5. SQL Concepts Used


| Concept             | Purpose                        |
| ------------------- | ------------------------------ |
| CTE                 | Remove duplicate records       |
| ROW_NUMBER()        | Identify duplicate rows        |
| Primary Key         | Unique identification          |
| Foreign Key         | Table relationships            |
| INNER JOIN          | Combine tables                 |
| DISTINCT            | Remove duplicate values        |
| Aggregate Functions | COUNT, SUM, AVG                |
| GROUP BY            | Group restaurant/category data |
| ORDER BY            | Sort business results          |
| Star Schema         | Data Warehouse Design          |
| ETL                 | Extract, Transform, Load       |


---

## 6. Business Questions Solved


✅ Top 10 Restaurants by Revenue

✅ Top 10 Restaurants by Orders

✅ Most Popular Dishes

✅ Highest Rated Restaurants

✅ Revenue by Category

✅ Revenue by State

✅ Revenue by City

✅ Average Rating by Restaurant

---

## 7. Sample Query


```sql
SELECT TOP 10
    r.Restaurant_Name,
    COUNT(*) AS Total_Orders,
    SUM(f.Price_INR) AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_restaurant r
ON f.Restaurant_id=r.Restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY Total_Revenue DESC;
```

---

## 8. Output


```text
Restaurant     Orders     Revenue

KFC            532        3,25,000

A2B            487        2,90,000

Domino's       455        2,75,000
```

---

## 9. Skills Demonstrated


* SQL Server
* Database Design
* Data Cleaning
* ETL Process
* Star Schema
* Data Warehousing
* Analytical SQL
* Joins
* Aggregate Functions
* Data Validation

---

## 10. Future Improvements


* Connect with Power BI Dashboard
* Build Stored Procedures
* Add Indexing
* Optimize Query Performance
* Automate ETL Process

---
