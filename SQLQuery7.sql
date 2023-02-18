-- rfc email address -> check length

use movies;

begin transaction;

--1.1
insert into moviestar (name, gender, birthdate)
values ('Nicole Kidman', 'F', '1967-06-20')

select * from moviestar

--1.2
select * from movieexec
where networth < 21000000

delete from movieexec
where networth < 21000000

--1.3
delete from moviestar
where address is null

--1.4
update movieexec
set name = 'Pres. ' + name
where cert# in (select presc# from studio)

use pc;

--2.1
insert into product (model, maker, type)
values ('1100', 'C', 'PC')
insert into pc (code, model, speed, ram, hd, cd, price)
values (12, '1100', 2400, 2048, 500, '52x', 299)

select * from product
select * from pc

--2.2
delete from pc where model = '1100'
delete from product where model = '1100'

--2.3
insert into product (model, maker, type)
select distinct model, 'Z', 'Laptop'
from pc

insert into laptop (code, model, speed, ram, hd, price, screen)
select code+100, model, speed, ram, hd, price+500, 15
from pc

select * from laptop

--2.4
delete from laptop
where model in (select model 
				from product
				where type = 'Laptop' and maker not in (select maker from product where type = 'Printer'))

--2.5
update product
set maker = 'A'
where maker = 'B'

select * from product

--2.6
update pc
set price = price/2, hd = hd+20

--2.7
update laptop
set screen = screen+1
where model in (select model from product where maker = 'B')

select * from laptop


use ships;

--3.1
insert into classes
values('Nelson', 'bb', 'Gt.Britain', 9, 16, 34000)

insert into ships
values('Nelson', 'Nelson', 1927)

insert into ships
values('Rodney', 'Nelson', 1927) 

--3.2
delete from ships
where name in (select ship from outcomes where result = 'sunk')

--3.3
update classes
set bore = bore*2.54, displacement = displacement/1.1

--3.4
delete from classes
where class not in (select class 
					from ships 
					group by class 
					having count(*) >= 3)

delete from classes
where class in (select classes.class
				from classes
				left join ships on classes.class = ships.class
				group by classes.class
				having count(name) < 3)

--3.5
update classes
set bore = (select bore from classes where class = 'Bismarck'), 
	displacement = (select displacement from classes where class = 'Bismarck')
where class = 'Iowa'

select * from classes

rollback transaction;



--4.1
create database test
go
use test
go

--4.2
create table Product(
	maker char(1),
	model char(4),
	type varchar(7)
)

create table Printer(
	code int,
	model char(4),
	color char(1) default 'n',
	price decimal(9,2)
)

create table Classes(
	class varchar(50),
	type char(2)
)

--4.3
insert into Product(maker, model, type)
values ('A', 500, 'bb'),
	   ('B', 300, 'bc')

select * from product

insert into Printer(code, model)
values (1, 500)

insert into Printer(code, model, color, price)
values (1, 300, 'y', 299),
	   (2, 300, 'y', 399),
	   (3, 300, 'n', 199)

select * from printer

insert into Classes(class, type)
values ('London', 'bc'),
	   ('York', 'bb')

select * from classes

--4.4
alter table Classes
add bore float default 0.1

alter table Classes
drop column bore

--4.5
alter table Printer
drop column price

--4.6
select *
from product
join printer on product.model = printer.model
join classes on product.type = classes.type

drop table Product
drop table Printer
drop table Classes

use master
go
drop database test
go