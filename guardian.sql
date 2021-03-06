-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 23, 2020 at 08:36 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `guardian`
--

-- --------------------------------------------------------

--
-- Table structure for table `email_verification`
--

CREATE TABLE `email_verification` (
  `email_verification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `verification_key` varchar(2048) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `expires_on` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `email_verification`
--

INSERT INTO `email_verification` (`email_verification_id`, `user_id`, `verification_key`, `email_address`, `expires_on`) VALUES
(17, 45, '4YZi6W4F9SCMcXNI9Doxe', 'anjula@mailnd7.com', '2020-06-28'),
(18, 46, 'yKeiwu5C8UdMxkIfSppdL', 'childanjula@mailnd7.com', '2020-06-28');

--
-- Triggers `email_verification`
--
DELIMITER $$
CREATE TRIGGER `generate_expires_on_date` BEFORE INSERT ON `email_verification` FOR EACH ROW BEGIN
  SET NEW.expires_on = DATE_ADD(CURDATE(), INTERVAL 14 DAY);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `geofence`
--

CREATE TABLE `geofence` (
  `geofence_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `longitude` decimal(10,6) NOT NULL,
  `latitude` decimal(10,6) NOT NULL,
  `radius` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `location_record`
--

CREATE TABLE `location_record` (
  `location_record_id` int(11) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `longitude` decimal(10,6) NOT NULL,
  `latitude` decimal(10,6) NOT NULL,
  `child_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `location_record`
--

INSERT INTO `location_record` (`location_record_id`, `timestamp`, `longitude`, `latitude`, `child_id`) VALUES
(12, '2020-06-22 12:30:00', '5.200000', '2.400000', 45),
(13, '2020-06-22 13:00:00', '7.200000', '2.400000', 44),
(14, '2020-06-22 13:30:00', '9.200000', '2.400000', 45);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset`
--

CREATE TABLE `password_reset` (
  `password_reset_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `reset_key` varchar(255) NOT NULL,
  `expires_on` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `password_reset`
--
DELIMITER $$
CREATE TRIGGER `generate_password_reset_expires_on_date` BEFORE INSERT ON `password_reset` FOR EACH ROW BEGIN
  SET NEW.expires_on = DATE_ADD(CURDATE(), INTERVAL 14 DAY);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `trusted_contact`
--

CREATE TABLE `trusted_contact` (
  `trusted_contact_id` int(11) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `first_name` varchar(63) NOT NULL,
  `last_name` varchar(63) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `relationship` varchar(63) NOT NULL,
  `parent_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('parent','child','admin','') NOT NULL DEFAULT 'parent',
  `first_name` varchar(63) NOT NULL,
  `last_name` varchar(63) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `email_address`, `password`, `role`, `first_name`, `last_name`, `address`, `phone_number`, `parent_id`, `active`) VALUES
(44, 'masilay376@lefaqr5.com', '$2b$10$eSVlw7JkMvlABOxECE8D5.vdIZquqjymGFRwvC6GsAJD0CopVaKB2', 'parent', 'Masilay', 'Swarey', '2359 Sampson Street', '071-0123456', NULL, 1),
(45, 'anjula@mailnd7.com', '$2b$10$oFNUQcAYJ1dk1tYF.miGIeGpbpsHPFsDFpCmIboZvTd4z2vX3IyZm', 'child', 'Tracy', 'Swarey', '2359 Sampson Street', '071-0123456', 44, 1),
(46, 'childanjula@mailnd7.com', '$2b$10$R2u1Iwqnh3vnbT1PoAiCyea/zK7im232h01wW4YN4NYzemKYrJ2EC', 'child', 'Tracy', 'Swarey', '2359 Sampson Street', '071-0123456', 45, 1),
(47, 'thechild@gmail.com', '$2b$10$no7CXz1lifkY59EOVdFPx.A4DT9naqaa32gtLl8ZrFOO3qn8HZMpO', 'child', 'Swarey', 'Junior', '2359 Sampson Street', '071-0123457', 44, 1),
(48, 'thecasdasdasdasdhild@gmail.com', '$2b$10$knfVv6IvEYuxiR0kozku8uK65i181UeYe80JECHdpursOYy1tIzWa', 'child', 'Swarey', 'Junior', '2359 Sampson Street', '071-0123457', 44, 1),
(49, 'thecasdasdasdasdhild@gmaisssssl.com', '$2b$10$KPaZVBSD1Lg2Udn2uqt5oupMqfuP/u4EmCx3WB7vSc5PgLgebHM6C', 'child', 'Swarey', 'Junior', '2359 Sampson Street', '071-0123457', 44, 1),
(50, 'thecadsdasdasdasdhild@gmaisssssl.com', '$2b$10$0dVwo73/pVTB5JJsEKW6m.ceZVck/RwSRkyEoLdrrtIUZFwSUckMG', 'child', 'Swarey', 'Junior', '2359 Sampson Street', '071-0123457', 44, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `email_verification`
--
ALTER TABLE `email_verification`
  ADD PRIMARY KEY (`email_verification_id`),
  ADD KEY `FK_email_verification_user_id` (`user_id`);

--
-- Indexes for table `geofence`
--
ALTER TABLE `geofence`
  ADD PRIMARY KEY (`geofence_id`),
  ADD KEY `FK_geofence_child_id` (`child_id`) USING BTREE;

--
-- Indexes for table `location_record`
--
ALTER TABLE `location_record`
  ADD PRIMARY KEY (`location_record_id`),
  ADD KEY `FK_location_record_child_id` (`child_id`);

--
-- Indexes for table `password_reset`
--
ALTER TABLE `password_reset`
  ADD PRIMARY KEY (`password_reset_id`),
  ADD KEY `FK_password_reset_user_id` (`user_id`);

--
-- Indexes for table `trusted_contact`
--
ALTER TABLE `trusted_contact`
  ADD PRIMARY KEY (`trusted_contact_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `FK_user_parent_id` (`parent_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `email_verification`
--
ALTER TABLE `email_verification`
  MODIFY `email_verification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `geofence`
--
ALTER TABLE `geofence`
  MODIFY `geofence_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `location_record`
--
ALTER TABLE `location_record`
  MODIFY `location_record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `password_reset`
--
ALTER TABLE `password_reset`
  MODIFY `password_reset_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `trusted_contact`
--
ALTER TABLE `trusted_contact`
  MODIFY `trusted_contact_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `email_verification`
--
ALTER TABLE `email_verification`
  ADD CONSTRAINT `FK_email_verification_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `geofence`
--
ALTER TABLE `geofence`
  ADD CONSTRAINT `FK_child_id` FOREIGN KEY (`child_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `location_record`
--
ALTER TABLE `location_record`
  ADD CONSTRAINT `FK_location_record_child_id` FOREIGN KEY (`child_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `password_reset`
--
ALTER TABLE `password_reset`
  ADD CONSTRAINT `FK_password_reset_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `trusted_contact`
--
ALTER TABLE `trusted_contact`
  ADD CONSTRAINT `FK_trusted_contact_parent_id` FOREIGN KEY (`trusted_contact_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `FK_user_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
