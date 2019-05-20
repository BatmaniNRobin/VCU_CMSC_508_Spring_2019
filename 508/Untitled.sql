select m.employee_id, count(*)
from employees e1, employees e2, employees e3, employees m
where e1.manager_id 

select department_id, AVG(salary)
from employees
where department_id = 50 or department_id = 80
group by department_id;

select d.department_id, AVG(e.salary)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id
having count(employee_id) > 10;

select j.job_title, MAX(e.salary)
from employees e join jobs j
on e.job_id = j.job_id
group by j.job_title
having MAX(salary) >= 4000;

select e.employee_id, e.department_id, (e.salary - m.salary) as difference
from employees e, employees m
where e.manager_id = m.employee_id
order by e.department_id;

select e.last_name AS Employee, m.last_name AS Manager
from employees e, employees m
where e.manager_id = m.employee_id
UNION
select e.last_name as Employee, NULL as Manager
from employees e
where e.manager_id is NULL;

select e.last_name as Employee, m.last_name as Manager
from employees e left join employees m
where e.manager_id = m.employee_id;

select e.first_name ||' '|| e.last_name as "Employee", m.first_name ||' '|| m.last_name as "Manager", region_name
from employees, employees m, regions
where e.manager_id = m.employee_id;

select m.last_name
from employees e1, employees e2, employees e3, employees m
where e1.manager_id = e2.employee_id
and e2.manager_id = e3.employee_id
and e3.manager_id = m.employee_id;

select last_name, department_id, department_name
from employees natural join departments
order by department_id;