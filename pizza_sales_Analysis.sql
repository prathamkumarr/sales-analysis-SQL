create database pizzahut;
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

alter table pizza_types_cleaned rename to pizza_types;

SELECT 
    *
FROM
    orders;

-- retrieve the total number of orders placed
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- calculate the total revenue generated from pizza sales.
SELECT 
    (ROUND(SUM(order_details.quantity * pizzas.price),
            2)) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- identify the highest priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- identify the most common pizza size ordered;
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

-- list the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


-- join necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    SUM(order_details.quantity) AS quantity,
    pizza_types.category
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY category;

-- determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY hour;

-- join relevant tables to find the category wise distribution of pizzas.
SELECT 
    category, COUNT(pizza_type_id) AS pizza_count
FROM
    pizza_types
GROUP BY category
ORDER BY pizza_count DESC;

-- group the order by date and calculate the average number of pizzas per day.
SELECT 
    ROUND(AVG(pizzas_sold_per_day), 0) AS avg_pizzas_sold_per_day
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS pizzas_sold_per_day
    FROM
        orders
    JOIN order_details ON order_details.order_id = orders.order_id
    GROUP BY orders.order_date) AS ordered_quantity;
    
-- determine the top 3 most ordered pizza types based on revenue.
-- here you have to join 3 tables.
 
SELECT 
    pizza_types.name,
    SUM(pizzas.price * order_details.quantity) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3;


-- calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS percentage_contribution_to_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY percentage_contribution_to_revenue DESC;


-- calculate the cumulative revenue generated overtime(based on date).
-- concept of cumulative freequency.
-- 200 200
-- 300 500
-- 450 950
-- 250 1200
-- used a window function here.
select order_date, round(revenue,2) as reve_nue,round(sum(revenue) over(order by order_date),2) as cum_revenue
from
(select orders.order_date, sum(order_details.quantity * pizzas.price) as revenue 
from orders join order_details on order_details.order_id = orders.order_id 
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by orders.order_date)as daily_sales;


-- determine top 3 most ordered pizza types based on revenue for each category. 
select name,revenue 
from  
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rank_of_pizzatypes 
from 
(select pizza_types.name, pizza_types.category ,sum(order_details.quantity * pizzas.price) as revenue 
from pizza_types join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name, pizza_types.category 
order by revenue desc) as A) as B
where rank_of_pizzatypes <=3;
