-- advanced slide 1 number 1
CREATE SEQUENCE  "V00778622"."PIKA_CONTROL"  
   MINVALUE 1 
   MAXVALUE 9999999999999999999999999999 
   INCREMENT BY 1 
   START WITH 1000 
   CACHE 20 
   NOORDER  
   NOCYCLE  
   NOKEEP  
   NOSCALE  
   GLOBAL ;

drop sequence "V00778622"."PIKA_CONTROL";

create table employees_copy as select * from employees;





-- advanced slide 1 number 2
create or replace function fullname(p_employee_id in employees.employee_id%TYPE)
    return VARCHAR2
IS
    v_name VARCHAR2(100);
BEGIN
    SELECT first_name||' '||last_name INTO v_Name
    FROM employees
    where employee_id = p_employee_id;
    RETURN v_Name;
END fullname;
/

select fullname(200) from dual;
drop function fullname;





-- advanced slide one exercise 3
create or replace function format_phone(p_phone_number in employees.phone_number%TYPE)
    RETURN VARCHAR2
IS
    v_number VARCHAR2(20);
BEGIN
    RETURN ('(' || SUBSTR(p_phone_number, 1, 3) || ')' ||
            SUBSTR(p_phone_number,5,3) || '-' ||
            SUBSTR(p_phone_number, 9,4));
END format_phone;
/

select format_phone('515.123.4567') from dual;
drop function format_phone;




-- advanced slides 1 number 4
CREATE OR REPLACE FUNCTION avg_salary (p_department_id IN employees.department_id%TYPE)
    RETURN NUMBER
IS
    v_avg NUMBER(10,2);
BEGIN
    select AVG(SALARY) INTO v_avg
    FROM employees e
    where e.department_id = p_department_id;
    RETURN v_avg;
END;
/

select avg_salary(20) from dual;
drop function avg_salary;





-- advanced slides number 5
create or replace procedure 
        increasePCT(p_employee_id IN employees_copy.employee_id%TYPE,
                    p_increase_pct IN number)
IS
BEGIN
    update employees_copy set salary = (salary *(1 + p_increase_pct))
    where employee_id = (select manager_id
                        from employees_copy 
                        where employee_id =p_employee_id);
END;
/

exec increasePCT(105, 0.1);

select salary, manager_id from employees_copy where employee_id = 103; 
drop procedure increasePCT;





-- advanced slides 1 number 6
--Create a procedure to create a table with the department name,
--the department’s manager full name and the number of employees working for that department.
create or replace procedure table_create(p_department_name IN departments.department_id%TYPE)
    AUTHID CURRENT_USER
AS
    var1 varchar2(5000);
BEGIN
    var1:= q'[create table number6 as 
        department_name as "Department Name",
        employees.first_name||' '||employees.last_name as "Manager Name",
        count (e2.employee_id) as Count
        FROM departments join employees
            on departments.manager_id = employees.employee_id
        join employees e2
            on departments.department_id = e2.department_id
        where departments.department_id = ]'||p_department_name||q'[
        group by department_name, "Manager Name"]';
END;
/

exec table_create(50);
drop procedure table_create;





-- not an exercise
create or replace trigger plus_ultra
after insert OR UPDATE OF department_id ON employees
    FOR EACH ROW
    BEGIN
        IF INSERTING OR(UPDATING AND :new.department_id != :old.department_id)
            THEN UPDATE employees
            SET salary = salary*1.05
            where :old.department_id = :new.department_id;
        END IF;
    END;
    /

drop trigger plus_ultra;






-- advanced slides 2 number 1
--finish
--Create a table for projects (manager,duration(days),cost),and
--check that the cost must be<500 per day nor bigger than the sum of the
--salaries of the department employees the manager works for.
create table projects(
    manager varchar2(25),
    duration number(3,0),
    cost number(10,2),
    primary key (manager),
    check((cost/duration<500))); -- is this allowed

create or replace trigger projects_trigger
before insert or update of cost ON projects
for each row
begin
    IF DELETING OR (UPDATING AND :old.cost != :new.cost)
        THEN UPDATE projects
        SET cost = cost / duration
        where cost < 500;
    end if;
    -- where cost / duration is < 500
    -- and cost < SUM(salary) from employee e, employee m
    -- on m.employee_id = e.manager_id
    -- group by manager_id
    -- having cost < SUM(salary);
END;
/
 drop table projects;
 drop trigger projects_trigger;
 
 
 
 
 
--advanced slides 2 example 2
--Create a mechanism to check and prevent having employees
--salary bigger than his manager(or King if they have no manager).
create or replace trigger check_salary
before insert ON employees_copy
FOR EACH ROW

declare manager_salary employees_copy.salary%TYPE;
        pres_salary employees_copy.salary%TYPE;
BEGIN
    select salary INTO pres_salary
    FROM employees_copy
    where job_id = 'AD_PRES';
    select salary INTO manager_salary
    FROM employees_copy
    WHERE employee_id = :new.manager_id;
    IF (:new.salary > manager_salary or :new.salary > pres_salary)
        THEN 
            RAISE_APPLICATION_ERROR(-20000, 'nah that aint it');
    END IF;
END;
/
 drop trigger check_salary;
 
 
 
 
 
--extra trigger exercises
drop table employees_copy;
create table employees_copy as select * from employees;

create or replace trigger pres_salary
before insert ON employees_copy
FOR EACH ROW

declare presidential_salary employees_copy.salary%TYPE;

