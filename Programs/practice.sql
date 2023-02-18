-- äà ñå íàïèøå èçãëåä, êîéòî íàìèðà èìåíàòà íà âñè÷êè àêòüîðè, èãðàëè âúâ ôèëìè ñ äúëæèíà ïîä 120 ìèíóòè èëè ñ íåèçâåñòíà äúëæèíà
use movies;

go

create view actors
as
select distinct starname
from starsin
left join movie on movietitle = title and movieyear = year
where length < 120 or length is null

go

select * from actors where starname like 'Bruce%'


-- Äà ñå íàïðàâè âúçìîæíî èçòðèâàíåòî íà ðåäîâå â èçãëåäà.
-- Ïðè èçïúëíåíèå íà delete çàÿâêà âúðõó stars äà ñå èçòðèâàò ñúîòâåòíèòå ðåäîâå îò starsin.

go

create trigger deleteActors
on actors
instead of delete
as
	delete 
	from starsin
	where starname in (select starname from deleted)

go	

drop view actors
drop trigger deleteActors

-- äà ñå èçòðèÿò âñè÷êè ó÷àñòèÿ íà ôèëìîâè çâåçäè (ðåäîâå â StarsIn)
-- âúâ ôèëìè, ÷èåòî çàãëàâèå çàïî÷âà ñúñ Star, íî ñàìî àêî íå ñà èãðàëè âúâ ôèëìè, íåçàïî÷âàùè ñúñ Star.

delete
from starsin
where movietitle like 'Star%' and starname not in (select starname 
												   from starsin
												   where movietitle not like 'Star%')


-- äà ñå èçòðèÿò âñè÷êè êîìïþòðè, ïðîèçâåäåíè îò ïðîèçâîäèòåë, êîéòî íå ïðîèçâåæäà öâåòíè ïðèíòåðè
use pc;

delete
from pc
where model in (select model 
			    from product 
				where maker not in (select maker
									from product
									join printer on product.model = printer.model
									where color = 'y'))

-- à) äà ñå ñúçäàäå èçãëåä, êîéòî ïîêàçâà êîäîâåòå, ìîäåëèòå, ïðîöåñîðèòå, RAM ïàìåòòà, õàðääèñêà è öåíàòà
-- íà âñè÷êè PC-òà è ëàïòîïè. Äà èìà äîïúëíèòåëíà êîëîíà, êîÿòî óêàçâà òèïà íà ïðîäóêòà - PC èëè Laptop.
-- á) äà ñå íàïðàâè âúçìîæíî èçïúëíåíèåòî íà DELETE çàÿâêè âúðõó òîçè èçãëåä

go

create view pc_laptop
as
	(select code, model, speed, ram, hd, price, 'pc' as type
	 from pc)
	union all
	(select code, model, speed, ram, hd, price, 'laptop' as type
	from laptop)

go

create trigger delete_pc_laptop
on pc_laptop
instead of delete
as
	begin
		delete
		from pc
		where code in (select code
					   from deleted
					   where type = 'pc')

		delete
		from laptop
		where code in (select code
					   from deleted
					   where type = 'laptop')
	end

select * from pc_laptop

delete
from pc_laptop
where code = 1 and type = 'pc'

drop view pc_laptop
drop trigger delete_pc_laptop

go

use movies;

select starname, movietitle, movieyear
from starsin, (select name
			   from moviestar
			   where gender = 'f' and year(birthdate) > 1978) actresses
where starname = name

select avg(countmovies) as avgmovies
from (select name, count(movietitle) as countmovies
	  from moviestar
	  left join starsin on name = starname
	  group by name) stat

use ships;

select country, avg(cast(countships as float)) as avgships
from (select country, battle, count(distinct name) as countships
	  from classes
	  join ships on classes.class = ships.class
	  join outcomes on name = ship
	  group by country, battle) stat
group by country

go

create trigger tr1
on outcomes
instead of insert,update
as
	if exists (select *
			   from inserted
			   join ships on ship = ships.name
			   join battles on battle = battles.name
			   where launched > year(battles.date))
	begin
		raiserror('...',16,10)
		rollback
	end

go

drop trigger tr1

use movies;

go

create trigger tr2
on movie
after update
as
	update movieexec
	set networth = networth + 100000
	where cert# in (select i.producerc#
					from inserted i
					join deleted d on i.title = d.title and i.year = d.year
					where i.incolor = 'y' and d.incolor = 'n')

go

drop trigger tr2

select * from movieexec where cert# in (select producerc# from movie where incolor = 'n')


