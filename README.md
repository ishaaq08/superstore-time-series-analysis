# About the Project

- The project was concerned with the **SuperStore Time Series** data consisting of 1,995 rows as provided by [Kaggle](https://www.kaggle.com/datasets/blurredmachine/superstore-time-series-dataset).
- The RDBMS employed was Microsoft SQL Server which utilises the T-SQL syntax. 

# Analysis & Execution

Where a time-series analysis is trivial with Python, SQL presents it as a more challenging task - hence this task difficulty was of the intermediate level.

The following tasks were conducted:

### TASK - Rank the data based on sales 
- RANK() window function to rank each row by sales

### TASK - Deduce the monthly and daily sales averages
- DATENAME() to extract month and days from datetimes.
- GROUP BY to group and aggregate sales data

### TASK - Analyse the difference in discounts between consecutive days
- LEAD() window function to make discount comparision between consecutive days (rows)

### Task - Evaluate 3 day moving averages
- Method 1 (simple): LAG window function with offset to obtain sales data for 2 previous rows
- Method 2 (subquery): Derived table to store daily sales averages and querying this table using LAG()
- Method 3 (CTE): CTE to store daily sales averages and querying of CTE using window function 


