-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: bd
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (2,'admin2','hashed_admin_password2','admin@example.com','Admin Two'),(3,'PuPSlCHeK','123','I@gmail.com','PuPSlCHeK');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add admins',7,'add_admins'),(26,'Can change admins',7,'change_admins'),(27,'Can delete admins',7,'delete_admins'),(28,'Can view admins',7,'view_admins'),(29,'Can add bookings',8,'add_bookings'),(30,'Can change bookings',8,'change_bookings'),(31,'Can delete bookings',8,'delete_bookings'),(32,'Can view bookings',8,'view_bookings'),(33,'Can add room images',9,'add_roomimages'),(34,'Can change room images',9,'change_roomimages'),(35,'Can delete room images',9,'delete_roomimages'),(36,'Can view room images',9,'view_roomimages'),(37,'Can add rooms',10,'add_rooms'),(38,'Can change rooms',10,'change_rooms'),(39,'Can delete rooms',10,'delete_rooms'),(40,'Can view rooms',10,'view_rooms'),(41,'Can add users',11,'add_users'),(42,'Can change users',11,'change_users'),(43,'Can delete users',11,'delete_users'),(44,'Can view users',11,'view_users'),(45,'Can add booking',12,'add_booking'),(46,'Can change booking',12,'change_booking'),(47,'Can delete booking',12,'delete_booking'),(48,'Can view booking',12,'view_booking'),(49,'Can add room',13,'add_room'),(50,'Can change room',13,'change_room'),(51,'Can delete room',13,'delete_room'),(52,'Can view room',13,'view_room'),(53,'Can add hotel',14,'add_hotel'),(54,'Can change hotel',14,'change_hotel'),(55,'Can delete hotel',14,'delete_hotel'),(56,'Can view hotel',14,'view_hotel'),(57,'Can add room',15,'add_room'),(58,'Can change room',15,'change_room'),(59,'Can delete room',15,'delete_room'),(60,'Can view room',15,'view_room'),(61,'Can add booking',16,'add_booking'),(62,'Can change booking',16,'change_booking'),(63,'Can delete booking',16,'delete_booking'),(64,'Can view booking',16,'view_booking'),(65,'Can add room category',17,'add_roomcategory'),(66,'Can change room category',17,'change_roomcategory'),(67,'Can delete room category',17,'delete_roomcategory'),(68,'Can view room category',17,'view_roomcategory'),(69,'Can add admins',18,'add_admins'),(70,'Can change admins',18,'change_admins'),(71,'Can delete admins',18,'delete_admins'),(72,'Can view admins',18,'view_admins'),(73,'Can add room images',19,'add_roomimages'),(74,'Can change room images',19,'change_roomimages'),(75,'Can delete room images',19,'delete_roomimages'),(76,'Can view room images',19,'view_roomimages'),(77,'Can add admin',20,'add_admin'),(78,'Can change admin',20,'change_admin'),(79,'Can delete admin',20,'delete_admin'),(80,'Can view admin',20,'view_admin'),(81,'Can add room',21,'add_room'),(82,'Can change room',21,'change_room'),(83,'Can delete room',21,'delete_room'),(84,'Can view room',21,'view_room'),(85,'Can add user',22,'add_user'),(86,'Can change user',22,'change_user'),(87,'Can delete user',22,'delete_user'),(88,'Can view user',22,'view_user'),(89,'Can add booking',23,'add_booking'),(90,'Can change booking',23,'change_booking'),(91,'Can delete booking',23,'delete_booking'),(92,'Can view booking',23,'view_booking');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$kbFsU3GyN5b68X6n8r5GyF$XI+j0VP0WxRE9bA746TzD6EFm2fJl0wjtavPIPGa1xA=',NULL,1,'igork','','','igor.kom@mail.com',1,1,'2024-12-19 16:35:20.703138'),(2,'pbkdf2_sha256$260000$S0gdnrjI5Q0FmSgGFzsMES$2qgOvsWDlB2bcTkq10Ryf6j+eoXaw8ZRsXocaRS8HCU=','2024-12-21 06:28:33.538958',1,'ig','','','igor@gmail.com',1,1,'2024-12-19 16:35:58.117996'),(3,'pbkdf2_sha256$870000$x1ZH3Gsq3C6uE3em1Qxw2j$k6X37JnptU/osi8IZy99rz+C/+zNJk3f9fGENeZOLQc=','2025-05-01 12:27:20.042951',1,'admin','','','admin@example.com',1,1,'2025-05-01 12:26:28.352326'),(4,'pbkdf2_sha256$1000000$PWRWRG09tyzcw0nQy6JxAq$/KLRYYp00qxey9IffAhWyJm5+qk6rOPkWDupOvvqo+U=','2025-05-08 14:10:27.189171',0,'PuPSlCHeK','Игорь','Пупкин','igor.kombarov04@gmail.com',0,1,'2025-05-01 16:37:24.927050'),(5,'pbkdf2_sha256$870000$NYAH56B6wty76exbHMSGem$jvFxl3C5hywMpxWTgUTAN0iOPNsRgMhexC7xMvdCklY=',NULL,0,'1','1','1','1@mail.ru',0,1,'2025-05-01 16:38:10.288010'),(6,'pbkdf2_sha256$720000$FVLOEicwAtgc88YHdCS0U6$Vx6GpaaSLSZ5J/o9+G8NO/d+Zb/NjfXSSQp3hYHEu4g=',NULL,1,'igor','','','igor@mail.ru',1,1,'2025-05-02 21:22:21.645717'),(7,'pbkdf2_sha256$720000$mluiWdF7cRr9bVUpczmJVr$tHqVV09tSJoEOW0L0nmb2x5UA8hoaqDiqhvEKkhb4LI=',NULL,0,'Name','','','1@mail.ru',0,1,'2025-05-03 15:35:32.151061'),(8,'pbkdf2_sha256$720000$iAVpPoPZ4wAzVNRBeNd047$hBJg6jBJDrcXZDiLCt5Q2E+DSEFxYMTqwzoeY146v1s=',NULL,0,'Na','','','admin1@example.com',0,1,'2025-05-03 15:38:37.084173'),(9,'pbkdf2_sha256$720000$knK80Z6EpE0Kk9icskjziK$G9yq5W4d5ZrT2Wp9sn0YHWfK5rxJQzK9AFipPx9TNGQ=',NULL,0,'N','','','a@example.com',0,1,'2025-05-03 15:41:10.805551'),(10,'pbkdf2_sha256$720000$CH2vFDXbYJ6SZ9uVGK9zjv$ppRu63/piL0ghj6PckV+mqfMHgpydHU6+YHmRK8YgD4=',NULL,0,'dima','Дима','Димасик','dima@mail.ru',0,1,'2025-05-03 16:19:12.637706'),(11,'pbkdf2_sha256$720000$vDWFr8AR8BLuYTVBfRHTdP$n4Me6RyWF4QWJgnL9lSc8lRevhtzOJS84n2lJkLCbZw=',NULL,0,'Roma','','','roma@mail.ru',0,1,'2025-05-03 17:27:48.155661'),(12,'pbkdf2_sha256$720000$8icWu6uakpV6PcSen4vTY1$EaBrOel6cUQEavCZr/kHS6DXPcMUm3HbktiH8aCAFFQ=',NULL,0,'Паша','','','pasha@mail.ru',0,1,'2025-05-04 15:21:33.620938'),(13,'pbkdf2_sha256$720000$2qRGRmUHzGkWrQQ6OjCZuu$2f2H7C48ZDjH5XPa7uZCIlTKX5mqfVex1iSYviECSMc=',NULL,0,'pop','','','ig@mail.com',0,1,'2025-05-04 15:25:28.995778'),(14,'pbkdf2_sha256$720000$cSwTGcPEG96GMIjqOhlfvf$NWZcrmp/W1YwOQ5aAitHTStZyI2FqXkksZ+SIWvaBBY=',NULL,0,'igorek','','','igor.kom@mail.ru',0,1,'2025-05-04 15:42:32.566888'),(15,'pbkdf2_sha256$720000$HyGoZ7Jjb6cUeZxkYi7xZn$bqwSyDAaNlgJ7AyVcyWj1yjbsoblh/T6jV+4hvn3xTU=',NULL,0,'Долма','','','dolma@mail.ru',0,1,'2025-05-04 17:27:03.590502'),(16,'pbkdf2_sha256$720000$D3z3BIxlE0Gip6ddCRx5r2$oWzpB42sXQ0Xo3vfKrIduVaj1at6Pb4ggfBl6dDJLHM=',NULL,0,'rom','','','rom@mail.ru',0,1,'2025-05-04 17:35:40.152668'),(17,'pbkdf2_sha256$720000$NkyC8QzOKm7jBLlakUEkON$Fa3Yc9GzCipwb/24YwavhOOt4ZyOuP5+9TXhbEU73Gk=',NULL,0,'Мем','','','mem@mail.ru',0,1,'2025-05-04 17:39:15.519424'),(18,'pbkdf2_sha256$720000$CSFPoQ6Mjzi5XyKx7it777$0wd7AWDKp9a/wbHJgzO5bNCTem3zNmG1UGwRyF+crHs=',NULL,0,'Misha','','','misha@mail.ru',0,1,'2025-05-04 17:42:32.467999'),(19,'pbkdf2_sha256$720000$YetmxB2p6o0EXYgtSjcSqL$qo0KdG1x/+N+qcNhPwy5IWRzcu3ii8QwZQ6kTM+bh7Q=',NULL,0,'masha','','','masha@mail.ru',0,1,'2025-05-04 17:50:11.196333'),(20,'pbkdf2_sha256$720000$fDIGNlXypTb6ZTc4RXL12A$wlxONjUfHYfV2A/UBeiLVhPQllPYOFBZreXw+T71q0A=',NULL,0,'marin','','','marin@mail.ru',0,1,'2025-05-04 18:00:27.987783'),(21,'pbkdf2_sha256$720000$TGMnmjeaDGCNYGpxjAmKVL$kwpW+I2oMPR+jq/UiTE6r7cxl+MTNhOFWGWBMmroxVU=',NULL,0,'mishgan','','','mishgan@mail.ru',0,1,'2025-05-04 18:04:07.937446'),(22,'pbkdf2_sha256$720000$5lNmtL3dEd3WIvQLMj3AEn$741q0qzxbzT0F4hWF27W7oKLrQmwxc4aJs4B23oyK64=',NULL,0,'janedoe','','','janedoe@example.com',0,1,'2025-05-04 18:49:51.902295'),(23,'pbkdf2_sha256$720000$qFp26wpwaI3RIcNDd18O4Z$518n+ApbBdSRgpm0TL/dVxqgHBHw1XsoHziOdQf74yQ=',NULL,0,'Pipa','','','pups@mail.ru',0,1,'2025-05-04 18:52:09.383931'),(24,'pbkdf2_sha256$720000$pTuinPoNZ3FZoxRodaPlnm$xH9j93mudhFVVPvbj7YfKck5Q8GpAFkC5RaLli1iSrU=',NULL,0,'guest','','','guest@example.com',0,1,'2025-05-04 19:07:37.232326'),(25,'pbkdf2_sha256$720000$T6DYt1XIPkhWwndDNxOFUL$2zRAV6gz7+bWWNclNctuVjwlWZUweiY0h6GwjiWq1ZA=',NULL,0,'guest_8da3edca','','','guest_8da3edca@example.com',0,1,'2025-05-04 19:07:38.188740'),(26,'pbkdf2_sha256$720000$CBQzBckUWF84slTiWMHPVk$eJ+1V05gAOCLMsI0a7DuvDaa+p/fTsQKYvd1oAa2394=',NULL,0,'guest_69ec3fc3','','','guest_69ec3fc3@example.com',0,1,'2025-05-04 19:07:38.952734');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  PRIMARY KEY (`booking_id`),
  KEY `user_id` (`user_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (5,2,2,'2024-12-12','2024-12-13',18.00,'2i'),(6,2,1,'2024-12-14','2025-01-02',1.00,'1'),(7,2,2,'2024-06-01','2024-06-02',1.00,'1'),(10,2,6,'2024-12-12','2024-12-13',1.00,'1'),(12,5,2,'2025-05-15','2025-05-22',75.00,'Гость: Игорь Пупкин'),(13,6,2,'2025-05-30','2025-05-31',75.00,'Гостевое бронирование'),(14,7,1,'2025-06-06','2025-05-02',50.00,'Гостевое бронирование');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(12,'api','booking'),(13,'api','room'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(20,'db_app','admin'),(7,'db_app','admins'),(23,'db_app','booking'),(8,'db_app','bookings'),(21,'db_app','room'),(9,'db_app','roomimages'),(10,'db_app','rooms'),(22,'db_app','user'),(11,'db_app','users'),(18,'hotel','admins'),(16,'hotel','booking'),(14,'hotel','hotel'),(15,'hotel','room'),(17,'hotel','roomcategory'),(19,'hotel','roomimages'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-12-19 16:07:35.576075'),(2,'auth','0001_initial','2024-12-19 16:07:36.518164'),(3,'admin','0001_initial','2024-12-19 16:07:36.789138'),(4,'admin','0002_logentry_remove_auto_add','2024-12-19 16:07:36.809112'),(5,'admin','0003_logentry_add_action_flag_choices','2024-12-19 16:07:36.831802'),(6,'contenttypes','0002_remove_content_type_name','2024-12-19 16:07:37.012027'),(7,'auth','0002_alter_permission_name_max_length','2024-12-19 16:07:37.142665'),(8,'auth','0003_alter_user_email_max_length','2024-12-19 16:07:37.203624'),(9,'auth','0004_alter_user_username_opts','2024-12-19 16:07:37.224157'),(10,'auth','0005_alter_user_last_login_null','2024-12-19 16:07:37.367791'),(11,'auth','0006_require_contenttypes_0002','2024-12-19 16:07:37.373083'),(12,'auth','0007_alter_validators_add_error_messages','2024-12-19 16:07:37.386007'),(13,'auth','0008_alter_user_username_max_length','2024-12-19 16:07:37.497129'),(14,'auth','0009_alter_user_last_name_max_length','2024-12-19 16:07:37.589828'),(15,'auth','0010_alter_group_name_max_length','2024-12-19 16:07:37.615440'),(16,'auth','0011_update_proxy_permissions','2024-12-19 16:07:37.627206'),(17,'auth','0012_alter_user_first_name_max_length','2024-12-19 16:07:37.720943'),(18,'db_app','0001_initial','2024-12-19 16:07:37.729819'),(19,'sessions','0001_initial','2024-12-19 16:07:37.776591'),(20,'api','0001_initial','2025-05-02 20:14:08.649573'),(21,'hotel','0001_initial','2025-05-03 10:17:50.682087');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('9rd76b1dtha8ewssf56srnn41ft68nac','.eJxVjDsOwjAQBe_iGlm2_F1Kes5g7dobHEC2FCcV4u4QKQW0b2beSyTc1pq2wUuaizgLK06_G2F-cNtBuWO7dZl7W5eZ5K7Igw557YWfl8P9O6g46rc2DAhmigU4Z2UJPJgYNNhABEQecHJRReN80FZnr7RTrEJxVpvCxOL9AdlPN1w:1uD1xD:yUola-AC9IgbNjv-BPE_lw0SfYkWMrpiCwfmusKtZqY','2025-05-22 14:10:27.209377'),('gndz683erhk06f32n2dd76at6ze2fbqr','.eJxVjDsOwyAQBe9CHSG-BlKm9xnQAktwEoFk7CrK3W1LLpz2zcz7Eg_rUvzacfZTInciyO26BYhvrAdIL6jPRmOryzwFeij0pJ2OLeHncbp_BwV62WvtouBKD45nJpSxAawYZA6OO4NoJe4ItQHgWRkZnc4McgLDGWppAchvA8CQN4Y:1tOsyX:BuDa8HBNaA6wr94YsPsK59mdi80xx32m1JKNA-ceTi4','2025-01-04 06:28:33.544848'),('ne1pqc6b8r92ybzdr59kxl9pigfn3yxl','.eJxVjDsOwjAQBe_iGlkY489S0ucM1q53gwPIluKkQtwdIqWA9s3Me6mE61LS2mVOE6uLsurwuxHmh9QN8B3rrenc6jJPpDdF77TrobE8r7v7d1Cwl29tXGTPIJZIwEXx3kUbKLNANhDd0ckYwBGcgLJBI2EMZyFvMyJbAPX-AO8WOGI:1uAT0X:EQqzPBH59Jt4XNx2-U5Vi8orOBPXkv52N1HYQOHiSGU','2025-05-15 12:27:17.819326');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_images`
--

DROP TABLE IF EXISTS `room_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `image_path` varchar(255) NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `room_images_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_images`
--

LOCK TABLES `room_images` WRITE;
/*!40000 ALTER TABLE `room_images` DISABLE KEYS */;
INSERT INTO `room_images` VALUES (10,10,'rooms/my_room10.jpg');
/*!40000 ALTER TABLE `room_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `room_number` varchar(10) NOT NULL,
  `room_type` varchar(50) NOT NULL,
  `price_per_night` decimal(10,2) NOT NULL,
  `description` text,
  `capacity` int NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'101','Single',50.00,'A cozy single room with a city view.',1),(2,'102','Double',75.00,'A comfortable double room.',4),(6,'2','2',2.00,'2',2),(7,'123','123',213.00,'423549234',2314),(8,'1','1',1.00,'1',1),(9,'f','f',124.00,'f',1234),(10,'145','open',1000.00,'Невероятная комната',10),(11,'220','Семейная',2550.00,'Вся семья поместится',4);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'janedoe','hashed_password2','janedoe@example.com','Jane Doe','0987654321'),(3,'Pipa','12345678','pups@mail.ru','PipaPupa','+88005553535'),(5,'guest','','guest@example.com','Игорь Пупкин',NULL),(6,'guest_8da3edca','','guest_8da3edca@example.com','Лопа Пола',NULL),(7,'guest_69ec3fc3','','guest_69ec3fc3@example.com','fjfjk kfkf',NULL),(8,'Na','pbkdf2_sha256$720000$iAVpPoPZ4wAzVNRBeNd047$hBJg6jBJDrcXZDiLCt5Q2E+DSEFxYMTqwzoeY146v1s=','admin1@example.com','Na',NULL),(9,'N','pbkdf2_sha256$720000$knK80Z6EpE0Kk9icskjziK$G9yq5W4d5ZrT2Wp9sn0YHWfK5rxJQzK9AFipPx9TNGQ=','a@example.com','N',NULL),(23,'pop','pbkdf2_sha256$720000$2qRGRmUHzGkWrQQ6OjCZuu$2f2H7C48ZDjH5XPa7uZCIlTKX5mqfVex1iSYviECSMc=','ig@mail.com',' ',''),(24,'igorek','pbkdf2_sha256$720000$cSwTGcPEG96GMIjqOhlfvf$NWZcrmp/W1YwOQ5aAitHTStZyI2FqXkksZ+SIWvaBBY=','igor.kom@mail.ru',' ',''),(25,'Долма','pbkdf2_sha256$720000$HyGoZ7Jjb6cUeZxkYi7xZn$bqwSyDAaNlgJ7AyVcyWj1yjbsoblh/T6jV+4hvn3xTU=','dolma@mail.ru',' ',''),(30,'guest_7cebf892','','guest_7cebf892@example.com','Дима Пупкин',NULL),(33,'Рома','123','roma@mail.ru','Рома Долгов',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-09 15:56:47
