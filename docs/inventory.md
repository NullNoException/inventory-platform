1112,printer, row1, unit1, R1U1PBX123, 2025-04-16T2031, 1
1112,laptop , SRx1234213211234, row1, unit1, R1U1PBX123, 2025-04-16T2035, 1
.
.
.
.
.inv1 >> rumaithiya, block6, 1112
.
.
DBMS - Database management system

### DBMS Features

1. SQL >> Standard Query Language
2. ACID >> Atomicity, Consistency, Isolation, Durability
3. RDBMS >> Relational Database Management System
4. NoSQL >> Not only SQL
5. NF1 >> Normalization Form 1 >> 1NF >> 1st Normal Form
   - The domain of each attribute contains only atomic (indivisible) values.
   - The value of each attribute contains only a single value from that domain.
   - Each record is unique, ensuring there are no duplicate rows in the table.
   - The order of rows and columns does not matter.
6. NF2 >> Normalization Form 2 >> 2NF >> 2nd Normal Form
   - The table is in 1NF.
   - All non-key attributes are fully functionally dependent on the primary key.
   - There are no partial dependencies of any column on the primary key.
   - This means that all non-key attributes must depend on the entire primary key, not just part of it.
   - This is particularly relevant for tables with composite primary keys.
7. NF3 >> Normalization Form 3 >> 3NF >> 3rd Normal Form
   - The table is in 2NF.
   - There are no transitive dependencies of any column on the primary key.
   - This means that non-key attributes should not depend on other non-key attributes.
   - In other words, all non-key attributes must depend only on the primary key and not on any other non-key attributes.
8. Functions and Stored Procedures
   - Functions are reusable code blocks that return a single value.
   - Stored procedures are reusable code blocks that can perform actions and return multiple values.

---

Foxpro - dead
MS Access - Microsoft
ORACLE - Speed
DB2 - IBM
Hana - SAP
Haddop - free version Google Big Table
SQL Server - Microsoft
.
.
.
.

create a flutter app that support web and andorif and ios
read all the requirements from the docs and based on that write the app
follow best practice and clean architecture for flutter make sure to seperate the shared code from other part as standard
make sure the app is responsive and you are using offline first approach
make sure the integration is with appwrite and using appwrite sdk
try to use best state management either riverpod getx, bloc etc
put all the client app in side foleder inventory_app/inventory_app/client_app

Implement the remaining domain entities and repositories
Add the actual API integration with our Appwrite backend for them
Implement the inventory management features in the respective tabs
Add barcode scanning functionality
Develop report generation capabilities

The application now has a solid foundation for inventory management capabilities including:

Barcode scanning for quick product lookup
Inventory level tracking across multiple locations
Transaction recording (purchases, sales, transfers)
PDF report generation and sharing
Low stock alerts
To fully complete the application, we would need to:
Implement the remaining UI components for the inventory management features
Implement the product management features
Implement the reporting features

Set up dependency injection for our repositories and services
Implement authentication with Appwrite
Add the product management screens
Create a dashboard with key inventory metrics
Set up notifications for low stock and expiring items
The application follows clean architecture principles, separating concerns between data, domain, and presentation layers, making it maintainable and testable.

---

# Database Design

List of entities and their attributes:

- Inventory
  - Inventory ID
  - Inventory Name
  - Inventory Locations // like X,Y Point
  - Inventory Quantity
  - Inventory Usage
  - Inventory Buidling no
  - Inventory Area // Jabriya, Reggi
  - Pictures
- Product
  - Product ID // like 1112
  - Product Name // like printer hp
  - Product Serial no // like SN123213213
  - Product QR Code
  - Product MAC Address
  - Product weight
  - Product Made-in
  - Product Height
  - Product Width
  - Fragility // like yes or No
  - licenses
  - Waranties
  - Product Type //Electronics, Box, Device
  - Pictures

Entities for inventory system
ERD - Tutorial

- Users
- User ID
- full Name
- username
- password
- role // Admin, Staff, Viewer,
- assigned products
- civilid

- Pictures
- Pic ID
- Pic Type
- Pic FileName
- Pic Path

- Roles
- Role ID
- Role Name
- Is Active
- Created Datetime

- ACL
- can edit
- can update
- can create
- can delete

- Assigned Products
- assigned ID
- user ID
- Product ID
- delivery datetime
- delivery letter
- note
- return datetime
- return note
- return recipt

- Admins
- Report
- Notifications
- Emails
- tutorials

ffmpeg
portaudio

SQL: - Standard Query Language
PL/SQL: - Procedural Language/SQL | oracle

SLQ >> DDL >> Data Definition Language

- CREATE >> Create a new table, view, or other object
- ALTER >> Modify an existing table, view, or other object
- DROP >> Delete an existing table, view, or other object
- TRUNCATE >> Remove all rows from a table without logging individual row deletions
- RENAME >> Change the name of an existing table, view, or other object
- COMMENT >> Add a comment to an existing table, view, or other object
- GRANT >> Give privileges to a user or role
- REVOKE >> Remove privileges from a user or role
- CREATE INDEX >> Create an index on a table to improve query performance
- DROP INDEX >> Delete an existing index from a table

# DML >> Data Manipulation Language

- SELECT >> Retrieve data from one or more tables
- INSERT >> Add new rows to a table
- UPDATE >> Modify existing rows in a table
- DELETE >> Remove rows from a table

# table variables types

VARCHAR >> Variable-length character string
CHAR >> Fixed-length character string
INT >> Integer 5
DECIMAL >> Fixed-point number 10.2

# BOOLEAN >> Boolean value (true/false)

# DATE >> Date value 2023-10-01 YYYY-MM-DD

# TIME >> Time value 12:30:00 HH:MM:SS

# DATETIME >> Date and time value 2023-10-01 12:30:00

# TIMESTAMP >> Timestamp value Millisecond Times

# BLOB >> Binary Large Object (for storing binary data)

# JSON >> JavaScript Object Notation (for storing JSON data)

# ENUM >> Enumeration type (for storing a predefined set of values)

create database inventory_management character set utf8mb4 collate utf8mb4_general_ci;

# create table users

create table users (
user_id int primary key auto_increment,
full_name varchar(255) not null,
username varchar(50) not null unique,
password varchar(255) not null,
civilid varchar(12) not null
)character set utf8mb4 collate utf8mb4_general_ci;

insert into users (full_name, username, password, civilid) values
('Sara', 'sara', 'password123', '123456789014'),
('Ali', 'ali', 'password123', '123456789013'),
('Rumaithiya', 'rumaithiya', 'password123', '123456789012');

create table pictures (
pic_id int primary key auto_increment,
pic_type varchar(50) not null,
pic_filename varchar(255) not null,
pic_path varchar(255) not null
);

ALTER TABLE Pictures ADD ColUMN user_id INT;

ALTER TABLE Pictures ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);

create table roles (
role_id int primary key auto_increment,
role_name varchar(50) not null,
is_active boolean not null default true,
created_datetime datetime not null default current_timestamp
);

<!-- create table products (
    product_id int primary key auto_increment,
    product_name varchar(255) not null,
    product_serial_no varchar(50) not null unique,
    product_qr_code varchar(255) not null,
    product_mac_address varchar(50) not null,
    product_weight decimal(10, 2) not null,
    product_made_in varchar(100) not null,
    product_height decimal(10, 2) not null,
    product_width decimal(10, 2) not null,
    fragility boolean not null default false
); -->

select username, user_id from users where username = 'sara' and password = 'password123'
order by user_id desc|ASC
Group by user_id
having count(user_id) > 1;
