select location_id, street_address, city, state_province, country_name
from locations natural join countries;

select last_name, department_id, department_name
from employees natural join departments
order by department_id;

select last_name, department_id, department_name
from employees join departments
using (department_id);

select e.last_name, e.job_id, e.department_id, d.department_name
from employees e join departments d
on (e.department_id = d.department_id)
join locations l
on (d.location_id = l.location_id)
where LOWER(l.city) = 'toronto';

select e.last_name as Employee, e.employee_id as EMP#, m.last_name as Manager, m.employee_id as MGR#
from employees e join employees m
on e.manager_id = m.employee_id;

select e.last_name as Employee, e.employee_id as EMP#, m.last_name as Manager, m.employee_id as MGR#
from employees e left join employees m
on e.manager_id = m.employee_id
order by EMP#;