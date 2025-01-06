# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `SQL_PROJECT_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_PROJECT_1`.
- **Data Import**: A table named `retail_sales` is imported to the SQL_PROJECT_1 database. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.



### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

The column sale_date was imported as a type text and in order to retreive this information we need to change the datatype of the sale_date column which is done using this query

```sql
UPDATE retail_sales
SET sale_date = STR_TO_DATE(sale_date,"%c/%e/%y");
```

```sql
SELECT * 
FROM retail_sales
WHERE sale_date = "2022-11-05";
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT transactions_id,sale_date,quantiy
FROM retail_sales
WHERE category = "clothing" AND quantiy > 3
AND sale_date BETWEEN "2022-11-01" AND "2022-11-30";
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT SUM(total_sale) AS total_sales, category
FROM retail_sales
GROUP BY category
ORDER BY 1 DESC;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age),1) AS average_age 
FROM retail_sales
WHERE category = "Beauty";
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT transactions_id
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT gender,category,COUNT(transactions_id) AS total_transactions
FROM retail_Sales
GROUP BY gender,category
ORDER BY gender,category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT Monthh,
Yearr,
total_sales
FROM(
	SELECT DATE_FORMAT(sale_date, "%M") AS Monthh, 
	DATE_FORMAT(sale_date, "%Y") AS Yearr, 
	ROUND(AVG(total_Sale),2) AS total_sales,
	RANK() OVER(PARTITION BY DATE_FORMAT(sale_date, "%Y") ORDER BY ROUND(AVG(total_Sale),2) DESC) AS Rankk
	FROM retail_sales
	GROUP BY Monthh,yearr
    ) Rank_table
WHERE Rankk = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id
FROM(
	SELECT customer_id, 
    SUM(total_sale) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(total_sale) DESC) AS ranking
	FROM retail_sales
	GROUP BY customer_id
    ) ranking_table
WHERE ranking < 6
ORDER BY customer_id;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT(customer_id)) AS DISTINCT_COUNT
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

changing the sale_time of column type text to datetime type
```sql
UPDATE retail_sales
SET sale_time = STR_TO_DATE(sale_time, "%H:%i:%s");
```

```sql
WITH hourly_sale
AS(
	SELECT sale_time,
		CASE 
			WHEN sale_time < 12 THEN "morning"
			WHEN sale_time BETWEEN 12 AND 17 THEN "afternoon"
			WHEN sale_time >17 THEN "evening"
		END AS shift
	FROM retail_sales
)
SELECT shift,
COUNT(*) AS Total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY Total_orders;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
