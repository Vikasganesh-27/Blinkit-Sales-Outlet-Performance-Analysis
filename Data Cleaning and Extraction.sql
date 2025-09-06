-- Display Table

select *
from blinkit_data;

-- Data Cleaning
select Item_Fat_Content,
case
	when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
	when Item_Fat_Content = 'reg' then 'Regular'
	else Item_Fat_Content
end as updated_item_table
from blinkit_data;

update blinkit_data
set Item_Fat_Content = 
case
	when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
	when Item_Fat_Content = 'reg' then 'Regular'
	else Item_Fat_Content
end;

-- A. KPIs

-- 1. Total Sales

select cast(sum(Total_Sales)/1000000.0 as decimal(10,2)) as total_sales_millions
from blinkit_data;

-- 2. Average Sales

select cast(avg(Total_Sales) as int) as Avg_Sales
from blinkit_data;

-- 3. No. of Items

select count(*) as order_no
from blinkit_data;

-- 4. Average Rating

select cast(avg(Rating) as decimal(10,1)) as Avg_Rating
from blinkit_data;

-- B. Total Sales by Fat Content

select Item_Fat_Content, cast(sum(Total_Sales) as decimal(10,2)) as	Total_Sales
from blinkit_data
group by Item_Fat_Content;

-- C. Total Sales by item type

select Item_Type, cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Item_Type
order by Total_Sales DESC;

-- D. Fat Content by Outlet for Total Sales

select Outlet_Location_Type, 
ISNULL([Low Fat], 0) as Low_Fat,
ISNULL([Regular], 0) as Regular
from 
(select Outlet_Location_Type, Item_Fat_Content, cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Outlet_Location_Type, Item_Fat_Content) as sourceTable
pivot(
sum(Total_Sales)
for Item_Fat_Content in ([Low Fat], [Regular])
) as PivotTable
order by Outlet_Location_Type;

-- E. Total Sales by Outlet Establishment

select Outlet_Establishment_Year, cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Outlet_Establishment_Year
order by Total_Sales desc;

-- F. Percentage of Sales by Outlet Size

select Outlet_Size, cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales, 
cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2)) as sales_percentage
from blinkit_data
group by Outlet_Size
order by Total_Sales desc;

-- G. Sales by Outlet Location

select Outlet_Location_Type, cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Outlet_Location_Type
order by Total_Sales desc;

-- H. All metrics by Outlet Type

select Outlet_Type,
cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
cast(avg(Total_Sales) as decimal(10,2)) as Average_Sales,
count(*) as No_of_Items,
cast(avg(Rating) as decimal(10,2)) as Average_Rating,
cast(avg(Item_Visibility) as decimal(10,2)) as Item_Visibility
from blinkit_data
group by Outlet_Type
order by Total_Sales desc;