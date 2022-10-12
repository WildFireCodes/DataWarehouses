--task1
with cte as(
select o.date,
	sum(od.quantity * p.price) as order_price
from orders o
join order_details od 
on o.order_id = od.order_id
join pizzas p
on od.pizza_id = p.pizza_id
where date = '2015-02-18'
group by o.order_id, o.date)
select date,
	cast(avg(order_price) as decimal(10, 2)) as avg_order_price_02_18
from cte
group by date;

--task2
select o.order_id
from orders o
join order_details od on o.order_id = od.order_id
join pizza_types pt on left(od.pizza_id, len(od.pizza_id) - 2) = pt.pizza_type_id
where month(date) = 3 and year(date) = 2015 
group by o.order_id
having string_agg(ingredients, ',') not like '%Pineapple%';

--task3
with cte as(
select o.order_id,
	o.date,
	sum(od.quantity * p.price) as order_price
from orders o
join order_details od on o.order_id = od.order_id
join pizzas p on od.pizza_id = p.pizza_id
where month(date) = 2
group by o.order_id, o.date)
select top (10) order_id,
	order_price,
	rank () over (order by order_price desc) as rank_price
from cte;

--task4
with cte as(
select o.order_id,
	sum(od.quantity * p.price) as order_amount,
	o.date
from orders o
join order_details od on o.order_id = od.order_id
join pizzas p on od.pizza_id = p.pizza_id
group by o.order_id, o.date)
select order_id,
	order_amount,
	avg(order_amount) over (partition by month(date)) as average_month_amount,
	date
from cte;

--task5
select count(order_id) as count_orders,
	date,
	datepart(hour, time) as hour
from orders 
where date = '2015-01-01'
group by date, datepart(hour, time);

--task6
select name,
	category,
	count(o.order_id) as count_orders
from orders o
join order_details od on o.order_id = od.order_id
join pizza_types pt on left(od.pizza_id, len(od.pizza_id) - 2) = pt.pizza_type_id
where month(date) = 1 and year(date) = 2015
group by name, category;

--task7
select size,
	count(o.order_id) as count_orders
from orders o
join order_details od on o.order_id = od.order_id
join pizzas p on od.pizza_id = p.pizza_id
where (month(date) = 2 or month(date) = 3) and year(date) = 2015
group by size;


