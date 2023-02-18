--3.4
use ships;

select battle, COUNT(outcomes.ship) as shipsCount  
from outcomes
join ships on ship = name
join classes on ships.class = classes.class
where country = 'USA' and result = 'sunk'
group by battle

--3.5
select distinct battle
from outcomes
join ships on ship = name
join classes on ships.class = classes.class
group by battle, country
having count(*) >= 3

--3.6
select class
from ships
group by class
having max(launched) <= 1921

--3.7
select ships.name, count(outcomes.battle)
from ships
left join outcomes on ships.name = outcomes.ship and result = 'damaged'
group by ships.name

--3.8
select class, count(distinct outcomes.ship)
from ships
left join outcomes on ships.name = outcomes.ship and result = 'ok'
group by class
having count(distinct ships.name) >= 3

select class, count(distinct ship) -- ïîâòîðåíèÿ èìà, àêî äàäåí êîðàá å áèë ok â íÿêîëêî áèòêè
from ships
left join outcomes on name = ship and result = 'ok'
group by class
having count(distinct name) >= 3; -- ïîâòîðåíèÿ èìà, àêî äàäåí êîðàá å áèë ok â íÿêîëêî áèòêè

--3.9
select distinct battle, year(date) as year,
	(select count(*) from outcomes where result = 'ok' and o.battle = battle) as ok,
	(select count(*) from outcomes where result = 'damaged' and o.battle = battle) as damaged,
	(select count(*) from outcomes where result = 'sunk' and o.battle = battle) as sunk
from outcomes o
join battles on o.battle = name

select battle, year(date) as year,
	sum(case result when 'ok' then 1 else 0 end) as ok,
	sum(case result when 'damaged' then 1 else 0 end) as damaged,
	sum(case result when 'sunk' then 1 else 0 end) as sunk
from outcomes
join battles on battle = name
group by battle, date

select country, count(ships.name), count(outcomes.ship)
from classes
left join ships on classes.class = ships.class
left join outcomes on name = ship and result = 'sunk'
group by country;

select country, count(distinct damaged.ship) as damaged, count(distinct sunk.ship) as sunk
from classes
left join ships on classes.class = ships.class
left join outcomes damaged on name = damaged.ship and damaged.result = 'damaged'
left join outcomes sunk on name = sunk.ship and sunk.result = 'sunk'
group by country;

select country, (select count(distinct name)
					from classes
					join ships on classes.class = ships.class
					join outcomes on ship = name
					where result = 'damaged' and country = c.country) as damaged,
				(select count(*)
					from classes
					join ships on classes.class = ships.class
					join outcomes on ship = name
					where result = 'sunk' and country = c.country) as sunk
from classes c
group by country;

--3.10
--battle, count(ships.name), count(classes.numguns), count(outcomes.result)
select battle
from outcomes
left join ships on ship = name and result = 'ok'
left join classes on ships.class = classes.class and numguns < 9
group by battle
having count(ships.name) >= 1 and count(classes.numguns) >= 1 and count(outcomes.result) >= 1
-- having count(ships.name) >= 3 and count(classes.numguns) >= 3 and count(outcomes.result) >= 2

select battle
from outcomes o 
join ships s on o.ship = s.name
join classes c on s.class = c.class
where c.numguns < 9 
group by battle
having count(*) >= 3 and sum(case result when 'ok' then 1 else 0 end) >= 2;

--extra
use movies;

select name,
	(case gender
		when 'F' then 'Female'
		when 'M' then 'Male'
		else 'Unknown'
	end) as gender
from moviestar

select (case when year(birthdate) < 1960 then '~50s'
			 when year(birthdate) between 1960 and 1969 then '60s'
			 when year(birthdate) between 1970 and 1979 then '70s'
			 when year(birthdate) >= 1980 then '80s~' end) as period,
		count(*) as num_moviestars
from moviestar
group by (case when year(birthdate) < 1960 then '~50s'
			   when year(birthdate) between 1960 and 1969 then '60s'
			   when year(birthdate) between 1970 and 1979 then '70s'
			   when year(birthdate) >= 1980 then '80s~' end)

