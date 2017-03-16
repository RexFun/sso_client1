-- MySQL dump 10.13  Distrib 5.7.9, for osx10.9 (x86_64)
--
-- Host: localhost    Database: paper
-- ------------------------------------------------------
-- Server version	5.5.49

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'paper'
--
/*!50003 DROP FUNCTION IF EXISTS `f_get_child_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_child_list`(rootId varchar(1000)) RETURNS varchar(1000) CHARSET utf8 COLLATE utf8_unicode_ci
begin
	declare sChildList varchar(1000); 
	declare sChildTemp varchar(1000);
	set sChildTemp =cast(rootId as char);
    
    
WHILE sChildTemp is not null DO

	IF (sChildList is not null) THEN 
		SET sChildList = concat(sChildList,',',sChildTemp); 
	ELSE 
		SET sChildList = concat(sChildTemp); 
	END IF;

	SELECT group_concat(id) INTO sChildTemp FROM paper.sys_menu where FIND_IN_SET(pid,sChildTemp)>0;
END WHILE;
RETURN sChildList;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `f_get_parent_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_parent_list`(rootId varchar(1000)) RETURNS varchar(1000) CHARSET utf8 COLLATE utf8_unicode_ci
begin
	declare sParentList varchar(1000); 
	declare sParentTemp varchar(1000);
	set sParentTemp =cast(rootId as char);
    
    
WHILE sParentTemp is not null DO

	IF (sParentList is not null) THEN 
		SET sParentList = concat(sParentTemp,',',sParentList); 
	ELSE 
		SET sParentList = concat(sParentTemp); 
	END IF;

	SELECT group_concat(pid) INTO sParentTemp FROM paper.sys_menu where FIND_IN_SET(id,sParentTemp)>0;
END WHILE;
RETURN sParentList;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `p_menu_get_by_userId_and_menuName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_menu_get_by_userId_and_menuName`(i_userId   INT,
																				i_menuName VARCHAR(100))
BEGIN
	DECLARE v_menuId_set VARCHAR(1000);
    -- 获取被搜索的菜单id集合
	SELECT group_concat(t.id)
	  INTO v_menuId_set 
	  FROM sys_menu t
	 INNER JOIN sys_role_permit_mapping t1 ON t.tc_sys_permit_id = t1.tc_sys_permit_id
	 INNER JOIN sys_user_role_mapping t2 ON t1.tc_sys_role_id = t2.tc_sys_role_id
			AND t2.tc_sys_user_id = i_userId
	 WHERE t.tc_name LIKE CONCAT('%', i_menuName, '%');
	-- 返回结果集
    SELECT t.* FROM
    (
		SELECT t.*
		  FROM sys_menu t
		 WHERE FIND_IN_SET(t.id, F_GET_PARENT_LIST(v_menuId_set)) 
		UNION 
		SELECT t.*
		  FROM sys_menu t
		 WHERE FIND_IN_SET(t.id, F_GET_CHILD_LIST(v_menuId_set))
	)t
	ORDER BY t.tc_order;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-23 16:34:24
