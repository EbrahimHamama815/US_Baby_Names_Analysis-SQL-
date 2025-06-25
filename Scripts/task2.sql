use baby_names_db;

-- finding the top 3 names each year
with cte1 as (select Year, Gender, Name, sum(Births) as total_count
from names
group by 1,2,3)
,
cte2 as (select Year, Gender, Name, total_count, row_number() over(partition by Year,Gender order by total_count desc) as ranking
from cte1)

select Year, Gender, Name, total_count, ranking
from cte2
where ranking in (1,2,3);

-- ==================================================================

-- finding the top 3 names each decade 
-- (same query except for the year column we replace it with a simple calculation to calculate decades)
with cte1 as (select floor(Year/10)*10 as decade, Gender, Name, sum(Births) as total_count
from names
group by 1,2,3)
,
cte2 as (select decade, Gender, Name, total_count, row_number() over(partition by decade,Gender order by total_count desc) as ranking
from cte1)

select concat(decade,"s") as decade, Gender, Name, total_count, ranking
from cte2
where ranking in (1,2,3);
