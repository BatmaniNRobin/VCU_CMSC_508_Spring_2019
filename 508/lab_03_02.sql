select SYSDATE as "Date"
from dual;

select employee_id, last_name, salary, ROUND(salary*1.155,0) as "New Salary"
from employees;