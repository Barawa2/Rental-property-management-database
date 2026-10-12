-- ============================================================
-- Sample (test) data for propertymanagementdatabase
-- Run AFTER propertymanagement_schema.sql, on an empty database.
--
-- Design notes
--  * No hardcoded IDs: each row is found by name/email and held in a
--    session variable, so AUTO_INCREMENT gaps cannot break the script.
--    Run the whole file in ONE session (File > Open SQL Script, then
--    Ctrl+Shift+Enter) so the variables survive between statements.
--  * Client types live in client_type_assignments (a client can be both
--    Tenant and Landlord). Clients are inserted first, then their types.
--  * Insert order respects foreign keys and the triggers:
--    properties need a Landlord assignment first.
--  * units.unit_status is NOT set here. The triggers on leases mark a
--    unit Occupied when an Active lease is inserted.
-- ============================================================
USE propertymanagementdatabase;

-- ---------- Reference data ----------
INSERT INTO client_types (type_name) VALUES
('Tenant'),
('Landlord');

INSERT INTO property_categories (category_name, category_description) VALUES
('Apartment Building', 'Multi-unit residential building'),
('Standalone House', 'Single residential house'),
('Commercial Property', 'Office or retail space'),
('Mixed Use', 'Combination of residential and commercial');

INSERT INTO unit_types (unit_type_name) VALUES
('Studio'),
('1 bedroom'),
('2 bedroom'),
('Retail Shop'),
('Office'),
('Restaurant');

INSERT INTO roles (role_name, role_description) VALUES
('Property manager', 'Oversees property operations'),
('Accountant', 'Handles rent payments and financial records'),
('Maintenance Officer', 'Handles maintenance requests and repairs');

SET @tenant_type   = (SELECT client_type_id FROM client_types WHERE type_name = 'Tenant');
SET @landlord_type = (SELECT client_type_id FROM client_types WHERE type_name = 'Landlord');

-- ---------- Clients and their types ----------
INSERT INTO clients (company_name, client_first_name, client_last_name, phone_number, client_email) VALUES
(NULL, 'Amina', 'Mohammed', '0700000000', 'amina@yahoo.com'),
(NULL, 'Kamau', 'Nyumba', '0711111110', 'knyumba@gmail.com'),
('Baringo Holdings', NULL, NULL, '07333333332', 'info@baringoholdings.com'),
(NULL, 'jojo', 'janji', '0722222221', 'jj2@gmail.com'),
('Sisi Limited', NULL, NULL, '0755555553', 'tuchati@sisilimited.com');

SET @amina   = (SELECT client_id FROM clients WHERE client_email = 'amina@yahoo.com');
SET @kamau   = (SELECT client_id FROM clients WHERE client_email = 'knyumba@gmail.com');
SET @baringo = (SELECT client_id FROM clients WHERE client_email = 'info@baringoholdings.com');
SET @jojo    = (SELECT client_id FROM clients WHERE client_email = 'jj2@gmail.com');
SET @sisi    = (SELECT client_id FROM clients WHERE client_email = 'tuchati@sisilimited.com');

INSERT INTO client_type_assignments (client_id, client_type_id) VALUES
(@amina,   @tenant_type),
(@kamau,   @tenant_type),
(@sisi,    @tenant_type),
(@baringo, @landlord_type),
(@jojo,    @landlord_type);

-- ---------- Staff and their roles ----------
INSERT INTO staff_details (first_name, last_name, phone_number, email, hire_date) VALUES
('Ari', 'Ochieng', '07444444448', 'ari@propagency.com', '2020-02-15'),
('Lilian', 'Bria', '07333333331', 'bria@propagency.com', '2021-01-10'),
('Sari', 'Oni', '071221122112', 'sario@propagency.com', '2020-10-30');

SET @ari    = (SELECT staff_id FROM staff_details WHERE email = 'ari@propagency.com');
SET @lilian = (SELECT staff_id FROM staff_details WHERE email = 'bria@propagency.com');
SET @sari   = (SELECT staff_id FROM staff_details WHERE email = 'sario@propagency.com');

SET @role_manager     = (SELECT role_id FROM roles WHERE role_name = 'Property manager');
SET @role_accountant  = (SELECT role_id FROM roles WHERE role_name = 'Accountant');
SET @role_maintenance = (SELECT role_id FROM roles WHERE role_name = 'Maintenance Officer');

