# Rental-property-management-database 
A MySQL rental property management database for tracking properties, units, clients, leases, payments, maintenance, Inspections and staff workflows.
The system is designed to support the day-to-day operations of a rental property business by storing and relating data about;
- properties & units
- landlords, tenants, and other clients
- lease agreements
- rent and security deposit payments
- utility bills
- maintenance requests
- inspection visits
- appointments
- staff members and staff roles

  The goal of the schema is not just to store data, but to reflect how rental management works in the real world while preserving historical accuracy and enforcing data integrity.

  ## Key design ideas
 -  **Clients are stored in a single `clients` table**  
    Instead of separating landlords and tenants into different tables, this system uses a `client_type_id` to classify each client. This makes the schema more flexible and       avoids duplicate person records.
-  **Payments are tied to leases, not just clients or units**  
    This preserves historical accuracy because financial obligations belong to the lease agreement.
  **Properties and units are separated**  
    A property can contain multiple units, which makes the design suitable for apartments, mixed-use buildings, and commercial properties.
   **The schema supports both residential and commercial scenarios**  
  Some unit attributes such as bedrooms and bathrooms can be `NULL` where they do not apply.
  **Open-ended leases are supported**  
    `lease_end_date` can be `NULL` for month-to-month or ongoing agreements.
  **Maintenance and inspections are treated as operational workflows**  
    The database includes tables for maintenance requests, appointment scheduling, and inspection visits.

## Main tables
Clients, client_types, properties, property_categories, units, unit_types, lease_payments, utility_bills, security deposit_returns, appointment_schedules, inspection_visits, maintenance_requests, staff_details, roles, staff_roles
  ## Relationships snapshot 

- One property can have many units
- One unit can have many leases over time
- One lease can have many payments
- One lease can have many utility bills
- Staff members can have multiple roles
- Maintenance requests and inspections are linked to operational activity in the system

## Business rules reflected in the schema

- a lease may be fixed-term or ongoing
- a unit can only be occupied by one active lease at a time
- child records must reference existing parent records
- maintenance requests default to a starting workflow status
- the same client table can represent both individuals and companies
  
## Files in this repository
- rental dabase system 2 – table creation scripts
- insertdata.sql – sample data inserts
- update rental property documentation – project documentation

## 🌩️ How to run the project

1. Create a new MySQL database
2. Run the table creation script (rental database system 2)
3. Run the insert script to populate sample data (insert data)
4. Use your SQL editor to test queries and inspect relationships

## Example use cases

This database can support workflows such as:

- registering a landlord and property
- adding units under a property
- onboarding a tenant through the `clients` table
- creating a lease for a unit
- recording rent, deposit, and late fee payments
- tracking maintenance requests from report to completion
- scheduling inspections and appointments
- recording utility charges for occupied units
- handling security deposit returns at lease end
  
## What I learned 📔

Through building this project, I explored:

- relational database design
- primary keys and foreign keys
- normalization and data integrity
- business rule modeling
- dependency order when inserting data
- handling edge cases such as open-ended leases, partial payments, and commercial units

## ✈️ Future improvements 

Possible next steps for this project:

- add triggers or stored procedures for automation
- add views for reporting
- track lease renewals more explicitly
- improve validation around payment and occupancy rules
- build a dashboard or frontend connected to the database

  This project is for learning, portfolio, and demonstration purposes.
If you like the project, Don't forget to leave a star ⭐.
