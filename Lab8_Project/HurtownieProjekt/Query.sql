--1. Ranking na podstawie sumy sprzedazy + rok z DimDate
select
	rank() over (order by sum(cast(f.amount as decimal(10,2)))) as ranks,
	sum(cast(f.amount as decimal(10,2))) as sum_sales,
	d.year as year
from factsales f
join dimdate d 
on f.datekey = d.datekey
group by d.year;

--2. Ranking sumy sprzedazy dla kazdego przewoznika (percentiles) w 2009 roku
select
	cast(percent_rank() over (partition by year(f.date) order by sum(cast(f.amount as decimal(10,2)))) as decimal(10,2)) as percentiles,
	sum(cast(f.amount as decimal(10,2))) as sum_sales,
	year(f.date) as sales_year,
	c.carrier_name as carrier
from factsales f
left join dimcarrier c
on f.carrier_id_key = c.carrier_id
where year(f.date) = '2009'
group by rollup( year(f.date), c.carrier_name)

--3. Srednia kroczaca
select 
	sum(cast(f.amount as decimal(10,2))) as sum_sales,
	cast(avg(sum(cast(f.amount as decimal(10,2)))) over (order by date rows between 7 preceding AND current row) as decimal(10,2)) AS moving_avg,
	date as sales_date
from factsales f
group by date
order by date

--4. Proste statystyki - najbardziej dochodowe 5 stanow w 2008
select
	rank() over (order by sum(cast(f.amount as decimal(10,2)))) as ranks,
	sum(cast(f.amount as decimal(10,2))) as sum_sales,
	STDEV(sum(cast(f.amount as decimal(10,2)))) over (order by sum(cast(f.amount as decimal(10,2)))) as stdev_sales,
	c.state
from factsales f
left join dimcustomers c
on f.customer_id_key = c.id_key
where year(f.date) = 2008
group by c.state


