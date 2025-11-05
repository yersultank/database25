-- part 1: database setup
-- step 1.1: create sample tables
create table employees (
 emp_id int primary key,
 emp_name varchar(50),
 dept_id int,
 salary decimal(10,2)
);

create table departments (
 dept_id int primary key,
 dept_name varchar(50),
 location varchar(50)
);

create table projects (
 project_id int primary key,
 project_name varchar(50),
 dept_id int,
 budget decimal(10,2)
);

-- step 1.2: insert sample data
insert into employees (emp_id, emp_name, dept_id, salary) values
(1, 'john smith', 101, 50000),
(2, 'jane doe', 102, 60000),
(3, 'mike johnson', 101, 55000),
(4, 'sarah williams', 103, 65000),
(5, 'tom brown', null, 45000);

insert into departments (dept_id, dept_name, location) values
(101, 'it', 'building a'),
(102, 'hr', 'building b'),
(103, 'finance', 'building c'),
(104, 'marketing', 'building d');

insert into projects (project_id, project_name, dept_id, budget) values
(1, 'website redesign', 101, 100000),
(2, 'employee training', 102, 50000),
(3, 'budget analysis', 103, 75000),
(4, 'cloud migration', 101, 150000),
(5, 'ai research', null, 200000);

-- part 2: cross join
select e.emp_name, d.dept_name
from employees e cross join departments d;
-- 5 employees × 4 departments = 20 rows

-- alternative syntax
select e.emp_name, d.dept_name from employees e, departments d;
select e.emp_name, d.dept_name from employees e inner join departments d on true;

-- all employees with all projects
select e.emp_name, p.project_name
from employees e cross join projects p;

-- part 3: inner join
select e.emp_name, d.dept_name, d.location
from employees e
inner join departments d on e.dept_id = d.dept_id;
-- 4 rows, tom brown not included (dept_id is null)

select emp_name, dept_name, location
from employees inner join departments using (dept_id);
-- using removes duplicate dept_id column

select emp_name, dept_name, location
from employees natural inner join departments;

select e.emp_name, d.dept_name, p.project_name
from employees e
inner join departments d on e.dept_id = d.dept_id
inner join projects p on d.dept_id = p.dept_id;

-- part 4: left join
select e.emp_name, e.dept_id as emp_dept, d.dept_id as dept_dept, d.dept_name
from employees e
left join departments d on e.dept_id = d.dept_id;
-- tom brown has null dept info

select emp_name, dept_id, dept_name
from employees left join departments using (dept_id);

select e.emp_name, e.dept_id
from employees e
left join departments d on e.dept_id = d.dept_id
where d.dept_id is null;

select d.dept_name, count(e.emp_id) as employee_count
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
order by employee_count desc;

-- part 5: right join
select e.emp_name, d.dept_name
from employees e
right join departments d on e.dept_id = d.dept_id;

-- convert to left join
select e.emp_name, d.dept_name
from departments d
left join employees e on d.dept_id = e.dept_id;

select d.dept_name, d.location
from employees e
right join departments d on e.dept_id = d.dept_id
where e.emp_id is null;

-- part 6: full join
select e.emp_name, e.dept_id as emp_dept, d.dept_id as dept_dept, d.dept_name
from employees e
full join departments d on e.dept_id = d.dept_id;
-- null on left = dept without employees, null on right = employee without dept

select d.dept_name, p.project_name, p.budget
from departments d
full join projects p on d.dept_id = p.dept_id;

select
 case
  when e.emp_id is null then 'department without employees'
  when d.dept_id is null then 'employee without department'
  else 'matched'
 end as record_status,
 e.emp_name,
 d.dept_name
from employees e
full join departments d on e.dept_id = d.dept_id
where e.emp_id is null or d.dept_id is null;

-- part 7: on vs where
select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id = d.dept_id and d.location = 'building a';
-- filter in on keeps all employees, only matching dept shown

select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id = d.dept_id
where d.location = 'building a';
-- filter in where removes unmatched rows

-- same for inner join (no difference)
select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d on e.dept_id = d.dept_id and d.location = 'building a';

select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d on e.dept_id = d.dept_id
where d.location = 'building a';

-- part 8: complex joins
select
 d.dept_name,
 e.emp_name,
 e.salary,
 p.project_name,
 p.budget
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
order by d.dept_name, e.emp_name;

-- self join
alter table employees add column manager_id int;
update employees set manager_id = 3 where emp_id in (1,2,4,5);
update employees set manager_id = null where emp_id = 3;

select
 e.emp_name as employee,
 m.emp_name as manager
from employees e
left join employees m on e.manager_id = m.emp_id;

-- join with subquery
select d.dept_name, avg(e.salary) as avg_salary
from departments d
inner join employees e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) > 50000;
