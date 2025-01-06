SELECT *
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

SELECT COUNT(transactions_id)
transactions_id FROM retail_sales;


UPDATE retail_sales
SET sale_date = STR_TO_DATE(sale_date,"%c/%e/%y");

# query to retreive all columns for sales made on "2022-11-05"
SELECT * 
FROM retail_sales
WHERE sale_date = "2022-11-05";

#retrieve all transactions where the category is clothing and the quantity is more than 3 in the month of nov-2022
SELECT transactions_id,sale_date,quantiy
FROM retail_sales
WHERE category = "clothing" AND quantiy > 3
AND sale_date BETWEEN "2022-11-01" AND "2022-11-30";

#calculate the total sale for each category
SELECT SUM(total_sale) AS total_sales, category
FROM retail_sales
GROUP BY category
ORDER BY 1 DESC;

#Find the avergae age of the customers who purchased items from beauty category
SELECT ROUND(AVG(age),1) AS average_age 
FROM retail_sales
WHERE category = "Beauty";

#Find all transactions where the total sale is > 1000
SELECT transactions_id
FROM retail_sales
WHERE total_sale > 1000;

#Find total number of transactions made by each gender in each category
SELECT gender,category,COUNT(transactions_id) AS total_transactions
FROM retail_Sales
GROUP BY gender,category
ORDER BY gender,category;

#write a query to find the average sale for each month and find out the best selling month in each year

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

# sql query to find top 5 customers based on the highest total sales 
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

#SQL query to find number of unique customers who purchased items from each category

SELECT category, COUNT(DISTINCT(customer_id)) AS DISTINCT_COUNT
FROM retail_sales
GROUP BY category;

#SQL query to create each shift and number of orders (morning <=12, afternoon between 12 and 17, evening>17)

UPDATE retail_sales
SET sale_time = STR_TO_DATE(sale_time, "%H:%i:%s");

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









