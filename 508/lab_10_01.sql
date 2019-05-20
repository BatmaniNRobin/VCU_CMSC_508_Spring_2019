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