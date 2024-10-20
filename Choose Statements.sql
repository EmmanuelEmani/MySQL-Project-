-- WHERE CLAUSE
select *
From parks_and_recreation.employee_salary
where first_name = 'Leslie'
;

select *
From parks_and_recreation.employee_salary
where salary <= 50000
;

select *
From parks_and_recreation.employee_demographics
where gender  != 'Female'
;

select *
From parks_and_recreation.employee_demographics
where birth_date > '1985-01-01'
and gender = 'male';


-- Like statement 
-- % and _

Select *
From parks_and_recreation.employee_demographics
where first_name like 'Jer%'
;

Select *
From parks_and_recreation.employee_demographics
where first_name like 'Jer%'
or first_name like '%a%'
;