BEGIN
    select salary INTO presidential_salary
    FROM employees_copy
    where job_id = 'AD_PRES';
    IF (:new.salary > presidential_salary)
        THEN
        RAISE_APPLICATION_ERROR(-20000, 'Failed');
    END IF;
END;
/

insert into employees_copy values (207, 'doe', 'do', 'dooo', 
    '650.507.9833', SYSDATE, 'SA_REP', 6000, NULL, 206, 50);    
select * from employees_copy where employee_id = 207;
delete from employees_copy where employee_id = 207;

update employees_copy set job_id = 13 where employee_id=100;
drop trigger pres_salary;





--trigger exercises 2
create or replace trigger manager_salaries
before insert ON employees_copy
FOR EACH ROW

declare manager_salary employees_copy.salary%TYPE;

BEGIN
    select salary INTO manager_salary
    FROM employees_copy
    WHERE employee_id = :new.manager_id;
    IF (:new.salary > manager_salary)
        THEN 
            RAISE_APPLICATION_ERROR(-20000, 'nah that aint it');
    END IF;
END;
/





-- trigger exercise 3
create table subordinates as
    select m.employee_id, count(*) as counter
    from employees e left join employees m
        on e.manager_id = m.employee_id
    group by m.employee_id;
    
select * from subordinates;
drop table subordinates;

-- trigger will be triggered if employee is promoted, added, deleted or moved to a different dept
-- on insert add 1 to count where manager_id = manager_id
-- on delete subtract 1 from count where manager_id = :old.manager_id
-- on update subtract 1 from :old.manager_id and add 1 to :new.manager_id
create or replace trigger logs
after insert or update or delete on employees_copy
for each row
begin
    if inserting or (updating and :old.manager_id != :new.manager_id)
    then
        update subordinates
        set counter = counter + 1
        where employee_id = :new.manager_id;
    END IF;
    IF deleting or (updating and :old.manager_id != :new.manager_id)
    then
        update subordinates
        set counter = counter - 1
        where employee_id = :old.manager_id;
    END IF;
END;
/   

create or replace trigger removal
after delete on employees_copy
for each row
begin  
    delete from employees_copy
    where employee_id = :old.employee_id;
end;
/

drop trigger logs;
drop trigger removal;
drop table subordinates;





--trigger exercise 4
create or replace trigger salarybump
after update on employees_copy
for each row
begin
    if inserting or (updating and :old.manager_id != :new.manager_id)
    then   
        update employees_copy
        set salary = salary*1.05
        where employee_id = :new.manager_id;
    END IF;
END;
/

drop trigger salarybump;





-- trigger exercise 5
create table loggedevents(
    log_event_id number(6,0) primary key,
    "date" date,
    description varchar2(1000)
);

create sequence increment_logs
    start with 1
    maxvalue   9999
    increment by 1
    nocycle;

create or replace trigger logger
after insert or delete or update oN employees_copy
for each row
begin
    if inserting
    then
        insert into loggedevents values (increment_logs.nextval, sysdate, 'Employee' ||
        :new.employee_id || 'was recently hired with a salary of' || :new.salary);
    END IF;
    IF deleting
    then
        insert into loggedevents values (increment_logs.nextval, sysdate, 'Employee' ||
        :old.employee_id || 'was fired and had a salary of' || :old.salary);
    END IF;
    IF updating
    then
        insert into loggedevents values (increment_logs.nextval, sysdate, 'Employee' ||
        :new.employee_id || 'updated salary from' || :old.salary || 'to' || :new.salary);
    END IF;
END;
/

drop table loggedevents;
drop sequence increment_logs;
drop trigger logger;





-- advanced slides 3 test example
-- for this func should i have done a left join with departments like canos example
create or replace function compute_average (f_employee_id in employees.employee_id%TYPE)
    RETURN NUMBER
IS
    f_salary employees.salary%TYPE;
BEGIN
    SELECT AVG(salary) into f_salary
    from employees
    where department_id = '&user'
    group by department_id;
    RETURN f_salary;
END;
/

select compute_average(85) from dual;
drop function compute_average;

-- this is still same example
-- use nvl for some group functions in select
create or replace view department_statistics(department_name, manager_name, employee_count, max_salary, min_salary, avg_salary) as
select d.department_name, SUBSTR(e.first_name, 1, 1)||'. '||e.last_name, count(e.employee_id),MAX(e.employee_id), MIN(e.employee_id), AVG(e.salary)
from employees e right join departments d
    on d.manager_id = e.manager_id
group by d.department_name, SUBSTR(e.first_name, 1, 1)||'. '||e.last_name;


select * from department_statistics;
drop view department_statistics;




drop table employees_copy;

-- chapter 11 practice problems
create or replace view employees_vu as
select employee_id, last_name as employee, department_id
from employees;
    
select * from employees_vu;

select employee, department_id
from employees_vu;

create or replace view dept50 as
select employee_id empno, last_name employee, department_id deptno
from employees
where department_id = 50
WITH CHECK OPTION CONSTRAINT emp_dept_50;

describe dept50;

UPDATE dept50
set deptno=80
where employee = 'Matos';

create sequence dept_id_seq
start with 200
increment by 10
maxvalue 1000;

insert into dept
values (dept_id_seq.nextval, 'Education');

insert into dept
values (dept_id_seq.nextval, 'Admin');

create index dept_name_index on dept(name);

create synonym emp for employees;

drop view dept50;
drop view employees_vu;