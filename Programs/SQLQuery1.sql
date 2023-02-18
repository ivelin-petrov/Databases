use Movies

--1.1
select address
from STUDIO
where name = 'MGM'

--1.2
select birthdate
from MOVIESTAR
where name = 'Sandra Bullock'

--1.3
select starname
from STARSIN
where movieyear = 1980 and movietitle like '%Empire%'

--1.4
select name
from MOVIEEXEC
where networth > 10000000

--1.5
select name
from MOVIESTAR
where gender = 'M' or address like '%Malibu%'

use pc

--2.1
select model, speed as MHz, hd as GB
from PC
where price < 1200

--2.2
select model, price / 1.1 as price
from laptop
order by price

--2.3
select model, ram, screen
from laptop
where price > 1000

--2.4
select *
from printer
where color = 'y'

--2.5
select model, speed, hd
from pc
where (cd = '12x' or cd = '16x') and price < 2000

--2.6
select code, model, speed + ram + 10*screen as rating
from laptop
order by rating desc, code

use ships

--3.1
select class, country
from classes
where numguns < 10

--3.2
select name as shipName
from ships
where launched < '1918'

--3.3
select ship, battle
from outcomes
where result = 'sunk'

--3.4
select name
from ships
where name = class

--3.5
select name
from ships
where name like 'R%'

--3.6
select name
from ships
where name like '% %' and name not like '% % %'
