-- Monday Coffee SCHEMAS

-- Import datasets


CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);


CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);


CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

-- Coffee Data Analysis

SELECT * FROM city ;
SELECT * FROM products ;
SELECT * FROM customers ;
SELECT * FROM sales ;

-- Report & Data Analysis

1.How many people in each city are estimated to consume coffee, 
  given that 25% of the population does?

SELECT city_name ,
       ROUND((population * 0.25)/ 1000000 , 2) as coffee_consumers_in_millions
FROM city
ORDER BY 2 DESC ; 

2. What is the total revenue generated from coffee sales across all
   cities in the last quarter of 2023?

SELECT city.city_name ,
       SUM(s.total) as Total_Revenue 
FROM sales as s
JOIN customers as c
ON c.customer_id = s.customer_id
JOIN city 
ON c.city_id = city.city_id
WHERE 
    EXTRACT(YEAR FROM s.sale_date ) = 2023 
	AND 
	EXTRACT(QUARTER FROM s.sale_date ) = 4
GROUP BY 1
ORDER BY 2 DESC;

3.How many units of each coffee product have been sold?

SELECT p.product_name , 
       COUNT(s.product_id) as unit_sold
FROM sales as s
JOIN products as p
ON p.product_id = s.product_id 
GROUP BY 1
ORDER BY 2 DESC;

4.What is the average sales amount per customer in each city?

SELECT 
       city.city_name,
       c.customer_id , 
       ROUND(AVG(s.total) ) as avg_revenue
FROM sales as s
JOIN customers as c
On c.customer_id = s.customer_id
JOIN city 
On city.city_id = c.city_id
GROUP BY 1 , 2
ORDER BY 3 DESC;

5.Provide a list of cities along with their populations and estimated coffee consumers.


SELECT 
     city_name , 
	 population ,
	 COUNT(s.sale_id) as coffee_consumers
FROM city 
JOIN customers as c 
On city.city_id = c.city_id
JOIN sales as s
On s.customer_id = c.customer_id
GROUP BY 1 , 2
ORDER BY 3 DESC;

6. What are the top 3 selling products in each city based on sales volume?


SELECT *FROM
(SELECT 
       city.city_name ,
      p.product_name,
	  COUNT(s.product_id) as product_count , 
	  DENSE_RANK() OVER(PARTITION BY city.city_name ORDER BY COUNT(s.product_id) DESC) as rank
FROM products as p
JOIN sales as s
On s.product_id = p.product_id
JOIN customers as c
On s.customer_id = c.customer_id
JOIN city 
On city.city_id = c.city_id
GROUP BY 1 , 2
) as t1
WHERE rank <= 3

7.How many unique customers are there in each city who have purchased coffee products?
SELECT * FROM city ;
SELECT * FROM customers ;
SELECT * FROM sales ;

SELECT 
      city.city_name,
      COUNT(DISTINCT c.customer_id) as unique_coustomers
FROM customers as c
JOIN sales as s
On s.customer_id = c.customer_id
JOIN city 
On city.city_id = c.city_id
GROUP BY 1










