use baby_names_db;

-- adding the region for the state MI in the regions table as it was not present
insert into regions set State = "MI", Region = "Midwest";
-- updating the "New England" so we don't have it twice
update regions set Region = "New_England" where Region = "New England";

-- -----------------------------------------

-- number of babies born in each region
select Region, sum(Births) as total_babies
from names
left join regions on regions.State = names.State
group by 1
order by 2 desc;

-- =======================================================================

-- top 3 popular girl names and  boy names within each region
with cte1 as (select Region, Gender, Name, sum(Births) as total_count
from names
left join regions on regions.State = names.State
group by 1,2,3)
,
cte2 as (select Region, Gender, Name, total_count, row_number() over(partition by Region,Gender order by total_count desc) as ranking
from cte1)

select region, Gender, Name, total_count, ranking
from cte2
where ranking in (1,2,3);