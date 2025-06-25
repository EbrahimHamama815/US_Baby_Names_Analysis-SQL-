use baby_names_db;

-- because the data base is too large (~2M rows) we index the needed columns for this task so we optimize query running times
create index idx_year_gender_name on names(Year, Gender, Name);
-- drop index idx_year_gender_name on names;
select * from names where Name = "Jessica";

-- Task 1:

-- finding overall most used name for males and females
with cte1 as (select Gender, Name, sum(Births) as total_count
from names
group by 1,2)

select Gender, Name, total_count
from cte1
where total_count in ((select max(total_count) from cte1 where Gender = "M"),(select max(total_count) from cte1 where Gender = "F"));

-- -----------------------------------------

-- finding how the rank of the most used female and male name changed over the years (side by side)
with cte1 as (select Year, Gender, Name, sum(Births) as total_count
from names
group by 1,2,3)
,
cte2 as (select Year, Gender, Name, row_number() over(partition by Year,Gender order by total_count desc) as ranking from cte1)
,
cte3 as (select * from cte2 where Name = "Jessica" and Gender = "F")
,
cte4 as (select * from cte2 where Name = "Michael" and Gender = "M")

select g.Year, g.Name, g.ranking, b.Name, b.ranking
from cte3 g
join cte4 b where g.Year = b.Year;

-- ==================================================================
-- Task 2
-- Names that had the greatest change in popularity from 1980 to 2009 
-- negative value means popularity increase while positive means decrease
with cte1 as (select Year, Gender, Name, sum(Births) as total_count
from names
group by 1,2,3)
,
cte2 as (select Year, Gender, Name, row_number() over(partition by Year,Gender order by total_count desc) as ranking 
from cte1
where Year = 1980)
,
cte3 as (select Year, Gender, Name, row_number() over(partition by Year order by total_count desc) as ranking 
from cte1
where Year = 2009)

select 
	t1.Gender,
	t1.Year, t1.Name, t1.ranking,
    t2.Year, t2.Name, t2.ranking,
    cast(t2.ranking as signed)-cast(t1.ranking as signed) as popularity_diff
from cte2 t1
inner join cte3 t2 on t1.Name = t2.Name
order by popularity_diff;
