select *
from Orders

----------------------sum of sales 
select sum(Sales) as TotalSales
,sum(COGS) as TotalCOGS
,sum(Profit) as TotalProfit
,count(distinct [Order ID]) as TotalOrder 
,count(distinct [Customer ID]) as TotalCustomer
from Orders
--create cte
with cte_total as (
select sum(Sales) as TotalSales
,sum(COGS) as TotalCOGS
,sum(Profit) as TotalProfit
,count(distinct [Order ID]) as TotalOrder 
,count(distinct [Customer ID]) as TotalCustomer
from Orders)
select *
from cte_total

----------------------What Is the Most Used Shipping Mode by our Customers?		
select [Ship Mode],COUNT([Ship Mode]) 'Most Used Shipping Mode'
from Orders
group by [Ship Mode]
order by 2 desc
--create procedure Most Used Shipping Mode by Customers
create procedure ShippingMode as (
select [Ship Mode],COUNT([Ship Mode]) 'Most Used Shipping Mode'
from Orders
group by [Ship Mode]
)
-----------------------Who Is the Most Top 10 Customers in term of sales?		
select top 10 [Customer Name],sum(Sales) TotalSales
from Orders
group by [Customer Name]
order by TotalSales desc
-- create view Top 10 Customers in term of sales
CREATE VIEW Top10Customers As (
select top 10 [Customer Name],sum(Sales) TotalSales
from Orders
group by [Customer Name]
order by TotalSales desc)

select *
from Top10Customers

-----------------------Most Top 5 Customers in orders frequency	
select top 5 [Customer Name],COUNT(DISTINCT [Order ID]) TotaloRDER
from Orders
group by [Customer Name]
order by TotaloRDER desc

----------------------Which segment of clients generates the most sales by categories		
select Category,Segment,SUM(Sales) Mostsales
from Orders
group by Category,Segment 
order by 1,2 desc

----------------------Which city has the most sales value		
select top 3 city,SUM(Sales) Mostsales
from Orders
group by city
order by 2 desc

----------------------Which state generates the most sales  by region		
select top 20 Region,state,sum(convert(float,Sales)/sumallsales)*100 salesbyregion		
from Orders
group by Region,state
order by 3 desc

----------------------What are the top performing product categories in the terms of sales and profits?		
select Category	,[Sub-Category],SUM(sales) totalsales,SUM(profit) totalprofit
from Orders
group by Category,[Sub-Category]
order by 2 desc

----------------------countofSubCategory
select [Sub-Category],count([Sub-Category]) countofSubCategory
from Orders
group by [Sub-Category]
order by countofSubCategory desc
--create temp table countofSubCategory
drop table if exists #countofSubCategory
CREATE TABLE #countofSubCategory (
SubCategory nvarchar(255),
countofSubCategory int )

insert into #countofSubCategory 
select [Sub-Category],count([Sub-Category]) countofSubCategory
from Orders
group by [Sub-Category]
order by countofSubCategory desc

select *
from #countofSubCategory 
where countofSubCategory > 500 and SubCategory='storage'

