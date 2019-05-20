select distinct job_id
from employees;

select employee_id as "Emp #", last_name as "Employee", job_id as "Job", hire_date AS "Hire Date"
from employees;

select last_name ||', '|| job_id as "Employee and Title"
from employees;

select employee_id ||', '|| first_name ||', '|| last_name ||', '|| email
 ||', '|| phone_number ||', '|| hire_date ||', '|| job_id ||', '|| salary
 ||', '|| commission_pct ||', '|| manager_id ||', '|| department_id
 AS "THE OUTPUT"
 from employees;