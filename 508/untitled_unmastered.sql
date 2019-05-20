select *
from user_catalog;

select last_name || ', ' || first_name as Name, salary, (salary*12)+NVL(commission_pct, 0)*salary as "Annual"
from employees;

select e.last_name, m.last_name
from employees e, employees m
where e.manager_id = m.employee_id
union
select e.last_name, NULL
from employees e
where e.manager_id is NULL;

select *
from employees inner join departments
on employees.department_id = departments.department_id;

select *
from employees, departments
where employees.department_id = departments.department_id;

select *
from employees natural join departments;

select *
from employees full join departments
on employees.department_id = departments.department_id;

select *
from employees, departments;

select *
from employees left join departments
on employees.department_id = departments.department_id;

select *
from employees right join departments
on employees.department_id = departments.department_id;

select AVG(salary), MAX(salary), MIN(salary), SUM(salary)
from employees natural join jobs
where job_title like 'Sales%';

select department_id, ROUND(AVG(salary),0)
from employees
where salary > 5000
group by department_id;

select department_name, avg(salary)
from employees join departments
on employees.department_id = departments.department_id
--where salary >5000
group by department_name
having avg(salary)>5000;

select job_title, SUM(salary)
from employees natural join jobs
where job_title NOT LIKE 'Sales%'
group by job_title
having AVG(salary) > 5000
order by SUM(salary) DESC;

select MAX(AVG(salary))
from employees
group by department_id;

select AVG(MAX(salary))
from employees
group by department_id;

select department_name, job_title, AVG(salary)
from employees join departments
on employees.department_id = departments.department_id
join jobs
on employees.job_id = jobs.job_id
group by department_name, job_title
order by job_title, department_name;

select e.employee_id, e.department_id, (e.salary-m.salary) as difference
from employees e, employees m
where e.manager_id = m.employee_id
order by e.department_id;

select first_name
from employees
where first_name LIKE 'S%';

select e1.last_name, e1.salary
from employees e1
where e1.salary > (select AVG(salary) from employees e2 where e2.department_id = e1.department_id);

-- wrong because false 1s instead of 0s
select city, count(*)
from employees e join departments d
on e.department_id = d.department_id 
right join locations l 
on d.location_id = l.location_id
group by city;

-- gives me nulls
select city, (select count(*)
        from employees join departments
        on employees.department_id = departments.department_id
        and departments.location_id = locations.location_id
        group by location_id) as "employee count"
from locations;

select city, (select count(*)
            from employees e, departments d
            where e.department_id = d.department_id
            and d.location_id = l.location_id) as count
from locations l;

select e.first_name ||' '|| e.last_name as "Full Name", d.department_name, l.city
from employees e join departments d
on (e.department_id = d.department_id)
join locations l
on (d.location_id = l.location_id)
where l.country_id IN (select country_id
                    from countries c
                    where c.country_id like 'UK');

-- how do you know where to put the subquery

select d.department_id, d.department_name, AVG(e.salary), count(distinct e.employee_id) as num
from employees e join departments d
on (e.department_id = d.department_id)
group by d.department_id, d.department_name
having count(*)>=2
order by department_id;

select e1.last_name, e1.salary
from employees e1
where salary > (select AVG(salary)
                from employees e2
                where e2.department_id = e1.department_id);

select last_name, job_title, salary, averages.avgDept
from employees natural join jobs,
(select department_id, AVG(salary)avgDept
from employees
group by department_id) averages
where employees.department_id= averages.department_id
and employees.salary> averages.avgDept;

select first_name ||' '|| last_name as "Full Name", salary, (salary*12)+NVL(salary*commission_pct, 0) Annual
from employees;

create table instructor(
id char(5),
name varchar(20),
dept_name varchar(20),
salary number(8,2),
primary key(id),
foreign key(dept_name) references department);

create table department(
dept_name varchar(20),
building varchar(15),
budget number(12,2),
primary key(dept_name));

drop table instructor;

select *
from user_catalog;

insert into department (dept_name, building) values ('Biology', 'West Hall');

insert into instructor values ('10211', 'Smith', 'Biology', 66000);

update department
set budget = 25000
where dept_name = 'Biology';

update instructor
set salary = salary*1.05
where name = 'Smith';

update instructor
set salary = salary*1.07;

update instructor
set salary=case
when salary <= 100000
    then salary*1.05
    else salary*1.03
end;

delete from department;

delete from instructor 
where name = 'Smith';

alter table instructor
add email varchar(25);

alter table instructor
drop column email;

truncate table department;

drop table instructor;

drop table department;

select sysdate from dual;

select '25'
from dual;

select 'ASD' as "fOo"
from departments;

select sysdate
from dual;

select last_name, (sysdate-hire_date)/7 as weeks
from employees;

select TO_CHAR(SYSDATE, 'DD MONTH YYYY') as Today
from dual;

