-- appointment_schedules, clients, client_types, inspection_visits, leases, lease_payments, maintenance_requests, properties, 
-- property_categories, staff_details, staff_roles, units, utility bills,


DROP DATABASE IF EXISTS `propertymanagementdatabase`;
CREATE DATABASE propertymanagementdatabase;
USE propertymanagementdatabase;

DROP TABLE IF EXISTS appointment_schedules;
CREATE TABLE appointment_schedules (
appointment_id INT AUTO_INCREMENT PRIMARY KEY,
scheduled_date DATETIME NOT NULL,
client_id INT NOT NULL,
staff_id INT NOT NULL,
unit_id INT,
appointment_type ENUM('New Client','Existing Client','Maintenance','Inspection') NOT NULL,
meeting_notes VARCHAR(255),
appointment_status ENUM ('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
FOREIGN KEY (client_id) REFERENCES clients(client_id),
FOREIGN KEY (staff_id) REFERENCES staff_details(staff_id),
FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);


DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
client_id INT AUTO_INCREMENT PRIMARY KEY,
company_name VARCHAR(100),
client_first_name VARCHAR(50),
client_last_name VARCHAR(50),
client_type_id INT NOT NULL,
phone_number VARCHAR(20) NOT NULL,
client_email VARCHAR(100),
FOREIGN KEY (client_type_id) REFERENCES client_types(client_type_id),
CONSTRAINT check_name CHECK (company_name IS NOT NULL OR client_first_name IS NOT NULL AND client_last_name IS NOT NULL)
);

DROP TABLE IF EXISTS client_types;
CREATE TABLE client_types (
client_type_id INT AUTO_INCREMENT PRIMARY KEY,
type_name VARCHAR(30) NOT NULL UNIQUE -- tenant, landlord, 
);

DROP TABLE IF EXISTS inspection_visits;
CREATE TABLE inspection_visits (
inspection_id INT AUTO_INCREMENT PRIMARY KEY,
appointment_id INT,
inspected_by INT NOT NULL,
unit_id INT NOT NULL,
date_inspected DATE NOT NULL,
items_damaged INT DEFAULT NULL,
inspection_report VARCHAR(255),
FOREIGN KEY (appointment_id) REFERENCES appointment_schedules (appointment_id),
FOREIGN KEY (inspected_by) REFERENCES staff_details(staff_id),
FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);


DROP TABLE IF EXISTS leases;
CREATE TABLE leases (
lease_id INT AUTO_INCREMENT PRIMARY KEY,
unit_id INT NOT NULL,
tenant_id INT NOT NULL,
lease_signed_date DATE NOT NULL,
lease_start_date DATE NOT NULL,
lease_end_date DATE NOT NULL,
lease_term_months INT DEFAULT NULL,
monthly_rent DECIMAL(10,2) NOT NULL,
security_deposit_amount DECIMAL(10,2) NOT NULL,
rent_due_day INT NOT NULL,
late_fee_amount DECIMAL(10,2) NOT NULL,
lease_status ENUM('Active','Terminated','Expired') NOT NULL DEFAULT 'Active',
FOREIGN KEY (unit_id) REFERENCES units(unit_id),
FOREIGN KEY (tenant_id) REFERENCES clients(client_id)
);


DROP TABLE IF EXISTS lease_payments;
CREATE TABLE lease_payments (
payment_id INT AUTO_INCREMENT PRIMARY KEY,
lease_id INT NOT NULL,
payment_date DATETIME NOT NULL,
amount_paid DECIMAL(10,2) NOT NULL,
payment_type ENUM('Rent','Security Deposit','Late Fee'),
payment_method ENUM('Cash','Mobile Money Transfer') NOT NULL,
transaction_reference VARCHAR(100) UNIQUE DEFAULT NULL,
paid_by INT,
payment_status ENUM('Completed','Pending','Cancelled')DEFAULT 'Completed',
FOREIGN KEY (lease_id) REFERENCES leases(lease_id),
FOREIGN KEY (paid_by) REFERENCES clients(client_id),
CONSTRAINT check_transaction_reference CHECK ((payment_method = 'Cash' AND transaction_reference IS NULL)
OR (payment_method = 'Cash' AND transaction_reference IS NOT NULL))
); 


