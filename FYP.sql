-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (arm64)
--
-- Host: 127.0.0.1    Database: my_flask_db
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `activity_type` varchar(100) NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_activity_logs_user_id` (`user_id`),
  CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_activity_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (1,1,'Recycler','2024-07-23 14:25:44'),(2,1,'Recycler','2024-07-23 14:26:04'),(3,1,'Recycler','2024-07-23 14:29:42'),(4,1,'Daily Habit','2024-07-23 14:29:42'),(5,1,'Recycler','2024-07-23 14:29:57'),(6,2,'Challenge Champ','2024-07-23 15:32:10'),(7,2,'Daily Habit','2024-07-23 15:32:10'),(8,2,'Challenge Champ','2024-07-23 15:37:20'),(9,2,'Challenge Champ','2024-07-23 15:38:13'),(10,2,'Challenge Champ','2024-07-23 15:38:19'),(11,2,'Challenge Champ','2024-07-23 15:41:22'),(12,2,'Challenge Champ','2024-07-23 15:44:17'),(13,2,'Challenge Champ','2024-07-23 15:44:30'),(14,1,'Green Commuter','2024-07-24 02:19:31'),(15,1,'Green Commuter','2024-07-24 02:19:31'),(16,1,'Daily Habit','2024-07-24 02:19:31'),(17,1,'Daily Habit','2024-07-24 02:19:31'),(18,1,'Challenge Champ','2024-07-24 02:19:51'),(19,1,'Challenge Champ','2024-07-24 02:22:14'),(20,1,'Recycler','2024-07-24 02:25:38'),(21,4,'Green Commuter','2024-07-27 08:23:10'),(22,4,'Daily Habit','2024-07-27 08:23:10'),(23,4,'Green Commuter','2024-07-27 08:50:39'),(24,6,'Green Commuter','2024-07-29 10:19:54'),(25,6,'Daily Habit','2024-07-29 10:19:57'),(26,6,'Green Commuter','2024-07-29 10:34:19'),(27,1,'Green Commuter','2024-07-29 13:27:51'),(28,1,'Daily Habit','2024-07-29 13:27:52'),(29,1,'Green Commuter','2024-07-29 13:53:58'),(30,1,'Green Commuter','2024-07-29 15:24:10'),(31,1,'Recycler','2024-07-30 06:34:43'),(32,1,'Daily Habit','2024-07-30 06:34:43'),(33,1,'Recycler','2024-07-30 08:15:11'),(34,1,'Recycler','2024-07-30 08:22:08'),(35,1,'Recycler','2024-07-30 08:22:30'),(36,1,'Recycler','2024-07-31 09:33:19'),(37,1,'Daily Habit','2024-07-31 09:33:19'),(38,1,'Recycler','2024-07-31 09:33:26'),(39,1,'Challenge Champ','2024-07-31 09:40:35'),(40,1,'Green Commuter','2024-07-31 10:34:15'),(41,1,'Challenge Champ','2024-07-31 10:35:56'),(42,1,'Recycler','2024-07-31 10:37:13'),(43,1,'Recycler','2024-07-31 10:37:13');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `all_stations`
--

DROP TABLE IF EXISTS `all_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `all_stations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `station_name` varchar(255) NOT NULL,
  `line_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=376 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `all_stations`
--

