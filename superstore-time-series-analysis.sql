-- Data loaded by SQL Server imp


-- Use the LEAD window function to create a new column sales_next that displays the sales of the next row in the dataset.
-- This function will help you quickly compare a given row’s values and values in the next row.

SELECT 
	row_id,
	order_date,
	sales,
	LEAD(sales) OVER (ORDER BY order_date, row_id) as sales_next,
	LAG(sales) OVER (ORDER BY order_date, row_id) as sales_previous
FROM
	dbo.['superstore-data-2$']

-- Rank the data based on sales in descending order using the RANK function.

SELECT 
	order_id,
	customer_name,
	city,
	product_name,
	category,
	sales,
	RANK() OVER (ORDER BY sales DESC) AS high_to_low
FROM 
	dbo.['superstore-data-2$']

-- Use common SQL commands and aggregate functions to show the monthly and daily sales averages.

	-- 1) Monthly Sales Average

SELECT 
	CONCAT(datename(mm, order_date), ' ', YEAR(order_date)) AS month,
	ROUND(AVG(sales),2) AS 'avg_sales_£'
FROM 
	dbo.['superstore-data-2$']
GROUP BY 
	CONCAT(datename(mm, order_date), ' ', YEAR(order_date))
ORDER BY 
	'avg_sales_£'

	-- 2a) Daily Sales Averages: Method 1

SELECT 
	CONCAT(DATENAME(weekday, order_date), ' ', YEAR(order_date)) AS day,
	ROUND(AVG(sales), 2) as 'avg_sales (£)'
FROM 
	dbo.['superstore-data-2$']
GROUP BY 
	CONCAT(DATENAME(weekday, order_date), ' ', YEAR(order_date))
ORDER BY 
	'avg_sales (£)', day

	-- 2b) Daily Sales Averages: Method 2

SELECT 
	DATENAME(weekday, order_date) as day,
	YEAR(order_date) AS year,
	ROUND(AVG(sales), 2) as 'avg_sales (£)'
FROM 
	dbo.['superstore-data-2$']
GROUP BY 
	DATENAME(weekday, order_date),
	YEAR(order_date)

-- Analyse discounts on 2 consecutive days

SELECT 
	order_date,
	ROUND(sales, 2) AS sales,
	discount,
	COALESCE(LEAD(discount) OVER (ORDER BY order_date),0) as consecutive_day_discount,
	COALESCE(LEAD(discount) OVER (ORDER BY order_date),0) - discount as difference
FROM 
	dbo.['superstore-data-2$']
ORDER BY 
	order_date
	

-- Evaluate moving averages using window functions

	-- 3 Day Moving Average: Method 1

SELECT 
	order_date,
	ROUND(AVG(sales), 2) AS 'avg_sales',
	COALESCE(ROUND(LAG(AVG(sales), 1) OVER (ORDER BY order_date), 2), 0) as one_before,
	COALESCE(ROUND(LAG(AVG(sales), 2) OVER (ORDER BY order_date), 2), 0) as two_before,
	ROUND((AVG(sales) + COALESCE((LAG(AVG(sales), 1) OVER (ORDER BY order_date)),0) + COALESCE((LAG(AVG(sales), 2) OVER (ORDER BY order_date)), 0))/3, 2) as '3_day_moving_average'
FROM 
	dbo.['superstore-data-2$']
GROUP BY 
	order_date
ORDER BY 
	order_date

	-- 3 Day Moving Average: Method 2

SELECT 
    order_date,
    AVG(sales) OVER (PARTITION BY order_date ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as '3_day_moving_average'
FROM 
    dbo.['superstore-data-2$']
GROUP BY 
    order_date
ORDER BY 
    order_date;





-- EXTRA > Breakdown of sales per customer

SELECT 
	customer_id,
	sales,
	order_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as transaction_number
FROM
	dbo.['superstore-data-2$']
GROUP BY
	customer_id, sales, order_date
