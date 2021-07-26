-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2021 at 09:20 PM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 8.0.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `supermarket`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `All workers and vehicles available for delivery` (IN `delivery_id` VARCHAR(9))  (SELECT DISTINCT ID,
 				 First_Name,
 				 Last_Name,
 				 Phone_Number,
 				 License,
 				 Id_vehicle AS `vehicle number`,
 				 Manufacturer,
 				 Model,
 				 Vehicle_type AS `Type`
FROM `shipping workers`  NATURAL JOIN ((SELECT *
							FROM `vehicles`
							WHERE `Cooling` >= (SELECT `Require_cooling`
				  								FROM `delievers`
				  								WHERE `Id_deliever` = delivery_id)) T)
WHERE `License` = T.`License_type`
ORDER BY T.`License_type`)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `branch with most deliveries` ()  SELECT COUNT(`delievers`.`Id_deliever`) AS `number of deliveries`, 
		`delievers`.`Area` 
FROM `delievers`
GROUP BY `delievers`.`Area` 
ORDER BY `number of deliveries` DESC
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `collision_of_deliveries-count` ()  select 
count(D1.Id_deliever) AS `number of collision`, 
D1.Area AS Area 
from delievers D1, delievers D2 
where 
	D1.Id_deliever <> D2.Id_deliever AND 
	D1.Area = D2.Area AND 
	D1.Order_shipping_time= D2.Order_shipping_time AND 
	D1.Start_shipping=D2.Start_shipping 
group by D1.Area$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `collision_of_deliveries-details` ()  select 
	D1.Id_deliever AS id1, 
	D1.Order_shipping_time AS date1, 
	D1.Start_shipping AS start1, 
	D1.End_shipping AS end1, 
	D2.Id_deliever AS id2, 
	D2.Order_shipping_time AS date2, 
	D2.Start_shipping AS start2, 
	D2.End_shipping AS end2 , 
	D1.Area AS Area 
from delievers D1, delievers D2 
where 
	D1.Id_deliever <> D2.Id_deliever AND 
	D1.Area = D2.Area AND 
	D1.Order_shipping_time= D2.Order_shipping_time AND 
	D1.Start_shipping=D2.Start_shipping 
