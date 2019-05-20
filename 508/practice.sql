SELECT d.department_name, AVG(e.salary-m.salary)
FROM employees e, employees m, departments d
where e.department_id = m.department_id
    and e.manager_id = m.employee_id
GROUP BY d.department_name
ORDER BY department_name;

SELECT department_id, AVG(salary), COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 10;

SELECT department_id, AVG(salary)
FROM employees
where department_id IN (50, 80)
group by department_id;

select last_name
from employees
where employee_id NOT IN (select manager_id from employees);

select last_name
from employees
where employee_id NOT IN (select manager_id from employees where manager_id is not null);

select department_name, (select count(*) from employees where departments.department_id= employees.department_id) from departments;

select department_name, count(*)
from employees join departments
on departments.department_id= employees.department_id
group by department_name;

create table students(
    id number(6,0) primary key,
    last_name varchar2(20) not null,
    email varchar2(20) not null unique
);

drop table students;

create table students(
    first_name varchar2(20) not null,
    last_name varchar2(20) not null,
    email varchar2(20) not null unique,
    primary key(first_name, last_name)
);

describe students;

create index jobID_index on employees(job_ID, last_name);

drop index jobID_index;

CREATE OR REPLACE FUNCTION retrieveSalary
    RETURN NUMBER
IS
    func_salary NUMBER(10,2);
BEGIN
    SELECT salary INTO func_salary
    FROM employees
    WHERE employee_id = '100';
    RETURN func_salary;
END retrieveSalary;
/

SELECT retrieveSalary FROM dual;

DROP FUNCTION retrieveSalary;

CREATE OR REPLACE FUNCTION RetrieveSalary(p_employee_id in employees.employee_id%TYPE)
    RETURN NUMBER
IS
    func_salary employees.salary%TYPE;
BEGIN
    SELECT salary INTO func_salary
    FROM employees
    WHERE employee_id = p_employee_id;
    RETURN func_salary;
END RetrieveSalary;
/

SELECT RetrieveSalary(100) from DUAL;

CREATE OR REPLACE PROCEDURE IncreaseSalary(
    p_employee_id IN employees.employee_id%TYPE, p_increment_pct IN number)
IS
BEGIN
    UPDATE employees set salary = salary*(1+p_increment_pct)
    WHERE employee_id = p_employee_id;
END IncreaseSalary;
/

exec IncreaseSalary(105, 0.1);

drop procedure increasesalary;

select salary from employees where last_name = 'King';

create or replace procedure getSalary(p_employee_id IN employees.employee_id%TYPE,
                                    p_salary OUT employees.salary%TYPE)
AS
BEGIN
    select salary INTO p_salary from employees where employee_id = p_employee_id;
END;
/

DECLARE
salary NUMBER;
BEGIN
getSalary(100, salary);
dbms_output.put_line(salary);
END;
/

create or replace procedure get_emp_name (dept_num IN NUMBER)
IS
    emp_name VARCHAR2(50);
    CURSOR c1(dept_num NUMBER) IS
            SELECT FIRST_NAME ||' '|| LAST_NAME
            FROM EMPLOYEES
            WHERE DEPARTMENT_ID = dept_num;
BEGIN
    OPEN c1(DEPT_NUM);
    LOOP
        FETCH c1 INTO emp_name;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(emp_name);
    END LOOP;
    CLOSE c1;
END;
/

exec get_emp_name(10);

create or replace view employeesData ( employee_id, last_name, department_name)
as
    SELECT employee_id, last_name, department_name
    FROM employees, departments
    WHERE employees.department_id = departments.department_id;
    
drop view employeesData;

create view regionsView
as select region_id, region_name from regions;

create view blah (region_id, region_name)
as select region_id, region_name from regions;

insert into blah values(95, 'blah');

delete from blah where region_id IN (95, 99);

drop view regionsView;
drop view blah;

drop view employeesData;

drop procedure get_emp_name;

create or replace trigger total_salary
AFTER DELETE OR INSERT OR UPDATE OF department_id, salary ON employees
    FOR EACH ROW
    BEGIN
        IF DELETING OR (UPDATING AND :old.department_id != :new.department_id)
            THEN UPDATE departments
            SET total_salary = totla_salary - :old_salary
            WHERE department_id = :old.department_id;
        END IF;
        IF INSERTING OR (UPDATING AND :olddepartment_id != :new.department_id)
            THEN UPDATE departments
            SET total_salary = total_salary + :new.salary
            WHERE department_id = :new.department_id;
        END IF;
        IF (UPDATING AND :old.department_id = :new.department_id AND :old.salary != :new.salary)
            THEN UPDATE departments
            SET total_salary = total_salary - :old.salary + :new.salary
            WHERE department_id = :new.department_id;
        END IF;
    END;
    /
    
    drop trigger total_salary;