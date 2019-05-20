
create table template_table(
    variable_name int primary key,
    variable_name2 number(6,0) not null unique,
    variable_name3 varchar2(40) references departments(department_id)
    check (variable_name2 in ('fall', 'winter','spring','summer'))
);


create sequence AI
start with 1
maxvalue 9999
increment by 1
nocycle;

AI.nextval;
drop sequence AI;

create or replace function skr (p_employee_id in employees.employee_id%TYPE)
    return number
is
    v_name number(10,2);
begin
    select salary into v_name
    from employees
    where employee_id = p_employee_id;
    return v_name;
end skr;
/

select skr(100) from dual;
drop function skr;

create or replace procedure produce (p_employee_id in employees.employee_id%TYPE)
as
    v_number number(10,2);
begin 
    select employee_id into v_number
    from employees
    where employee_id = p_employee_id;
end;
/

drop procedure produce;

create or replace procedure get_emp_names (dept_num in number)
is
    emp_name varchar(40);
    cursor c1(dept_num NUMBER) is
        select first_name ||' '||last_name
        from employees
        where department_id = dept_num;
begin
    open c1(dept_num);
    loop
        fetch c1 into emp_name;
        exit when c1%notfound;
        dbms_output.put_line(emp_name);
    end loop;
    close c1;
end;
/

exec get_emp_names(50);
drop procedure get_emp_names;

create or replace trigger trigga
after insert or delete or update on employees
for each row
begin
    if inserting 
    then
        select * from employees;
    end if;
end;
/

drop trigger trigga;


create view highsalaryEmployees(last_name, department_name, salary) as
select e.last_name, d.department_name, e.salary
from employees e join departments d
    on e.department_id = d.department_id
where e.salary > (select AVG(salary) from employees c where e.department_id = c.department_id);

select * from highsalaryemployees;

create or replace function compute_average(p_department_id in employees.department_id%TYPE)
    return number
is
    faverage employees.salary%TYPE;
begin
    select AVG(salary) into faverage
    from employees
    where department_id = p_department_id;
    return faverage;
end;
/

create or replace function compute_count(p_department_id in employees.department_id%TYPE)
    return number
as
    f_count int;
begin
    select COUNT(*) into f_count
    FROM employees
    where department_id = p_department_id;
    return f_count;
end;
/

create or replace function salarymax(p_department_id in employees.department_id%TYPE)
    return number
as
    salarymax int;
begin
    select MAX(salary) into salarymax
    from employees
    where department_id = p_department_id;
    return salarymax;
end;
/

create or replace function salarymin(p_department_id in employees.department_id%TYPE)
    return number
as
    salarymin int;
begin
    select MIN(salary) into salarymin
    from employees
    where department_id = p_department_id;
    return salarymin;
end;
/


create or replace view department_statistics as
select d.department_name, substr(e.first_name,0,1)||'. '||e.last_name as name, compute_count(d.department_id) as counter,
        compute_average(d.department_id)as avg, salarymax(d.department_id)as high, salarymin(d.department_id) as low
from employees e, departments d
where d.manager_id = e.employee_id
UNION
select d.department_name, null as name,compute_count(d.department_id)as counter, nvl(compute_average(d.department_id),0)as avg,
        nvl(salarymax(d.department_id),0) as high, nvl(salarymin(d.department_id),0) as low
from departments d
where d.manager_id is null;

select * from department_statistics;

drop view highsalaryemployees;
drop function compute_average;
drop function compute_count;
drop function salarymin;
drop function salarymax;
drop view department_statistics;




drop table employees_copy;
create table employees_copy as select * from employees;




create or replace procedure fire_employee (p_employee_id in employees.employee_id%TYPE)
as
    idnum employees.employee_id%TYPE;
    cursor c1(p_employee_id number) is
        select manager_id
        from employees_copy;
    emp_rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into emp_rec;
        if (emp_rec.manager_id = idnum)
        then
            update employees_copy
            set manager_id = 100
            where idnum = p_employee_id;
        end if;
        exit when c1%notfound;
    end loop;
    close c1;
    delete from employees_copy
    where employee_id = p_employee_id;
end;
/

exec fire_employee(101);


select * from employees_copy;


create table salary_updates_log(
    update_id int primary key,
    employee_id number (6,0) references employees(employee_id),
    previous_salary int,
    new_salary int
);

create sequence AI
start with 100
maxvalue 999
increment by 1
nocycle;

create or replace trigger trigga
after insert or delete or update of salary on employees
for each row
begin
    if inserting
    then
        insert into salary_updates_log values (AI.nextval, :new.employee_id, :old.salary,:new.salary);
    end if;
    if deleting
    then
        insert into salary_updates_log values (AI.nextval, :old.employee_id, :old.salary, :new.salary);
    end if;
    if updating
    then
        insert into salary_updates_log values (AI.nextval, :old.employee_id, :old.salary, :new.salary);
    end if;
end;
/

select * from salary_updates_log;
select * from employees where employee_id = 300;
update employees
set salary = 17000
where employee_id = 101;

insert into employees VALUES (300, 'mani', 'malik', 'malikmui', '123.456.7890', '18-sep-03', 'IT_PROG', 18000, 0.5, 103, 60);
delete from salary_updates_log where employee_id = 300;
update employees set job_id = null where employee_id = 300;
delete from employees where employee_id = 300;

drop sequence AI;
drop table salary_updates_log;
drop trigger trigga;


drop table employees_copy;

create table project(
    manager varchar2(40),
    duration date,
    cost number(6,0)
);

create or replace trigger projects
before insert or delete or update of cost on project
for each row
begin
    if (:old.cost / :old.duration) > 500
    then
        raise_application_error(20000, 'cost per day too high');
    end if;
    if :old.cost > (select sum(e.salary)
                    from employees e, departments d
                    where project.manager = d.manager_id
                    and e.department_id = d.department_id)
    then
        raise_application_error(20021, 'nah chief not today');
    end if;
end;
/


create sequence pk
start with 1
