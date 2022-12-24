# GROUP BY statements:

#Q1 Find the product category that has maximum products
select max(ProductCategory) from tr_products; 
select ProductCategory,count(*) as COUNT from tr_products group by ProductCategory order by 2 desc; # 2 is 2nd column

#Q2 Find the state where most stores are present
select PropertyState, count(*) as COUNT from tr_propertyinfo group by PropertyState order by 2 desc; 

#Q3 Find the top 5 productIDs that did maximum sales in terms of quantity 
select ProductID, sum(Quantity) as Total_quantity from tr_orderdetails group by ProductID order by 2 desc limit 5;

#Q4 find the top 5 propertyID that did maximum quantity
select PropertyID, sum(Quantity) as Total_quantity from tr_orderdetails group by PropertyID order by 2 desc limit 5;
