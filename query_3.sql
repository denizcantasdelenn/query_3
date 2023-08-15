create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')


--Display number of total visits, most visited floors and distinct resources used.

--select * from entries


with total_vis as(
select name, count(*) as total_visits
from entries
group by name)
, floors as (
select name, floor
from (
select *, 
rank() over(partition by name order by counts_of_floors desc) as rank_flag
from (
select name, floor, count(*) as counts_of_floors
from entries
group by name, floor) A) B
where rank_flag = 1)
, distinct_resources as (
select name, resources
from entries
group by name, resources)
, alligned_resources as (
select dr1.name, dr1.resources as r1, dr2.resources as r2
from distinct_resources dr1
inner join distinct_resources dr2 on dr1.name = dr2.name and dr1.resources < dr2.resources)
, resources as (
select name, r1 + ',' + r2 as resources_used
from alligned_resources)

select tv.name, tv.total_visits, f.floor as most_visited_floor, r.resources_used
from total_vis tv
inner join floors f on (tv.name = f.name)
inner join resources r on (tv.name = f.name) and (f.name = r.name)