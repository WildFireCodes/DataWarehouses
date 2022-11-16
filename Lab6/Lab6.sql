-- Zadanie 1

with cte as 
(
SELECT
	[OrderDate],
	sum([SalesAmount]) as sales
  FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
  group by [OrderDate]
)

select
	[OrderDate],
	sales,
	avg(Sales) over (order by [OrderDate] rows between 3 preceding and current row) as avg_sales
from cte;

-- Zadanie 2

select month_of_year,
	[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]
from 
(
select 
      [SalesTerritoryKey],
      [SalesAmount],
	month([OrderDate]) as month_of_year
  from [AdventureWorksDW2019].[dbo].[FactInternetSales]
  where year([OrderDate]) = 2011
) as tab1
pivot
(
 sum([SalesAmount])
  for [SalesTerritoryKey] IN ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10])
) as tab2
order by month_of_year;

-- Zadanie 3

select 
	[DepartmentGroupKey],
      [OrganizationKey],
      sum([Amount])
from [AdventureWorksDW2019].[dbo].[FactFinance]
group by rollup([OrganizationKey], [DepartmentGroupKey])
order by [OrganizationKey];

-- Zadanie 4

select 
	[DepartmentGroupKey],
      [OrganizationKey],
      sum([Amount])
from [AdventureWorksDW2019].[dbo].[FactFinance]
group by cube([OrganizationKey], [DepartmentGroupKey])
order by [OrganizationKey];

-- Zadanie 5

with cte as(
	select OrganizationKey, 
		sum(Amount) as sum_amount
	from dbo.FactFinance
	where year(Date)=2012
	group by OrganizationKey
)

select t.OrganizationKey, 
	t.sum_amount, 
	perecent_rank() over (order by t.sum_amount) as percentiles,
	d.OrganizationName
from cte t
join dbo.DimOrganization d
on d.OrganizationKey = t.OrganizationKey
order by t.OrganizationKey;

-- Zadanie 6

with cte as(
	select OrganizationKey, 
		sum(Amount) as sum_amount
	from dbo.FactFinance
	where year(Date)=2012
	group by OrganizationKey
)

select t.OrganizationKey, 
	t.sum_amount, 
	perecent_rank() over (order by t.sum_amount) as percentiles,
	d.OrganizationName,
	stdev(t.sum_amount) over (order by t.sum_amount) as std_dev
from cte t
join dbo.DimOrganization d
on d.OrganizationKey = t.OrganizationKey
order by t.OrganizationKey;
