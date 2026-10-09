create database A_projects;
use A_projects;
select * from amazon_sales_report;
alter table amazon_sales_report
rename column `Order ID` to Order_id;
# Find duplicate rows.
select `index` ,Order_id,`Date`,Status,Fulfilment,`Sales Channel`,`ship-service-level`,Style,SKU,Category,Size,ASIN,`Courier Status`,Qty,currency,Amount,
`ship-city`,`ship-state`,`ship-postal-code`,`ship-country`,`promotion-ids`,B2B,`fulfilled-by`,`Unnamed: 22`
from amazon_sales_report
group by `index` ,Order_id,`Date`,Status,Fulfilment,`Sales Channel`,`ship-service-level`,Style,SKU,Category,Size,ASIN,`Courier Status`,Qty,currency,Amount,
`ship-city`,`ship-state`,`ship-postal-code`,`ship-country`,`promotion-ids`,B2B,`fulfilled-by`,`Unnamed: 22`
having count(*) >1;


# Find duplicate Order IDs.
select Order_id, count(*) as total_number_of_rows from amazon_sales_report
group by Order_id
having count(*) > 1;

#Find NULL values in important columns.
select *
from amazon_sales_report
where Order_id is null or SKU is null or `ship-service-level` is null or Qty is null or `Courier Status` is null;

# Find blank city/state values.
select *
from amazon_sales_report 
where  `ship-city` = '' or `ship-state` = '';

# Find orders where Amount is NULL.
select * 
from amazon_sales_report 
where Amount is null;

# Find records where Qty <= 0.
select * from 
amazon_sales_report 
where Qty <=0;

# Find all distinct order statuses.
select distinct(status) as Unique_Status 
from amazon_sales_report;

# Find all distinct fulfilment methods.
select distinct(fulfilment) as Unique_fulfilment 
from amazon_sales_report;

# Find all distinct categories.
select distinct(Category) as Categories 
from amazon_sales_report;

# Find all distinct courier statuses.
select distinct(`Courier Status`) as Couries_status 
from amazon_sales_report;

# Find the total number of orders.
select count(Order_id) as total_number_orders
from amazon_sales_report;

# Find the total quantity sold.
select sum(Qty) as total_quantity_sold 
from amazon_sales_report;

# Calculate total sales.
select round(sum(Amount),2) as total_sales
from amazon_sales_report;

# Calculate average order value.
select round(avg(Amount),2) as AVG_Order_Value 
from amazon_sales_report;

# Find the number of cancelled orders.
select count(
            case when `Status` = 'Cancelled' then 1 end ) as Num_of_cancelled
            from amazon_sales_report;

# Calculate cancellation percentage.
select count( case when Status = 'Cancelled' then 1 end) / count(*)*100 as cancelled_per 
from amazon_sales_report;

