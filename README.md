MONDAY COFFEE SQL PROJECT
====================================

PROJECT OVERVIEW
----------------
This project analyzes sales and customer data for "Monday Coffee" using SQL. 
The database consists of four main tables: city, customers, products, and sales.
The goal is to derive insights into city populations, coffee consumption, revenue, 
and product performance.

------------------------------------
SCHEMAS
------------------------------------
CREATE TABLE city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(15),
    population BIGINT,
    estimated_rent FLOAT,
    city_rank INT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(25),
    city_id INT,
    CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(35),
    Price FLOAT
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_id INT,
    customer_id INT,
    total FLOAT,
    rating INT,
    CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

------------------------------------
DATA SELECTION
------------------------------------
SELECT * FROM city;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;

------------------------------------
DATA ANALYSIS & BUSINESS QUESTIONS
------------------------------------

1. Estimated Coffee Consumers per City
------------------------------------
-- How many people in each city are estimated to consume coffee, 
-- given that 25% of the population does?
SELECT city_name,
       ROUND((population * 0.25)/1000000, 2) AS coffee_consumers_in_millions
FROM city
ORDER BY 2 DESC;

------------------------------------
2. Total Revenue in Last Quarter of 2023
------------------------------------
SELECT city.city_name,
       SUM(s.total) AS Total_Revenue
FROM sales AS s
JOIN customers AS c ON c.customer_id = s.customer_id
JOIN city ON c.city_id = city.city_id
WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
  AND EXTRACT(QUARTER FROM s.sale_date) = 4
GROUP BY 1
ORDER BY 2 DESC;

------------------------------------
3. Units Sold per Product
------------------------------------
SELECT p.product_name,
       COUNT(s.product_id) AS unit_sold
FROM sales AS s
JOIN products AS p ON p.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC;

------------------------------------
4. Average Sales per Customer per City
------------------------------------
SELECT city.city_name,
       c.customer_id,
       ROUND(AVG(s.total)) AS avg_revenue
FROM sales AS s
JOIN customers AS c ON c.customer_id = s.customer_id
JOIN city ON city.city_id = c.city_id
GROUP BY 1, 2
ORDER BY 3 DESC;

------------------------------------
5. Cities with Populations and Estimated Coffee Consumers
------------------------------------
SELECT city_name,
       population,
       COUNT(s.sale_id) AS coffee_consumers
FROM city
JOIN customers AS c ON city.city_id = c.city_id
JOIN sales AS s ON s.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 3 DESC;

------------------------------------
6. Top 3 Selling Products per City
------------------------------------
SELECT * FROM (
    SELECT city.city_name,
           p.product_name,
           COUNT(s.product_id) AS product_count,
           DENSE_RANK() OVER(PARTITION BY city.city_name ORDER BY COUNT(s.product_id) DESC) AS rank
    FROM products AS p
    JOIN sales AS s ON s.product_id = p.product_id
    JOIN customers AS c ON s.customer_id = c.customer_id
    JOIN city ON city.city_id = c.city_id
    GROUP BY 1, 2
) AS t1
WHERE rank <= 3;

------------------------------------
7. Unique Customers per City
------------------------------------
SELECT city.city_name,
       COUNT(DISTINCT c.customer_id) AS unique_customers
FROM customers AS c
JOIN sales AS s ON s.customer_id = c.customer_id
JOIN city ON city.city_id = c.city_id
GROUP BY 1;

------------------------------------
INSIGHTS & KEY TAKEAWAYS
------------------------------------
- 25% of each city’s population is estimated to consume coffee.
- Top revenue-generating cities can be identified by quarterly revenue.
- Identify which coffee products perform best per city.
- Discover customer engagement and repeat patterns via unique customer counts.
- Analyze trends to help with marketing and store expansion.

------------------------------------
TOOLS USED
------------------------------------
- PostgreSQL / MySQL
- SQL Language
- DBeaver / pgAdmin

------------------------------------
AUTHOR
------------------------------------
Deepan R
Data Analyst | SQL | Power BI | Excel | Python
