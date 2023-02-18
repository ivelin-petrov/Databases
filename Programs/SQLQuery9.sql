use movies;

--1.1
go
create view actresses
as
	select name, birthdate
	from moviestar
	where gender = 'F'
go

select * from actresses
drop view actresses

--1.2
go
create view moviestar_movieCount
as
	select name, count(movietitle) as movieCount
	from moviestar
	left join starsin on name = starname
	group by name
go

select * from moviestar_movieCount
drop view moviestar_movieCount

--1.3

use pc;

--2.1
go
create view product_info
as
	(select code, model, price
	from laptop)
	union all
	(select code, model, price
	from pc)
	union all
	(select code, model, price
	from printer)
go

--2.2, 2.3
go
alter view product_info
as
	(select code, model, price, speed, 'Laptop' as type
	from laptop)
	union all
	(select code, model, price, speed, 'PC'
	from pc)
	union all
	(select code, model, price, null, 'Printer'
	from printer)
go

select * from product_info
drop view product_info

use ships;

--3.1
go
create view BritishShips
as
	select classes.class as class, type, numguns, bore, displacement, launched
	from classes
	join ships on classes.class = ships.class
	where country = 'Gt.Britain'
go

select * from BritishShips

--3.2
select numguns, displacement
from BritishShips
where type = 'bb' and launched < 1919

drop view BritishShips

--3.3
select numguns, displacement
from classes
join ships on classes.class = ships.class
where country = 'Gt.Britain' and type = 'bb' and launched < 1919

--3.4
select class, country, avg(displacement) as avg_displacement
from classes
group by class, country
order by avg_displacement desc

--3.5
go
create view sunken_ships
as
	select battle, ship
	from outcomes
	where result = 'sunk'
go

select * from sunken_ships

--3.6
insert into sunken_ships(battle, ship)
values('Guadalcanal', 'California')

select * from outcomes where result is null;
delete from outcomes where result is null

alter table outcomes
add default 'sunk' for result

select * from outcomes where battle = 'Guadalcanal' and ship = 'California'

--3.7
go
create view classes_atleast_9guns
as
	select *
	from classes
	where numguns >= 9
with check option
go

select * from classes_atleast_9guns

update classes_atleast_9guns
set numguns = 15
where class = 'Iowa'

update classes_atleast_9guns
set numguns = 5
where class = 'Iowa'

--3.8
drop view classes_atleast_9guns

go
create view classes_atleast_9guns
as
	select *
	from classes
	where numguns >= 9
go

select * from classes_atleast_9guns

update classes_atleast_9guns
set numguns = 5
where class = 'Iowa'

select * from classes where class = 'Iowa'

--3.9
go
create view some_battles
as
	select battle
	from classes
	left join ships on classes.class = ships.class and numguns < 9
	left join outcomes on name = ship and result = 'damaged'
	group by battle
	having count(distinct name) >= 3 and count(distinct ship) >= 1
go

select * from some_battles

drop view sunken_ships
drop view classes_atleast_9guns
drop view some_battles

select *
from outcomes o
left join ships on ship = name and result = 'damaged'
left join classes on ships.class = classes.class and numguns < 9

select battle
from classes
left join ships on classes.class = ships.class and numguns < 9
left join outcomes on name = ship and result = 'ok'
group by battle
having count(distinct name) >= 1 and count(distinct ship) >= 1