-- Lilian holds two roles (one person, many roles) and Maintenance Officer is
-- held by two people (one role, many people), so this exercises both sides
-- of the many-to-many link.
INSERT INTO staff_roles (staff_id, role_id) VALUES
(@ari,    @role_manager),
(@lilian, @role_accountant),
(@lilian, @role_maintenance),
(@sari,   @role_maintenance);

-- ---------- Properties (each landlord must hold the Landlord type) ----------
SET @cat_apartment = (SELECT property_category_id FROM property_categories WHERE category_name = 'Apartment Building');
SET @cat_house     = (SELECT property_category_id FROM property_categories WHERE category_name = 'Standalone House');
SET @cat_commercial= (SELECT property_category_id FROM property_categories WHERE category_name = 'Commercial Property');
SET @cat_mixed     = (SELECT property_category_id FROM property_categories WHERE category_name = 'Mixed Use');

INSERT INTO properties (property_name, property_category_id, county, location, latitude, longitude, landlord_id) VALUES
('Starling Apartment', @cat_apartment,  'Marsabit',      'Karare',  2.36809, 37.82617, @baringo),
('Kali Heights',       @cat_commercial, 'Kericho',       'Tuwan',   1.03012, 34.98580, @jojo),
('Canali',             @cat_house,      'Tharake-Nithi', 'Mwimbi', -0.11670, 37.70315, @jojo),
('Wemda',              @cat_mixed,      'Baringo',       'Mogotio', NULL,     NULL,     @baringo);

SET @p_starling = (SELECT property_id FROM properties WHERE property_name = 'Starling Apartment');
SET @p_canali   = (SELECT property_id FROM properties WHERE property_name = 'Canali');
SET @p_wemda    = (SELECT property_id FROM properties WHERE property_name = 'Wemda');

-- ---------- Units (status left to the lease triggers) ----------
SET @ut_2bed   = (SELECT unit_type_id FROM unit_types WHERE unit_type_name = '2 bedroom');
SET @ut_office = (SELECT unit_type_id FROM unit_types WHERE unit_type_name = 'Office');
SET @ut_shop   = (SELECT unit_type_id FROM unit_types WHERE unit_type_name = 'Retail Shop');

INSERT INTO units (property_id, unit_number, unit_type_id, bedrooms, bathrooms) VALUES
(@p_starling, '2A',       @ut_2bed,   2,    2),
(@p_starling, '2B',       @ut_2bed,   2,    2),
(@p_canali,   'Office-1', @ut_office, NULL, 1),
(@p_wemda,    'Shop-2',   @ut_shop,   NULL, NULL);

SET @u_2a      = (SELECT unit_id FROM units WHERE unit_number = '2A');
SET @u_2b      = (SELECT unit_id FROM units WHERE unit_number = '2B');
SET @u_office1 = (SELECT unit_id FROM units WHERE unit_number = 'Office-1');

-- ---------- Leases ----------
-- Lease on 2A ended on its end date (Expired). The Active leases below
-- have no end date, so the daily expiry event leaves them alone, and the
-- insert trigger marks 2B and Office-1 as Occupied.
INSERT INTO leases (unit_id, tenant_id, lease_signed_date, lease_start_date, lease_end_date,
                    lease_term_months, monthly_rent, security_deposit_amount, rent_due_day,
                    late_fee_amount, lease_status) VALUES
(@u_2a,      @amina, '2022-07-12', '2022-07-24', '2023-07-24', 12,   30000, 30000, 5,  0,    'Expired'),
(@u_2b,      @kamau, '2023-01-01', '2023-01-01', NULL,         NULL, 15000, 15000, 1,  1000, 'Active'),
(@u_office1, @amina, '2021-03-10', '2021-03-30', NULL,         NULL, 20000, 20000, 10, 500,  'Active');

SET @lease_a = (SELECT lease_id FROM leases WHERE unit_id = @u_2a);
SET @lease_b = (SELECT lease_id FROM leases WHERE unit_id = @u_2b);
SET @lease_c = (SELECT lease_id FROM leases WHERE unit_id = @u_office1);

