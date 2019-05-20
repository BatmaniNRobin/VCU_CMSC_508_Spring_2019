describe my_employee;

insert into my_employee values (1,'Patel','Ralph','rpatel',895);

insert into my_employee (id, last_name, first_name, userid, salary)
values (2,'Dancs','Betty','bdancs',860);

select *
from my_employee;

insert into my_employee values (&p_id,'&p_last_name','&p_first_name','&p_userid',&p_salary);

select *
from my_employee;

commit;

update my_employee
set last_name = 'Drexler'
where id = 3;

update my_employee
set salary = 1000
where salary < 900;

select *
from my_employee;

delete from my_employee
where last_name = 'Dancs' and first_name = 'Betty';

select *
from my_employee;

commit;

savepoint checkpointone;

delete
from my_employee;

select *
from my_employee;

rollback to checkpointone;

select *
from my_employee;

commit;

drop table my_employee;