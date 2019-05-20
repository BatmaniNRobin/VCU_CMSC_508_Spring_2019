select SYSDATE as "Date"
from dual;

select employee_id, last_name, salary, ROUND(salary*1.155,0) as "New Salary", ROUND((salary*1.155 - salary),0) as Increase
from employees;

select INITCAP(last_name)as Name, LENGTH(last_name) as Length
from employees
where last_name like 'J%'
or last_name like 'A%'
or last_name like 'M%';

select INITCAP(last_name) as "Name", Length(last_name) as "Length"
from employees
where last_name like UPPER('&letter%');

select last_name, ROUND(MONTHS_BETWEEN(SYSDATE,hire_date)) as "Months_Worked"
from employees
order by "Months_Worked";

select last_name, LPAD(salary,15,'$') SALARY
from employees;

select rpad(last_name, 8) ||' '|| rpad(' ', salary/1000+1, '*')
as EMPLOYEES_AND_THEIR_SALARIES
from employees
order by salary desc;

select last_name, TRUNC((SYSDATE-hire_date)/7) as TENURE
from employees
where department_id = 90
order by tenure DESC;