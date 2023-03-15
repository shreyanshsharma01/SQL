use zomato_case_study;

-- #1 Find customer who have never ordered?
select u.name, u.user_id
from users u Left join orders o 
on u.user_id = o.user_id
group by u.user_id
having count(u.user_id) = 1; 
-- or 
SELECT u.name, u.user_id
FROM users u LEFT JOIN orders o 
ON u.user_id = o.user_id
WHERE o.user_id IS NULL;
-- or
SELECT name,user_id 
FROM users 
WHERE user_id NOT IN 
      (SELECT user_id FROM orders);
      
-- #2 Calculate averagee price of dish/food and then sort the dish in desc order
select avg(price) as avg_price 
from menu 
where f_id in (select f_id,f_name from food);

select f.f_name,avg(m.price) as avg_price
from menu m left join food f 
on m.f_id = f.f_id 
group by m.f_id
order by avg_price desc;

-- #3 FInd top restaurant in terms of number of orders for a given month
select r.r_name, COUNT(o.r_id) as Orders 
from restaurants r join orders o  
on r.r_id = o.r_id
where monthname(date) like 'May'
group by o.r_id
order by COUNT(o.r_id) desc limit 1;
 
-- #4 Find the restaurants with monthly sales > x. x = any amount
select r.r_name,sum(o.amount) as Sales 
from orders o join restaurants r 
on o.r_id = r.r_id
group by r.r_name
having sum(o.amount) > 1500;

-- #5 Show all orders with order details for a particular customer in a particular date range
select u.name,o.amount,r.r_name,f.f_name
from orders o join users u 
on o.user_id = u.user_id join order_details od
on o.order_id = od.order_id join restaurants r 
on o.r_id = r.r_id join food f 
on od.f_id = f.f_id 
where u.name like 'Ankit' 
and date between '2022-06-10' and '2022-07-10';

-- #6 Show the number of customers who placed orders at each restaurant. 
select r.r_id,r.r_name, count(o.user_id) as Customers  
from orders o join restaurants r 
on o.r_id = r.r_id
group by r_id;

-- #7 Find restaurants with max repeated customers
select r.r_name,count(*) as 'Loyal_customers'
from (select r_id, user_id,count(*) as 'Visits' 
      from orders
      group by r_id,user_id
      having Visits > 1
      ) t join restaurants r 
on t.r_id = r.r_id 
group by t.r_id
order by Loyal_customers desc limit 1;
      
-- #8 Find the month over month growth of zomato.
-- Basically it means how much % revenue earned each month

with sales as 
(
	select monthname(date) as Month,sum(amount) As Revenue
	from orders
	group by Month 
) -- this query will give month & revenue of the month. Using 'with' to store the value of the query  
  -- using this value in the next query 
  -- here lag is used to shift the row by 1 downside  
  select Month,revenue,lag(revenue,1) over (order by Revenue) as prev 
  from sales
  
  -- now we need to calculate the growth so rewriting the final query
  select Month,((revenue - prev)/prev)*100 as Growth%
  from (
      with sales as 
      (
	   select monthname(date) as Month,sum(amount) As Revenue
	   from orders
	   group by Month 
      )   
      select Month,revenue,lag(revenue,1) over (order by Revenue) as prev 
      from sales
  ) t

-- #9 Calculate the customer and their favourite food?
-- Favourite food can be calc as the food ordered the most by the same customer

select o.user_id,max(Frequency)
from orders o inner join
(select o.user_id,od.f_id,count(*) as Frequency
from orders o join order_details od
on o.order_id = od.order_id 
group by o.user_id,od.f_id ) as t
on o.user_id = t.user_id
group by o.user_id 
-- this query will return table with user_id & their frequency of food order 
-- but we need to further convert user_id to user name & f_if to food name 
-- so this query will increase complexity  so using "WITH" clause

with temp as 
(select o.user_id,od.f_id,count(*) as Frequency
from orders o join order_details od
on o.order_id = od.order_id 
group by o.user_id,od.f_id -- this will group user_id with f_id for favourite food
)
select u.name,f.f_name, Frequency
from temp t1 join users u
on t1.user_id = u.user_id join food f 
on t1.f_id = f.f_id
where t1.Frequency = (select max(Frequency)
					  from temp t2 
					  where t1.user_id = t2.user_id ) 
-- this will return user name, food name & their frequency
										