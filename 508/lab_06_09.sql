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

select e.department_id as Department, e.last_name as Employee, c.last_name as Colleague
from employees e join employees c
on e.department_id = c.department_id
where e.employee_id <> c.employee_id
order by e.department_id, e.last_name, c.last_name;

describe job_grades;

select e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
from employees e join departments d
on (e.department_id = d.department_id)
join job_grades j
on e.salary between j.lowest_sal and j.highest_sal;

select e.last_name, e.hire_date
from employees e join employees davies
on davies.last_name = 'Davies'
where e.hire_date > davies.hire_date;

select e.last_name, e.hire_date, m.last_name Manager, m.hire_date as "Manager Hire Date"
from employees e join employees m
on e.manager_id = m.employee_id
where e.hire_date < m.hire_date;