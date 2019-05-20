select last_name, salary
from employees
where salary < 5000 or salary > 12000;

select last_name, job_id, hire_date
from employees
where last_name = 'Matos' or last_name = 'Taylor'
order by hire_date;

select last_name, department_id
from employees
where department_id = 20 or department_id = 50
order by last_name;

