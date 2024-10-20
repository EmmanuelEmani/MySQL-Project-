-- Group by

select gender , avg(AGE)
from  employee_demographics
group by gender ;


select occupation, salary
from  employee_salary
group by occupation ,salary
;

select gender , avg(AGE), max(age), min(age), count(age)
from  employee_demographics
group by gender ;

-- Order by
select *
from  employee_demographics
order by  gender , age  ;



