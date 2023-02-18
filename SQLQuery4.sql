-- coalesce(name,name) as name => |NULL|,|Name|->|Name|
-- between value1 and value2
use movies;

--1.1
select title,year,studioname,address
from movie
join studio on studioname = name
where length > 120

--1.2
select studioname,starname
from movie
join starsin on title = movietitle and year = movieyear
order by studioname

--1.3
select distinct name
from movieexec
join movie on cert# = producerc#
join starsin on movietitle = title and movieyear = year
where starname = 'Harrison Ford'

--1.4
select name
from moviestar
join starsin on starname = name
join movie on movietitle = title and movieyear = year
where studioname = 'MGM' and gender = 'F'

--1.5
select name, title
from movieexec
join movie on cert# = producerc#
where name in (select name from movieexec join movie on cert# = producerc# where title = 'Star Wars')

--1.6
select name
from moviestar
left join starsin on starname = name
where starname is null

select name
from moviestar
where name not in (select starname from starsin)

use pc;

--2.1
select distinct product.model,price
from product
left join pc on product.model = pc.model
where product.type = 'PC'

--2.2
select maker,p.model,type
from product p
left join (select model from pc
			union all
		   select model from laptop
		    union all
		   select model from printer) t on p.model = t.model
where t.model is null

select maker,model,type
from product
where model not in (select model from pc) 
	and model not in (select model from laptop)
	and model not in (select model from printer)

use ships;

--3.1
select name,country,numguns,launched
from classes
left join ships on classes.class = ships.class

--3.2
select distinct ship
from outcomes
join battles on battle = name
where year(date) = 1942

--general tasks

--4.1
use ships;

select name,launched
from ships
where name = class

--4.2
use movies;

select title,year
from movie
where title like '%Star%' and title like '%Trek%'
order by year desc, title

--4.3
use movies;

select movietitle,movieyear
from starsin
join moviestar on starname = name
where birthdate between '1970-01-01' and '1980-07-01'

--4.4
use ships;

select distinct name
from ships
join outcomes on name = ship
where name like 'C%' or name like 'K%'

select distinct ship 
from outcomes
where ship like 'C%' or ship like 'K%'

--4.5
use ships;

select distinct country
from classes
left join ships on classes.class = ships.class
left join outcomes on ships.name = outcomes.ship
where result = 'sunk'

select distinct country
from classes
left join ships on classes.class = ships.class
where name in (select ship from outcomes where result = 'sunk')

--4.6
use ships;

select distinct country
from classes
where country not in (select distinct country
						from classes
						left join ships on classes.class = ships.class
						where name in (select ship from outcomes where result = 'sunk'))

--4.7
use ships;

select class
from classes
where class not in (select class from ships where launched > 1921)

select classes.class
from classes
left join ships on classes.class = ships.class and launched > 1921
where name is null;

--4.8
use ships;

select class, country, bore * 2.54 as bore_cm
from classes
where numguns in (6,8,10)

--4.9
use ships;

select distinct c1.country
from classes c1
join classes c2 on c1.country = c2.country
where c1.bore < c2.bore
	--where c1.bore <> c2.bore

--4.10
use ships;

select distinct country
from classes
where numguns >= all (select numguns from classes)

--4.11
use pc;

select *
from pc
join product p1 on pc.model = p1.model
where price < all (select price from laptop join product p2 on laptop.model = p2.model where p1.maker = p2.maker)

--4.12
use pc;

select pc.*
from pc
join product p1 on pc.model = p1.model
where price < all ((select price from laptop join product p2 on laptop.model = p2.model where p1.maker = p2.maker)
					union all
				   (select price from printer join product p3 on printer.model = p3.model where p1.maker = p3.maker))

select pc.*
from pc
join product p1 on pc.model = p1.model
where price < all (select price from laptop join product p2 on laptop.model = p2.model where p1.maker = p2.maker)
  and price < all (select price from printer join product p3 on printer.model = p3.model where p1.maker = p3.maker)