select last_name, hire_date
from employees
where department_id = (select department_id
                    from employees
                    where last_name like '&&last_name')
and last_name <> '&last_name';

select employee_id, last_name, salary
from employees
where salary > (select AVG(salary)
                from employees)
order by salary ASC;

select employee_id, last_name
from employees
where department_id IN (select department_id
                        from employees
                        where last_name like '%u%');

select last_name, department_id, job_id
from employees
where department_id IN (select department_id
                        from departments
                        where location_id = '&location_id');
                        
select last_name, salary
from employees
where manager_id = (select employee_id
                    from employees
                    where last_name = 'King'); 

select department_id, last_name, job_id
from employees
where department_id = (select department_id
                        from departments
                        where department_name = 'Executive');

select employee_id, last_name, salary
from employees
where salary > ANY (select salary
                    from employees
                    where department_id = 60);