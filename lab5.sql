-- Student: Kuralbay Yersultan
-- Student ID: 24B032136
create table employees(
    employee_id serial primary key ,
    first_name text not null,
    last_name text not null,
    age integer check(age between 18 and 65),
    salary numeric check(salary>0)
);
create table products_catalog (
    product_id integer primary key,
    product_name text not null,
    regular_price numeric,
    discount_price numeric,
    constraint valid_discount check (
        regular_price > 0
        and discount_price > 0
        and discount_price < regular_price
    )
);
create table bookings (
    booking_id integer primary key,
    check_in_date date not null,
    check_out_date date not null,
    num_guests integer check (num_guests between 1 and 10),
    check (check_out_date > check_in_date)
);
insert into employees values (1, 'john', 'doe', 30, 50000);
insert into employees values (2, 'mary', 'smith', 45, 72000);
insert into products_catalog values (1, 'laptop', 1200, 1000);
insert into products_catalog values (2, 'phone', 800, 750);
insert into employees values (3, 'tom', 'young', 16, 40000);
insert into employees values (4, 'alice', 'old', 70, 55000);
insert into products_catalog values (4, 'mouse', 25, 0);
insert into products_catalog values (5, 'keyboard', 100, 120);
insert into bookings values (1, '2025-10-20', '2025-10-25', 2);
insert into bookings values (2, '2025-11-01', '2025-11-05', 4);
create table customers (
    customer_id integer not null,
    email text not null,
    phone text,
    registration_date date not null
);
create table inventory (
    item_id integer not null,
    item_name text not null,
    quantity integer not null check (quantity >= 0),
    unit_price numeric not null check (unit_price > 0),
    last_updated timestamp not null
);
insert into inventory values (1, 'laptop', 10, 1200.50, '2025-10-16 10:00:00');
insert into inventory values (3, null, 20, 10.00, '2025-10-16 10:10:00');
insert into inventory values (7, null, null, null, null);
create table users (
    user_id integer,
    username text unique,
    email text unique,
    created_at timestamp
);
create table course_enrollments (
    enrollment_id integer,
    student_id integer,
    course_code text,
    semester text,
    unique (student_id, course_code, semester)
);
alter table users
add constraint unique_username unique (username);
alter table users
add constraint unique_email unique (email);
insert into users values (1, 'alice', 'alice@example.com', '2025-10-16 12:00:00');
insert into users values (2, 'bob', 'bob@example.com', '2025-10-16 12:05:00');
insert into users values (3, 'alice', 'alice2@example.com', '2025-10-16 12:10:00');
insert into users values (4, 'charlie', 'bob@example.com', '2025-10-16 12:15:00');
create table departments (
    dept_id integer primary key,
    dept_name text not null,
    location text
);
insert into departments values (1, 'human resources', 'new york');
insert into departments values (2, 'finance', 'london');
insert into departments values (3, 'it', 'tokyo');
insert into departments values (1, 'marketing', 'paris');
insert into departments values (null, 'sales', 'berlin');
create table student_courses (
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    primary key (student_id, course_id)
);
/*
1. difference between unique and primary key
   - a primary key uniquely identifies each row in a table and automatically implies both uniqueness and not null.
   - a unique constraint also ensures that all values in a column (or group of columns) are unique,
     but unlike a primary key, it allows null values (unless explicitly set not null).
   - a table can have only one primary key but can have many unique constraints.

2. when to use a single-column vs. composite primary key
   - use a single-column primary key when one column (like id) can uniquely identify each record.
   - use a composite primary key when a single column alone cannot ensure uniqueness,
     but a combination of multiple columns together can (for example, student_id + course_id in enrollment tables).

3. why a table can have only one primary key but multiple unique constraints
   - the primary key defines the main unique identifier of a table — it is the table’s primary reference in relationships.
   - sql allows only one such definition to maintain data integrity and clarity in references.
   - unique constraints, however, can be applied to multiple columns to ensure other sets of data are also unique,
     but they do not serve as the main identifier like the primary key.
*/
create table employees_dept (
    emp_id integer primary key,
    emp_name text not null,
    dept_id integer references departments(dept_id),
    hire_date date
);
insert into employees_dept values (1, 'john doe', 1, '2025-01-10');
insert into employees_dept values (2, 'mary smith', 2, '2025-03-15');
insert into employees_dept values (3, 'alex kim', 3, '2025-06-20');

insert into employees_dept values (4, 'susan lee', 5, '2025-07-01');
create table authors (
    author_id integer primary key,
    author_name text not null,
    country text
);
create table publishers (
    publisher_id integer primary key,
    publisher_name text not null,
    city text
);
create table books (
    book_id integer primary key,
    title text not null,
    author_id integer references authors(author_id),
    publisher_id integer references publishers(publisher_id),
    publication_year integer,
    isbn text unique
);
insert into authors values (1, 'george orwell', 'united kingdom');
insert into authors values (2, 'j.k. rowling', 'united kingdom');
insert into authors values (3, 'mark twain', 'united states');

