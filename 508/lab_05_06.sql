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

select job_id, count(*)
from employees
where job_id = '&job_id'
group by job_id;

select count(DISTINCT manager_id) as "Number of Managers"
from employees;

select (MAX(salary)-MIN(salary)) as Difference
from employees;

select manager_id, MIN(salary)
from employees
where manager_id is NOT NULL
group by manager_id
having MIN(salary) > 6000
order by MIN(salary) DESC;

-- dont know how to do 10 or 11, they both involve decode in the textbook solutions and i dont know how that function works