# Calculate the percentage distribution of order statuses.
select count( case when status = 'Cancelled' then 1 end ) / count(*)*100 as cancelled_per,
	   count(case when status = 'Shipped - Delivered to Buyer' then 1 end) / count(*)*100 as Shipped_Delivered_Buyer,
	   count(case when status = 'Shipped' then 1 end)  / count(*)*100 as Shipped_per,
       count(case when status = 'Shipped - Returned to Seller' then 1 end)  / count(*)*100 as Shipped_Return_seller,
       count(case when status = 'Shipped - Rejected by Buyer' then 1 end)  / count(*)*100 as Shipped_Rejected_Buyer,
       count(case when status = 'Shipped - Lost in Transit' then 1 end)  / count(*)*100 as Shipped_Lost_Transit,
       count(case when status = 'Shipped - Out for Delivery' then 1 end)  / count(*)*100 as Shipped_Out_for_Delivery,
       count(case when status = 'Shipped - Returning to Seller' then 1 end)  / count(*)*100 as Shipped_Returning_Seller,
       count(case when status = 'Shipped - Picked Up' then 1 end)  / count(*)*100 as Shipped_Picked_Up,
       count(case when status = 'Pending' then 1 end)  / count(*)*100 as Pending,
       count(case when status = 'Pending - Waiting for Pick Up' then 1 end)  / count(*)*100 as Pending_Waiting_for_Pick_Up,
       count(case when status = 'Shipped - Damaged' then 1 end)  / count(*)*100 as Shipped_Damaged
       from amazon_sales_report;
     

	select status , count(*) as number_of_order , 
    count(*)/ (select count(*) from amazon_sales_report) *100 as_per
    from amazon_sales_report
    group by status;
    
    # Find total sales by fulfilment method.
    select fulfilment , round(sum(Amount),2) as total_sales 
    from amazon_sales_report
    group by fulfilment;
    
    # Find average order value by fulfilment method.
    select fulfilment , round(avg(Amount),2) as AOV
    from amazon_sales_report
    group by fulfilment;
       
       
	# Find total B2B and non-B2B orders.
    select B2B , count(*) as number_of_order
    from amazon_sales_report 
    group by B2B;
    
    # Find total sales by category.
    select category , round(sum(Amount),2) as total_sales
    from amazon_sales_report
    group by category;
    
    # Find total quantity by category.
    select category , sum(Qty) as total_quantity
    from amazon_sales_report
    group by category;
    
    # Find the top 10 categories by sales.
    select category , round(sum(Amount),2) as total_sales 
    from amazon_sales_report
    group by category
    order by total_sales DESC
    limit 10;
    
    # Find the top 10 SKUs by sales.
    select SKU , round(sum(Amount),2) as total_sales 
    from amazon_sales_report 
    group by SKU 
    order by total_sales DESC
    limit 10;
    
    # Find the top 10 SKUs by quantity.
    select SKU , sum(Qty) as total_quantity 
    from amazon_sales_report
    group by SKU 
    order by total_quantity DESC
    limit 10;
    
    # Find the highest-selling category.
    select category , round(sum(Amount),2) as total_sales 
    from amazon_sales_report 
    group by category 
    order by total_sales DESC
    limit 1;
    
    # Find the highest-selling SKU.
    select SKU , round(sum(Amount),2) as total_sales
    from amazon_sales_report
    group by SKU
    order by total_sales DESC
    limit 1;
    
    # Calculate each category's percentage contribution to total sales.
    select category , round(sum(Amount),2) as total_sales ,
    sum(Amount)/(select sum(Amount) from amazon_sales_report) *100 as per_contri
    from amazon_sales_report
    group by category ;
    
    # Find the highest-selling size.
    select size , round(sum(Amount),2) as total_sales 
    from amazon_sales_report
    group by size
    order by total_sales desc
    limit 1;
    
    # Find SKUs ordered more than 100 times.
    select SKU , count(*) as total_order
    from amazon_sales_report 
    group by SKU 
    having count(*) > 100;
    
   # Find monthly sales.
   select year(`Date`) as Years , month(`Date`) as Monthly , round(sum(Amount),2) as total_sales 
   from amazon_sales_report
   group by  year(`Date`) , month(`Date`)
   order by  year(`Date`)  , month(`Date`);
   
   # Find monthly order volume.
   select year(`Date`) as Years , month(`Date`) as Monthly , count(*) as order_volume 
   from amazon_sales_report
   group by  year(`Date`) , month(`Date`)
   order by  year(`Date`)  , month(`Date`);
   
   # Find the month with the highest sales.
    select year(`Date`) as Years , month(`Date`) as Monthly , round(sum(Amount),2) as total_sales 
   from amazon_sales_report
    where year(`Date`)  is not null 
   group by  year(`Date`) , month(`Date`) 
   order by total_sales DESC
   limit 1;
   
   # Find the month with the highest number of orders.
   select year(`Date`) as Years , month(`Date`) as Months , count(*) as total_orders
   from amazon_sales_report 
   where year(`Date`) is not null
   group by year(`Date`)  , month(`Date`) 
   order by total_orders DESC
   limit 1;
    
    # Calculate month-over-month sales growth using LAG().
