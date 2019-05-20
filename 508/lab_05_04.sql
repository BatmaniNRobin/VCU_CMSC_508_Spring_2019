--True
--False
--True

select ROUND(MAX(salary),0) as Maximum, ROUND(MIN(salary),0) as Minimum, ROUND(SUM(salary),0) as Sum, ROUND(AVG(salary),0) as Average
from employees;