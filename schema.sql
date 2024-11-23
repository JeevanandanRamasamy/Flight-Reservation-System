CREATE DATABASE  IF NOT EXISTS `reservation_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `reservation_system`;
-- MySQL dump 10.13  Distrib 8.0.34, for macos13 (arm64)
--
-- Host: localhost    Database: reservation_system
-- ------------------------------------------------------
-- Server version	8.2.0

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
-- Table structure for table `Aircraft`
--

DROP TABLE IF EXISTS `Aircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Aircraft` (
  `registration` varchar(6) NOT NULL,
  `seats` int NOT NULL,
  `airline_id` char(2) NOT NULL,
  PRIMARY KEY (`registration`),
  KEY `airline_id` (`airline_id`),
  CONSTRAINT `aircraft_ibfk_1` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Aircraft`
--

LOCK TABLES `Aircraft` WRITE;
/*!40000 ALTER TABLE `Aircraft` DISABLE KEYS */;
INSERT INTO `Aircraft` VALUES ('N1010',200,'AA'),('N1111',120,'QF'),('N1112',999,'WN'),('N1212',190,'WN'),('N1313',240,'CX'),('N4444',160,'DL'),('N5555',220,'LH'),('N6666',130,'B6'),('N7777',250,'EK'),('N8888',170,'AS'),('N9999',300,'SQ');
/*!40000 ALTER TABLE `Aircraft` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Airline`
--

DROP TABLE IF EXISTS `Airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Airline` (
  `id` char(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Airline`
--

LOCK TABLES `Airline` WRITE;
/*!40000 ALTER TABLE `Airline` DISABLE KEYS */;
INSERT INTO `Airline` VALUES ('AA'),('AS'),('B6'),('CX'),('DL'),('EK'),('LH'),('QF'),('SQ'),('WN');
/*!40000 ALTER TABLE `Airline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Airport`
--

DROP TABLE IF EXISTS `Airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Airport` (
  `id` char(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Airport`
--

LOCK TABLES `Airport` WRITE;
/*!40000 ALTER TABLE `Airport` DISABLE KEYS */;
INSERT INTO `Airport` VALUES ('ATL'),('BOS'),('DFW'),('DXB'),('FRA'),('HKG'),('JFK'),('LAS'),('LAX'),('MCO'),('MIA'),('ORD'),('PHX'),('SEA'),('SFO'),('SIN'),('SYD');
/*!40000 ALTER TABLE `Airport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Associated_with`
--

DROP TABLE IF EXISTS `Associated_with`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Associated_with` (
  `airline_id` char(2) NOT NULL,
  `airport_id` char(3) NOT NULL,
  PRIMARY KEY (`airline_id`,`airport_id`),
  KEY `airport_id` (`airport_id`),
  CONSTRAINT `associated_with_ibfk_1` FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `associated_with_ibfk_2` FOREIGN KEY (`airport_id`) REFERENCES `Airport` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Associated_with`
--

LOCK TABLES `Associated_with` WRITE;
/*!40000 ALTER TABLE `Associated_with` DISABLE KEYS */;
/*!40000 ALTER TABLE `Associated_with` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cust_Ticket`
--

DROP TABLE IF EXISTS `Cust_Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cust_Ticket` (
  `ticket_num` int NOT NULL,
  `cust_id` int NOT NULL,
  `class` varchar(11) NOT NULL,
  `time_purchased` datetime NOT NULL,
  PRIMARY KEY (`ticket_num`,`cust_id`),
  KEY `cust_id` (`cust_id`),
  CONSTRAINT `cust_ticket_ibfk_1` FOREIGN KEY (`ticket_num`) REFERENCES `Ticket` (`num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cust_ticket_ibfk_2` FOREIGN KEY (`cust_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cust_Ticket`
--

LOCK TABLES `Cust_Ticket` WRITE;
/*!40000 ALTER TABLE `Cust_Ticket` DISABLE KEYS */;
INSERT INTO `Cust_Ticket` VALUES (2,4,'Business','2023-11-27 14:30:00'),(3,5,'Economy','2023-11-30 22:00:00'),(4,6,'First Class','2023-10-03 07:15:00'),(5,6,'Business','2023-11-17 12:30:00'),(6,6,'Economy','2023-11-20 18:45:00'),(8,4,'First Class','2023-11-12 08:00:00'),(9,5,'Economy','2023-12-02 20:15:00');
/*!40000 ALTER TABLE `Cust_Ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Flight`
--

DROP TABLE IF EXISTS `Flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Flight` (
  `num` int NOT NULL,
  `flight_type` varchar(13) NOT NULL,
  `registration` varchar(6) NOT NULL,
  `airline_id` char(2) NOT NULL,
  `dep_airport_id` char(3) NOT NULL,
  `dep_date` date NOT NULL,
  `dep_time` time DEFAULT NULL,
  `arr_airport_id` char(3) NOT NULL,
  `arr_date` date NOT NULL,
  `arr_time` time NOT NULL,
  `price` int NOT NULL,
  PRIMARY KEY (`num`,`airline_id`),
  KEY `registration` (`registration`),
  KEY `airline_id` (`airline_id`),
  KEY `dep_airport_id` (`dep_airport_id`),
  KEY `arr_airport_id` (`arr_airport_id`),
  CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`registration`) REFERENCES `Aircraft` (`registration`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `flight_ibfk_3` FOREIGN KEY (`dep_airport_id`) REFERENCES `Airport` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `flight_ibfk_4` FOREIGN KEY (`arr_airport_id`) REFERENCES `Airport` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flight`
--

LOCK TABLES `Flight` WRITE;
/*!40000 ALTER TABLE `Flight` DISABLE KEYS */;
INSERT INTO `Flight` VALUES (207,'Domestic','N4444','DL','ATL','2023-12-12','14:45:00','MIA','2023-12-12','17:30:00',280),(208,'International','N5555','LH','FRA','2023-12-15','18:30:00','ORD','2023-12-15','22:15:00',850),(209,'Domestic','N6666','B6','MIA','2023-12-18','08:15:00','MCO','2023-12-18','11:45:00',220),(210,'International','N7777','EK','MCO','2023-12-21','23:00:00','JFK','2023-12-22','06:30:00',1200),(211,'Domestic','N8888','AS','MCO','2023-12-25','12:30:00','SFO','2023-12-25','15:15:00',320),(212,'International','N9999','SQ','SIN','2023-12-28','06:00:00','LAX','2023-12-28','14:45:00',1100),(213,'Domestic','N1010','AA','LAX','2024-01-02','09:45:00','ORD','2024-01-02','12:30:00',260),(214,'International','N1111','QF','ORD','2024-01-05','20:00:00','SYD','2024-01-06','04:30:00',950),(215,'Domestic','N1212','WN','PHX','2024-01-08','07:30:00','LAS','2024-01-08','09:15:00',180),(216,'International','N1313','CX','LAS','2024-01-11','16:15:00','HKG','2024-01-12','00:45:00',1300),(217,'Domestic','N1111','QF','ORD','2024-01-12','12:52:00','LAS','2024-01-12','17:23:00',420),(218,'International','N1111','QF','SFO','2024-01-13','12:52:00','HKG','2024-01-14','17:23:00',1420),(219,'International','N1111','QF','LAX','2024-01-15','12:52:00','SYD','2024-01-16','17:23:00',1020),(220,'Domestic','N1212','WN','LAS','2024-01-15','12:52:00','JFK','2024-01-15','20:23:00',520),(221,'International','N1212','WN','LAS','2023-12-13','12:30:00','LAX','2023-12-18','03:03:00',999);
/*!40000 ALTER TABLE `Flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Operates_on`
--

DROP TABLE IF EXISTS `Operates_on`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Operates_on` (
  `flight_num` int NOT NULL,
  `weekday` varchar(9) NOT NULL,
  `airline_id` char(2) NOT NULL,
  PRIMARY KEY (`flight_num`,`airline_id`,`weekday`),
  KEY `weekday` (`weekday`),
  CONSTRAINT `operates_on_ibfk_1` FOREIGN KEY (`flight_num`, `airline_id`) REFERENCES `Flight` (`num`, `airline_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `operates_on_ibfk_2` FOREIGN KEY (`weekday`) REFERENCES `Weekday` (`weekday`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Operates_on`
--

LOCK TABLES `Operates_on` WRITE;
/*!40000 ALTER TABLE `Operates_on` DISABLE KEYS */;
/*!40000 ALTER TABLE `Operates_on` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Questions`
--

DROP TABLE IF EXISTS `Questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject` varchar(30) NOT NULL,
  `field` varchar(400) NOT NULL,
  `userid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Questions`
--

LOCK TABLES `Questions` WRITE;
/*!40000 ALTER TABLE `Questions` DISABLE KEYS */;
INSERT INTO `Questions` VALUES (1,'Hello','Test',1);
/*!40000 ALTER TABLE `Questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Replies`
--

DROP TABLE IF EXISTS `Replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Replies` (
  `id` int NOT NULL,
  `field` varchar(400) NOT NULL,
  `csrepid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `csrepid` (`csrepid`),
  CONSTRAINT `replies_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `replies_ibfk_2` FOREIGN KEY (`csrepid`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Replies`
--

LOCK TABLES `Replies` WRITE;
/*!40000 ALTER TABLE `Replies` DISABLE KEYS */;
/*!40000 ALTER TABLE `Replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ticket`
--

DROP TABLE IF EXISTS `Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ticket` (
  `num` int NOT NULL,
  `fare` float NOT NULL,
  `booking_fee` float NOT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket`
--

LOCK TABLES `Ticket` WRITE;
/*!40000 ALTER TABLE `Ticket` DISABLE KEYS */;
INSERT INTO `Ticket` VALUES (1,820,10),(2,850,15),(3,1420,12),(4,2310,10),(5,1480,20),(6,280,15),(7,680,15),(8,1740,15),(9,2120,15),(10,700,15);
/*!40000 ALTER TABLE `Ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ticket_Flight`
--

DROP TABLE IF EXISTS `Ticket_Flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ticket_Flight` (
  `ticket_num` int NOT NULL,
  `flight_num` int NOT NULL,
  `airline_id` char(2) NOT NULL,
  PRIMARY KEY (`ticket_num`,`flight_num`,`airline_id`),
  KEY `airline_id` (`airline_id`,`flight_num`),
  CONSTRAINT `ticket_flight_ibfk_1` FOREIGN KEY (`ticket_num`) REFERENCES `Ticket` (`num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ticket_flight_ibfk_2` FOREIGN KEY (`airline_id`, `flight_num`) REFERENCES `Flight` (`airline_id`, `num`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket_Flight`
--

LOCK TABLES `Ticket_Flight` WRITE;
/*!40000 ALTER TABLE `Ticket_Flight` DISABLE KEYS */;
INSERT INTO `Ticket_Flight` VALUES (4,213,'AA'),(7,213,'AA'),(1,211,'AS'),(8,211,'AS'),(1,209,'B6'),(3,209,'B6'),(5,216,'CX'),(1,207,'DL'),(6,207,'DL'),(3,210,'EK'),(2,208,'LH'),(4,214,'QF'),(7,217,'QF'),(8,218,'QF'),(9,219,'QF'),(4,212,'SQ'),(9,212,'SQ'),(5,215,'WN'),(10,215,'WN'),(10,220,'WN');
/*!40000 ALTER TABLE `Ticket_Flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `fname` varchar(30) NOT NULL,
  `lname` varchar(30) NOT NULL,
  `permission` varchar(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'csrep','1234','Jeeva','Ramasamy','customer'),(3,'admin','1234','333','1112','admin'),(4,'user','password','user','user','customer'),(5,'user2','password','John','Johnes','customer'),(6,'user3','password','James','James','customer'),(7,'Name','is','Hello','My','customer'),(8,'hi','hi','hi','hi','customer');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Waiting_list`
--

DROP TABLE IF EXISTS `Waiting_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Waiting_list` (
  `flight_num` int NOT NULL,
  `airline_id` char(2) NOT NULL,
  `cust_id` int NOT NULL,
  PRIMARY KEY (`flight_num`,`airline_id`,`cust_id`),
  KEY `cust_id` (`cust_id`),
  CONSTRAINT `waiting_list_ibfk_1` FOREIGN KEY (`flight_num`, `airline_id`) REFERENCES `Flight` (`num`, `airline_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `waiting_list_ibfk_2` FOREIGN KEY (`cust_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Waiting_list`
--

LOCK TABLES `Waiting_list` WRITE;
/*!40000 ALTER TABLE `Waiting_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `Waiting_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Weekday`
--

DROP TABLE IF EXISTS `Weekday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Weekday` (
  `weekday` varchar(9) NOT NULL,
  PRIMARY KEY (`weekday`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Weekday`
--

LOCK TABLES `Weekday` WRITE;
/*!40000 ALTER TABLE `Weekday` DISABLE KEYS */;
/*!40000 ALTER TABLE `Weekday` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-13 21:59:17