with MoM as (
select Year(`Date`) as Years , month(`Date`) as Monthly , round(sum(Amount),2) as total_sales
from amazon_sales_report
group by Year(`Date`)  , month(`Date`)) 

select Years , Monthly , total_sales , 
lag(total_sales) over( order by Years , Monthly) as MoM_sales
from MoM;

# Calculate monthly cancellation rate.
select Year(`Date`) as Years , month(`Date`) as Monthly , count( 
                                                                 case when status = 'Cancelled' then 1 end)/Count(*) *100 as cancellation_rate
from amazon_sales_report
group by Year(`Date`) , month(`Date`);
   

#Find the date with the highest sales.
select `Date` , round(sum(Amount),2) as total_sales 
from amazon_sales_report
group by `Date`
order by total_sales DESC 
limit 1;

# Calculate average daily sales.
with ads as (
select `Date` , round(sum(Amount),2) as daily_sales
from amazon_sales_report
group by `Date` 
order by `Date`)
select avg(daily_sales) as Avg_daily_sales
from ads;

# Find the top 5 sales dates.
select `Date` 
from ( select `Date` , sum(Amount) as total_sales
       from amazon_sales_report
       group by `Date`
       order by total_sales DESC
       limit 5) as tp ;
	
    select `Date` 
    from ( select `Date` , sum(Amount) as total_sales , row_number() over( order by sum(Amount) DESC ) as tp 
            from amazon_sales_report
            group by `Date`) as five 
	where five.tp <= 5;

# Find months where sales increased compared with the previous month.
with sales as (
select Year(`Date`) as Years , month(`Date`) as Monthly , round(sum(Amount),2) as total_sales 
from amazon_sales_report 
group by  Year(`Date`) , month(`Date`) ) ,
inc_sales  as( 
select Years , Monthly , total_sales , lag(total_sales) over(order by Years , Monthly ) as prev_sales
from sales ) 

select Years , Monthly , total_sales , prev_sales 
from inc_sales 
where total_sales > prev_sales ;

# Find total sales by state.
select `ship-state` , round(sum(Amount),2) as total_sales
from amazon_sales_report
group by `ship-state`;

# Find total orders by state.
select `ship-state` , count(*) as no_of_order
from amazon_sales_report
group by `ship-state`;

# Find the top 10 states by sales.
select `ship-state` , round(sum(Amount),2) as total_sales
from amazon_sales_report
group by `ship-state`
order by total_sales DESC
limit 10;

# Find the top 10 cities by sales.
select `ship-city` , round(sum(Amount),2) as total_sales
from amazon_sales_report
group by `ship-city`
order by total_sales DESC
limit 10;

# Find the average order value by state.
select `ship-state` , round(avg(Amount),2) as Avg_sales_State 
from amazon_sales_report
group by `ship-state`;

# Calculate each state's contribution to total sales.
select `ship-state` , round(sum(Amount),2) as total_sales , sum(Amount)/sum(sum(Amount)) over()*100 as per_contri
from amazon_sales_report 
group by `ship-state`;

# Find cities having more than 500 orders.
select `ship-city` , count(*) as total_orders
from amazon_sales_report
group by `ship-city`
having count(*) > 500;

# Find states whose cancellation rate is above the overall cancellation rate.
with cnr as (
select `ship-state` , count( 
                             case when status = 'Cancelled' then 1 end ) as cancellation , 
                             count( 
                             case when status = 'Cancelled' then 1 end )/count(*)*100 as cancel_rate
	from amazon_sales_report
    group by `ship-state`)
    
    select `ship-state` , cancellation ,cancel_rate
    from cnr 
    where cancel_rate > ( select count( case when status = 'Cancelled' then 1 end) / count(*) *100 as can_rate
                                       from amazon_sales_report) ; 
                                       
                                 
