use project;

-- ECONOMIC EFFECTS ON PURCHASING
-- This dataset represent the purchasing behaviour due to econimic conditions. 
-- By using this dataset our aim to demonstrate the bulk in purchasing sector for the different types of industries over the year
-- under the changing condition of economic.
-- we have Three tables that indicate the purchasing bulk due to economic conditions

# Economic_data - It provide the economic data like - Gdp, cpi, unemployment_rate etc
select * from economic_data;
# Companies -  It provide the different types of companies, thier name and locations etc 
select * from companies;
# Purchases -  It provide the Purchasing information of industries like revenue, quantity and productcategory
select * from purchases;

-- Describe the tables
describe economic_data;
describe companies;
describe purchases;

-- Found the date column in economic_data and purchase have the datatype in text formate.
-- Modify the datatype text to date
alter table economic_data modify column Date date;
describe economic_data;

alter table purchases modify column date date;
describe purchases;

select date, year(date) as Year, quarter(date) as Qtr, month(date) as Month from purchases;

-- Create some measure for purchasing data that would be help us to understand the data more clearly

# 1) Total_Revenue of purchasing
 select sum(revenue) as Total_revenue from purchases;

# 2) CurrentYear_Revenue                     -- Here, Yr standfor Year, CY_revenue standfor current year revenue
select Yr,CY_revenue from ( 
select year(date) as Yr, sum(revenue) as CY_revenue from purchases group by Yr) dt; 

# 3) PreviousYear_Revenue                    -- Here, PY_revenue  standfor previous year revenue
select Yr,PY_revenue from (                  
select year(date) as Yr,sum(revenue) as CY_revenue, lag(sum(revenue),1) over(order by year(date)) as PY_revenue from purchases
group by Yr) dt;

# 4) YOY%_Revenue_Change                     -- Here, YOY%_change standfor Year of Year Percent Change in Revenue   
select round(((CY_revenue-PY_revenue)/PY_revenue)*100,4) as `YOY%_revenue` from (
select PY_revenue,CY_revenue from (
select year(date) as Yr,sum(revenue) as CY_revenue, lag(sum(revenue),1) over(order by year(date)) as PY_revenue from purchases
group by Yr) dt) dt1;

-- Now we compute Quantity changes with respect to Date
# 5) Total_quantity
select sum(quantity) as Total_quantity from purchases;

# 6) CY_quantity
select Yr, CY_quantity from (
select year(date) as Yr, sum(quantity) as CY_quantity from purchases group by Yr) dt;

# 7) PY_quantity
select Yr, PY_quantity from (
select year(date) as Yr,  sum(quantity) as CY_quantity, lag(sum(quantity),1) over(order by year(date)) as PY_quantity from purchases
group by Yr) dt;

# 8) YOY%_Revenue_Change
select round(((CY_quantity-PY_quantity)/PY_quantity)*100,4) as `YOY%_revenue` from (
select Yr,CY_quantity, PY_quantity from (
select year(date) as Yr,  sum(quantity) as CY_quantity, lag(sum(quantity),1) over(order by year(date)) as PY_quantity from purchases
group by Yr) dt ) dt1;

# 9) Year by Quarter_Revenue change                    -- Here, Qtr standfor Quarter, CQ_revenue standfor Current Year Quarter Revenue
select Yr,Qtr,CQ_revenue from (
select year(date) as Yr, quarter(date) as Qtr, sum(revenue) as CQ_revenue from purchases group by Qtr, Yr order by Yr,Qtr) dt; 

# 10) Previous Year by Quarter_Revenue Change          -- Here, PQ_revenue standfor Previous Year Revenue
select Yr,Qtr,CQ_revenue,PQ_revenue from (
select year(date) as Yr, quarter(date) as Qtr,sum(revenue) as CQ_revenue,
lag(sum(revenue),1) over(order by year(date),quarter(date)) as PQ_revenue
from purchases group by Qtr, Yr) dt; 

# 11) QOQ%_Revenue_Change                              -- Here, QOQ%_revenue standfor Quarter of Quarter Percent Change in Revenue  
select round(((CQ_revenue-PQ_revenue)/PQ_revenue)*100,4) as `QOQ%_Change` from (
select CQ_revenue,PQ_revenue from (
select year(date) as Yr, quarter(date) as Qtr,sum(revenue) as CQ_revenue, 
lag(sum(revenue),1) over(order by year(date),quarter(date)) as PQ_revenue
from purchases group by Qtr, Yr) dt) dt1;

# 12) Average Revenue for Per Purchase
select (sum(revenue)/sum(quantity)) as Avg_revenue_PerPurchase from purchases;


-- Now we calculate the appropiate measure that display the Economic changes by Time

