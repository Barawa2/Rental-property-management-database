USE propertymanagementdatabase;


INSERT INTO client_types(type_name) VALUES 
('Tenant'),
('Landlord');

DESCRIBE property_categories;
INSERT INTO property_categories(category_name,category_description) VALUES
('Apartment Building','Multi-unit residential building'),
('Standalone House','Single residential house'),
('Commercial Property','Office or retail space'),
('Mixed Use','Properties with both residential and commercial spaces');

DESCRIBE unit_types;
INSERT INTO unit_types(unit_type_name) VALUES
('Studio'),
('1 bedroom'),
('2 bedroom');

INSERT INTO unit_types (unit_type_name) VALUES
('Retail Shop'),
('Office'),
('Restaurant');

DESCRIBE roles;
INSERT INTO roles (role_name,role_description) VALUES
('Property manager','Oversees property operations'),
('Accountant','Handles rent payments and financial records'),
('Maintenance Officer','Handles maintenance requests and repairs');

DESCRIBE clients;
INSERT INTO clients(company_name, client_first_name, client_last_name, client_type_id, phone_number, client_email) VALUES 
(NULL, 'Amina','Mohammed',1,'0700000000', 'amina@yahoo.com'),
(NULL, 'Kamau','Nyumba',1,'0711111110', 'knyumba@gmail.com'),
('Baringo Holdings',NULL, NULL,2,'07333333332','info@baringoholdings.com'),
(NULL, 'jojo', 'janji', 2,'0722222221','jj2@gmail.com'),
('Sisi Limited',NULL, NULL, 1,'0755555553','tuchati@sisilimited.com');

DESCRIBE security_deposit_returns;
INSERT INTO security_deposit_returns(lease_id, return_date, deposit_amount, amount_returned, deduction_reason, return_status) VALUES
(4,'2023-08-30', 30000, 30000, NULL, 'Processed'),
(5,'2026-01-19',15000, 'Wall repainting minor plumbing repairs', DEFAULT),
(6,'2023-04-01',20000, 'Pending move out inspection', DEFAULT);

SELECT  *
FROM security_deposit_returns;

DESCRIBE staff_details;
INSERT INTO staff_details(first_name, last_name, phone_number, email, hire_date) VALUES
('Ari','Ochieng','07444444448','ari@propagency.com','2020-02-15'),
('Lilian','Bria','07333333331','bria@propagency.com','2021-01-10'),
('Sari','Oni','071221122112','sario@propagency.com','2020-10-30');

DESCRIBE staff_roles;
INSERT INTO staff_roles (staff_id, role_id) VALUES
(1,1),
(2,2),
(2,3);

DESCRIBE properties;
INSERT INTO properties(property_name, property_category_id, county, location, latitude, longitude, landlord_id) VALUES
('Starling Apartment',1,'Marsabit','Karare',2.36809,37.82617,3),
('Kali Heights',3,'Kericho','Tuwan',1.03012,34.98580,1),
('Canali',2,'Tharake-Nithi','Mwimbi', -0.11670,37.70315,2),
('Wemda', 4, 'Baringo','Mogotio',NULL, NULL,5);

DESCRIBE units;
INSERT INTO units(property_id, unit_number, unit_type_id, bedrooms, bathrooms) VALUES
(1, '2A', 3, 2, 2),
(1, '2B', 3, 2 ,2),
(3, 'Office-1', 8, NULL, 1),
(4, 'Shop-2', 7, NULL, NULL);

DESCRIBE leases;
INSERT INTO leases(unit_id, tenant_id, lease_signed_date, lease_start_date, lease_end_date, 
lease_term_months, monthly_rent, security_deposit_amount, rent_due_day, late_fee_amount) VALUES
(1, 1, '2022-07-12', '2022-07-24', '2023-07-24', 12, 30000, 30000, 5, 0),
(2, 2, '2023-01-01', '2023-01-01', NULL, NULL, 15000, 15000, 1, 1000),
(3, 1, '2021-03-10', '2021-03-30', NULL, NULL, 20000, 20000, 10,500);


DESCRIBE lease_payments;
INSERT INTO lease_payments(lease_id, payment_date, amount_paid, payment_type, payment_type, payment_method, transaction_reference,
paid_by) VALUES
(1, '2024-01-01', 30000, 'Security Deposit', 'Cash', NULL, 3),
(1, '2024-01-05', 30000, 'Rent', 'Mobile Money Transfer', 'AirtelMoney-AG987K63',2 ),
(2, '2022-02-03', 1000, 'Late Fee', 'Mobile Money Transfer', 'MPESA - TIK34R670', 1);

DESCRIBE maintenance_requests;
INSERT INTO maintenance_requests(unit_id, reported_by, reported_to_staff_id, date_reported, request_description, priority, request_status) VALUES
(1,1,3, '2023-02-02', 'Leaking kitchen sink', 'Medium', DEFAULT),
(2,2,1,'2026-05-12', 'Front door lock broken, security concern', 'High', 'Completed'),
(3,3,2, '2025-04-22', 'Air conditioning not cooling properly', 'Medium', 'In Progress');

DESCRIBE appointment_schedules;
INSERT INTO appointment_schedules(scheduled_date, client_id, staff_id, unit_id, appointment_type, meeting_notes) VALUES
('2026-02-21', 1, 3, 1, 'New Client', 'Initial meeting to discuss lease terms and property value'),
('2025-09-15',2, 1, 2, 'Maintenance', 'Inspection of leaking sink'),
('2025-11-07',3, 2, 3, 'Existing Client', 'Discuss lease renewal options');

DESCRIBE inspection_visits;
INSERT INTO inspection_visits(appointment_id, inspected_by, unit_id, date_inspected, items_damaged, inspection_report) VALUES
(1,3,1, '2024-03-10', 1, 'Minor paint chip on the kitchen wall. Otherwise excellent condition. Recommend touch-up paint'),
(3,3,3, '2025-04-19', 0,  'Property in excellent condition. No damages found'), 
(NULL,2,2, '2026-12-12', 1, 'Toilet cistern requires replacement');

DESCRIBE utility_bills;
INSERT INTO utility_bills(unit_id, lease_id, utility_type, billing_month, meter_reading_previous, meter_reading_current, units_consumed, bill_amount
) VALUES
(3, 4,'Electricity','2026-01-01', 11507, 11520, 13,1300),
(1, 6, 'Water','2025-02-01',450, 520, 70, 1800),
(3, 5, 'Garbage', '2026-01-01', NULL, NULL,NULL, 300);