# Find total orders by fulfilment method.
select fulfilment , count(*) as total_order
from amazon_sales_report
group by fulfilment;

# Find total sales by fulfilment method.
select fulfilment , round(sum(Amount),2) as total_sales 
from amazon_sales_report
group by fulfilment ;

# Calculate cancellation rate by fulfilment method.
select fulfilment ,count( case when status = 'Cancelled' then 1 end) as cancelled ,
                    count( case when status = 'Cancelled' then 1 end)/count(*)*100 as cancelled_rate
                    from amazon_sales_report 
                    group by fulfilment;
	
    
    # Find order distribution by courier status.
    select `Courier Status` , count(*) as no_of_orders
    from amazon_sales_report
    group by `Courier Status` ;
    
    # Compare Standard vs Expedited shipping.
    select `ship-service-level` , count(*) as total_orders , round(sum(Amount),2) as total_sales , round(sum(Amount)/sum(sum(Amount)) over() *100,2) as per_contri,
    round(avg(Amount),2) as avg_order_value
    from amazon_sales_report 
    group by `ship-service-level`;
    
    # Find the fulfilment method with the highest average order value.
    select fulfilment , round(avg(Amount),2) as avg_order_value 
    from amazon_sales_report
    group by fulfilment
    order by avg_order_value DESC 
    limit 1;
    
    # Calculate total B2B sales.
    select B2B , round(sum(Amount),2) as total_sales
    from amazon_sales_report
    where B2B = 'True'
    group by B2B;
    
    # Calculate B2B sales contribution %.
    select B2B , round(sum(Amount),2) as total_sales , round(sum(Amount) / sum(sum(Amount)) over() *100,2) as per_contri
    from amazon_sales_report
    group by B2B;
    
   # Compare B2B vs non-B2B average order value.
   select B2B , round(avg(Amount),2) as total_sales 
   from amazon_sales_report 
   group by B2B ;
   
   # Find the top 10 cities by B2B sales.
   select `ship-city` , B2B , round(sum(Amount),2) as total_sales
   from amazon_sales_report
   where B2B = 'True'
   group by `ship-city` , B2B 
   order by total_sales DESC
   limit 10;
   
   # Find the top 5 SKUs in each category using RANK().
   select category , SKU , total_sales , rk from (
   select category , SKU , round(sum(Amount),2) as total_sales , rank() over(partition by category order by sum(Amount) DESC) as rk 
   from amazon_sales_report
   group by category , SKU) as tp
   where tp.rk <= 5;
   
   # Find the highest-selling SKU in each category.
   select category , SKU , total_sales  from (
   select category , SKU , round(sum(Amount),2) as total_sales , rank() over(partition by category order by sum(Amount) desc) as hs
   from amazon_sales_report
   group by category , SKU ) as chs
   where chs.hs = 1; 
   
   # Find the second-highest-selling SKU in each category.
   select category , SKU , total_sales  from (
   select category , SKU , round(sum(Amount),2) as total_sales , dense_rank() over(partition by category order by sum(Amount) desc) as seh
   from amazon_sales_report
   group by category , SKU) as csec
   where csec.seh = 2;
   
   # Calculate category sales contribution using a window function.
   with sales_con as (
   select category , round(sum(Amount),2)as total_sales 
   from amazon_sales_report
   group by category ) 
   
   select category , total_sales , round(total_sales /sum(total_sales) over() *100,4) as sales_contri 
   from sales_con;
   
   
   # Calculate monthly sales and previous-month sales using LAG().
   select year(`Date`) as Years , month(`Date`) as Months , round(sum(Amount),2) as total_sales, 
       round(lag(sum(Amount)) over( order by year(`Date`) , month(`Date`)),2) as prev_month
       from amazon_sales_report
       group by year(`Date`) , month(`Date`) ;
       
  # Calculate month-over-month sales growth.
  with MoM as (
  select year(`Date`) as Years , month(`Date`) as Months , round(sum(Amount),2) as total_sales ,
  lag(sum(Amount)) over(order by year(`Date`)  , month(`Date`) ) as prev_mom
  from amazon_sales_report
  group by year(`Date`)  , month(`Date`) ) 
  
  select Years , Months , total_sales , (total_sales-prev_mom) / prev_mom * 100 as MoM_growth
  from MoM
  order by Years , Months;
  
  # Find the top 3 cities within each state by sales.
  with first_cte as (
  select `ship-city` , `ship-state` , round(sum(Amount),2) as total_sales
  from amazon_sales_report 
  group by `ship-city` , `ship-state` ) 
  
  select `ship-city`,`ship-state`, total_sales , tp
  from (
  select `ship-city` , `ship-state` , total_sales , dense_rank() over(partition by `ship-state`  order by total_sales Desc) as tp 
  from first_cte ) as ch 
  where ch.tp <= 3;
  
  # Find states whose sales are above the average state sales.
  with state_sales as (
select `ship-state` , sum(Amount) as total_sales
from amazon_sales_report
group by `ship-state` )

