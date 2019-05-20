select last_name, salary
from employees
where (salary < 5000 or salary > 12000) and (department_id =50 or department_id = 20);

select last_name, hire_date
from employees
where hire_date like '%03';

select last_name, job_id
from employees
where manager_id is NULL;

select last_name, salary, commission_pct
from employees
where commission_pct is NOT NULL
order by 2 DESC, 3 DESC;

