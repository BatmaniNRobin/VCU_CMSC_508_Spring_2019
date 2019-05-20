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

select last_name, salary
from employees
where salary > '&salary';

select employee_id, last_name, salary, department_id
from employees
where manager_id = &manager_id
order by &order_col;

select last_name
from employees
where last_name like '__a%';

select last_name
from employees
where last_name like '%a%'
and last_name like'%e%';

select last_name, job_id, salary
from employees
where job_id IN ('SA_REP', 'ST_CLERK')
and salary NOT IN (2500, 3500, 7000);