select `ship-state` , total_sales 
from state_sales 
where total_sales > ( 
                     select avg(total_sales) from state_sales);
                     
# Find categories whose sales are above average category sales.
with category_sales as (
select category , sum(Amount) as total_sales 
from amazon_sales_report 
group by category ) 

select category , total_sales 
from category_sales 
where total_sales > ( select avg(total_sales) from category_sales);

# Find SKUs whose sales are above their category's average SKU sales.
with sku_sales as (
select category , SKU , sum(Amount) as total_sales 
from amazon_sales_report
group by category , SKU) 

select category , SKU , total_sales 
from sku_sales ss1 
where total_sales > ( select  avg(total_sales)  
                        from sku_sales ss2 
                        where ss2.category = ss1.category) 
order by category;

# Rank states by total sales.
select `ship-state` , sum(Amount) as total_sales , rank() over( order by sum(Amount) Desc) as rr 
from amazon_sales_report
group by `ship-state`;

# Rank categories by sales within each fulfilment method.
select category , Fulfilment , sum(Amount) as total_sales , rank() over(partition by Fulfilment order by sum(Amount) DESC) as rr
from amazon_sales_report 
group by Category , Fulfilment ;

# Find the top-selling SKU for each month.
select Months , SKU , total_sales 
from (
select month(`Date`) as Months , SKU , sum(Amount) as total_sales , rank() over(partition by month(`Date`)  order by sum(Amount) DESC) as tss
from amazon_sales_report 
group by month(`Date`) , SKU ) as ts
where ts.tss = 1;

# Find the month-over-month change in order volume.
with MoM as (
select month(`Date`) as Months ,  count(*) as no_of_order , lag(count(*)) over(order by  month(`Date`)) as prev_month
from amazon_sales_report 
group by month(`Date`) )

select Months , no_of_order , prev_month , (no_of_order - prev_month)/prev_month *100 as MoM_Volume
from MoM;

# Find the percentage of total sales generated by the top 10 SKUs.
with tp as (
select SKU , sum(Amount) as total_sales 
from amazon_sales_report 
group by SKU 
order by total_sales DESC ) ,
tp10 as (
select *
from tp
limit 10) 

select SKU , total_sales , sum(total_sales) over() as total_sales1 , 
                          sum(total_sales) over() / (select  sum(total_sales) from tp ) *100 as top_10_per
from tp10;

# Find categories appearing in every month.
select category 
from amazon_sales_report
group by category 
having count(distinct(month(`Date`))) = ( select  count(distinct(month(`Date`))) 
                                                   from amazon_sales_report ) ;

# Find cities having both B2B and non-B2B orders.
select `ship-city` 
from amazon_sales_report 
group by `ship-city`
having count(distinct(B2B)) = ( select count(distinct(B2B)) from amazon_sales_report);

