use baby_names_db;

-- most popular names given to both females and males
select Name, count(distinct Gender) as given_genders, sum(births) as total_babies
from names
group by 1
having given_genders = 2
order by 3 desc
limit 10;

-- =======================================================================

-- finding popularity of shortest and longest names
with cte1 as (select Gender, Name, length(Name) as name_length, sum(births) as total_babies
from names
group by 1,2,3)

select *
from cte1
where name_length in ((select max(name_length) from cte1), (select min(name_length) from cte1))
order by name_length desc, total_babies desc;

-- =======================================================================

-- finding percent of babies named chris (name of maven founder) in each state
with cte1 as (select State, Name, sum(births) as total_babies
from names
group by 1,2)
,
cte2 as (select State, Name, total_babies, sum(total_babies) over(partition by State) as total_per_state
from cte1)

select State, Name, concat((total_babies/total_per_state)*100,"%") as percentage
from cte2
where Name = "Chris"
order by (total_babies/total_per_state)*100 desc;
