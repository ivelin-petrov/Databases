use movies;

--1.1
select name
from moviestar
where gender = 'F' and name in (select name
				from movieexec
				where networth > 10000000)
--1.2
select name
from moviestar
where name not in (select name from movieexec)

use pc;

--2.1
select distinct maker
from product
where model in (select model from pc where speed >= 500)

--2.2
select *
from laptop
where speed < all (select speed from pc)

--2.3
select model
from (select model, price from pc
	  union all
	  select model, price from laptop
	  union all
	  select model, price from printer) AllProducts
where price >= all (select price from pc
					union all
					select price from laptop
					union all
					select price from printer)

--2.4
select distinct maker
from product
where model in (select model from printer where color = 'y' and price <= all (select price
										from printer
										where color = 'y'))

--2.5
select distinct maker
from product
where model in (select model from pc where ram <= all (select ram from pc) and speed >= all (select speed from pc where ram <= all (select ram from pc)))

select distinct maker
from product
where model in (select model 
				from pc p1
				where ram <= all (select ram from pc)
						and speed >= all (select speed 
										  from pc p2
										  where p1.ram = p2.ram))

use ships;

--3.1
select distinct country
from classes
where numguns >= all (select numguns from classes)

--3.2
select name
from ships
where class in (select class from classes where bore = 16)

--3.3
select battle
from outcomes
where ship in (select name from ships where class = 'Kongo')

--3.4
select name
from ships
where class in (select class from classes c1 where numguns >= all (select numguns from classes c2 where c1.bore = c2.bore))

select name
from ships s
join classes c on s.class = c.class
where numguns >= all (select numguns from classes c2 where c2.bore = c.bore)
