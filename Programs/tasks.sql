use movies_original

go

create view stars
as
select distinct starname
from starsin
join movie on movietitle = title and movieyear = year
where length < 120 or length is null;

go

select * from stars;


go

create trigger DeleteStars
on stars
instead of delete
as
delete from starsin
where starname in (select starname
				from deleted);

go


delete
from starsin
where movietitle like 'Star%'
	and starname not in (select starname
				from starsin
				where movietitle not like 'Star%');

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
