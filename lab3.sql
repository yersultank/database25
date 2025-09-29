create database advanced_lab;
create table employees(
    emp_id serial primary key ,
    first_name text,
    department text,
    salary int,
    hire_date date,
    status text default 'Active'
);
create table departments(
    dept_id serial primary key ,
    dept_name text,
    budget int,
    manager_id int
);
create table projects(
    project_id serial primary key ,
    project_name text,
    dept_id int,
    start_date date,
    end_date int,
    budget int
);
alter table employees
alter column salary set default 1000000;
insert into employees(emp_id, first_name, last_name, department)
values (1,'yers','kuralbay', 'uni');
select * from employees;
insert into employees(emp_id, first_name,department,salary,hire_date, last_name, status)
values(2, 'yeskendir', 'politics', default,'2023-01-01','kuralbay',default);
insert into departments(dept_name, budget, manager_id)
values('uni', 200,1 ),
      ( 'politics', 30000,2),
      ('IT', 150000, 3);
select * from departments;
insert into employees(emp_id,first_name,last_name, department, salary, hire_date,status)
values(4,'john', 'wick', 'killing', 50000*1.1, current_date,default);
select * from employees;
insert into employees(emp_id, first_name, last_name, department)
values(3,'ye', 'kan', 'IT');
create temp table temp_employees as
select *
from employees
where department='IT';
select * from temp_employees;
update employees
set salary=salary*1.1;
select * from employees;
update employees
set hire_date='2018-01-01'
where first_name='yers';
update employees
set salary=100000
where first_name='yers';
update employees
set status='Senior'
where salary>60000 and hire_date<'2020-01-01';
update employees
set department=case
    when salary>80000 then 'Management'
    when salary between 50000 and 80000 then 'Senior'
    else 'Junior'
end;
update employees
set department=default
where status='Inactive';
update departments d
set budget=(
    select avg(e.salary)*1.2
    from employees e
    where e.department=d.dept_name
    );
update employees
set salary=salary*1.15,
    status='Promoted'
where department='Sales';
delete  from employees
where status='Terminated'
delete from employees
where salary<40000
  and hire_date>'2023-01-01'
  and department is null ;
DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE department IS NOT NULL
);
delete from projects
where end_date<'2023-01-01'
returning *;
insert into employees (first_name, department, salary, hire_date, status)
values ('Martin', Null, null, '2000-01-01',default);
select * from employees;
update employees
set department='Unassigned'
where department is null;
delete from employees
where salary is null
or department is null;
alter table employees
add column last_name text;
insert into employees (first_name, last_name, department, salary, hire_date, status)
values ('miller', 'gena', null, 777,'2012-01-01', default)
returning emp_id, first_name || ' ' || last_name as full_name;
update employees
set salary=salary+5000
where department='IT'
returning emp_id,
    salary-5000 as old_salary,
    salary as new_salary;
delete from employees
where hire_date<'2020-01-01'
returning  *;
insert into employees(first_name,last_name, department, salary, hire_date,status)
select 'john', 'kennedy', 'president', 99999, '1982-01-01', 'Active'
where not exists(
    select 1
    from employees
    where first_name='john'
    and last_name='kennedy'
);
update employees e
set salary=salary*
           case
               when d.budget>100000 then 1.10
                else 1.05
            end
from departments d
where e.department=d.dept_name;
insert into employees(first_name, department, salary)
values('max', 'Sales', 6000),
      ('jeremy', 'IT', 5000),
      ('nicola', 'Medicine', 7000),
      ('jackson','IT', 8000);
update employees
set salary=salary*1.10
where first_name in ('max', 'jeremy','nicola', 'jackson');
select * from employees;
create table employee_archive as
    table employees
with no data;
insert into employee_archive
select *
from employees
where status='Inactive';
delete from employees
where status='Inactive';
update projects
set end_date=end_date+interval '30 days'
where projects.budget>50000
and(
    select count(*)
    from employees e
    join departments d on e.department=d.dept_name
    where d.dept_id=projects.dept_id
    )>3;
