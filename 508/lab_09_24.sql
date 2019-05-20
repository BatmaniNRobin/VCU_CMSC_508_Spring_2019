insert into my_employee
values (&p_id,'&p_last_name','&p_first_name',lower(substr('&p_firstname',1,1) ||
substr('&p_last_name',1-7)),&p_salary);

select *
from my_employee
where id = '6';