# Find the highest-selling category for each state.
with cst as 
( select category , `ship-state` , sum(Amount) as total_sales , 
          rank() over(partition by `ship-state` order by sum(Amount) DESC) as tt
from amazon_sales_report 
group by Category , `ship-state` ) 

select  category , `ship-state` , total_sales 
from cst 
where tt = 1;

# Find the cancellation rate for each state and rank states from highest to lowest cancellation rate.
select `ship-state` , count( case when status = 'Cancelled' then 1 end)/count(*) *100 as cancellation_rate , rank() over( 
order by  count( case when status = 'Cancelled' then 1 end)/count(*) DESC) as rr 
from amazon_sales_report
group by `ship-state`;

# Find the top 3 categories by sales for each fulfilment method.
with tp as (
select category , fulfilment , sum(Amount) as total_sales
from amazon_sales_report
group by category , fulfilment ) 

select category , fulfilment , total_sales 
from (
select category , fulfilment , total_sales , rank() over(partition by fulfilment order by total_sales DESC) as rr 
from tp) as tp3
where tp3.rr <= 3;

# Find the category whose sales contribution is highest within each state.
with cs as (
select  `ship-state` , category ,sum(Amount) as total_sales 
from amazon_sales_report 
group by category , `ship-state`) 

select  `ship-state` , category , total_sales 
from (
select `ship-state`, category , total_sales , rank() over(partition by `ship-state` order by total_sales DESC) as hs
from cs) as es
where es.hs = 1;

# Find the state with the highest sales but also an above-average cancellation rate.
with hs as (
select `ship-state` , sum(Amount) as total_sales , count( case when status = 'Cancelled' then 1 end ) / count(*)*100 as cancellation_rate
from amazon_sales_report 
group by `ship-state` 
)

select `ship-state` , total_sales , cancellation_rate 
from hs 
where cancellation_rate > ( select avg(cancellation_rate) from hs)
order by total_sales DESC
limit 1;

# Find cities where sales are above their state's average city sales.
with csa as 
( select  `ship-city`,`ship-state`, sum(Amount) as total_sales 
from amazon_sales_report
 group by `ship-city`,`ship-state` )
 
 select `ship-city`,`ship-state` , total_sales 
 from (
 select `ship-city`,`ship-state` , total_sales , avg(total_sales) over (partition by `ship-state`) as Avg_state_sales
 from csa ) as avs
 where total_sales > avs.Avg_state_sales;
 
 # Find SKUs whose sales are above the overall average SKU sales and whose quantity sold is above the overall average quantity.
 with sks as (
 select SKU , sum(Amount) as total_sales , sum(Qty) as total_quantity
 from amazon_sales_report
 group by SKU )
 
 select SKU , total_sales , total_quantity
 from (
 select SKU , total_sales , total_quantity , avg(total_sales) over() as avg_sales 
 , avg(total_quantity) over() as avg_qty 
 from sks ) as sq
 where total_sales > avg_sales and total_quantity > avg_qty;
 
 # Calculate each state's: total sales,total orders ,average order value,cancellation rate,sales contribution %
 with kpi as (
 select `ship-state`,sum(Amount) as total_sales , count(*) as total_order , avg(Amount) as Avg_order_value , 
  count( case when status = 'Cancelled' then 1 end ) /count(*) *100 as cancellation_rate , sum(Amount)/sum(sum(Amount)) over() * 100 as sales_contri
  from amazon_sales_report 
  group by `ship-state` )
  
  select * 
  from kpi ;
  
  # Find the month with the highest sales for each category.
  with mhc as (
  select month(`Date`) as Months , category , sum(Amount) as total_sales 
  from amazon_sales_report
  group by month(`Date`)  , category )
  
  select Months , category , total_sales 
  from (
  select Months , category , total_sales , rank() over( partition by category order by  total_sales DESC) as rr
  from mhc ) as ct 
  where ct.rr = 1;
  
  # Find the top-selling SKU for each category for each month.
  with sku1 as (
  select month(`Date`) as Months, category , SKU , sum(Amount) as total_sales 
  from amazon_sales_report 
  group by month(`Date`) , category , SKU )
  
  select Months , category , SKU , total_sales , rr
  from (
  select Months , category , SKU , total_sales , rank() over(partition by category , Months order by total_sales DESC) as rr
  from sku1) as css
  where css.rr = 1;
  
  #  Find categories where sales increased for two consecutive months.
  with csi as (
  select category , month(`Date`) as Months , sum(Amount) as total_sales 
  from amazon_sales_report
  group by category , month(`Date`) ) ,
  twom as ( 
            select category , Months , total_sales , lag(total_sales) over(partition by category order by Months ) as prev_month ,
             lag(total_sales,2) over(partition by category order by Months )  as prev_2
            from csi ) 
            