insert into publishers values (1, 'penguin books', 'london');
insert into publishers values (2, 'harpercollins', 'new york');
insert into publishers values (3, 'bloomsbury', 'london');

insert into books values (1, '1984', 1, 1, 1949, '9780451524935');
insert into books values (2, 'animal farm', 1, 1, 1945, '9780451526342');
insert into books values (3, 'harry potter and the philosopher''s stone', 2, 3, 1997, '9780747532699');
insert into books values (4, 'adventures of huckleberry finn', 3, 2, 1884, '9780061120084');
create table categories (
    category_id integer primary key,
    category_name text not null
);
create table products_fk (
    product_id integer primary key,
    product_name text not null,
    category_id integer references categories(category_id) on delete restrict
);
create table orders (
    order_id integer primary key,
    order_date date not null
);
create table order_items (
    item_id integer primary key,
    order_id integer references orders(order_id) on delete cascade,
    product_id integer references products_fk(product_id),
    quantity integer check (quantity > 0)
);
insert into categories values (1, 'electronics');
insert into categories values (2, 'books');
insert into products_fk values (1, 'laptop', 1);
insert into products_fk values (2, 'smartphone', 1);
insert into products_fk values (3, 'novel', 2);
insert into orders values (1, '2025-10-16');
insert into orders values (2, '2025-10-17');
insert into order_items values (1, 1, 1, 2);
insert into order_items values (2, 1, 2, 1);
insert into order_items values (3, 2, 3, 3);
delete from categories where category_id = 1;
delete from orders where order_id = 1;
-- case 1: delete from categories where category_id = 1;
-- fails because products_fk has rows referencing category_id = 1.
-- ON DELETE RESTRICT prevents deletion while dependent rows exist.

-- case 2: delete from orders where order_id = 1;
-- succeeds, and all rows in order_items with order_id = 1
-- are automatically deleted due to ON DELETE CASCADE behavior.
DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

create table customers (
    customer_id integer primary key,
    name text not null,
    email text not null unique,
    phone text,
    registration_date date not null
);
insert into customers values (1, 'john doe', 'john@example.com', '1234567890', '2025-01-01');
insert into customers values (2, 'mary smith', 'mary@example.com', '2345678901', '2025-02-10');
insert into customers values (3, 'alex kim', 'alex@example.com', '3456789012', '2025-03-15');
insert into customers values (4, 'susan lee', 'susan@example.com', '4567890123', '2025-04-20');
insert into customers values (5, 'david brown', 'david@example.com', '5678901234', '2025-05-25');
create table products (
    product_id integer primary key,
    name text not null,
    description text,
    price numeric not null check (price >= 0),
    stock_quantity integer not null check (stock_quantity >= 0)
);
insert into products values (1, 'laptop', 'high-performance laptop', 1200.00, 10);
insert into products values (2, 'mouse', 'wireless optical mouse', 25.99, 100);
insert into products values (3, 'keyboard', 'mechanical keyboard', 75.50, 50);
insert into products values (4, 'monitor', '24-inch hd monitor', 200.00, 30);
insert into products values (5, 'headphones', 'noise-cancelling headphones', 150.00, 20);
create table orders (
    order_id integer primary key,
    customer_id integer references customers(customer_id) on delete cascade,
    order_date date not null,
    total_amount numeric not null check (total_amount >= 0),
    status text not null check (status in ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);
insert into orders values (1, 1, '2025-06-01', 1225.99, 'pending');
insert into orders values (2, 2, '2025-06-05', 275.50, 'processing');
insert into orders values (3, 3, '2025-07-10', 200.00, 'shipped');
insert into orders values (4, 4, '2025-08-15', 150.00, 'delivered');
insert into orders values (5, 5, '2025-09-20', 2400.00, 'cancelled');
create table order_details (
    order_detail_id integer primary key,
    order_id integer references orders(order_id) on delete cascade,
    product_id integer references products(product_id),
    quantity integer not null check (quantity > 0),
    unit_price numeric not null check (unit_price >= 0)
);
insert into order_details values (1, 1, 1, 1, 1200.00);
insert into order_details values (2, 1, 2, 1, 25.99);
insert into order_details values (3, 2, 3, 2, 75.50);
insert into order_details values (4, 3, 4, 1, 200.00);
insert into order_details values (5, 4, 5, 1, 150.00);
insert into customers values (6, 'fake user', 'john@example.com', '6789012345', '2025-10-01');
insert into products values (6, 'usb cable', 'standard usb cable', -5.00, 50);
insert into products values (7, 'webcam', 'hd webcam', 80.00, -10);
insert into orders values (6, 1, '2025-10-05', 100.00, 'unknown');
insert into order_details values (6, 2, 1, 0, 1200.00);
delete from customers where customer_id = 1;