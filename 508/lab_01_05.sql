--true
select last_name, job_id, salary AS Sal
from employees;
--true

--true
select *
from job_grades;
--true

--the lack of comma between last_name and sal*12,
--forgotten AS for annual salary,
--wrong symbol for multiplication
--no use of quotes, specifically hard quotes, around annual salary
-- there is no sal in employees only salary
select employee_id, last_name, salary*12 AS "ANNUAL SALARY"
from employees;

describe departments;

select *
from employees;

describe employees;

select employee_id, last_name, job_id, hire_date AS "STARTDATE"
from employees;