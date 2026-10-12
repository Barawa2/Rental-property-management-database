-- ============================================================
-- Schema for propertymanagementdatabase (structure only, no data)
-- WARNING: this script DROPs and recreates every table. Run it only
-- on a new, empty database. Never run it on a database holding real data.
-- Then load the sample data with Insertdata.sql.
-- ============================================================
CREATE DATABASE  IF NOT EXISTS `propertymanagementdatabase` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `propertymanagementdatabase`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: propertymanagementdatabase
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointment_schedules`
--

DROP TABLE IF EXISTS `appointment_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment_schedules` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `scheduled_date` datetime NOT NULL,
  `client_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `unit_id` int DEFAULT NULL,
  `appointment_type` enum('New Client','Existing Client','Maintenance','Inspection') NOT NULL,
  `meeting_notes` varchar(255) DEFAULT NULL,
  `appointment_status` enum('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
  PRIMARY KEY (`appointment_id`),
  KEY `client_id` (`client_id`),
  KEY `staff_id` (`staff_id`),
  KEY `unit_id` (`unit_id`),
  CONSTRAINT `appointment_schedules_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`),
  CONSTRAINT `appointment_schedules_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff_details` (`staff_id`),
  CONSTRAINT `appointment_schedules_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_type_assignments`
--