# 13) Total_GDP
select sum(gdp_value) as Total_Gdp from economic_data; 

# 14) Current Year GDP value
select year(Date) as Yr, Sum(gdp_value) as CY_gdp from economic_data group by Yr;

# 15) Previous Year GDP value
select year(Date) as Yr, Sum(gdp_value) as CY_gdp , lag(Sum(gdp_value),1) over(order by year(Yr)) as PY_gdp from economic_data group by Yr;

# 16) YOY%_Change GDP Rate
select round(((CY_gdp-PY_gdp)/PY_gdp)*100,4) as `YOY%_gdp` from (
select year(Date) as Yr, Sum(gdp_value) as CY_gdp , lag(Sum(gdp_value),1) over(order by year(Yr)) as PY_gdp from economic_data group by Yr
) dt;

-- Now calculate the Customer Price Index (CPI) changes rate 

# 17) Total_cpi
select sum(cpi) as Total_cpi from economic_data; 

# 18) Curreny Year CPI
select Yr, CY_cpi from (
select year(Date) as Yr, sum(cpi) as CY_cpi from economic_data group by Yr) dt;

# 19) Previous Year CPI
select  Yr, CY_cpi, PY_cpi from (
select year(Date) as Yr, sum(cpi) as CY_cpi, lag(sum(cpi),1) over(order by year(Yr)) as PY_cpi from economic_data group by Yr) dt;

# 20) YOY%_CPI change
select round(((CY_cpi-PY_cpi)/PY_cpi)*100,4) as `YOY%_cpi` from (
select  Yr, CY_cpi, PY_cpi from (
select year(Date) as Yr, sum(cpi) as CY_cpi, lag(sum(cpi),1) over(order by year(Yr)) as PY_cpi from economic_data group by Yr) dt) dt1;

# 21) CPI Index OverTime
select avg(CPI) as CPI_index_overTime from (
select Date,sum(cpi) as CPI from economic_data group by Date) dt;

# 22) Unemployment_Rate OverTime
select avg(Unp_rate) as Unemployment_Rate_OverTime from(
select Date,sum(unemployment_rate) as Unp_rate from economic_data group by Date) dt;


-- There are some visual about our data that represent the deep insight of it

# Q.1) Top Product categories by total revenue
select productcategory, sum(revenue) as Total_revenue from purchases group by productcategory order by Total_revenue desc;

# Q.2) Top Product categories by total quantity
select productcategory, sum(quantity) as Total_quantity from purchases group by productcategory order by Total_quantity desc;

# Q.3) Top product categories by previous year revenue
select productcategory, round(sum(revenue),2) as previous_year_revenue from purchases where year(date) = 2020
group by productcategory order by previous_year_revenue desc;


# Q.4) Top product catogries by YOY%_change_revenue
select productcategory, round(((CY_revenue-PY_revenue)/PY_revenue)*100,4) as `YOY%_revenue` from (
select productcategory,CY_revenue,PY_revenue from (
select productcategory, year(date) as Yr,sum(revenue) as CY_revenue, 
lag(sum(revenue),1) over(order by year(date)) as PY_revenue from purchases
group by Yr,productcategory) dt) dt1;


# Q.5) Mortage_rate and Unemployment_rate changes over the Year
delimiter //
create procedure year_wise_ckeck(in year_value int)
begin
select year(date) as Yr,mortgage_rate_30y, unemployment_rate from economic_data
where year(date)= year_value;
end //
delimiter ;

call year_wise_ckeck(2019);


# Q.6) calculate the GDP value change for different type of comapnies_id 
delimiter //
create procedure company_wise_gdp(in id int)
begin
select c.company_id,c.company_name, sum(e.gdp_value) as gdp_value from companies c
inner join purchases p on  c.company_id=p.company_id
inner join economic_data e on year(p.date) = year(e.Date)
where  c.company_id= 2
group by  c.company_id,c.company_name;
end //
delimiter ;

call company_wise_gdp(9);

# Q.7) YOY%_Change Revenue and YOY%_Change GDP
with cte1 as
(select round(((CY_quantity-PY_quantity)/PY_quantity)*100,2) as `YOY%_revenue` from (
select Yr,CY_quantity, PY_quantity from (
select year(date) as Yr,  sum(quantity) as CY_quantity, lag(sum(quantity),1) over(order by year(date)) as PY_quantity from purchases
group by Yr) dt ) dt1)
select * from cte1;

with cte2 as 
(select round(((CY_gdp-PY_gdp)/PY_gdp)*100,2) as `YOY%_gdp` from (
select year(Date) as Yr, Sum(gdp_value) as CY_gdp , lag(Sum(gdp_value),1) over(order by year(Yr)) as PY_gdp from economic_data group by Yr
) dt)
select * from cte2;


