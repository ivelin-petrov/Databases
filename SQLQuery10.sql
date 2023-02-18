go
use movies;
go

--1.1
insert into moviestar(name, gender)
values ('Bruce Willis', 'M')

select * from moviestar
delete from moviestar where name = 'Bruce Willis'

go
create trigger tr1
on movie
after insert
as
	insert into starsin(movietitle, movieyear, starname)
	select title, year, 'Bruce Willis'
	from inserted
	where title like '%save%' or title like '%world%'

insert into movie(title, year)
values ('Armageddon', 1970),
	   ('Save the world', 2020)

select * from starsin
select * from movie

delete from movie where title = 'Armageddon' or title = 'Save the world'

drop trigger tr1

--1.2
go
create trigger tr2
on movieexec
after insert, update, delete
as
	if (select avg(networth) from movieexec) < 500000
	begin
		raiserror('Error: average networth cannot be less than 500000', 16, 10)
		rollback
	end

drop trigger tr2

--1.3
go
create trigger tr3
on movieexec
instead of delete
as
	begin
		update movie 
		set producerc# = null
		where producerc# in (select cert# from deleted)
	
		delete from movieexec
		where cert# in (select cert# from deleted)
	end

drop trigger tr3

--1.4
go
create trigger tr4
on starsin
instead of insert
as
	insert into moviestar(name)
	select distinct starname
	from inserted
	where starname not in (select name from moviestar)

	insert into movie(title, year)
	select distinct movietitle, movieyear
	from inserted
	where not exists (select * from movie where title = movietitle and year = movieyear)

	insert into starsin
	select *
	from inserted

drop trigger tr4

go
use pc;
go

--2.1
create trigger tr1
on laptop
after delete
as
	insert into pc(code,model,speed,ram,hd,cd,price)
	select code + 100,'1121',speed,ram,hd,'52x',price
	from deleted
	where model in (select model from product where maker = 'D')
	
drop trigger tr1

--2.2
go
create trigger tr2
on pc
after update
as
	if exists (select * from pc p
				where exists (select * from pc where price < p.price and speed = p.speed)
						and code in (select i.code 
									 from deleted d 
									 join inserted i on d.code = i.code
									 where d.price != i.price))
	begin
		raiserror('Error: there is a cheaper pc with the same speed.',16,10)
		rollback
	end

drop trigger tr2

--2.3
go
create trigger tr3
on product
after insert,update
as
	if exists (select *
			   from product p1
			   join product p2 on p1.maker = p2.maker
			   where p1.type = 'PC' and p2.type = 'Printer')
	begin
		raiserror('Error: ...',16,10)
		rollback
	end

drop trigger tr3

--2.4
go
create trigger tr4
on product
after insert,update
as
	if exists (select distinct maker
			   from product
			   where type = 'PC'
				and maker not in (select p1.maker
							      from product p1 
								  join product p2 on p1.maker = p2.maker 
								  join pc on p1.model = pc.model
								  join laptop on p2.model = laptop.model
								  where p1.type = 'PC' and p2.type = 'Laptop'
									and laptop.speed >= pc.speed))
	begin
		raiserror('Error: ...',16,10)
		rollback
	end

drop trigger tr4

--2.5
go
create trigger tr5
on laptop
after update
as
	if exists (select maker
			   from laptop
			   join product on laptop.model = product.model
			   group by maker
			   having avg(price) < 2000)
	begin
		raiserror('Error: ...',16,10)
		rollback
	end

drop trigger tr5

--2.6
go
create trigger tr6
on product
after insert,update
as
	if exists (select *
			   from product p1
			   join product p2 on p1.type != p2.type
			   join pc on p1.model = pc.model
			   join laptop on p2.model = laptop.model
			   where laptop.ram > pc.ram and laptop.price <= pc.price)
	begin
		raiserror('Error: ...',16,10)
		rollback
	end

drop trigger tr6
		

--2.7
go
create trigger tr7
on printer
instead of insert
as
	insert into printer
	select *
	from inserted
	where not (color = 'y' and type = 'Matrix')
	-- where color != 'y' or type != 'Matrix'

drop trigger tr7

go
use ships;
go

--3.1
create trigger tr1
on classes
instead of insert
as
	insert into classes
	select *
	from inserted
	where displacement < 35000
	
	insert into classes
	select class,type,country,numguns,bore,35000
	from inserted
	where displacement >= 35000

select * from classes

insert into classes
values ('Bulgaria','bg','Bulgaria',7,14,34000),
	   ('Britain','bb','Gt.Britain',7,14,36000)

delete from classes
where class = 'Bulgaria' or class = 'Britain'

drop trigger tr1

--3.2
go
create view ShipsCount
as
	select c.class, count(s.name) as ships
	from classes c
	left join ships s on c.class = s.class
	group by c.class
go

select * from ShipsCount

go
create trigger tr2
on ShipsCount
instead of delete
as
begin
	delete from ships
	where class in (select class from deleted)
	
	delete from classes
	where class in (select class from deleted)
end

insert into classes
values ('Test 1','bb','Bulgaria',20,20,50000),
	   ('Test 2','bc','Bulgaria',18,21,45000)

insert into ships
values ('Test Ship','Test 1',2020)

select * from ShipsCount

delete from ShipsCount where class = 'Test 1'

select * from classes where class like 'Test%'

drop trigger tr2

--3.3
go
create trigger tr3
on ships
after insert,update
as
	if exists (select class
			   from ships
			   group by class
			   having count(name) > 2)
	begin
		raiserror('...',16,10)
		rollback
	end

drop trigger tr3

--3.4
go
create trigger tr4
on outcomes
after insert,update
as
	if exists (select *
			   from classes c1
			   join ships s1 on c1.class = s1.class
			   join outcomes o1 on name = o1.ship
			   join outcomes o2 on o1.battle = o2.battle
			   join ships s2 on o2.ship = s2.name
			   join classes c2 on s2.class = c2.class
			   where c1.numguns > 9 and c2.numguns < 9)
	begin
		raiserror('...',16,10)
		rollback
	end

drop trigger tr4

--3.5
go
create trigger tr5
on outcomes
after insert,update
as
	if exists (select *
			   from outcomes o1
			   join battles b1 on o1.battle = b1.name
			   join outcomes o2 on o1.ship = o2.ship
			   join battles b2 on o2.battle = b2.name
			   where o1.result = 'sunk' and b1.date < b2.date)
	begin
		raiserror('...',16,10)
		rollback
	end

drop trigger tr5

go
create trigger tr6
on battles
after update
as
	if exists (select *
			   from outcomes o1
			   join battles b1 on o1.battle = b1.name
			   join outcomes o2 on o1.ship = o2.ship
			   join battles b2 on o2.battle = b2.name
			   where o1.result = 'sunk' and b1.date < b2.date)
	begin
		raiserror('...',16,10)
		rollback
	end

drop trigger tr6