DROP TABLE IF EXISTS `client_type_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_type_assignments` (
  `client_id` int NOT NULL,
  `client_type_id` int NOT NULL,
  PRIMARY KEY (`client_id`,`client_type_id`),
  KEY `client_type_id` (`client_type_id`),
  CONSTRAINT `client_type_assignments_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`),
  CONSTRAINT `client_type_assignments_ibfk_2` FOREIGN KEY (`client_type_id`) REFERENCES `client_types` (`client_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_cta_protect_landlord_update` BEFORE UPDATE ON `client_type_assignments` FOR EACH ROW BEGIN
    IF OLD.client_type_id = (SELECT client_type_id FROM client_types WHERE type_name = 'Landlord')
       AND (NEW.client_type_id <> OLD.client_type_id OR NEW.client_id <> OLD.client_id)
       AND EXISTS (SELECT 1 FROM properties WHERE landlord_id = OLD.client_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot change the Landlord type of a client who still owns properties';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_cta_protect_landlord_delete` BEFORE DELETE ON `client_type_assignments` FOR EACH ROW BEGIN
    IF OLD.client_type_id = (SELECT client_type_id FROM client_types WHERE type_name = 'Landlord')
       AND EXISTS (SELECT 1 FROM properties WHERE landlord_id = OLD.client_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot remove the Landlord type from a client who still owns properties';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `client_types`
--

DROP TABLE IF EXISTS `client_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_types` (
  `client_type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(30) NOT NULL,
  PRIMARY KEY (`client_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `client_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) DEFAULT NULL,
  `client_first_name` varchar(50) DEFAULT NULL,
  `client_last_name` varchar(50) DEFAULT NULL,
  `phone_number` varchar(20) NOT NULL,
  `client_email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`client_id`),
  CONSTRAINT `check_name` CHECK (((`company_name` is not null) or ((`client_first_name` is not null) and (`client_last_name` is not null))))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inspection_visits`
--

DROP TABLE IF EXISTS `inspection_visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspection_visits` (
  `inspection_id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int DEFAULT NULL,
  `inspected_by` int NOT NULL,
  `unit_id` int NOT NULL,
  `date_inspected` date NOT NULL,
  `items_damaged` int DEFAULT NULL,
  `inspection_report` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`inspection_id`),
  KEY `appointment_id` (`appointment_id`),
  KEY `inspected_by` (`inspected_by`),
  KEY `unit_id` (`unit_id`),
  CONSTRAINT `inspection_visits_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointment_schedules` (`appointment_id`),
  CONSTRAINT `inspection_visits_ibfk_2` FOREIGN KEY (`inspected_by`) REFERENCES `staff_details` (`staff_id`),
  CONSTRAINT `inspection_visits_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lease_payments`
--

DROP TABLE IF EXISTS `lease_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lease_payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `lease_id` int NOT NULL,
  `payment_date` datetime NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_type` enum('Rent','Security Deposit','Late Fee') DEFAULT NULL,
  `payment_method` enum('Cash','Mobile Money Transfer') NOT NULL,
  `transaction_reference` varchar(100) DEFAULT NULL,
  `paid_by` int DEFAULT NULL,
  `payment_status` enum('Completed','Pending','Cancelled') DEFAULT 'Completed',
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `transaction_reference` (`transaction_reference`),
  KEY `lease_id` (`lease_id`),
  KEY `paid_by` (`paid_by`),
  CONSTRAINT `lease_payments_ibfk_1` FOREIGN KEY (`lease_id`) REFERENCES `leases` (`lease_id`),
  CONSTRAINT `lease_payments_ibfk_2` FOREIGN KEY (`paid_by`) REFERENCES `clients` (`client_id`),
  CONSTRAINT `check_transaction_reference` CHECK ((((`payment_method` = _utf8mb4'Cash') and (`transaction_reference` is null)) or ((`payment_method` <> _utf8mb4'Cash') and (`transaction_reference` is not null))))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leases`
--

DROP TABLE IF EXISTS `leases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leases` (
  `lease_id` int NOT NULL AUTO_INCREMENT,
  `unit_id` int NOT NULL,
  `tenant_id` int NOT NULL,
  `lease_signed_date` date NOT NULL,
  `lease_start_date` date NOT NULL,
  `lease_end_date` date DEFAULT NULL,
  `lease_term_months` int DEFAULT NULL,
  `monthly_rent` decimal(10,2) NOT NULL,
  `security_deposit_amount` decimal(10,2) NOT NULL,
  `rent_due_day` int NOT NULL,
  `late_fee_amount` decimal(10,2) NOT NULL,
  `lease_status` enum('Active','Terminated','Expired') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`lease_id`),
  KEY `unit_id` (`unit_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `leases_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`),
  CONSTRAINT `leases_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `clients` (`client_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_leases_unit_status_insert` AFTER INSERT ON `leases` FOR EACH ROW BEGIN
    IF NEW.lease_status = 'Active' THEN
        UPDATE units SET unit_status = 'Occupied' WHERE unit_id = NEW.unit_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_leases_unit_status_update` AFTER UPDATE ON `leases` FOR EACH ROW BEGIN
    IF NEW.lease_status = 'Active' AND OLD.lease_status <> 'Active' THEN
        UPDATE units SET unit_status = 'Occupied' WHERE unit_id = NEW.unit_id;
    ELSEIF OLD.lease_status = 'Active' AND NEW.lease_status <> 'Active' THEN
        IF NOT EXISTS (SELECT 1 FROM leases
                       WHERE unit_id = OLD.unit_id AND lease_status = 'Active') THEN
            UPDATE units SET unit_status = 'Vacant'
            WHERE unit_id = OLD.unit_id AND unit_status = 'Occupied';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `maintenance_requests`
--

DROP TABLE IF EXISTS `maintenance_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `unit_id` int NOT NULL,
  `reported_by` int NOT NULL,
  `reported_to_staff_id` int NOT NULL,
  `date_reported` datetime NOT NULL,
  `request_description` varchar(255) NOT NULL,
  `priority` enum('Low','Medium','High') DEFAULT NULL,
  `request_status` enum('New','Awaiting Approval','In Progress','Completed','Cancelled') DEFAULT 'New',
  `due_date` datetime DEFAULT NULL,
  `resolution_notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `unit_id` (`unit_id`),
  KEY `reported_by` (`reported_by`),
  KEY `reported_to_staff_id` (`reported_to_staff_id`),
  CONSTRAINT `maintenance_requests_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`),
  CONSTRAINT `maintenance_requests_ibfk_2` FOREIGN KEY (`reported_by`) REFERENCES `clients` (`client_id`),
  CONSTRAINT `maintenance_requests_ibfk_3` FOREIGN KEY (`reported_to_staff_id`) REFERENCES `staff_details` (`staff_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `properties` (
  `property_id` int NOT NULL AUTO_INCREMENT,
  `property_name` varchar(100) NOT NULL,
  `property_category_id` int NOT NULL,
  `county` varchar(50) NOT NULL,
  `location` varchar(100) NOT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `landlord_id` int NOT NULL,
  PRIMARY KEY (`property_id`),
  KEY `landlord_id` (`landlord_id`),
  KEY `property_category_id` (`property_category_id`),
  CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`landlord_id`) REFERENCES `clients` (`client_id`),
  CONSTRAINT `properties_ibfk_2` FOREIGN KEY (`property_category_id`) REFERENCES `property_categories` (`property_category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_properties_landlord_insert` BEFORE INSERT ON `properties` FOR EACH ROW BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM client_type_assignments cta
        JOIN client_types ct ON cta.client_type_id = ct.client_type_id
        WHERE cta.client_id = NEW.landlord_id
          AND ct.type_name = 'Landlord'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'landlord_id must reference a client with the Landlord type';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_properties_landlord_update` BEFORE UPDATE ON `properties` FOR EACH ROW BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM client_type_assignments cta
        JOIN client_types ct ON cta.client_type_id = ct.client_type_id
        WHERE cta.client_id = NEW.landlord_id
          AND ct.type_name = 'Landlord'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'landlord_id must reference a client with the Landlord type';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `property_categories`
--

DROP TABLE IF EXISTS `property_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_categories` (
  `property_category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `category_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`property_category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `role_description` text,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `security_deposit_returns`
--

DROP TABLE IF EXISTS `security_deposit_returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_deposit_returns` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `lease_id` int NOT NULL,
  `return_date` datetime NOT NULL,
  `deposit_amount` decimal(10,2) NOT NULL,
  `amount_returned` decimal(10,2) DEFAULT NULL,
  `deduction_reason` varchar(255) DEFAULT NULL,
  `return_status` enum('Processed','Pending','Failed') DEFAULT 'Pending',
  PRIMARY KEY (`request_id`),
  KEY `lease_id` (`lease_id`),
  CONSTRAINT `security_deposit_returns_ibfk_1` FOREIGN KEY (`lease_id`) REFERENCES `leases` (`lease_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_details`
--

DROP TABLE IF EXISTS `staff_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_details` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `hire_date` date NOT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`staff_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_roles`
--

DROP TABLE IF EXISTS `staff_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_roles` (
  `staff_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`staff_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `staff_roles_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_details` (`staff_id`),
  CONSTRAINT `staff_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit_types`
--

DROP TABLE IF EXISTS `unit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_types` (
  `unit_type_id` int NOT NULL AUTO_INCREMENT,
  `unit_type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`unit_type_id`),
  UNIQUE KEY `unit_type_name` (`unit_type_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `unit_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `unit_number` varchar(20) NOT NULL,
  `unit_type_id` int NOT NULL,
  `unit_status` enum('Vacant','Occupied','Under Maintenance') DEFAULT 'Vacant',
  `bedrooms` int DEFAULT NULL,
  `bathrooms` int DEFAULT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `property_id` (`property_id`),
  KEY `unit_type_id` (`unit_type_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`),
  CONSTRAINT `units_ibfk_2` FOREIGN KEY (`unit_type_id`) REFERENCES `unit_types` (`unit_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `utility_bills`
--

DROP TABLE IF EXISTS `utility_bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utility_bills` (
  `utility_bill_id` int NOT NULL AUTO_INCREMENT,
  `unit_id` int NOT NULL,
  `lease_id` int NOT NULL,
  `utility_type` enum('Water','Electricity','Security','Garbage') NOT NULL,
  `billing_month` date NOT NULL,
  `meter_reading_previous` decimal(10,2) DEFAULT NULL,
  `meter_reading_current` decimal(10,2) DEFAULT NULL,
  `units_consumed` decimal(10,2) DEFAULT NULL,
  `bill_amount` decimal(10,2) NOT NULL,
  `bill_status` enum('Pending','Paid','Partially Paid') DEFAULT 'Pending',
  PRIMARY KEY (`utility_bill_id`),
  KEY `unit_id` (`unit_id`),
  KEY `lease_id` (`lease_id`),
  CONSTRAINT `utility_bills_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`),
  CONSTRAINT `utility_bills_ibfk_2` FOREIGN KEY (`lease_id`) REFERENCES `leases` (`lease_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_utility_bills_unit_insert` BEFORE INSERT ON `utility_bills` FOR EACH ROW BEGIN
    IF NEW.unit_id <> (SELECT unit_id FROM leases WHERE lease_id = NEW.lease_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'unit_id must match the unit of the lease';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_utility_bills_unit_update` BEFORE UPDATE ON `utility_bills` FOR EACH ROW BEGIN
    IF NEW.unit_id <> (SELECT unit_id FROM leases WHERE lease_id = NEW.lease_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'unit_id must match the unit of the lease';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'propertymanagementdatabase'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `ev_expire_leases` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `ev_expire_leases` ON SCHEDULE EVERY 1 DAY STARTS '2026-10-10 01:00:00' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Marks leases as Expired once their end date has passed' DO UPDATE leases
  SET lease_status = 'Expired'
  WHERE lease_status = 'Active'
    AND lease_end_date < CURDATE() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12  9:28:27