DROP TABLE IF EXISTS maintenance_requests;
CREATE TABLE maintenance_requests (
request_id INT AUTO_INCREMENT PRIMARY KEY,
unit_id INT NOT NULL,
reported_by INT NOT NULL,
reported_to_staff_id INT NOT NULL,
date_reported DATETIME NOT NULL,
request_description VARCHAR(255) NOT NULL,
priority ENUM('Low','Medium','High'),
request_status ENUM('New','Awaiting Approval','In Progress','Completed','Cancelled')DEFAULT 'New',
due_date DATETIME,
resolution_notes VARCHAR(255),
FOREIGN KEY (unit_id) REFERENCES units(unit_id),
FOREIGN KEY (reported_by) REFERENCES clients(client_id),
FOREIGN KEY (reported_to_staff_id) REFERENCES staff_details(staff_id)
);

DROP TABLE IF EXISTS properties;
CREATE TABLE properties (
property_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
property_name VARCHAR(100) NOT NULL,
property_category_id INT NOT NULL,
county VARCHAR(50) NOT NULL,
location VARCHAR(100) NOT NULL,
latitude DECIMAL(9,6),
longitude DECIMAL(9,6),
landlord_id INT NOT NULL,
FOREIGN KEY (landlord_id) REFERENCES clients(client_id),
FOREIGN KEY (property_category_id) REFERENCES property_categories(property_category_id)
);	


DROP TABLE IF EXISTS property_categories;
CREATE TABLE property_categories (
property_category_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
category_name VARCHAR(50) NOT NULL UNIQUE,
category_description VARCHAR(255)
);

DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
role_id INT,
role_name VARCHAR(50) NOT NULL UNIQUE,
role_description TEXT
);

DROP TABLE IF EXISTS security_deposit_returns;
CREATE TABLE security_deposit_returns (
request_id INT AUTO_INCREMENT PRIMARY KEY,
lease_id INT NOT NULL,
return_date DATETIME NOT NULL,
deposit_amount DECIMAL(10,2) NOT NULL,
amount_returned DECIMAL(10,2),
deduction_reason VARCHAR(255),
return_status ENUM('Processed','Pending','Failed') DEFAULT 'Pending',
FOREIGN KEY (lease_id) REFERENCES  leases(lease_id)
);

DROP TABLE IF EXISTS staff_details;
CREATE TABLE staff_details (
staff_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
phone_number VARCHAR(20) NOT NULL,
email VARCHAR(100),
hire_date DATE NOT NULL,
status ENUM('Active','Inactive') DEFAULT 'Active'
);

DROP TABLE IF EXISTS staff_roles;
CREATE TABLE staff_roles (
staff_id INT,
role_id INT,
PRIMARY KEY (staff_id,role_id),
FOREIGN KEY (staff_id) REFERENCES staff_details(staff_id),
FOREIGN KEY (role_id) REFERENCES roles(role_id)
);


DROP TABLE IF EXISTS units;
CREATE TABLE units (
unit_id INT AUTO_INCREMENT PRIMARY KEY,
property_id INT NOT NULL,
unit_number VARCHAR(20) NOT NULL,
unit_type_id INT NOT NULL,
bedrooms INT DEFAULT NULL,
bathrooms INT DEFAULT NULL,
unit_status ENUM ('Vacant','Occupied','Under Maintenance') DEFAULT 'Vacant',
FOREIGN KEY (property_id) REFERENCES properties(property_id),
FOREIGN KEY (unit_type_id) REFERENCES unit_types(unit_type_id)
);


DROP TABLE IF EXISTS unit_types;
CREATE TABLE unit_types (
unit_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
unit_type_name VARCHAR(50) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS utility_bills;
CREATE TABLE utility_bills (
utility_bill_id INT AUTO_INCREMENT PRIMARY KEY,
unit_id INT NOT NULL,
lease_id INT NOT NULL,
utility_type ENUM ('Water','Electricity','Security','Garbage') NOT NULL,
billing_month DATE NOT NULL,
meter_reading_previous DECIMAL(10,2) DEFAULT NULL,
meter_reading_current DECIMAL(10,2) DEFAULT NULL,
units_consumed DECIMAL(10,2) DEFAULT NULL,
bill_amount DECIMAL(10,2) NOT NULL,
bill_status ENUM('Pending','Paid','Partially Paid') DEFAULT 'Pending',
FOREIGN KEY (unit_id) REFERENCES units(unit_id),
FOREIGN KEY (lease_id) REFERENCES leases(lease_id)
); 

SHOW TABLES;