select TO_DATE('2003/07/09', 'yyyy/mm/dd/')
from dual;

insert into foo (bname, bday)
values ('ANDY',TO_DATE('13-AUG-^^ 12:56 A.M.','DD-MON_YY HH:MI A.M.'));

select e.last_name, m.last_name
from employees e, employees m
where e.manager_id = m.employee_id
union
select e.last_name, null
from employees e
where e.manager_id is null;

select e.last_name, m.last_name
from employees e left join employees m
on (e.manager_id = m.employee_id);

select AVG(salary)
from employees;

select AVG(salary)
from employees
where department_id = 100;

select AVG(salary)
from employees
group by department_id;

select MAX(salary)
from employees
where manager_id is NOT NULL;

select count(*)
from employees;

select count(*)
from employees
where first_name = 'John';

select count(distinct last_name)
from employees;

select AVG(salary), MAX(salary), MIN(salary), SUM(salary)
from employees natural join jobs
where job_title like 'Sales%';

select MIN(hire_date), MAX(hire_date)
from employees
where salary between 1500 and 2500;

select AVG(commission_pct)
from employees;

select AVG(NVL(commission_pct,0))
from employees;

select department_id, AVG(salary)
from employees
group by department_id
order by department_id;

select department_id, count(*)
from employees
group by department_id;

select department_id, AVG(salary)
from employees
where salary > 5000
group by department_id;

select department_id, AVG(salary)
from employees
group by department_id
having AVG(salary) > 5000;

select job_title, SUM(salary)
from employees natural join jobs
where job_title NOT LIKE 'Sales%'
group by job_title
having AVG(salary) > 5000
order by SUM(salary) DESC;

select MAX(AVG(salary))
from employees
group by department_id;

select AVG(MAX(salary))
from employees
group by department_id;

select department_name, job_title, AVG(salary)
from employees join departments
on employees.department_id = departments.department_id
join jobs
on employees.job_id = jobs.job_id
group by department_name, job_title
order by job_title, department_name;

select d.department_name, AVG(e.salary-m.salary)
from employees e, employees m, departments d
where e.manager_id = m.employee_id
and e.department_id = d.department_id
group by d.department_name
order by d.department_name;

select j.job_title, MAX(e.salary)
from employees e natural join jobs j
group by j.job_title
having MAX(e.salary) >= 4000;

select department_id, AVG(salary), count(*)
from employees
group by department_id
having count(employee_id)>10;

select department_id, AVG(salary)
from employees
where department_id IN(50, 80)
group by department_id;

select e.first_name ||' '|| e.last_name as "Employee Full Name",
    m.first_name ||' '|| m.last_name as "Manager Full Name",
    region_name
from employees e left join employees m
    on e.manager_id = m.employee_id
left join departments d
    on e.department_id = d.department_id
left join locations l
    on d.location_id = l.location_id
left join countries c
    on l.country_id = c.country_id
left join regions r
    on c.region_id = r.region_id;
    
select DISTINCT(m.last_name)
from employees m, employees e1, employees e2, employees e3
where m.employee_id = e1.manager_id 
and e2.manager_id = m.employee_id
and e3.manager_id = m.employee_id
and e1.employee_id <> e2.employee_id
and e2.employee_id <> e3.employee_id
and e3.employee_id <> e1.employee_id;

-- name of supervisors to 3 employees
select m.last_name
from employees m join (select e.manager_id
                        from employees e
                        group by e.manager_id
                        having count(*) > 3) result
on m.employee_id = result.manager_id;

--name of supervisors to 5 employees
select m.last_name, count(*)
from employees e join employees m
on e.manager_id = m.employee_id
group by m.last_name
having count(*) > 3;

select j.job_title, MAX(e.salary)
from employees e natural join jobs j
group by j.job_title
having MAX(e.salary) >= 4000;

select department_id, AVG(salary)
from employees
group by department_id
having count(employee_id)>10;

select department_id, AVG(salary)
from employees
where department_id = 50
or department_id = 80
group by department_id;

select m.employee_id, count(*)
from employees e join employees m
    on e.manager_id = m.employee_id
group by m.employee_id
having count(e.employee_id) > 3;

select l.city, count(e.employee_id)
from employees e join departments d
    on e.department_id = d.department_id
join locations l
    on d.location_id = l.location_id
group by l.city;

select e.first_name||' '||e.last_name "Name",
    d.department_name,
    l.city
from employees e join departments d
    on e.department_id = d.department_id
join locations l
    on d.location_id = l.location_id
where d.department_id IN (select f.department_id
                        from departments f natural join locations k
                        where k.country_id = 'UK');

select d.department_id, d.department_name, AVG(salary), count(*)from employees e join departments d
    on e.department_id = d.department_id
group by d.department_id, d.department_name
having count(employee_id) IN (select d2.department_id
                                from employees d2
                                group by d2.department_id
                                having count(d2.employee_id) >1);
order by d.department_id;