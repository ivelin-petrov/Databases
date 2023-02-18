use movies;

--1.1
alter table movie
add constraint unique_length unique(length)

alter table movie
add constraint unique2 unique(studioname, length)

select * from movie
insert into movie(title, year, length, incolor, studioname, producerc#)
values('Fail', 2012, 111, 'N', 'Fox', 123)

--1.2
alter table movie
drop constraint unique_length

alter table movie
drop constraint unique2

--1.3
create database deleteme
go
use deleteme
go

create table students
(
	fn int primary key check(fn between 0 and 99999),
	name nvarchar(100) not null,
	id char(10) unique not null,
	email varchar(100) unique not null,
	bdate date not null,
	adate date not null,
	constraint at_least_18_yrs check(datediff(year, bdate, adate) >= 18)
)

insert into students
values(81888, 'Ivan Ivanov', '9001012222', 'ivan@gmail.com', '1990-01-01', '2009-01-10');

select * from students

alter table students
add constraint id_valid check(len(id)=10 and id not like '%[^0-9.]%')

update students
set id = '123'

alter table students
add constraint email_valid check(email like '%_@%_.%_')

update students
set email = 'aaaa'

create table courses
(
	id int identity primary key,
	name varchar(50) not null
)

insert into courses(name)
values('DB'),
	  ('OOP'),
	  ('Android'),
	  ('iOS')

select * from courses

create table StudentsIn
(
	student_fn int references students(fn),
	course_id int references courses(id) on delete cascade,
	primary key(student_fn, course_id)
)

insert into StudentsIn
values(81888,2),
	  (81888,3),
	  (81888,4)

select * from StudentsIn

select course_id
from StudentsIn
where student_fn = 81888

select student_fn
from StudentsIn
where course_id = 3

delete from courses
where name = 'iOS'
select * from StudentsIn

use master
go
drop database deleteme
go