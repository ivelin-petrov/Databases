use movies;

select AVG(moviescount) as moviesavg
from (select name, COUNT(movietitle) as moviescount
		from moviestar
		left join starsin on name = starname
		group by name) stat

use pc;

--1.1
select AVG(speed)
from pc

--1.2
select maker, AVG(screen)
from product 
left join laptop on product.model = laptop.model -- join / left join
group by maker

--1.3
select AVG(price)
from laptop
where price > 1000

--1.4
select AVG(price)
from product
left join pc on product.model = pc.model
where maker = 'A'

--1.5
select AVG(price)
from (select price from product p join pc on p.model = pc.model where maker = 'B'
		union all
	  select price from product p join laptop on p.model = laptop.model where maker = 'B') AllPrices

--1.6
select speed, AVG(price)
from pc
group by speed

--1.7
select maker
from product
where type = 'PC'
group by maker
having COUNT(*) >= 3

--1.8
select distinct maker
from product
join pc on product.model = pc.model
where price = (select MAX(price) from pc)
--where price >= all (select price from pc) àêî íÿìà null ñòîéíîñòè

--1.9
select speed, AVG(price)
from pc
where speed > 800
group by speed

--1.10
select AVG(hd)
from pc
join product on pc.model = product.model
where maker in (select maker from product join printer on product.model = printer.model) --where type='Printer'

--1.11
select screen, MAX(price) - MIN(price)
from laptop
group by screen

use ships;

--2.1
select COUNT(*)
from classes

--2.2
select AVG(numguns)
from classes
join ships on classes.class = ships.class

--2.3
select class, MIN(launched) as FirstYear, MAX(launched) as LastYear
from ships
group by class

--2.4
select class, COUNT(*)
from ships
join outcomes on ships.name = outcomes.ship
where result = 'sunk'
group by class

--2.5
select class, COUNT(name)
from ships
join outcomes on ships.name = outcomes.ship
where result = 'sunk' and class in (select class from ships group by class having COUNT(*) > 4) 
group by class

--2.6
select country, AVG(displacement)
from classes
group by country

--3.1
use movies;

select starname, COUNT(distinct studioname)
from starsin
join movie on movietitle = title and movieyear = year
group by starname

--3.1'
select name, COUNT(distinct studioname)
from movie
join starsin on title = movietitle and year = movieyear
right join moviestar on starname = name
group by name

--OR

select name, COUNT(distinct studioname)
from moviestar
left join starsin on name = starname
left join movie on movietitle = title and movieyear = year
group by name

--3.2
use movies;

select starname
from starsin
where movieyear > 1990
group by starname
having COUNT(*) >= 3

--3.3
use pc;

select model
from pc
group by model
order by MAX(price)
