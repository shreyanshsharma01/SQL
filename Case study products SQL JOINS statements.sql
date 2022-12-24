# JOINS & GROUP BY

#Q1 Find the top 5 product names that did max in sales in terms of quantity
# then find top 5 products that did max sales 
select o.*, p.ProductName,p.ProductCategory,p.Price
from tr_orderdetails as o 
LEFT JOIN tr_products as p on o.ProductID = p.ProductID;  # just joined the 2 tables

select p.ProductName, sum(o.Quantity*p.Price) as Sales
from tr_orderdetails as o
LEFt JOIN tr_products as p on o.ProductID = p.ProductID 
group by p.ProductName
order by Sales desc limit 5;


#Q2 Find the top 5 cities that did max sales
select o.*,pr.PropertyCity from tr_orderdetails as o
LEFT JOIN tr_propertyinfo as pr on o.PropertyID = pr.`Prop ID`; #only join of tables

select pr.PropertyCity, sum(o.Quantity*p.Price) as Sales
from tr_orderdetails as o 
LEFT JOIN tr_products as p on o.ProductID = p.ProductID
LEFT JOIN tr_propertyinfo as pr on o.PropertyID = pr.`Prop ID`
group by pr.PropertyCity
order by Sales desc limit 5;
 