group by D1.Area$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count workers by positions` ()  SELECT count(*) AS amount, position 
from worker 
group by position$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deliveries by branch` (IN `branch_name` VARCHAR(20))  SELECT * 
from delievers NATURAL JOIN branches
where `branches`.`location` = branch_name
		AND
        `branches`.`location` = `delievers`.`Area`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deliveries stats` ()  SELECT ROUND(AVG(`Deliever_fee`),3) AS `average price`,
		ROUND(SUM(`Deliever_fee`),3) AS `sum price`,
       ROUND( MAX(`Deliever_fee`),3) AS `max price`,
        ROUND(MIN(`Deliever_fee`),3) AS `min price`,
       ROUND(STDDEV(`Deliever_fee`),3) AS `price STD`
FROM `delievers`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `external-count of workers according to all positions` ()  SELECT COUNT(worker.ID) as num_employees,
worker.position as position
FROM worker
GROUP BY worker.position$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `external-count of workers per position` (IN `my_position` VARCHAR(20))  SELECT COUNT(*) as "number of workers", my_position
FROM worker
WHERE position=my_position$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `external-details of employees worker more than 160 hours` ()  SELECT worker.ID,
worker.First_Name,
worker.Last_Name,
positions.position_name,
positions.salary

FROM worker

INNER JOIN positions ON
worker.position=positions.position_name 

where positions.min_hours>160$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `FitVehiclesForDelivery` (IN `NeedCooling` VARCHAR(1))  SELECT *
FROM `vehicles`
WHERE Cooling >= NeedCooling$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAboveAvgDeliveries` ()  SELECT *
FROM `delievers`
WHERE `Deliever_fee` >= (SELECT AVG(`Deliever_fee`)
                         FROM `delievers`)      
      AND
      `Id_deliever` NOT IN (SELECT `Id_deliever`
                            FROM `deliever scheduling`)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDelivery` (IN `delivery_id` VARCHAR(9))  SELECT *
FROM `delievers`
WHERE Id_deliever = delivery_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `happy birthday` ()  SELECT `First_Name`,`Last_Name`,`Date_of_Birth` FROM `worker` WHERE MONTH(`Date_of_Birth`) = (SELECT MONTH((CAST(NOW() AS Date)))) AND DAY(`Date_of_Birth`) >= DAY(CAST(NOW() AS Date)) ORDER BY `Date_of_Birth`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `happy birthday by branches` ()  SELECT `worker`.`First_Name`,`worker`.`Last_Name`,`worker`.`Date_of_Birth`, `branches`.`location` AS `branch`
FROM `worker`, `branches`
WHERE MONTH(`Date_of_Birth`) = (SELECT MONTH((CAST(NOW() AS Date)))) AND DAY(`Date_of_Birth`) >= DAY(CAST(NOW() AS Date)) AND `worker`.`branch`=`branches`.`branch_id`
ORDER BY `Date_of_Birth`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `has A or C license` ()  SELECT * 
FROM `shipping workers`
WHERE
License = 'A' 
OR
License = 'C'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `most profitable branch in the last week` ()  SELECT ROUND(SUM(`delievers`.`Deliever_fee`), 2) AS `most profitable`, `deliever scheduling`.`branch_id` 
from `deliever scheduling`, `delievers` 
where `delievers`.`Id_deliever` = `deliever scheduling`.`Id_deliever` 
		AND `Order_shipping_time` >(SELECT DATE_ADD(CAST(NOW() AS Date), INTERVAL -7 DAY))
Group by `deliever scheduling`.`branch_id`
ORDER BY `most profitable` DESC
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `need cooling but not scheduled` ()  SELECT * 
FROM `delievers`
 WHERE `Require_cooling` = 1 
AND
 `Id_deliever` NOT IN (SELECT `Id_deliever`
 FROM `deliever scheduling`)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `need_of_more_schedueling` ()  SELECT 
( 
    (
	(select count(Id_deliever) from `deliever scheduling`)
	+ 
	(select count(Id_deliever) from `finished deliveries`) 
	) 
	
    < 
	
    (select count(Id_deliever) from `delievers`) 
	
    
) AS `Do we need to schedule more deliveries?`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `number of COVID19 workers` ()  SELECT COUNT(*) AS `COVID-19 workers`
FROM `worker`
WHERE `Starting_Date` > '2020-03-09'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Number of deliveries and workers to area` ()  SELECT Area,
	   COUNT(Area) AS `Num of delvieries`,
       COUNT(id_worker) AS `Num of workers`
FROM `deliever scheduling` NATURAL JOIN `delievers`
GROUP BY Area$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `number of deliveries to area` ()  SELECT Area,COUNT(Id_deliever) AS count_deliever
FROM delievers GROUP BY Area$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `numbers of deliveries today` ()  SELECT COUNT(*) AS `Num_of_deliveries_today`
FROM `delievers` 
WHERE `Order_shipping_time` IN (SELECT (CAST(NOW() AS Date)))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `old deliveries not scheduled` ()  SELECT * 
FROM `delievers` 
WHERE `Order_create_time` < (SELECT DATE_ADD(CAST(NOW() AS Date), INTERVAL -7 DAY))
AND
`Id_deliever` NOT IN (SELECT `Id_deliever` FROM `deliever scheduling`)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profit by branch for last week` ()  SELECT ROUND(SUM(`delievers`.`Deliever_fee`), 2) AS profit, `deliever scheduling`.`branch_id` 
from `deliever scheduling`, `delievers` 
where `delievers`.`Id_deliever` = `deliever scheduling`.`Id_deliever` 
		AND `Order_shipping_time` >(SELECT DATE_ADD(CAST(NOW() AS Date), INTERVAL -7 DAY))
Group by `deliever scheduling`.`branch_id`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Total salary` ()  SELECT SUM(`salary`) "Total salary"
FROM `worker`, `positions`
WHERE `position` = `position_name`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `vehicles need maintenance` ()  SELECT *
FROM `vehicles`
WHERE `Last_care_vehicle` < (SELECT DATE_ADD(CAST(NOW() AS Date), INTERVAL -11 MONTH))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `worker with most deliveries` ()  SELECT count(`deliever scheduling`.`Id_deliever`) AS `number of deliveries`, `worker`.`ID`, `worker`.`First_Name`, `worker`.`Last_Name` FROM `deliever scheduling`, `worker` where `deliever scheduling`.`id_worker`=`worker`.`ID` 
GROUP BY `worker`.`ID`
ORDER BY `number of deliveries` DESC
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Worker's_deliveries` (IN `worker_id` VARCHAR(9))  SELECT *
FROM `deliever scheduling` NATURAL JOIN `delievers`
WHERE `deliever scheduling`.`id_worker` = `worker_id`$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `branch_id` tinyint(1) NOT NULL,
  `location` varchar(20) NOT NULL,
  `num_of_employees` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`branch_id`, `location`, `num_of_employees`) VALUES
