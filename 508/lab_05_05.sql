--True
--False
--True

select ROUND(MAX(salary),0) as Maximum, ROUND(MIN(salary),0) as Minimum, ROUND(SUM(salary),0) as Sum, ROUND(AVG(salary),0) as Average
from employees;

select job_id, MAX(salary) as Maximum, MIN(salary) as Minimum, SUM(salary) as Sum, AVG(salary) as Average
from employees
group by job_id;

select job_id, count(*)
from employees
group by job_id;