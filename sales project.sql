create database sales_insight;


-- create table 
create table retails_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar (15),
age int,
category varchar (15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float);


-- data exploration 
-- how many sales we have ?
select count(*) as total_sale From retails_sales;


-- how many unique customers we have ?
select count(distinct customer_id) as total_sales from retails_sales;

select distinct category from retails_sales;

--
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retails_sales 
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retails_sales
GROUP BY 1


-- Q.3 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
round(avg(age), 2) avg_age
from retails_sales
where category ='Beauty'

-- Q.4 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retails_sales
where total_sale > 1000

-- Q.5 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender,
count(*) as total_trans
from retails_sales
group by category, gender
order by 1;

-- Q.6 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(
select
year(sale_date) as year,
month(sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as r
from retails_sales
group by 1, 2
) as t1
where r = 1
-- order by 1, 2
 
 
-- Q.7 Write a SQL query to find the top 5 customers based on the highest total sales 


select
    customer_id,
    sum(total_sale) as total_sales
from retails_sales
group by 1
order by 2 desc 
limit 5


-- Q.8 Write a SQL query to find the number of unique customers who purchased items from each category.

select
category,
count(distinct customer_id) as cnt_unique_cs 
from retails_sales
group by category

-- Q.9 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retails_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


