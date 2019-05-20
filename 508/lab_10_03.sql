create table dept (
id Number(7) NOT NULL,
name varchar2(25),
primary key(id));

describe dept;

insert into dept
select department_id, department_name
from departments;

create table emp (
id number(7),
last_name varchar2(25),
first_name varchar2(25),
dept_id number(7));

create table employees2 as
select employee_id id, first_name, last_name, salary, department_id dept_id
from employees;

alter table employees2 read only;

insert into employees2 values (34, 'Grant', 'Marcie', 5678, 10);

alter table employees2 read write;

insert into employees2 values (34, 'Grant', 'Marcie', 5678, 10);

alter table employees2 read only;

drop table employees2;