LOCK TABLES `all_stations` WRITE;
/*!40000 ALTER TABLE `all_stations` DISABLE KEYS */;
INSERT INTO `all_stations` VALUES (1,'Gombak','LRT Kelana Jaya Line'),(2,'Taman Melati','LRT Kelana Jaya Line'),(3,'Wangsa Maju','LRT Kelana Jaya Line'),(4,'Sri Rampai','LRT Kelana Jaya Line'),(5,'Setiawangsa','LRT Kelana Jaya Line'),(6,'Jelatek','LRT Kelana Jaya Line'),(7,'Datuk Keramat','LRT Kelana Jaya Line'),(8,'Damai','LRT Kelana Jaya Line'),(9,'Ampang Park','LRT Kelana Jaya Line'),(10,'KLCC','LRT Kelana Jaya Line'),(11,'Kampung Baru','LRT Kelana Jaya Line'),(12,'Dang Wangi','LRT Kelana Jaya Line'),(13,'Masjid Jamek','LRT Kelana Jaya Line'),(14,'Pasar Seni','LRT Kelana Jaya Line'),(15,'KL Sentral','LRT Kelana Jaya Line'),(16,'Bangsar','LRT Kelana Jaya Line'),(17,'Abdullah Hukum','LRT Kelana Jaya Line'),(18,'Kerinchi','LRT Kelana Jaya Line'),(19,'Universiti','LRT Kelana Jaya Line'),(20,'Taman Jaya','LRT Kelana Jaya Line'),(21,'Asia Jaya','LRT Kelana Jaya Line'),(22,'Taman Paramount','LRT Kelana Jaya Line'),(23,'Taman Bahagia','LRT Kelana Jaya Line'),(24,'Kelana Jaya','LRT Kelana Jaya Line'),(25,'Lembah Subang','LRT Kelana Jaya Line'),(26,'Ara Damansara','LRT Kelana Jaya Line'),(27,'Subang Jaya','LRT Kelana Jaya Line'),(28,'SS15','LRT Kelana Jaya Line'),(29,'SS18','LRT Kelana Jaya Line'),(30,'USJ7','LRT Kelana Jaya Line'),(31,'Taipan','LRT Kelana Jaya Line'),(32,'Wawasan','LRT Kelana Jaya Line'),(33,'USJ21','LRT Kelana Jaya Line'),(34,'Alam Megah','LRT Kelana Jaya Line'),(35,'Subang Alam','LRT Kelana Jaya Line'),(36,'Putra Heights','LRT Kelana Jaya Line'),(37,'Gombak','LRT Kelana Jaya Line'),(38,'Taman Melati','LRT Kelana Jaya Line'),(39,'Wangsa Maju','LRT Kelana Jaya Line'),(40,'Sri Rampai','LRT Kelana Jaya Line'),(41,'Setiawangsa','LRT Kelana Jaya Line'),(42,'Jelatek','LRT Kelana Jaya Line'),(43,'Dato\' Keramat','LRT Kelana Jaya Line'),(44,'Damai','LRT Kelana Jaya Line'),(45,'Ampang Park','LRT Kelana Jaya Line'),(46,'KLCC','LRT Kelana Jaya Line'),(47,'Kampung Baru','LRT Kelana Jaya Line'),(48,'Dang Wangi','LRT Kelana Jaya Line'),(49,'Masjid Jamek','LRT Kelana Jaya Line'),(50,'Pasar Seni','LRT Kelana Jaya Line'),(51,'KL Sentral','LRT Kelana Jaya Line'),(52,'Bangsar','LRT Kelana Jaya Line'),(53,'Abdullah Hukum','LRT Kelana Jaya Line'),(54,'Kerinchi','LRT Kelana Jaya Line'),(55,'Universiti','LRT Kelana Jaya Line'),(56,'Taman Jaya','LRT Kelana Jaya Line'),(57,'Asia Jaya','LRT Kelana Jaya Line'),(58,'Taman Paramount','LRT Kelana Jaya Line'),(59,'Taman Bahagia','LRT Kelana Jaya Line'),(60,'Kelana Jaya','LRT Kelana Jaya Line'),(61,'Lembah Subang','LRT Kelana Jaya Line'),(62,'Ara Damansara','LRT Kelana Jaya Line'),(63,'Subang Jaya','LRT Kelana Jaya Line'),(64,'SS15','LRT Kelana Jaya Line'),(65,'SS18','LRT Kelana Jaya Line'),(66,'USJ7','LRT Kelana Jaya Line'),(67,'Taipan','LRT Kelana Jaya Line'),(68,'Wawasan','LRT Kelana Jaya Line'),(69,'USJ21','LRT Kelana Jaya Line'),(70,'Alam Megah','LRT Kelana Jaya Line'),(71,'Subang Alam','LRT Kelana Jaya Line'),(72,'Putra Heights','LRT Kelana Jaya Line'),(73,'Gombak','LRT Kelana Jaya Line'),(74,'Taman Melati','LRT Kelana Jaya Line'),(75,'Wangsa Maju','LRT Kelana Jaya Line'),(76,'Sri Rampai','LRT Kelana Jaya Line'),(77,'Setiawangsa','LRT Kelana Jaya Line'),(78,'Jelatek','LRT Kelana Jaya Line'),(79,'Dato\' Keramat','LRT Kelana Jaya Line'),(80,'Damai','LRT Kelana Jaya Line'),(81,'Ampang Park','LRT Kelana Jaya Line'),(82,'KLCC','LRT Kelana Jaya Line'),(83,'Kampung Baru','LRT Kelana Jaya Line'),(84,'Dang Wangi','LRT Kelana Jaya Line'),(85,'Masjid Jamek','LRT Kelana Jaya Line'),(86,'Pasar Seni','LRT Kelana Jaya Line'),(87,'KL Sentral','LRT Kelana Jaya Line'),(88,'Bangsar','LRT Kelana Jaya Line'),(89,'Abdullah Hukum','LRT Kelana Jaya Line'),(90,'Kerinchi','LRT Kelana Jaya Line'),(91,'Universiti','LRT Kelana Jaya Line'),(92,'Taman Jaya','LRT Kelana Jaya Line'),(93,'Asia Jaya','LRT Kelana Jaya Line'),(94,'Taman Paramount','LRT Kelana Jaya Line'),(95,'Taman Bahagia','LRT Kelana Jaya Line'),(96,'Kelana Jaya','LRT Kelana Jaya Line'),(97,'Lembah Subang','LRT Kelana Jaya Line'),(98,'Ara Damansara','LRT Kelana Jaya Line'),(99,'Subang Jaya','LRT Kelana Jaya Line'),(100,'SS15','LRT Kelana Jaya Line'),(101,'SS18','LRT Kelana Jaya Line'),(102,'USJ7','LRT Kelana Jaya Line'),(103,'Taipan','LRT Kelana Jaya Line'),(104,'Wawasan','LRT Kelana Jaya Line'),(105,'USJ21','LRT Kelana Jaya Line'),(106,'Alam Megah','LRT Kelana Jaya Line'),(107,'Subang Alam','LRT Kelana Jaya Line'),(108,'Putra Heights','LRT Kelana Jaya Line'),(109,'Sentul Timur','LRT Ampang Line'),(110,'Sentul','LRT Ampang Line'),(111,'Titiwangsa','LRT Ampang Line'),(112,'PWTC','LRT Ampang Line'),(113,'Sultan Ismail','LRT Ampang Line'),(114,'Masjid Jamek','LRT Ampang Line'),(115,'Plaza Rakyat','LRT Ampang Line'),(116,'Hang Tuah','LRT Ampang Line'),(117,'Pudu','LRT Ampang Line'),(118,'Chan Sow Lin','LRT Ampang Line'),(119,'Miharja','LRT Ampang Line'),(120,'Maluri','LRT Ampang Line'),(121,'Pandan Jaya','LRT Ampang Line'),(122,'Pandan Indah','LRT Ampang Line'),(123,'Cempaka','LRT Ampang Line'),(124,'Cahaya','LRT Ampang Line'),(125,'Ampang','LRT Ampang Line'),(126,'Sentul Timur','LRT Sri Petaling Line'),(127,'Sentul','LRT Sri Petaling Line'),(128,'Titiwangsa','LRT Sri Petaling Line'),(129,'PWTC','LRT Sri Petaling Line'),(130,'Sultan Ismail','LRT Sri Petaling Line'),(131,'Masjid Jamek','LRT Sri Petaling Line'),(132,'Plaza Rakyat','LRT Sri Petaling Line'),(133,'Hang Tuah','LRT Sri Petaling Line'),(134,'Maharajalela','LRT Sri Petaling Line'),(135,'Jalan Imbi','LRT Sri Petaling Line'),(136,'Bukit Bintang','LRT Sri Petaling Line'),(137,'Raja Chulan','LRT Sri Petaling Line'),(138,'Bukit Nanas','LRT Sri Petaling Line'),(139,'Dang Wangi','LRT Sri Petaling Line'),(140,'KLCC','LRT Sri Petaling Line'),(141,'Kampung Baru','LRT Sri Petaling Line'),(142,'Datuk Keramat','LRT Sri Petaling Line'),(143,'Damai','LRT Sri Petaling Line'),(144,'Ampang Park','LRT Sri Petaling Line'),(145,'KL Sentral','LRT Sri Petaling Line'),(146,'Abdullah Hukum','LRT Sri Petaling Line'),(147,'Kerinchi','LRT Sri Petaling Line'),(148,'Universiti','LRT Sri Petaling Line'),(149,'Taman Jaya','LRT Sri Petaling Line'),(150,'Asia Jaya','LRT Sri Petaling Line'),(151,'Taman Paramount','LRT Sri Petaling Line'),(152,'Taman Bahagia','LRT Sri Petaling Line'),(153,'Kelana Jaya','LRT Sri Petaling Line'),(154,'Lembah Subang','LRT Sri Petaling Line'),(155,'Ara Damansara','LRT Sri Petaling Line'),(156,'Subang Jaya','LRT Sri Petaling Line'),(157,'SS15','LRT Sri Petaling Line'),(158,'SS18','LRT Sri Petaling Line'),(159,'USJ7','LRT Sri Petaling Line'),(160,'Taipan','LRT Sri Petaling Line'),(161,'Wawasan','LRT Sri Petaling Line'),(162,'USJ21','LRT Sri Petaling Line'),(163,'Alam Megah','LRT Sri Petaling Line'),(164,'Subang Alam','LRT Sri Petaling Line'),(165,'Putra Heights','LRT Sri Petaling Line'),(166,'Sungai Buloh','MRT Kajang Line'),(167,'Kampung Selamat','MRT Kajang Line'),(168,'Kwasa Damansara','MRT Kajang Line'),(169,'Kwasa Sentral','MRT Kajang Line'),(170,'Kota Damansara','MRT Kajang Line'),(171,'Surian','MRT Kajang Line'),(172,'Mutiara Damansara','MRT Kajang Line'),(173,'Bandar Utama','MRT Kajang Line'),(174,'TTDI','MRT Kajang Line'),(175,'Phileo Damansara','MRT Kajang Line'),(176,'Pusat Bandar Damansara','MRT Kajang Line'),(177,'Semantan','MRT Kajang Line'),(178,'Muzium Negara','MRT Kajang Line'),(179,'Pasar Seni','MRT Kajang Line'),(180,'Merdeka','MRT Kajang Line'),(181,'Bukit Bintang','MRT Kajang Line'),(182,'Tun Razak Exchange','MRT Kajang Line'),(183,'Cochrane','MRT Kajang Line'),(184,'Maluri','MRT Kajang Line'),(185,'Taman Pertama','MRT Kajang Line'),(186,'Taman Midah','MRT Kajang Line'),(187,'Taman Mutiara','MRT Kajang Line'),(188,'Taman Connaught','MRT Kajang Line'),(189,'Taman Suntex','MRT Kajang Line'),(190,'Sri Raya','MRT Kajang Line'),(191,'Bandar Tun Hussein Onn','MRT Kajang Line'),(192,'Batu 11 Cheras','MRT Kajang Line'),(193,'Bukit Dukung','MRT Kajang Line'),(194,'Sungai Jernih','MRT Kajang Line'),(195,'Stadium Kajang','MRT Kajang Line'),(196,'Kajang','MRT Kajang Line'),(197,'Gombak','LRT Kelana Jaya Line'),(198,'Taman Melati','LRT Kelana Jaya Line'),(199,'Wangsa Maju','LRT Kelana Jaya Line'),(200,'Sri Rampai','LRT Kelana Jaya Line'),(201,'Setiawangsa','LRT Kelana Jaya Line'),(202,'Jelatek','LRT Kelana Jaya Line'),(203,'Dato\' Keramat','LRT Kelana Jaya Line'),(204,'Damai','LRT Kelana Jaya Line'),(205,'Ampang Park','LRT Kelana Jaya Line'),(206,'KLCC','LRT Kelana Jaya Line'),(207,'Kampung Baru','LRT Kelana Jaya Line'),(208,'Dang Wangi','LRT Kelana Jaya Line'),(209,'Masjid Jamek','LRT Kelana Jaya Line'),(210,'Pasar Seni','LRT Kelana Jaya Line'),(211,'KL Sentral','LRT Kelana Jaya Line'),(212,'Bangsar','LRT Kelana Jaya Line'),(213,'Abdullah Hukum','LRT Kelana Jaya Line'),(214,'Kerinchi','LRT Kelana Jaya Line'),(215,'Universiti','LRT Kelana Jaya Line'),(216,'Taman Jaya','LRT Kelana Jaya Line'),(217,'Asia Jaya','LRT Kelana Jaya Line'),(218,'Taman Paramount','LRT Kelana Jaya Line'),(219,'Taman Bahagia','LRT Kelana Jaya Line'),(220,'Kelana Jaya','LRT Kelana Jaya Line'),(221,'Lembah Subang','LRT Kelana Jaya Line'),(222,'Ara Damansara','LRT Kelana Jaya Line'),(223,'Subang Jaya','LRT Kelana Jaya Line'),(224,'SS15','LRT Kelana Jaya Line'),(225,'SS18','LRT Kelana Jaya Line'),(226,'USJ7','LRT Kelana Jaya Line'),(227,'Taipan','LRT Kelana Jaya Line'),(228,'Wawasan','LRT Kelana Jaya Line'),(229,'USJ21','LRT Kelana Jaya Line'),(230,'Alam Megah','LRT Kelana Jaya Line'),(231,'Subang Alam','LRT Kelana Jaya Line'),(232,'Putra Heights','LRT Kelana Jaya Line'),(233,'Sentul Timur','LRT Ampang Line'),(234,'Sentul','LRT Ampang Line'),(235,'Titiwangsa','LRT Ampang Line'),(236,'PWTC','LRT Ampang Line'),(237,'Sultan Ismail','LRT Ampang Line'),(238,'Masjid Jamek','LRT Ampang Line'),(239,'Plaza Rakyat','LRT Ampang Line'),(240,'Hang Tuah','LRT Ampang Line'),(241,'Pudu','LRT Ampang Line'),(242,'Chan Sow Lin','LRT Ampang Line'),(243,'Miharja','LRT Ampang Line'),(244,'Maluri','LRT Ampang Line'),(245,'Pandan Jaya','LRT Ampang Line'),(246,'Pandan Indah','LRT Ampang Line'),(247,'Cempaka','LRT Ampang Line'),(248,'Cahaya','LRT Ampang Line'),(249,'Ampang','LRT Ampang Line'),(250,'Sentul Timur','LRT Sri Petaling Line'),(251,'Sentul','LRT Sri Petaling Line'),(252,'Titiwangsa','LRT Sri Petaling Line'),(253,'PWTC','LRT Sri Petaling Line'),(254,'Sultan Ismail','LRT Sri Petaling Line'),(255,'Masjid Jamek','LRT Sri Petaling Line'),(256,'Plaza Rakyat','LRT Sri Petaling Line'),(257,'Hang Tuah','LRT Sri Petaling Line'),(258,'Maharajalela','LRT Sri Petaling Line'),(259,'Jalan Imbi','LRT Sri Petaling Line'),(260,'Bukit Bintang','LRT Sri Petaling Line'),(261,'Raja Chulan','LRT Sri Petaling Line'),(262,'Bukit Nanas','LRT Sri Petaling Line'),(263,'Dang Wangi','LRT Sri Petaling Line'),(264,'KLCC','LRT Sri Petaling Line'),(265,'Kampung Baru','LRT Sri Petaling Line'),(266,'Datuk Keramat','LRT Sri Petaling Line'),(267,'Damai','LRT Sri Petaling Line'),(268,'Ampang Park','LRT Sri Petaling Line'),(269,'KL Sentral','LRT Sri Petaling Line'),(270,'Abdullah Hukum','LRT Sri Petaling Line'),(271,'Kerinchi','LRT Sri Petaling Line'),(272,'Universiti','LRT Sri Petaling Line'),(273,'Taman Jaya','LRT Sri Petaling Line'),(274,'Asia Jaya','LRT Sri Petaling Line'),(275,'Taman Paramount','LRT Sri Petaling Line'),(276,'Taman Bahagia','LRT Sri Petaling Line'),(277,'Kelana Jaya','LRT Sri Petaling Line'),(278,'Lembah Subang','LRT Sri Petaling Line'),(279,'Ara Damansara','LRT Sri Petaling Line'),(280,'Subang Jaya','LRT Sri Petaling Line'),(281,'SS15','LRT Sri Petaling Line'),(282,'SS18','LRT Sri Petaling Line'),(283,'USJ7','LRT Sri Petaling Line'),(284,'Taipan','LRT Sri Petaling Line'),(285,'Wawasan','LRT Sri Petaling Line'),(286,'USJ21','LRT Sri Petaling Line'),(287,'Alam Megah','LRT Sri Petaling Line'),(288,'Subang Alam','LRT Sri Petaling Line'),(289,'Putra Heights','LRT Sri Petaling Line'),(290,'Sungai Buloh','MRT Kajang Line'),(291,'Kampung Selamat','MRT Kajang Line'),(292,'Kwasa Damansara','MRT Kajang Line'),(293,'Kwasa Sentral','MRT Kajang Line'),(294,'Kota Damansara','MRT Kajang Line'),(295,'Surian','MRT Kajang Line'),(296,'Mutiara Damansara','MRT Kajang Line'),(297,'Bandar Utama','MRT Kajang Line'),(298,'TTDI','MRT Kajang Line'),(299,'Phileo Damansara','MRT Kajang Line'),(300,'Pusat Bandar Damansara','MRT Kajang Line'),(301,'Semantan','MRT Kajang Line'),(302,'Muzium Negara','MRT Kajang Line'),(303,'Pasar Seni','MRT Kajang Line'),(304,'Merdeka','MRT Kajang Line'),(305,'Bukit Bintang','MRT Kajang Line'),(306,'Tun Razak Exchange','MRT Kajang Line'),(307,'Cochrane','MRT Kajang Line'),(308,'Maluri','MRT Kajang Line'),(309,'Taman Pertama','MRT Kajang Line'),(310,'Taman Midah','MRT Kajang Line'),(311,'Taman Mutiara','MRT Kajang Line'),(312,'Taman Connaught','MRT Kajang Line'),(313,'Taman Suntex','MRT Kajang Line'),(314,'Sri Raya','MRT Kajang Line'),(315,'Bandar Tun Hussein Onn','MRT Kajang Line'),(316,'Batu 11 Cheras','MRT Kajang Line'),(317,'Bukit Dukung','MRT Kajang Line'),(318,'Sungai Jernih','MRT Kajang Line'),(319,'Stadium Kajang','MRT Kajang Line'),(320,'Kajang','MRT Kajang Line'),(321,'Kwasa Damansara','MRT Putrajaya Line'),(322,'Kampung Selamat','MRT Putrajaya Line'),(323,'Sungai Buloh','MRT Putrajaya Line'),(324,'Damansara Damai','MRT Putrajaya Line'),(325,'Sri Damansara Barat','MRT Putrajaya Line'),(326,'Sri Damansara Sentral','MRT Putrajaya Line'),(327,'Sri Damansara Timur','MRT Putrajaya Line'),(328,'Metro Prima','MRT Putrajaya Line'),(329,'Kepong Baru','MRT Putrajaya Line'),(330,'Jinjang','MRT Putrajaya Line'),(331,'Sri Delima','MRT Putrajaya Line'),(332,'Kampung Batu','MRT Putrajaya Line'),(333,'Kentonmen','MRT Putrajaya Line'),(334,'Jalan Ipoh','MRT Putrajaya Line'),(335,'Sentul West','MRT Putrajaya Line'),(336,'Titiwangsa','MRT Putrajaya Line'),(337,'Hospital Kuala Lumpur','MRT Putrajaya Line'),(338,'Raja Uda','MRT Putrajaya Line'),(339,'Ampang Park','MRT Putrajaya Line'),(340,'Persiaran KLCC','MRT Putrajaya Line'),(341,'Conlay','MRT Putrajaya Line'),(342,'Tun Razak Exchange','MRT Putrajaya Line'),(343,'Chan Sow Lin','MRT Putrajaya Line'),(344,'Sungai Besi','MRT Putrajaya Line'),(345,'Taman Naga Emas','MRT Putrajaya Line'),(346,'Kuchai Lama','MRT Putrajaya Line'),(347,'Taman Salak Selatan','MRT Putrajaya Line'),(348,'Sungai Besi','MRT Putrajaya Line'),(349,'Serdang Raya Utara','MRT Putrajaya Line'),(350,'Serdang Raya Selatan','MRT Putrajaya Line'),(351,'Serdang Jaya','MRT Putrajaya Line'),(352,'UPM','MRT Putrajaya Line'),(353,'Taman Equine','MRT Putrajaya Line'),(354,'Putra Permai','MRT Putrajaya Line'),(355,'16 Sierra','MRT Putrajaya Line'),(356,'Cyberjaya Utara','MRT Putrajaya Line'),(357,'Cyberjaya City Centre','MRT Putrajaya Line'),(358,'Putrajaya Sentral','MRT Putrajaya Line'),(359,'KL Sentral','KL Monorail'),(360,'Tun Sambanthan','KL Monorail'),(361,'Maharajalela','KL Monorail'),(362,'Hang Tuah','KL Monorail'),(363,'Imbi','KL Monorail'),(364,'Bukit Bintang','KL Monorail'),(365,'Raja Chulan','KL Monorail'),(366,'Bukit Nanas','KL Monorail'),(367,'Medan Tuanku','KL Monorail'),(368,'Chow Kit','KL Monorail'),(369,'Titiwangsa','KL Monorail'),(370,'Setia Jaya','BRT Sunway Line'),(371,'Mentari','BRT Sunway Line'),(372,'Sunway Lagoon','BRT Sunway Line'),(373,'SunMed','BRT Sunway Line'),(374,'SunU-Monash','BRT Sunway Line'),(375,'South Quay-USJ 1','BRT Sunway Line');
/*!40000 ALTER TABLE `all_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `badges`
--

DROP TABLE IF EXISTS `badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `bronze_steps` int NOT NULL,
  `silver_steps` int NOT NULL,
  `gold_steps` int NOT NULL,
  `current_steps` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `level` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `how_to_attain` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_id` (`user_id`),
  CONSTRAINT `badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `badges`
--

LOCK TABLES `badges` WRITE;
/*!40000 ALTER TABLE `badges` DISABLE KEYS */;
INSERT INTO `badges` VALUES (1,'Daily Habit',10,20,30,5,1,'None',NULL,NULL),(2,'Green Commuter',10,20,30,7,1,'None',NULL,NULL),(3,'Challenge Champ',10,20,30,4,1,'None',NULL,NULL),(4,'Green Friend',10,20,30,0,1,'None',NULL,NULL),(5,'Recycler',10,20,30,15,1,'Bronze',NULL,NULL),(6,'Daily Habit',10,20,30,1,2,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(7,'Green Commuter',10,20,30,0,2,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(8,'Challenge Champ',10,20,30,7,2,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(9,'Green Friend',10,20,30,0,2,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(10,'Recycler',10,20,30,0,2,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'),(11,'Daily Habit',10,20,30,0,3,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(12,'Green Commuter',10,20,30,0,3,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(13,'Challenge Champ',10,20,30,0,3,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(14,'Green Friend',10,20,30,0,3,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(15,'Recycler',10,20,30,0,3,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'),(16,'Daily Habit',10,20,30,1,4,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(17,'Green Commuter',10,20,30,2,4,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(18,'Challenge Champ',10,20,30,0,4,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(19,'Green Friend',10,20,30,0,4,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(20,'Recycler',10,20,30,0,4,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'),(21,'Daily Habit',10,20,30,0,5,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(22,'Green Commuter',10,20,30,0,5,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(23,'Challenge Champ',10,20,30,0,5,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(24,'Green Friend',10,20,30,0,5,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(25,'Recycler',10,20,30,0,5,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'),(26,'Daily Habit',10,20,30,1,6,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(27,'Green Commuter',10,20,30,2,6,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(28,'Challenge Champ',10,20,30,0,6,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(29,'Green Friend',10,20,30,0,6,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(30,'Recycler',10,20,30,0,6,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'),(31,'Daily Habit',10,20,30,0,7,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(32,'Green Commuter',10,20,30,0,7,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(33,'Challenge Champ',10,20,30,0,7,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(34,'Green Friend',10,20,30,0,7,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(35,'Recycler',10,20,30,0,7,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'),(36,'Daily Habit',10,20,30,0,8,'None','Incorporate eco-friendly habits into your daily routine.','Turn off lights when not in use, use reusable water bottles, conserve water daily.'),(37,'Green Commuter',10,20,30,0,8,'None','Choose green transportation methods.','Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'),(38,'Challenge Champ',10,20,30,0,8,'None','Complete sustainability challenges.','Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'),(39,'Green Friend',10,20,30,0,8,'None','Spread awareness about sustainability.','Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'),(40,'Recycler',10,20,30,0,8,'None','Dedicate efforts to recycling.','Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.');
/*!40000 ALTER TABLE `badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carbon_footprint_for_food`
--

DROP TABLE IF EXISTS `carbon_footprint_for_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carbon_footprint_for_food` (
  `Food_Item` varchar(255) DEFAULT NULL,
  `CO2_e_per_kg` float DEFAULT NULL,
  `Typical_Serving_Size_g` int DEFAULT NULL,
  `CO2_e_per_serving` float DEFAULT NULL,
  `contains_meat` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carbon_footprint_for_food`
--

LOCK TABLES `carbon_footprint_for_food` WRITE;
/*!40000 ALTER TABLE `carbon_footprint_for_food` DISABLE KEYS */;
INSERT INTO `carbon_footprint_for_food` VALUES ('apple_pie',2.26,125,0.2825,0),('baby_back_ribs',16,200,3.2,1),('baklava',4,75,0.3,0),('beef_carpaccio',27,85,2.295,1),('beef_tartare',27,100,2.7,1),('beet_salad',2,150,0.3,0),('beignets',2.36,80,0.1888,0),('bibimbap',3.5,400,1.4,0),('bread_pudding',1.98,150,0.297,0),('breakfast_burrito',3.5,200,0.7,0),('bruschetta',1.5,50,0.075,0),('caesar_salad',2.5,200,0.5,0),('cannoli',3.84,70,0.2688,0),('caprese_salad',2.2,180,0.396,0),('carrot_cake',1.245,100,0.1245,0),('ceviche',3.115,150,0.46725,1),('cheesecake',3.5,125,0.4375,0),('cheese_plate',12.9,100,1.29,0),('chicken_curry',3.745,250,0.93625,1),('chicken_quesadilla',4,150,0.6,1),('chicken_wings',3.2,150,0.48,1),('chocolate_cake',2.585,100,0.2585,0),('chocolate_mousse',10.86,100,1.086,0),('churros',1.7,80,0.136,0),('clam_chowder',5.04,250,1.26,0),('club_sandwich',3.775,250,0.94375,0),('crab_cakes',5.43,150,0.8145,1),('creme_brulee',2.857,150,0.42855,0),('croque_madame',6.61,200,1.322,0),('cup_cakes',3.96,80,0.3168,0),('deviled_eggs',1.83,100,0.183,0),('donuts',3.96,80,0.3168,0),('dumplings',4.535,150,0.68025,0),('edamame',1.005,100,0.1005,0),('eggs_benedict',0.943,200,0.1886,1),('escargots',4.8,100,0.48,1),('falafel',2.8,150,0.42,0),('filet_mignon',27,200,5.4,1),('fish_and_chips',4.5,300,1.35,1),('foie_gras',15,50,0.75,1),('french_fries',2.5,200,0.5,0),('french_onion_soup',3.2,250,0.8,0),('french_toast',3.1,200,0.62,0),('fried_calamari',3.6,150,0.54,1),('fried_rice',3,200,0.6,0),('frozen_yogurt',2.2,150,0.33,0),('garlic_bread',1.5,50,0.075,0),('gnocchi',2.6,200,0.52,0),('greek_salad',2.2,200,0.44,0),('grilled_cheese_sandwich',3.5,150,0.525,0),('grilled_salmon',6,200,1.2,1),('guacamole',2,100,0.2,0),('gyoza',4.5,150,0.675,1),('hamburger',5.7,250,1.425,1),('hot_and_sour_soup',2.5,250,0.625,0),('hot_dog',3.5,150,0.525,1),('huevos_rancheros',2.7,250,0.675,0),('hummus',1.5,100,0.15,0),('ice_cream',4.5,100,0.45,0),('lasagna',4,250,1,1),('lobster_bisque',6.5,250,1.625,1),('lobster_roll_sandwich',6.5,200,1.3,0),('macaroni_and_cheese',3,200,0.6,0),('macarons',3.5,30,0.105,0),('miso_soup',1.8,200,0.36,0),('mousaka',4.5,250,1.125,0),('mussels',2,200,0.4,1),('nachos',2.5,200,0.5,0),('omelette',2.3,150,0.345,0),('onion_rings',3,150,0.45,0),('oysters',2,150,0.3,0),('pad_thai',4,300,1.2,0),('paella',4,300,1.2,1),('pancakes',2.5,150,0.375,0),('panna_cotta',3,150,0.45,0),('peach_melba',2,200,0.4,0),('peanut_butter_cookies',4,50,0.2,0),('peking_duck',15,200,3,0),('pho',3,300,0.9,1),('pizza',3.5,150,0.525,1),('pork_chop',7,250,1.75,1),('poutine',4,300,1.2,0),('prime_rib',27,250,6.75,1),('pulled_pork_sandwich',7,200,1.4,1),('ramen',3.5,300,1.05,1),('ravioli',4,200,0.8,1),('red_velvet_cake',2.5,100,0.25,0),('risotto',4,250,1,0),('samosa',3,100,0.3,0),('sashimi',6,150,0.9,1),('scallops',5,150,0.75,1),('seaweed_salad',1.5,100,0.15,0),('shrimp_and_grits',5.5,250,1.375,1),('spaghetti_bolognese',3.5,300,1.05,1),('spaghetti_carbonara',4,300,1.2,0),('spring_rolls',2.5,150,0.375,0),('steak',27,250,6.75,1),('strawberry_shortcake',3,150,0.45,0),('sushi',3.5,200,0.7,1),('tacos',3,150,0.45,0),('takoyaki',4,150,0.6,1),('tiramisu',3.5,150,0.525,0),('tuna_tartare',6,100,0.6,1),('waffles',3,150,0.45,0);
/*!40000 ALTER TABLE `carbon_footprint_for_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cost-of-electricity-by-country-2024`
--

DROP TABLE IF EXISTS `cost-of-electricity-by-country-2024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost-of-electricity-by-country-2024` (
  `country` text,
  `CostOfElectricityMarch2023` double DEFAULT NULL,
  `CostOfElectricitySeptember2022` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cost-of-electricity-by-country-2024`
--

LOCK TABLES `cost-of-electricity-by-country-2024` WRITE;
/*!40000 ALTER TABLE `cost-of-electricity-by-country-2024` DISABLE KEYS */;
INSERT INTO `cost-of-electricity-by-country-2024` VALUES ('India',0.0731,0.074),('China',0.0791,0.078),('United States',0.1751,0.18),('Indonesia',0.0951,0.096),('Pakistan',0.0371,0.046),('Nigeria',0.0491,0.03),('Brazil',0.1971,0.175),('Bangladesh',0.0541,0.052),('Russia',0.0641,0.059),('Ethiopia',0.0061,0.006),('Mexico',0.0971,0.104),('Japan',0.2461,0.247),('Philippines',0.1841,0.176),('Egypt',0.0271,0.027),('DR Congo',0.0811,0.07),('Vietnam',0.0791,0.08),('Iran',0.0051,0.002),('Turkey',0.0771,0.073),('Germany',0.5201,0.557),('Thailand',0.1121,0.121),('Tanzania',0.0981,0.096),('United Kingdom',0.4711,0.421),('France',0.2141,0.218),('South Africa',0.1511,0.151),('Italy',0.4611,0.579),('Kenya',0.1721,0.156),('Myanmar',0.0291,0.029),('Colombia',0.1371,0.167),('South Korea',0.0931,0.101),('Uganda',0.1631,0.164),('Sudan',0.0091,0.008),('Spain',0.3661,0.371),('Iraq',0.0131,0.015),('Algeria',0.0391,0.039),('Argentina',0.0331,0.032),('Afghanistan',0.0421,0.043),('Poland',0.1781,0.194),('Canada',0.1121,0.121),('Morocco',0.1131,0.117),('Ukraine',0.0391,0.039),('Angola',0.0231,0.016),('Saudi Arabia',0.0481,0.048),('Uzbekistan',0.0261,0.026),('Mozambique',0.1271,0.127),('Ghana',0.0291,0.033),('Peru',0.2251,0.242),('Malaysia',0.0491,0.048),('Nepal',0.0441,0.044),('Madagascar',0.1361,0.13),('Ivory Coast',0.1171,0.121),('Venezuela',0.1731,0.045),('Cameroon',0.0811,0.083),('Australia',0.2151,0.238),('Syria',0.0141,0.005),('Mali',0.2121,0.218),('Taiwan',0.0921,0.095),('Burkina Faso',0.2001,0.206),('Sri Lanka',0.0411,0.05),('Malawi',0.1091,0.109),('Zambia',0.0281,0.029),('Kazakhstan',0.0451,0.045),('Chile',0.1731,0.194),('Romania',0.1721,0.176),('Ecuador',0.0961,0.096),('Guatemala',0.2711,0.281),('Senegal',0.1671,0.172),('Netherlands',0.3411,0.491),('Cambodia',0.1501,0.148),('Zimbabwe',0.0051,0.015),('Rwanda',0.2361,0.223),('Tunisia',0.0671,0.068),('Belgium',0.4441,0.524),('Dominican Republic',0.1231,0.124),('Jordan',0.1001,0.09),('Cuba',0.0301,0.03),('Honduras',0.2311,0.231),('Sweden',0.2871,0.348),('Czech Republic',0.3651,0.453),('Azerbaijan',0.0471,0.047),('Greece',0.1981,0.273),('Portugal',0.2661,0.295),('Hungary',0.1051,0.115),('United Arab Emirates',0.0811,0.079),('Belarus',0.0921,0.091),('Israel',0.1591,0.16),('Togo',0.1871,0.193),('Sierra Leone',0.0821,0.081),('Austria',0.4621,0.502),('Switzerland',0.2291,0.234),('Laos',0.0351,0.032),('Hong Kong',0.1631,0.173),('Nicaragua',0.1731,0.174),('Serbia',0.0921,0.105),('Libya',0.0041,0.01),('Paraguay',0.0551,0.056),('Kyrgyzstan',0.0101,0.01),('Bulgaria',0.1301,0.14),('El Salvador',0.2441,0.24),('Singapore',0.2221,0.238),('Denmark',0.5291,0.579),('Slovakia',0.1991,0.207),('Finland',0.2351,0.456),('Norway',0.1331,0.129),('New Zealand',0.1881,0.191),('Costa Rica',0.1551,0.161),('Lebanon',0.0021,0.001),('Ireland',0.3301,0.426),('Oman',0.0261,0.026),('Panama',0.1761,0.18),('Kuwait',0.0291,0.029),('Georgia',0.0761,0.077),('Uruguay',0.2431,0.25),('Moldova',0.1151,0.147),('Bosnia and Herzegovina',0.0961,0.101),('Albania',0.1051,0.116),('Jamaica',0.3301,0.325),('Armenia',0.1031,0.104),('Qatar',0.0321,0.033),('Botswana',0.0951,0.096),('Lithuania',0.3601,0.502),('Namibia',0.1351,0.109),('Gabon',0.1991,0.205),('Lesotho',0.0921,0.092),('Slovenia',0.2681,0.295),('North Macedonia',0.1011,0.117),('Latvia',0.2951,0.317),('Trinidad and Tobago',0.0521,0.052),('Bahrain',0.0481,0.048),('Estonia',0.3191,0.393),('Mauritius',0.1311,0.132),('Cyprus',0.2701,0.382),('Eswatini',0.0951,0.098),('Bhutan',0.0151,0.016),('Macau',0.1511,0.158),('Luxembourg',0.2391,0.24),('Suriname',0.0101,0.016),('Cape Verde',0.3041,0.313),('Malta',0.1421,0.146),('Maldives',0.1431,0.15),('Belize',0.2171,0.218),('Bahamas',0.2621,0.26),('Iceland',0.1371,0.15),('Barbados',0.3301,0.273),('Aruba',0.1851,0.183),('Cayman Islands',0.3661,0.444),('Bermuda',0.3951,0.46),('Liechtenstein',0.2731,0.29);
/*!40000 ALTER TABLE `cost-of-electricity-by-country-2024` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cost_of_electricity_by_country_2024`
--

DROP TABLE IF EXISTS `cost_of_electricity_by_country_2024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_of_electricity_by_country_2024` (
  `country` varchar(100) NOT NULL,
  `CostOfElectricityMarch2023` float NOT NULL,
  `CostOfElectricitySeptember2022` float NOT NULL,
  PRIMARY KEY (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cost_of_electricity_by_country_2024`
--

LOCK TABLES `cost_of_electricity_by_country_2024` WRITE;
/*!40000 ALTER TABLE `cost_of_electricity_by_country_2024` DISABLE KEYS */;
/*!40000 ALTER TABLE `cost_of_electricity_by_country_2024` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_carbon_footprint`
--

DROP TABLE IF EXISTS `daily_carbon_footprint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_carbon_footprint` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `date` date NOT NULL,
  `carbon_footprint` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `daily_carbon_footprint_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_carbon_footprint`
--

LOCK TABLES `daily_carbon_footprint` WRITE;
/*!40000 ALTER TABLE `daily_carbon_footprint` DISABLE KEYS */;
INSERT INTO `daily_carbon_footprint` VALUES (1,1,'2024-07-29',1.47073),(2,1,'2024-07-30',9.6),(3,1,'2024-07-31',1.22273);
/*!40000 ALTER TABLE `daily_carbon_footprint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_log`
--

DROP TABLE IF EXISTS `food_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `food_name` varchar(100) NOT NULL,
  `serving_size` float NOT NULL,
  `carbon_footprint` float NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_food_log_user_id` (`user_id`),
  CONSTRAINT `fk_food_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_log`
--

LOCK TABLES `food_log` WRITE;
/*!40000 ALTER TABLE `food_log` DISABLE KEYS */;
INSERT INTO `food_log` VALUES (1,1,'spaghetti_bolognese',200,0.7,'2024-07-23 05:00:31'),(2,1,'spaghetti_bolognese',200,0.7,'2024-07-23 05:00:40'),(3,1,'waffles',50,0.15,'2024-07-23 05:03:32'),(4,1,'waffles',100,0.3,'2024-07-23 05:04:22'),(5,1,'waffles',100,0.3,'2024-07-23 05:06:05'),(6,1,'prime_rib',100,2.7,'2024-07-23 06:21:03'),(7,1,'prime_rib',100,2.7,'2024-07-23 06:21:43'),(8,4,'pizza',200,0.7,'2024-07-27 08:24:43'),(9,4,'waffles',500,1.5,'2024-07-27 08:25:26'),(10,1,'Baklava',100,0.4,'2024-07-29 02:06:38'),(11,1,'Lasagna',100,0.4,'2024-07-29 15:25:16'),(12,1,'cup_cakes',50,0.198,'2024-07-29 15:38:05'),(13,1,'pizza',100,0.35,'2024-07-31 10:33:14');
/*!40000 ALTER TABLE `food_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `points`
--

DROP TABLE IF EXISTS `points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `points` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `points` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_points_user_id` (`user_id`),
  CONSTRAINT `fk_points_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `points_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `points`
--

LOCK TABLES `points` WRITE;
/*!40000 ALTER TABLE `points` DISABLE KEYS */;
INSERT INTO `points` VALUES (1,1,200),(2,2,70),(3,4,20),(4,6,20);
/*!40000 ALTER TABLE `points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_posts_user_id` (`user_id`),
  CONSTRAINT `fk_posts_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,1,'Hannah','I just learned how to make a tin can planter','2024-07-23 02:34:33'),(2,1,'Hannah','I learned how to make a birdhouse','2024-07-31 02:37:47');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recycling_recommendations`
--

DROP TABLE IF EXISTS `recycling_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recycling_recommendations` (
  `id` int NOT NULL,
  `topic` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` text,
  `popularity_score` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recycling_recommendations`
--

LOCK TABLES `recycling_recommendations` WRITE;
/*!40000 ALTER TABLE `recycling_recommendations` DISABLE KEYS */;
INSERT INTO `recycling_recommendations` VALUES (1,'DIY Recycling Projects','DIY Tin Can Planter','https://www.instructables.com/Tin-Can-Planter/','Learn how to make planters from tin cans.',8),(2,'DIY Recycling Projects','Plastic Bottle Bird Feeder','https://www.instructables.com/Plastic-Bottle-Bird-Feeder/','This project is about Plastic Bottle Bird Feeder in the category of DIY Recycling Projects.',6),(3,'DIY Recycling Projects','Toilet Paper Roll Crafts','https://www.instructables.com/Projects-using-Toilet-Paper-Rolls/','Creative crafts using toilet paper rolls.',0),(4,'DIY Recycling Projects','DIY Recycled Paper','https://paperslurry.com/blog/2014/05/19/how-to-make-handmade-paper-from-recycled-materials','This project is about DIY Recycled Paper in the category of DIY Recycling Projects.',1),(5,'DIY Recycling Projects','Cardboard Box Playhouse','https://www.instructables.com/Turn-a-Cardboard-Box-Into-a-Playhouse/','This project is about Cardboard Box Playhouse in the category of DIY Recycling Projects.',0),(6,'DIY Recycling Projects','Recycled Bottle Cap Mosaic','https://thecolorgirl.com/index.php/2020/10/10/how-to-make-a-bottle-cap-art-mosaic-tabletop/','This project is about Recycled Bottle Cap Mosaic in the category of DIY Recycling Projects.',0),(7,'DIY Recycling Projects','Egg Carton Flower Lights','https://www.instructables.com/Egg-Carton-Flower-Lights/','This project is about Egg Carton Flower Lights in the category of DIY Recycling Projects.',0),(8,'DIY Recycling Projects','Milk Jug Watering Can','https://thegrowingcreatives.com/milk-jug-watering-can-craft/','This project is about Milk Jug Watering Can in the category of DIY Recycling Projects.',0),(9,'DIY Recycling Projects','Magazine Coasters','https://www.instructables.com/Magazine-Coasters/','This project is about Magazine Coasters in the category of DIY Recycling Projects.',0),(10,'DIY Recycling Projects','Tin Can Lanterns','https://www.instructables.com/Tin-Can-Lantern/','This project is about Tin Can Lanterns in the category of DIY Recycling Projects.',0),(11,'DIY Recycling Projects','Recycled T-Shirt Tote Bag','https://www.instructables.com/No-Sew-T-Shirt-Tote-Bag-1/','This project is about Recycled T-Shirt Tote Bag in the category of DIY Recycling Projects.',0),(12,'DIY Recycling Projects','Wine Cork Bulletin Board','https://www.instructables.com/Wine-Cork-Bulletin-Board/','This project is about Wine Cork Bulletin Board in the category of DIY Recycling Projects.',0),(13,'Environmental Impact','Environmental Impact of Recycling','https://www.recyclingbins.co.uk/blogs/education-tips/environmental-impacts-of-recycling','Discover the impact of recycling on the environment.',0),(14,'Environmental Impact','How Recycling Reduces Pollution','https://sciencing.com/can-recycling-prevent-pollution-7455182.html','Explore how recycling can help reduce pollution.',0),(15,'Environmental Impact','Benefits of Recycling','https://friendsoftheearth.uk/sustainable-living/7-benefits-recycling','This project is about Benefits of Recycling in the category of Environmental Impact.',0),(16,'Environmental Impact','Recycling and Climate Change','https://www.colorado.edu/ecenter/2023/12/15/impact-recycling-climate-change','This project is about Recycling and Climate Change in the category of Environmental Impact.',0),(17,'Environmental Impact','Recycling Facts and Statistics','https://www.weforum.org/agenda/2022/06/recycling-global-statistics-facts-plastic-paper/','This project is about Recycling Facts and Statistics in the category of Environmental Impact.',0),(18,'Environmental Impact','Impact of Plastic Recycling','https://www.buxtonwater.co.uk/articles/community-and-environment/plastic-recycling#:~:text=Plastic%20recycling%20reduces%20the%20need,adding%20more%20rubbish%20to%20landfills.','This project is about Impact of Plastic Recycling in the category of Environmental Impact.',0),(19,'Environmental Impact','Economic Impact of Recycling','https://www.slrecyclingltd.co.uk/what-are-the-economic-benefits-of-recycling/#:~:text=Recycling%20helps%20boost%20the%20broader,and%20expansion%20of%20different%20markets.','This project is about Economic Impact of Recycling in the category of Environmental Impact.',0),(20,'Environmental Impact','Global Recycling Day','https://www.globalrecyclingday.com/','This project is about Global Recycling Day in the category of Environmental Impact.',0),(21,'Environmental Impact','Recycling and Energy Conservation','https://www.americangeosciences.org/critical-issues/faq/how-does-recycling-save-energy#:~:text=Extracting%20and%20processing%20raw%20resources,turn%20them%20into%20usable%20materials.','This project is about Recycling and Energy Conservation in the category of Environmental Impact.',0),(22,'Environmental Impact','Recycling Myths Debunked','https://www.colorado.edu/ecenter/2022/04/26/debunking-recycling-myths','This project is about Recycling Myths Debunked in the category of Environmental Impact.',0),(23,'Environmental Impact','The Lifecycle of Recyclables','https://sustainability.wm.com/esg-hub/environmental/recycling-life-cycle-approach','This project is about The Lifecycle of Recyclables in the category of Environmental Impact.',0),(24,'Environmental Impact','Reducing Carbon Footprint Through Recycling','https://kingcounty.gov/en/legacy/depts/dnrp/solid-waste/programs/climate/climate-change-recycling#:~:text=Recycling%20helps%20reduce%20greenhouse%20gas,extracting%20or%20mining%20virgin%20materials.','This project is about Reducing Carbon Footprint Through Recycling in the category of Environmental Impact.',0),(25,'Reuse Projects','Repurpose Plastic Bags','https://www.teongchuan.com/ways-reuse-repurpose-plastic-bags','Ideas for reusing and repurposing plastic bags.',0),(26,'Reuse Projects','Reuse Takeout Containers','https://www.familyhandyman.com/article/ways-to-repurpose-takeout-containers/','Tips for reusing takeout containers.',2),(27,'Reuse Projects','Glass Jar Repurposing','https://www.budgetdumpster.com/blog/reusing-glass-bottles-and-jars','This project is about Glass Jar Repurposing in the category of Reuse Projects.',0),(28,'Reuse Projects','Pallet Furniture Ideas','https://www.thespruce.com/wood-pallet-furniture-ideas-7557353','This project is about Pallet Furniture Ideas in the category of Reuse Projects.',0),(29,'Reuse Projects','Cardboard Furniture','https://www.instructables.com/Make-Furniture-With-Cardboard/','This project is about Cardboard Furniture in the category of Reuse Projects.',0),(30,'Reuse Projects','Repurposing Old Clothes','https://www.thespruce.com/ways-to-reuse-clothes-8634146','This project is about Repurposing Old Clothes in the category of Reuse Projects.',0),(31,'Reuse Projects','Turn Jeans into Shorts','https://www.instyle.com/how-to-cut-jeans-shorts-5387251','This project is about Turn Jeans into Shorts in the category of Reuse Projects.',0),(32,'Reuse Projects','DIY Pet Bed from Sweater','https://www.hgtv.com/design/make-and-celebrate/handmade/diy-pet-bed','This project is about DIY Pet Bed from Sweater in the category of Reuse Projects.',0),(33,'Reuse Projects','Coffee Grounds Uses','https://www.healthline.com/nutrition/uses-for-coffee-grounds','This project is about Coffee Grounds Uses in the category of Reuse Projects.',0),(34,'Reuse Projects','DIY Compost Bin','https://www.thespruce.com/compost-bin-plans-4769337','This project is about DIY Compost Bin in the category of Reuse Projects.',0),(35,'Reuse Projects','Old Furniture Repurposing','https://www.architecturaldigest.com/story/repurposed-furniture-ideas','This project is about Old Furniture Repurposing in the category of Reuse Projects.',0),(36,'Reuse Projects','Tire Planters','https://divaofdiy.com/tire-planters/','This project is about Tire Planters in the category of Reuse Projects.',0),(37,'Upcycling Ideas','Upcycling Plastic Bottles','https://www.instructables.com/3-Upcycling-Ideas-for-Plastic-Bottles/','Innovative ways to upcycle plastic bottles.',1),(38,'Upcycling Ideas','Upcycling Clothes','https://www.instructables.com/Upcycling/','Ideas for upcycling old clothes.',0),(39,'Upcycling Ideas','Upcycling Pallets','https://associated-pallets.co.uk/blog/wooden-pallets-ultimate-guide-safely-upcycling/','This project is about Upcycling Pallets in the category of Upcycling Ideas.',0),(40,'Upcycling Ideas','Upcycled Glass Bottle Crafts','https://www.countryliving.com/diy-crafts/g2534/repurpose-wine-bottles/','This project is about Upcycled Glass Bottle Crafts in the category of Upcycling Ideas.',0),(41,'Upcycling Ideas','Upcycled Home Décor','https://upcyclemystuff.com/category/upcycled-furniture-and-home-decor/diy-home-decor-tutorials-upcycling/','This project is about Upcycled Home Décor in the category of Upcycling Ideas.',0),(42,'Upcycling Ideas','DIY Upcycled Furniture','https://www.hellowonderful.co/post/upcycling-furniture-ideas/','This project is about DIY Upcycled Furniture in the category of Upcycling Ideas.',0),(43,'Upcycling Ideas','Upcycled Lighting Ideas','https://earth911.com/diy/bright-ideas-for-upcycled-lighting/','This project is about Upcycled Lighting Ideas in the category of Upcycling Ideas.',0),(44,'Upcycling Ideas','Upcycling Denim','https://scratchandstitch.com/30-denim-upcycling-ideas-using-old-jeans/','This project is about Upcycling Denim in the category of Upcycling Ideas.',0),(45,'Upcycling Ideas','Upcycled Book Crafts','https://www.instructables.com/How-to-make-upcycled-art-with-old-books/','This project is about Upcycled Book Crafts in the category of Upcycling Ideas.',0),(46,'Upcycling Ideas','Upcycling Wooden Crates','https://www.pillarboxblue.com/old-wooden-crates/','This project is about Upcycling Wooden Crates in the category of Upcycling Ideas.',0),(47,'Upcycling Ideas','Upcycled Jewelry','https://smallbiztrends.com/upcycled-jewelry/','This project is about Upcycled Jewelry in the category of Upcycling Ideas.',0),(48,'Upcycling Ideas','Upcycled Garden Ideas','https://www.pillarboxblue.com/50-cool-upcycling-ideas-for-the-garden/','This project is about Upcycled Garden Ideas in the category of Upcycling Ideas.',0),(49,'Benefits of Recycling','Why Recycling Matters','https://www.brysonrecycling.org/recycling/why-recycle/','This project is about Why Recycling Matters in the category of Benefits of Recycling.',1),(50,'Benefits of Recycling','Recycling Reduces Waste','https://www.nature.org/en-us/about-us/where-we-work/united-states/delaware/stories-in-delaware/delaware-eight-ways-to-reduce-waste/','This project is about Recycling Reduces Waste in the category of Benefits of Recycling.',0),(51,'Benefits of Recycling','Impact on Wildlife','https://www.jbrecycling.co.uk/jb-knowledge/why-is-recycling-important-for-biodiversity#:~:text=How%20Does%20Recycling%20Help%20Animals,natural%20environments%20where%20animals%20live.','This project is about Impact on Wildlife in the category of Benefits of Recycling.',0),(52,'Benefits of Recycling','Fight Climate Change','https://www.un.org/sustainabledevelopment/climate-change/','This project is about Fight Climate Change in the category of Benefits of Recycling.',0),(53,'Benefits of Recycling','Economic Benefits','https://www.linkedin.com/pulse/power-recycling-benefits-environment-economy-society-join-tanuu-shree','This project is about Economic Benefits in the category of Benefits of Recycling.',0),(54,'Benefits of Recycling','Sustainable Living','https://www.detpak.com/news-and-events/latest-news/benefits-of-recycling-go-beyond-the-environment/','This project is about Sustainable Living in the category of Benefits of Recycling.',0),(55,'Benefits of Recycling','E-Waste Recycling','https://www.gclcevre.com/en/benefits-of-e-waste-recycling#:~:text=Conserves%20natural%20resources%3A%20Recycling%20recovers,raw%20materials%20from%20the%20earth.','This project is about E-Waste Recycling in the category of Benefits of Recycling.',0),(56,'Benefits of Recycling','Healthier Planet','https://www.earth.com/news/global-recycling-day-creating-a-healthier-planet-for-all/','This project is about Healthier Planet in the category of Benefits of Recycling.',0),(57,'Benefits of Recycling','Reduce Landfill Waste','https://green.org/2024/01/30/how-recycling-reduces-landfill-waste-and-pollution/','This project is about Reduce Landfill Waste in the category of Benefits of Recycling.',0),(58,'Benefits of Recycling','Social Benefits','https://green.org/2024/01/30/the-social-benefits-of-community-recycling-programs/','This project is about Social Benefits in the category of Benefits of Recycling.',0),(59,'Benefits of Recycling','Energy Savings','https://harmony1.com/recycling-saves-energy/','This project is about Energy Savings in the category of Benefits of Recycling.',0),(60,'Benefits of Recycling','Long-Term Benefits','https://www.allcountyrecycling.com/blog/2022/6-long-term-and-short-term-recycling-benefits.html','This project is about Long-Term Benefits in the category of Benefits of Recycling.',0);
/*!40000 ALTER TABLE `recycling_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_results`
--

DROP TABLE IF EXISTS `survey_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `country` varchar(100) NOT NULL,
  `electricity_bill` float NOT NULL,
  `electricity_usage_kwh` float NOT NULL,
  `car_mileage_km` float DEFAULT NULL,
  `flights_per_year` int DEFAULT NULL,
  `meat_consumption_per_week` int DEFAULT NULL,
  `carbon_footprint` float NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_survey_results_user_id` (`user_id`),
  CONSTRAINT `fk_survey_results_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `survey_results_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_results`
--

LOCK TABLES `survey_results` WRITE;
/*!40000 ALTER TABLE `survey_results` DISABLE KEYS */;
INSERT INTO `survey_results` VALUES (1,1,'Malaysia',127,12086.7,0,3,5,14319.8,'2024-07-23 04:45:49'),(2,2,'Malaysia',152,14466,0,5,2,15348.7,'2024-07-23 15:16:59'),(3,4,'Malaysia',160,15156.5,0,5,5,17544,'2024-07-27 08:22:02'),(4,5,'Malaysia',241,22829.5,200,5,5,24627.2,'2024-07-28 09:44:59'),(5,6,'Malaysia',200,18945.7,200,5,5,21054,'2024-07-29 07:42:25'),(6,8,'Malaysia',127,11974.8,0,5,5,14616.8,'2024-07-31 10:29:50');
/*!40000 ALTER TABLE `survey_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_interactions`
--

DROP TABLE IF EXISTS `user_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_interactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `article_id` int NOT NULL,
  `category` varchar(255) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_interactions_user_id` (`user_id`),
  KEY `fk_user_interactions_article_id` (`article_id`),
  CONSTRAINT `fk_user_interactions_article_id` FOREIGN KEY (`article_id`) REFERENCES `recycling_recommendations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_interactions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_interactions`
--

LOCK TABLES `user_interactions` WRITE;
/*!40000 ALTER TABLE `user_interactions` DISABLE KEYS */;
INSERT INTO `user_interactions` VALUES (1,1,2,'DIY Recycling Projects','2024-07-31 10:37:12'),(2,1,1,'DIY Recycling Projects','2024-07-31 10:37:12');
/*!40000 ALTER TABLE `user_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_vouchers`
--

DROP TABLE IF EXISTS `user_vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_vouchers` (
  `user_voucher_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `voucher_id` int NOT NULL,
  `date_claimed` date DEFAULT NULL,
  PRIMARY KEY (`user_voucher_id`),
  KEY `user_id` (`user_id`),
  KEY `voucher_id` (`voucher_id`),
  CONSTRAINT `user_vouchers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `user_vouchers_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `Vouchers` (`voucher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_vouchers`
--

LOCK TABLES `user_vouchers` WRITE;
/*!40000 ALTER TABLE `user_vouchers` DISABLE KEYS */;
INSERT INTO `user_vouchers` VALUES (1,1,1,'2024-07-30'),(2,1,1,'2024-07-30');
/*!40000 ALTER TABLE `user_vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(256) DEFAULT NULL,
  `survey_completed` tinyint(1) DEFAULT '0',
  `carbon_footprint` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Hannah','hanah@gmail.com','scrypt:32768:8:1$F8rDey21OJFHNV38$09c5977a4c091ddff42eb0445a446996beb1de3c1dc866751e5dadfe3edd9de467e2fc781df2ff417763fb33071199faa6d45bec527315877ae4aee9719093f1',1,14384.4),(2,'Meghna','meghna@gmail.com','scrypt:32768:8:1$6bA69uueB6PpK7Lb$0a93861ce40a12b3c57fa8d633d5573ce561f9cabf9a3ca781136c6168f39537d4aa2f11d0294fd00dcde5f73dead7ddd8f80e2b57c375bb285555b1522852ab',1,15348.7),(3,'Jamie','jamie@gmail.com','scrypt:32768:8:1$pfMT35xf7Uizc1rQ$63878568e71eb99be34054cb0f7fc393a64a210acbe92dbd3922255459bd539a77208181221ff250625f37137e5e673465bfeab64422c9fc2e08372ee34c5fe5',0,13849.4),(4,'John Doe','john@gmail.com','scrypt:32768:8:1$gUDbZWreIT8tsIrE$55ca2d8c58767f37d26f128e7b7c608cdabb79d369693533a732dc2929fdc489fd3d1d5a5f384a0a0263a49305761641d6832e49c2cfc69c43506d0de8ffa1eb',1,17543.3),(5,'Kate','kate@gmail.com','scrypt:32768:8:1$AYLODXzesqqyepDx$a281b8800b206b0fdf72a2aacf355918816aeb002b921dc0e2121237197af6fd60d2fb5b87ecc4290a5239f06a05b0ffee2f7f4b29a9a7bdf1bde7b7baada20d',1,24627.2),(6,'Lee','lee@gmail.com','scrypt:32768:8:1$GRqGrvknPdJrqFbv$5de46e49324b314039619d1c8a3fdc9e32af1812ba16033bd4e4357557bcb87966bcb638fc00f2466a48676ce849437bcbb351251f3316ad033b3d667189f35a',1,20283.3),(7,'Sudiksha','sudhi@gmail.com','scrypt:32768:8:1$Tm4tGHLel5hhQX9m$51190446af0ed68f807668ac23bfa8dd0a754d9781359f4439c469ad5584901daecc47ebf2ddbe1aa021dacc78cf58e0f4b3448123eae529c1a7241b93c192ca',0,0),(8,'James','james@gmail.com','scrypt:32768:8:1$msphldRcXO1EOgA8$0a461127c2e4cd2a20ad47b19b0a783e7ae5ea5f7eb1732539b39f6ec73d54c98b3a0c7665a248a9c225c92e259cd5b6bc3823e93b7d76a9a533cc3ad0a7c022',1,14616.8);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vouchers`
--

DROP TABLE IF EXISTS `Vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Vouchers` (
  `voucher_id` int NOT NULL,
  `points_required` int NOT NULL,
  `discount_percentage` int NOT NULL,
  `description` varchar(255) NOT NULL,
  `validity_period` date DEFAULT NULL,
  PRIMARY KEY (`voucher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vouchers`
--

LOCK TABLES `Vouchers` WRITE;
/*!40000 ALTER TABLE `Vouchers` DISABLE KEYS */;
INSERT INTO `Vouchers` VALUES (1,100,15,'Bronze Level - 15% off Grab Food','2024-12-31'),(2,200,28,'Silver Level - 28% off Grab Food','2024-12-31'),(3,300,35,'Gold Level - 35% off Grab Food','2024-12-31');
/*!40000 ALTER TABLE `Vouchers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-31 23:40:03
