drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR (120),
name VARCHAR (150) NOT NULL,
mrp NUMERIC (8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER, 
outOfStock BOOLEAN,
quantity INTEGER
);

------------------- Data exploration -------------------

--Count number of rows--
select count(*)
from zepto

--Sample data---
select *
from zepto
limit 10

--Check Null values--
select *
from zepto 
where category is NULL
or
name is NULL
or
mrp is NULL
or
discountpercent is NULL
or
availablequantity is NULL
or
discountedsellingprice is NULL
or
weightingms is NULL
or
outofstock is NULL
or
quantity is NULL;

--Different product categories--
select distinct category
from zepto
order by 1;

--Number of items instock vs outofstock--
select outofstock, count(sku_id)
from zepto
group by 1

--Product names present multiple times--
select name, count(sku_id)
from zepto
group by name
having count(sku_id) > 1
order by 2 desc;

--------------------Data cleaning--------------------

--Products with price 0--
select *
from zepto 
where mrp=0 or discountedsellingprice=0;
-- Deleting item with price is 0--
Delete from zepto 
where mrp=0;

-- Updating mrp and discountedselling price from pasie to rupees--
update zepto
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;
--for check--
select mrp,discountedsellingprice
from zepto;


--Q1. find the best top 10 value product based on discount percent?--
select distinct name,mrp,discountpercent
from zepto 
order by 3 desc
limit 10;

--Q2. What are the products with High mrp but outofstock?--
select name,max(mrp)
from zepto
where outofstock='true' 
group by name
order by 2 desc;

--Q3. calculate estimated revenue for each category?--
select sum(discountedsellingprice*availablequantity) as total_revenue
from zepto
group by category
order by 1 desc;

--Q4. Find all products where mrp is greater than 500 and discount is less than 10%.--

select distinct name,mrp,discountpercent
from zepto
where mrp > 500 and discountpercent < 10
order by 2 desc, 3 desc

--Q5. Identify the top 5 categories offering the highest average discount percent.---

select category,round(avg(discountpercent),2)
from zepto
group by category
order by 2 desc
limit 5

--Q6. Find the price per gram for products above 100g and sort by best value.--

select distinct name,weightingms,round(discountedsellingprice/weightingms,2) as price_per_gm
from zepto
where weightingms > 100
order by price_per_gm 

--Q7. Group the products into categories like low,medium and bulk.--

select distinct name,
case
   when weightingms < 1000 then 'Low'
   when weightingms < 5000 then 'Mid'
   else 'bulk'
   end as Product_categories
from zepto

--Q8. what is the total inventory weight per category.--
select sum(weightingms*availablequantity) as Total_weight ,category
from zepto
group by category
order by 1 desc