select * from twom
where total_sales > prev_month and prev_month > prev_2;

# Find states where sales increased but order volume decreased compared with the previous month.
with sio as (
select `ship-state` , month(`Date`) as Months , sum(Amount) as total_sales , count(*) as total_order 
from amazon_sales_report
group by `ship-state` , month(`Date`) ) ,
lastmonth as ( 
               select `ship-state` , Months , total_sales , total_order , 
               lag(total_sales) over(partition by `ship-state` order by Months) as prev_month_sales ,
                              lag(total_order) over(partition by `ship-state` order by Months) as prev_month_order
                              from sio
                              ) 
		select * from lastmonth
        where total_sales > prev_month_sales and total_order < prev_month_order;


# Find cities having both B2B and non-B2B orders and calculate their B2B sales contribution.
select `ship-city` , 
                     count(distinct(B2B)) as total_order , 
                     sum(case when B2B = 'True' then Amount Else 0 end ) as total_sales ,
                      sum(case when B2B = 'True' then Amount Else 0 end ) / sum(Amount) *100 as sales_contri
from amazon_sales_report
group by `ship-city` 
having count(distinct(B2B))  = ( select count(distinct(B2B)) from amazon_sales_report);

# Find the highest-selling category in each state and show its percentage contribution to that state's total sales.
with hcs as (
select `ship-state` , category , sum(Amount) as total_sales 
from amazon_sales_report
group by `ship-state`, category ) ,
ranks as (
         select `ship-state` , category , total_sales , rank() over(partition by `ship-state` order by total_sales DESC) as rr
         , sum(total_sales) over(partition by `ship-state`) as state_total 
         from hcs) 


	select `ship-state` , category , total_sales , state_total , (total_sales/state_total)*100 as per_contri
    from ranks 
    where rr = 1;
    
    # Create a single SQL result containing: Total Sales,Total Orders,Total Quantity,Average Order Value,Cancellation Rate,B2B Sales %,Top Category,Top State,Top SKU
    with overall as (
    select sum(Amount) as total_sales , count(*) as total_order , sum(Qty) as total_quantity , avg(Amount) as Avg_order_value ,
           count( case when status = 'Cancelled' then 1 end )/ Count(*)*100 as cancellation_rate ,
           sum( case when B2B = 'True' then Amount end)/sum(Amount)*100 as B2B_sales_contri 
           from amazon_sales_report) ,
		topcat as (
           select category , sum(Amount) as total_sales 
           from amazon_sales_report 
           group by category 
           order by total_sales Desc
           limit 1 ) ,
		topstate as ( 
        select `ship-state` , sum(Amount) as total_sales 
        from amazon_sales_report
        group by `ship-state`
        order by total_sales DESC
        limit 1) , 
        topsku as (
        select SKU , sum(Amount) as total_sales 
        from amazon_sales_report 
        group by SKU
        order by total_sales DESC 
        limit 1) 
        
        select o.total_sales , o.total_order , o.total_quantity ,o.Avg_order_value , o.cancellation_rate , o.B2B_sales_contri, 
        c.category , s.`ship-state`,sk.SKU
        from overall o 
        cross join topcat c
        cross join topstate s
        cross join topsku sk ; 
        










