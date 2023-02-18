use movies_original
-- äà ñå íàïèøå èçãëåä, êîéòî íàìèðà èìåíàòà íà âñè÷êè àêòüîðè, èãðàëè âúâ ôèëìè ñ äúëæèíà ïîä 120 ìèíóòè èëè ñ íåèçâåñòíà äúëæèíà

go

create view stars
as
select distinct starname
from starsin
join movie on movietitle = title and movieyear = year
where length < 120 or length is null;

go

select * from stars;

-- Äà ñå íàïðàâè âúçìîæíî èçòðèâàíåòî íà ðåäîâå â èçãëåäà. Ïðè èçïúëíåíèå íà delete çàÿâêà âúðõó stars 
-- äà ñå èçòðèâàò ñúîòâåòíèòå ðåäîâå îò starsin.

go

create trigger DeleteStars
on stars
instead of delete
as
delete from starsin
where starname in (select starname
				from deleted);

go

-- äà ñå èçòðèÿò âñè÷êè ó÷àñòèÿ íà ôèëìîâè çâåçäè (ðåäîâå â StarsIn)
-- âúâ ôèëìè, ÷èåòî çàãëàâèå çàïî÷âà ñúñ Star, íî ñàìî àêî íå ñà èãðàëè âúâ ôèëìè, íåçàïî÷âàùè ñúñ Star.

delete
from starsin
where movietitle like 'Star%'
	and starname not in (select starname
						from starsin
						where movietitle not like 'Star%');

-- äà ñå èçòðèÿò âñè÷êè êîìïþòðè, ïðîèçâåäåíè îò ïðîèçâîäèòåë, êîéòî íå ïðîèçâåæäà öâåòíè ïðèíòåðè
use pc;
go

delete
from pc
where model in (select model
				from product
				where maker not in (select maker
									from product
									join printer on product.model = printer.model
									where color = 'y'));

go

-- à) äà ñå ñúçäàäå èçãëåä, êîéòî ïîêàçâà êîäîâåòå, ìîäåëèòå, ïðîöåñîðèòå, RAM ïàìåòòà, õàðääèñêà è öåíàòà
-- íà âñè÷êè PC-òà è ëàïòîïè. Äà èìà äîïúëíèòåëíà êîëîíà, êîÿòî óêàçâà òèïà íà ïðîäóêòà - PC èëè Laptop.
-- á) äà ñå íàïðàâè âúçìîæíî èçïúëíåíèåòî íà DELETE çàÿâêè âúðõó òîçè èçãëåä

create view Computers
as
select code, model, speed, ram, hd, price, 'PC'
from pc
union all
select code, model, speed, ram, hd, price, 'Laptop'
from laptop;


go

create view Computers
as
select code, model, speed, ram, hd, price, 'PC' as type
from pc
union all
select code, model, speed, ram, hd, price, 'Laptop'
from laptop;

go

create trigger DeleteComputers
on Computers
instead of delete
as
begin
	delete from pc
	where code in (select code
					from deleted
					where type = 'PC');

	delete from laptop
	where code in (select code
					from deleted
					where type = 'Laptop');

end;

delete Computers
where code = 1 and type = 'PC';

select * from Computers;

drop trigger DeleteComputers;
drop view Computers;

use pc;