-- ---------- Payments (paid by the lease's tenant, dated within the lease) ----------
-- Cash payments carry no transaction reference; mobile money payments must.
INSERT INTO lease_payments (lease_id, payment_date, amount_paid, payment_type, payment_method,
                            transaction_reference, paid_by, payment_status) VALUES
(@lease_a, '2022-07-12 10:00:00', 30000, 'Security Deposit', 'Cash',                  NULL,                  @amina, 'Completed'),
(@lease_a, '2022-08-05 09:30:00', 30000, 'Rent',             'Mobile Money Transfer', 'AirtelMoney-AG987K63', @amina, 'Completed'),
(@lease_b, '2023-02-03 14:15:00', 1000,  'Late Fee',         'Mobile Money Transfer', 'MPESA - TIK34R670',    @kamau, 'Completed');

-- ---------- Security deposit returns (only for the lease that has ended) ----------
INSERT INTO security_deposit_returns (lease_id, return_date, deposit_amount, amount_returned,
                                      deduction_reason, return_status) VALUES
(@lease_a, '2023-08-30', 30000, 30000, NULL, 'Processed');

-- ---------- Maintenance requests ----------
INSERT INTO maintenance_requests (unit_id, reported_by, reported_to_staff_id, date_reported,
                                  request_description, priority, request_status, resolution_notes) VALUES
(@u_2a,      @amina, @sari, '2023-02-02', 'Leaking kitchen sink',                        'Medium', 'Completed',   'Replaced worn tap washer'),
(@u_2b,      @kamau, @ari,  '2026-05-12', 'Front door lock broken, security concern',    'High',   'Completed',   'Lock replaced and tested'),
(@u_office1, @amina, @sari, '2025-04-22', 'Air conditioning not cooling properly',       'Medium', 'In Progress', NULL);

-- ---------- Appointments ----------
INSERT INTO appointment_schedules (scheduled_date, client_id, staff_id, unit_id, appointment_type,
                                   meeting_notes, appointment_status) VALUES
('2022-07-05 09:00:00', @amina, @sari,   @u_2a,      'New Client',      'Initial meeting to discuss lease terms and property value', 'Completed'),
('2023-02-03 10:00:00', @amina, @ari,    @u_2a,      'Maintenance',     'Inspection of leaking sink',                               'Completed'),
('2025-11-07 11:00:00', @amina, @lilian, @u_office1, 'Existing Client', 'Discuss lease renewal options',                            'Completed');

SET @appt_sink = (SELECT appointment_id FROM appointment_schedules WHERE meeting_notes = 'Inspection of leaking sink');

-- ---------- Inspection visits ----------
INSERT INTO inspection_visits (appointment_id, inspected_by, unit_id, date_inspected,
                               items_damaged, inspection_report) VALUES
(@appt_sink, @sari,   @u_2a,      '2023-02-03', 1, 'Minor paint chip on the kitchen wall. Otherwise excellent condition. Recommend touch-up paint'),
(NULL,       @sari,   @u_office1, '2025-04-19', 0, 'Property in excellent condition. No damages found'),
(NULL,       @lilian, @u_2b,      '2026-05-14', 1, 'Toilet cistern requires replacement');

-- ---------- Utility bills (unit always matches the lease's unit) ----------
INSERT INTO utility_bills (unit_id, lease_id, utility_type, billing_month, meter_reading_previous,
                           meter_reading_current, units_consumed, bill_amount, bill_status) VALUES
(@u_office1, @lease_c, 'Electricity', '2026-01-01', 11507, 11520, 13,   1300, 'Pending'),
(@u_2b,      @lease_b, 'Water',       '2025-02-01', 450,   520,   70,   1800, 'Pending'),
(@u_office1, @lease_c, 'Garbage',     '2026-01-01', NULL,  NULL,  NULL, 300,  'Pending');

-- ---------- Quick checks (expected results in comments) ----------
-- 2B and Office-1 Occupied by the triggers; 2A and Shop-2 Vacant.
SELECT unit_number, unit_status FROM units ORDER BY unit_id;
-- 5 clients, each with exactly one type.
SELECT COUNT(*) AS clients_without_type
FROM clients c LEFT JOIN client_type_assignments cta ON c.client_id = cta.client_id
WHERE cta.client_id IS NULL;   -- expect 0