use movies;

--4.1
select distinct title, year
from movie
join starsin on title = movietitle and year = movieyear
where year < 1982 and starname not like '%k%' and starname not like '%b%'
order by year

--4.2
select m1.title, (m1.length/60 + (m1.length%60)/100.0) as hours
from movie m1, movie m2
where m2.title = 'Terms of Endearment' and m1.year = m2.year and (m1.length < m2.length or m1.length is null)

--4.3
select name
from movie
join movieexec on producerc# = cert#
join starsin on title = movietitle and year = movieyear and name = starname
group by name
having sum(case when movieyear < 1980 then 1 else 0 end) >= 1 and
	   sum(case when movieyear > 1985 then 1 else 0 end) >= 1

--4.4
select m.title
from movie m
where m.incolor = 'N' and m.year < (select min(year) from movie where incolor = 'Y' and movie.studioname = m.studioname)

--4.5
select studioname, address, count(distinct starname) as stars
from movie
join studio on studioname = name
left join starsin on title = movietitle and year = movieyear
group by studioname, address
having count(distinct starname) < 5
order by stars desc

use ships;

--4.6
select name, launched
from ships
join classes on classes.class = ships.class and (classes.class not like '%i%' and classes.class not like '%k%')
order by launched desc

--4.7
select battle
from classes
left join ships on classes.class = ships.class
left join outcomes o on name = o.ship
where country = 'Japan'
group by battle
having sum(case result when 'damaged' then 1 else 0 end) >= 1

--4.8
select s1.name, s1.class
from ships s1, ships s2
join classes c on c.class = s2.class
where s2.name = 'Rodney' and (s1.launched - s2.launched) = 1 and numguns > (select avg(numguns) from classes where classes.country = c.country)

--4.9
select classes.class
from classes
left join ships on classes.class = ships.class
where country = 'USA'
group by classes.class
having max(launched) - min(launched) > 10

--4.10
select battle, (select avg(convert(real, num_ships))
				from
					(select count(name) as num_ships 
					from ships
					join classes on classes.class = ships.class 
					join outcomes on name = ship
					where battle = o.battle
					group by country)
				stat) as avg_ships
from classes c
join ships s on c.class = s.class
join outcomes o on s.name = o.ship
group by battle

--4.11
select country, count(distinct name) as num_ship, count(distinct battle) as num_battles,
	(select count(distinct battle)
	 from classes
	 left join ships on classes.class = ships.class
	 left join outcomes o on ships.name = o.ship and result = 'sunk'
	 where country = c.country
	 group by country) as num_battles_with_sunken_ship
from classes c
left join ships s on c.class = s.class
left join outcomes o on s.name = o.ship
group by country

use movies;

--4.12
select name, count(distinct studioname) as studios
from movie
join starsin on movietitle = title and movieyear = year
join moviestar on starname = name
group by name

--4.13
select name, count(distinct studioname) as studios
from moviestar
left join starsin on name = starname
left join movie on movietitle = title and movieyear = year
group by name

--4.14
select starname
from starsin
where movieyear > 1990
group by starname
having count(*) >= 3

use pc;

--4.15
select model
from pc
group by model
order by max(price)

use ships;

--4.16
select battle, sum(case result when 'sunk' then 1 else 0 end) as sunk
from classes
join ships on classes.class = ships.class
join outcomes on name = ship
where country = 'USA'
group by battle
having sum(case result when 'sunk' then 1 else 0 end) >= 1

--4.17
select distinct battle
from classes
join ships on classes.class = ships.class
join outcomes on name = ship
group by battle, country
having count(distinct ship) >= 3

--4.18
select class
from ships
group by class
having max(launched) <= 1921

--4.19
select name, count(battle) as times_damaged
from ships
left join outcomes on name = ship and result = 'damaged'
group by name

--4.20
select classes.class, sum(case result when 'ok' then 1 else 0 end) as num_victories
from classes
left join ships on classes.class = ships.class
left join outcomes on name = ship
group by classes.class
having count(distinct name) >= 3
