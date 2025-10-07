CREATE TABLE employees (
 employee_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 department VARCHAR(50),
 salary NUMERIC(10,2),
 hire_date DATE,
 manager_id INTEGER,
 email VARCHAR(100)
);
CREATE TABLE projects (
 project_id SERIAL PRIMARY KEY,
 project_name VARCHAR(100),
 budget NUMERIC(12,2),
 start_date DATE,
 end_date DATE,
 status VARCHAR(20)
);
CREATE TABLE assignments (
 assignment_id SERIAL PRIMARY KEY,
 employee_id INTEGER REFERENCES employees(employee_id),
 project_id INTEGER REFERENCES projects(project_id),
 hours_worked NUMERIC(5,1),
 assignment_date DATE
);
INSERT INTO employees (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');
INSERT INTO projects (project_name, budget, start_date,
end_date, status) VALUES
('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
('Database Migration', 120000, '2024-01-10', NULL, 'Active');
INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
(1, 1, 120.5, '2024-01-15'),
(2, 1, 95.0, '2024-01-20'),
(1, 4, 80.0, '2024-02-01'),
(3, 3, 60.0, '2024-03-05'),
(5, 2, 110.0, '2024-02-20'),
(6, 3, 75.5, '2024-03-10');
select
    first_name || ' ' || last_name as full_name,
    department,
    salary
from employees;
select distinct department from employees;
select
    project_name,
    budget,
    case
        when budget>150000 then 'Large'
        when budget between 100000 and 150000 then 'Medium'
        else 'Small'
        end as budget_category
from projects;
select
    first_name || ' ' || last_name as full_name,
    coalesce(email, 'No email provided') as email
from employees;
select * from employees
where hire_date>'2020-01-01';
select * from employees
where salary between 60000 and 70000;
select * from employees
where first_name like 'S%'
   or first_name like 'J%';
select * from employees
where manager_id is not null
and department='IT';
select
    upper(first_name) as upper_name,
    length(last_name) as length_last_name,
    substring(email from 1 for 3) as short_email
from employees;
select
    first_name || ' ' || last_name as full_name,
    (salary*12) as annual_salary,
    round(salary,2) as rounded_salary,
    (salary*0.1) as raise_amount
from employees;
select
    format('Project: %s - Budget: $%s - Status: %s',
    project_name,
    to_char(budget, 'FM999,999,999.00'),
    status)
from projects;
select
    first_name || ' ' || last_name as full_name,
    hire_date,
    extract(year from age(current_date,hire_date))
from employees;
select
    department,
    avg(salary)
from employees
group by department;
select
    project_name,
    sum((end_date-start_date)*24) as total_hours
from projects
group by project_name;
select
    projects.start_date,
    projects.end_date
from projects;
select
    employees.department,
    count(*) as employee_num
from employees
group by  department
having count(*)>1;
select
    min(salary) as min_salary,
    max(salary) as max_salary,
    sum(salary) as total_salary
from employees;
select
    first_name || ' ' || last_name as full_name,
    employees.employee_id,
    salary
from employees
where salary>65000
union
select
    first_name || ' ' || last_name as full_name,
    employees.employee_id,
    salary
from employees
where hire_date>'2020-01-01';
select
    first_name || ' ' || last_name as full_name,
    employees.employee_id,
    salary,
    department
from employees
where salary>65000
intersect
select
    first_name || ' ' || last_name as full_name,
    employees.employee_id,
    salary,
    department
from employees
where department='IT';
select
    first_name,
    last_name
from employees e
where exists(
    select 1
    from assignments a
    where a.employee_id=e.employee_id
);
select
    employees.first_name,
    employees.last_name
from employees
where employee_id in(
    select employee_id
    from assignments
    where project_id in(
        select project_id
        from projects
        where status='Active'
        )
    );
select
    first_name,
    last_name,
    employees.salary
from employees
where salary>any(
    select salary
    from employees
    where department='Sales'
    );
select
    e.first_name || ' ' || e.last_name as full_name,
    e.department,
    (select avg(a.hours_worked)
     from assignments a
     where a.employee_id=e.employee_id)
    as avg_hours,
    (select count(*)
     from employees e2
     where e2.department=e.department
     and e2.salary>e.salary)+1 as salary_rank
from employees e
order by e.department, salary_rank;
select
    (select project_name
        from projects p
        where p.project_id=a.project_id) as project_name,
    sum(a.hours_worked) as total_hours,
    count(distinct (a.employee_id)) as employee_num
from assignments a
group by a.project_id
having sum(a.hours_worked)>150;
select
    count(distinct employee_id) as employee_num,
    round(avg(salary), 2) as avg_salary,
    (
        select first_name || ' ' || last_name
        from employees
        where salary = (
            select greatest(
                max(salary),
                (select least(max(salary), max(salary)) from employees)
            )
            from employees
        )
    ) as highest_paid_employee
from employees;