(1, 'Jerusalem', 11),
(2, 'Tel Aviv', 1),
(3, 'Beit Shemesh', 0),
(4, 'Beer Sheva', 2),
(5, 'Haifa', 3);

-- --------------------------------------------------------

--
-- Table structure for table `delievers`
--

CREATE TABLE `delievers` (
  `Id_deliever` varchar(9) NOT NULL,
  `Address_destination` varchar(20) NOT NULL,
  `Order_create_time` date NOT NULL,
  `Order_shipping_time` date NOT NULL,
  `Deliever_fee` float NOT NULL,
  `Area` varchar(20) NOT NULL,
  `Start_shipping` time NOT NULL DEFAULT current_timestamp(),
  `End_shipping` time NOT NULL,
  `Require_cooling` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `delievers`
--

INSERT INTO `delievers` (`Id_deliever`, `Address_destination`, `Order_create_time`, `Order_shipping_time`, `Deliever_fee`, `Area`, `Start_shipping`, `End_shipping`, `Require_cooling`) VALUES
('1000001', 'Nave Shaanan', '2020-11-02', '2021-05-26', 10.2, 'Jerusalem', '10:00:00', '13:00:00', 1),
('1000002', 'Old City', '2020-12-01', '2021-05-25', 1.1, 'Jerusalem', '10:00:00', '14:13:15', 0),
('1000003', 'Nave Zedek', '2021-02-02', '2021-02-08', 12.24, 'Tel Aviv', '10:00:00', '13:28:38', 1),
('1000004', 'Yosftal', '2020-10-06', '2020-10-12', 1.5, 'Beit Shemesh', '10:00:00', '19:30:16', 0),
('1000005', 'Har Hazofim', '2021-02-26', '2021-03-01', 3.6, 'Beer Sheva', '10:00:00', '13:00:00', 1),
('1000006', 'Ramat Aviv', '2021-03-02', '2021-03-03', 2.5, 'Tel Aviv', '07:36:44', '10:36:44', 0),
('1000007', 'Arnona', '2021-02-28', '2021-03-02', 11.87, 'Jerusalem', '08:36:44', '13:23:31', 1),
('1000008', 'Carmel', '2021-01-05', '2021-01-13', 0.2, 'Haifa', '08:03:30', '19:21:36', 1),
('1000009', 'Florentin', '2021-02-02', '2021-03-06', 26.98, 'Tel Aviv', '09:24:31', '14:14:39', 1),
('1000010', 'Hadar', '2021-03-01', '2021-03-02', 50, 'Haifa', '06:23:19', '21:05:31', 0),
('1000011', 'Har Nof', '2021-01-20', '2021-01-30', 1, 'Jerusalem', '07:00:15', '11:06:59', 1);

-- --------------------------------------------------------

--
-- Table structure for table `deliever scheduling`
--

CREATE TABLE `deliever scheduling` (
  `id_worker` varchar(9) NOT NULL,
  `Id_deliever` varchar(20) NOT NULL,
  `id_vehicle` varchar(20) NOT NULL,
  `branch_id` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `deliever scheduling`
--

INSERT INTO `deliever scheduling` (`id_worker`, `Id_deliever`, `id_vehicle`, `branch_id`) VALUES
('134679258', '1000011', '12365445', 1),
('789012345', '1000001', '2095980', 1),
('789012345', '1000002', '12144132', 1);

--
-- Triggers `deliever scheduling`
--
DELIMITER $$
CREATE TRIGGER `update_finished_deliveries` AFTER DELETE ON `deliever scheduling` FOR EACH ROW BEGIN
	insert into `finished deliveries` VALUES
    (OLD.`Id_deliever`,
     OLD.`id_vehicle`,
     OLD.`id_worker`);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `finished deliveries`
--

CREATE TABLE `finished deliveries` (
  `Id_deliever` varchar(20) NOT NULL,
  `id_vehicle` varchar(20) NOT NULL,
  `id_worker` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `finished deliveries`
--

INSERT INTO `finished deliveries` (`Id_deliever`, `id_vehicle`, `id_worker`) VALUES
('1000009', '8159533', '890123456');

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE `positions` (
  `position_name` varchar(20) NOT NULL,
  `min_hours` int(3) NOT NULL,
  `salary` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`position_name`, `min_hours`, `salary`) VALUES
('assistant_manager', 160, 19000),
('branch_manager', 200, 26000),
('cashier', 170, 10000),
('cleaner', 170, 8500),
('shipping', 100, 5000),
('stocker', 170, 9000);

-- --------------------------------------------------------

--
-- Stand-in structure for view `shipping workers`
-- (See below for the actual view)
--
CREATE TABLE `shipping workers` (
`ID` varchar(9)
,`First_Name` varchar(20)
,`Last_Name` varchar(20)
,`Phone_Number` varchar(12)
,`License` varchar(1)
,`Date_of_Birth` date
,`Starting_Date` date
,`branch` int(2)
,`email_address` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `Id_vehicle` varchar(10) NOT NULL,
  `Manufacturer` varchar(20) NOT NULL,
  `Model` varchar(20) NOT NULL,
  `Year_of_production` year(4) NOT NULL,
  `Vehicle_type` varchar(20) NOT NULL,
  `License_type` varchar(1) NOT NULL,
  `Cooling` tinyint(1) NOT NULL,
  `Entry_date` date NOT NULL,
  `Last_care_vehicle` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`Id_vehicle`, `Manufacturer`, `Model`, `Year_of_production`, `Vehicle_type`, `License_type`, `Cooling`, `Entry_date`, `Last_care_vehicle`) VALUES
('12144132', 'kia', 'picanto', 2015, 'car', 'B', 0, '2018-09-11', '2020-01-01'),
('12365445', 'hyundai', 'i20', 2019, 'car', 'B', 0, '2021-01-14', '2021-02-10'),
('1264888', 'isuzu', 'sumo', 2017, 'truck', 'C', 1, '2018-07-04', '2020-09-02'),
('12971682', 'kymco', 'g-dink', 2020, 'motorcycle', 'A', 0, '2020-01-14', '2021-02-10'),
('2095980', 'isuzu', 'sumo', 2016, 'truck', 'C', 1, '2017-07-04', '2020-09-08'),
('42960050', 'sanyang', 'XPRO', 2021, 'motorcycle', 'A', 0, '2021-03-06', '2021-03-06'),
('4340052', 'nissan', 'cabstar', 2017, 'truck', 'B', 1, '2017-08-16', '2021-02-01'),
('54116001', 'mercedes', 'sprinter519', 2018, 'LCV', 'B', 0, '2018-07-31', '2020-08-05'),
('8159533', 'yamaha', 'tricity', 2015, 'motorcycle', 'A', 0, '2015-07-04', '2021-02-10'),
('9126158', 'Hino', 'M5', 2020, 'truck', 'C', 1, '2021-03-01', '2021-03-01');

-- --------------------------------------------------------

--
-- Table structure for table `worker`
--

CREATE TABLE `worker` (
  `ID` varchar(9) NOT NULL,
  `First_Name` varchar(20) NOT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `Phone_Number` varchar(12) NOT NULL,
  `License` varchar(1) NOT NULL,
  `Date_of_Birth` date NOT NULL,
  `Starting_Date` date NOT NULL DEFAULT current_timestamp(),
  `position` varchar(20) NOT NULL,
  `branch` int(2) NOT NULL,
  `email_address` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `worker`
--

INSERT INTO `worker` (`ID`, `First_Name`, `Last_Name`, `Phone_Number`, `License`, `Date_of_Birth`, `Starting_Date`, `position`, `branch`, `email_address`) VALUES
('111111111', 'Reuven', 'Israeli', '0548974967', 'B', '2000-03-14', '2019-04-15', 'assistant_manager', 5, ''),
('123456788', 'david', 'cohen', '0504952521', '', '1996-10-10', '2021-06-09', 'stocker', 5, ''),
('123456789', 'Reuven', 'Israeli', '0548974967', 'C', '2000-03-14', '2020-03-14', 'shipping', 2, ''),
('134679258', 'Asher', 'Lau', '0582564973', 'B', '1999-03-27', '2021-02-23', 'shipping', 1, ''),
('206291544', 'Amihay', 'Hassan', '0529598108', 'B', '1995-07-31', '2021-06-09', 'branch_manager', 4, 'amihassan@gmail.com'),
('234567890', 'Shimon', 'Cohen', '0521234567', 'A', '1997-04-19', '2018-11-08', 'shipping', 1, ''),
('318260023', 'Zafrir', 'Fourrer', '0508642760', 'B', '1997-05-02', '2021-06-09', 'branch_manager', 5, 'zafrir97@gmail.com'),
('345678901', 'Levi', 'Kook', '0545908059', 'B', '1990-05-23', '2013-03-21', 'shipping', 1, ''),
('456789012', 'Yehuda', 'Levi', '0546229120', 'C', '1993-06-28', '2017-10-23', 'shipping', 1, ''),
('567890123', 'Isaschar', 'Drukman', '0597820864', 'A', '1987-07-03', '2010-01-29', 'shipping', 1, ''),
('643197816', 'Gad', 'Yosef', '0547707707', 'A', '1991-01-26', '2020-09-18', 'shipping', 1, ''),
('678901234', 'Zvulun', 'Bigon', '0545990584', 'B', '1999-08-07', '2019-12-14', 'shipping', 1, ''),
('789012345', 'Yosef', 'Tau', '0547629120', 'C', '2002-09-12', '2020-08-11', 'shipping', 1, ''),
('791346852', 'Naftali', 'Sadan', '0539876543', 'C', '1997-12-24', '2018-07-19', 'shipping', 1, ''),
('890123456', 'Binyamin', 'Lior', '0526298372', 'A', '1995-10-16', '2021-01-28', 'shipping', 1, ''),
('901234567', 'Dan', 'Kalner', '0552037357', 'B', '1989-11-21', '2011-09-10', 'shipping', 1, ''),
('953982456', 'Shlomo ', 'Zar', '052478954', 'B', '2018-06-14', '2021-04-05', 'stocker', 4, 'zar@gmail.com');

--
-- Triggers `worker`
--
DELIMITER $$
CREATE TRIGGER `update moving worker` AFTER UPDATE ON `worker` FOR EACH ROW UPDATE `branches`
SET `num_of_employees`=
(SELECT COUNT(`ID`)
FROM `worker`
WHERE `branch` = `branch_id`)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update new worker` AFTER INSERT ON `worker` FOR EACH ROW UPDATE `branches`
SET `num_of_employees`=
(SELECT COUNT(`ID`)
FROM `worker`
WHERE `branch` = `branch_id`)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update worker leaving` AFTER DELETE ON `worker` FOR EACH ROW UPDATE `branches`
SET `num_of_employees`=
(SELECT COUNT(`ID`)
FROM `worker`
WHERE `branch` = `branch_id`)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `shipping workers`
--
DROP TABLE IF EXISTS `shipping workers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `shipping workers`  AS SELECT `worker`.`ID` AS `ID`, `worker`.`First_Name` AS `First_Name`, `worker`.`Last_Name` AS `Last_Name`, `worker`.`Phone_Number` AS `Phone_Number`, `worker`.`License` AS `License`, `worker`.`Date_of_Birth` AS `Date_of_Birth`, `worker`.`Starting_Date` AS `Starting_Date`, `worker`.`branch` AS `branch`, `worker`.`email_address` AS `email_address` FROM `worker` WHERE `worker`.`position` = 'shipping' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indexes for table `delievers`
--
ALTER TABLE `delievers`
  ADD PRIMARY KEY (`Id_deliever`);

--
-- Indexes for table `deliever scheduling`
--
ALTER TABLE `deliever scheduling`
  ADD KEY `Worker_ID_Constraint` (`id_worker`) USING BTREE,
  ADD KEY `Delivery_ID_Constraint` (`Id_deliever`),
  ADD KEY `Vehicle_ID_Constraint` (`id_vehicle`);

--
-- Indexes for table `finished deliveries`
--
ALTER TABLE `finished deliveries`
  ADD KEY `Worker_ID_Constraint` (`id_worker`) USING BTREE,
  ADD KEY `Delivery_ID_Constraint` (`Id_deliever`),
  ADD KEY `Vehicle_ID_Constraint` (`id_vehicle`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`position_name`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`Id_vehicle`);

--
-- Indexes for table `worker`
--
ALTER TABLE `worker`
  ADD PRIMARY KEY (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
