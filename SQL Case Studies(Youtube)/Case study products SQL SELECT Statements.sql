#SELECT statements

#Q1 Maximum quantity sold in a transaction
select max(quantity) from tr_orderdetails;
select max(quantity), count(*) from tr_orderdetails;

#Q2 Unique products in all transactions
select distinct(ProductID) from tr_orderdetails;

#Q3 Unique properties
select distinct(PropertyID) from tr_orderdetails;
select count(distinct(PropertyID)) from tr_orderdetails