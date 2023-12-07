
-- -----------------------------------------------------------------------------------------
-- -----------------------------Feature Engineering--------------------------

-- time_of_day
SELECT 
	time,
    (CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END) as time_of_day
FROM sales ;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(30);

UPDATE sales
SET time_of_day=(CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);


-- day_name
ALTER TABLE sales ADD COLUMN day_name VARCHAR(3);

UPDATE sales
SET day_name= SUBSTRING(UPPER(DATE_FORMAT(date, '%a')), 1, 3);

-- month_name
ALTER TABLE sales ADD COLUMN month_name VARCHAR(4);

UPDATE sales
	SET month_name= SUBSTRING(UPPER(DATE_FORMAT(date,"%b")),1,3);

-- ------------------------------------------------------------------------------------------------------------------
-- --------------------------------------Generic-----------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT 
DISTINCT city
	FROM sales;
    
-- In which city is each branch?
SELECT 
DISTINCT city, branch
	FROM sales;
-- --------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------Product---------------------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT 
	DISTINCT product_line
    FROM sales;
-- What is the most common payment method?
SELECT payment_method,
	COUNT(payment_method)
    FROM sales
    GROUP BY payment_method;
-- What is the most selling product line?
SELECT 
	product_line, COUNT(product_line) as total_count
    FROM sales
    ORDER BY total_count;
    
-- What is the total revenue by month?
SELECT 
	SUM(total), month_name
    FROM sales
    GROUP BY month_name
    ORDER BY month_name;
-- What month had the largest COGS?
SELECT 
	SUM(COGS), month_name
    FROM sales
    GROUP BY month_name
    ORDER BY SUM(COGS) DESC;
    
-- What product line had the largest revenue?
SELECT 
	SUM(total-COGS) AS revenue, product_line
    FROM sales
    GROUP BY product_line
    ORDER BY revenue DESC;
-- What is the city with the largest revenue?
SELECT 
	SUM(total-COGS) AS revenue, city
    FROM sales
    GROUP BY city
    ORDER BY revenue DESC;
-- What product line had the largest VAT?
SELECT 
	VAT, product_line
    FROM sales
    GROUP BY product_line
    ORDER BY VAT DESC;
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
    AVG(total) AS avg_total,
    product_line,
    CASE
        WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN 'Above Average'
        ELSE 'Below Average'
    END AS evaluation
FROM sales
GROUP BY product_line;
-- Which branch sold more products than average product sold?
SELECT 
branch, AVG(total)
FROM sales
GROUP BY branch;

-- What is the most common product line by gender?
SELECT
	gender, product_line,
    COUNT(gender) as total_cnt
    FROM sales
    GROUP BY gender , product_line
    ORDER BY total_cnt DESC;
       
-- What is the average rating of each product line?
SELECT 
	AVG(rating) as avg_rating, product_line
    FROM sales
    GROUP BY product_line
    ORDER BY avg_rating DESC;
-- ----------------------------------------------------------------------------------------------------------------------
-- ------------------------------Sales------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
SELECT
	day_name, COUNT(day_name) as sales_per_day
    FROM sales
    GROUP BY day_name
    ORDER BY sales_per_day;
    
-- Which of the customer types brings the most revenue?
SELECT 
	SUM(total-COGS) AS revenue, customer_type
    FROM sales
    GROUP BY customer_type
    ORDER BY revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	VAT, city
    FROM sales
    GROUP BY city
    ORDER BY VAT DESC;
    
-- Which customer type pays the most in VAT?

SELECT
	customer_type, AVG(VAT) AS vat
    FROM sales
    GROUP BY customer_type
    ORDER BY vat DESC;

-- --------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Customer-------------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
    FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment_method
    FROM sales;

-- What is the most common customer type?
SELECT
	customer_type, COUNT(customer_type) AS total_customer_type
    FROM sales
    GROUP BY customer_type
    ORDER BY total_customer_type DESC;
    
-- Which customer type buys the most?
SELECT 
	customer_type, COUNT(total) as buys
    FROM sales
    GROUP BY customer_type
    ORDER BY buys DESC;

 -- What is the gender of most of the customers?
 SELECT 
	gender, COUNT(gender) as total_gender
    FROM sales
    GROUP BY gender
    ORDER BY total_gender DESC;

-- What is the gender distribution per branch?
SELECT 
	branch,gender, COUNT(branch) as branch_cnt
    FROM sales
    GROUP BY branch, gender
    ORDER BY branch;
    
-- Which time of the day do customers give most ratings?
SELECT
	time_of_day, AVG(rating) AS avg_rating
    FROM sales
    GROUP BY time_of_day
    ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day, AVG(rating) AS avg_rating, branch
    FROM sales
    GROUP BY time_of_day, branch
    ORDER BY avg_rating DESC;
-- Which day fo the week has the best avg ratings?

SELECT
	day_name, AVG(rating) as avg_rating
    FROM sales
    GROUP BY day_name
    ORDER BY avg_rating DESC;
    
    -- Which day of the week has the best average ratings per branch?
    SELECT
	branch,day_name, AVG(rating) as avg_rating
    FROM sales
    GROUP BY day_name, branch
    ORDER BY avg_rating DESC;
    