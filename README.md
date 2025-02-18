# Sales Analysis Using SQL

📌 Project Overview
This project focuses on analyzing pizza sales data using **SQL**. We explore sales trends, revenue generation, and order patterns using **Joins, Window Functions, and Subqueries**. The goal is to extract meaningful insights from the dataset by performing advanced SQL operations.

---

📂 Dataset Overview(https://github.com/Ayushi0214/pizza-sales---SQL)
The analysis is performed on the following tables:

- **`order_details`**: Contains information about each order, including `order_details_id`, `pizza_id`, and `quantity`.
- **`pizzas`**: Holds pricing and size details for each pizza.
- **`pizza_types`**: Includes `pizza_type_id`, `name`, and `category` of pizzas.

---

🔍 Key SQL Concepts Used

**1️⃣ Joins**
We use **INNER JOIN, LEFT JOIN, and RIGHT JOIN** to combine multiple tables and extract meaningful insights.

Example:
```sql
SELECT order_details.order_details_id, pizzas.size, pizza_types.category
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id;
```

**2️⃣ Window Functions**
We use **RANK()** and **SUM() OVER()** to analyze cumulative trends and ranking of pizza sales.

Example (Top 3 pizza types by revenue in each category):
```sql
SELECT name, revenue 
FROM (
    SELECT 
        category, 
        name, 
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank_of_pizzatypes 
    FROM (
        SELECT 
            pizza_types.name, 
            pizza_types.category, 
            SUM(order_details.quantity * pizzas.price) AS revenue 
        FROM pizza_types 
        JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
        JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.name, pizza_types.category 
    ) AS A
) AS B
WHERE rank_of_pizzatypes <= 3;
```

**3️⃣ Subqueries**
Subqueries help break down complex queries into smaller, more readable parts.

Example (Find the highest-priced pizza):
```sql
SELECT pizza_id, price
FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);
```
---

📊 Key Insights Extracted
1. **Most Ordered Pizza Size:**
   - Using **GROUP BY and COUNT()**, we determined the most ordered pizza size.
2. **Top-Selling Pizzas by Revenue:**
   - Using **Window Functions (`RANK()`)**, we identified the highest revenue-generating pizzas per category.
3. **Category-wise Distribution of Pizzas:**
   - Using **GROUP BY**, we analyzed the number of pizzas available in each category.
4. **Total Revenue Generated:**
   - Using **SUM()**, we calculated the total sales revenue from all orders.

---

🚀 Conclusion
This project demonstrates how SQL can be used for effective sales analysis. By leveraging **Joins, Window Functions, and Subqueries**, we extracted valuable insights into sales trends, top-selling pizzas, and revenue distribution.

---

📜 Author
Pratham kumar  
Data Analyst Enthusiast | SQL | Python | power BI

---

🔹 *This project is part of my data analytics learning journey and college placement preparation.*

