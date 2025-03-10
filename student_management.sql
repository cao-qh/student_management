/*
 Navicat Premium Data Transfer

 Source Server         : 曹起豪
 Source Server Type    : MySQL
 Source Server Version : 80404 (8.4.4)
 Source Host           : localhost:3306
 Source Schema         : student_management

 Target Server Type    : MySQL
 Target Server Version : 80404 (8.4.4)
 File Encoding         : 65001

 Date: 10/03/2025 21:49:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add 班级', 7, 'add_grade');
INSERT INTO `auth_permission` VALUES (26, 'Can change 班级', 7, 'change_grade');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 班级', 7, 'delete_grade');
INSERT INTO `auth_permission` VALUES (28, 'Can view 班级', 7, 'view_grade');
INSERT INTO `auth_permission` VALUES (29, 'Can add student', 8, 'add_student');
INSERT INTO `auth_permission` VALUES (30, 'Can change student', 8, 'change_student');
INSERT INTO `auth_permission` VALUES (31, 'Can delete student', 8, 'delete_student');
INSERT INTO `auth_permission` VALUES (32, 'Can view student', 8, 'view_student');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$720000$Vi9X3kURHv0beAPrVn3Bed$UDxPnQ+FJqf9QAdm1/nwYVHjKBpxMKNuFOZTn0Lqcgs=', '2025-02-09 09:41:40.590246', 1, 'admin', '', '', 'admin@qq.com', 1, 1, '2025-02-08 07:25:38.134513');
INSERT INTO `auth_user` VALUES (2, 'pbkdf2_sha256$720000$RdyrfZ2ZJYFNWDQidB4BS4$0IUodiln0a83J1gRNgO05bkk8UMOSs9D1gZwAZJiXK0=', NULL, 0, '张三丰_x123456789123111111', '', '', '', 0, 1, '2025-03-01 13:22:30.687714');
INSERT INTO `auth_user` VALUES (3, 'pbkdf2_sha256$720000$9iBMhAuswd4D8DFzwhFH9H$8fd2j7ZPlemyA3fZKdsnUP+r6KbcT7mS1eQf5+GzwR4=', NULL, 0, '李四_x123456789012345678', '', '', '', 0, 1, '2025-03-02 15:01:34.281759');
INSERT INTO `auth_user` VALUES (4, 'pbkdf2_sha256$720000$TpQI0vo93tUtZJveIFetq8$iL9S6Mw/KxyF2E0gkr394H/65J3mOvzQMUy4z2E0oFY=', NULL, 0, '张三_x123456789123456789', '', '', '', 0, 1, '2025-03-08 15:55:07.775284');
INSERT INTO `auth_user` VALUES (5, 'pbkdf2_sha256$720000$eqJiBg9IdYdsRsCioPkD3r$VApxSwKi5QH37yLgeGx9PW/gecGiuCdQpSFG+ezD1D0=', NULL, 0, '王五_x123456789123111111', '', '', '', 0, 1, '2025-03-09 08:14:46.043529');
INSERT INTO `auth_user` VALUES (7, 'pbkdf2_sha256$720000$gwyQlqPNynw5021pTg088J$w4lC0AOqaXehE0rhiooUrBNdOSghu7UELmtr9VbGS5g=', NULL, 0, '张亮_G48619020', '', '', '', 0, 1, '2025-03-10 09:17:57.501387');
INSERT INTO `auth_user` VALUES (8, 'pbkdf2_sha256$720000$u3sbAFCkY4F8snUNYhcbGf$JJonKmJDU5aWnBXz0RpIDq674HqhFFy1GmZ3Px56Siw=', NULL, 0, '吕帅_G53396920', '', '', '', 0, 1, '2025-03-10 09:23:44.440448');
INSERT INTO `auth_user` VALUES (9, 'pbkdf2_sha256$720000$4lC9dHfzmD0uW519ZsY72P$iiu1Kur9a8d3TUX6x7OtQQzNjb2vZa4ykPRUHK5y/UQ=', NULL, 0, '金鑫_G54886220', '', '', '', 0, 1, '2025-03-10 09:23:45.121324');
INSERT INTO `auth_user` VALUES (10, 'pbkdf2_sha256$720000$ncr1yxCjY6Q73g3nZe0ljC$9pj/MqWp2g3tGqDWQUjoUGrLmoEQaU43tKZvw254QTE=', NULL, 0, '张欣_G56271720', '', '', '', 0, 1, '2025-03-10 09:23:45.799937');
INSERT INTO `auth_user` VALUES (11, 'pbkdf2_sha256$720000$nJ2D62heLpua5INLRrweau$50mPFvuFwxrA0cw54ybnN5pZ3s3glYI7tSZHvIkv9hQ=', NULL, 0, '黄伟_G61019820', '', '', '', 0, 1, '2025-03-10 09:23:46.484545');
INSERT INTO `auth_user` VALUES (12, 'pbkdf2_sha256$720000$9d9lnl7BFPX3oBvTFHm1Xv$tBFkNFaKdqdUFGl74RnX8+L5Gn0YpYHDSFBLZao4EMc=', NULL, 0, '钟佳_G55603520', '', '', '', 0, 1, '2025-03-10 09:23:47.158792');
INSERT INTO `auth_user` VALUES (13, 'pbkdf2_sha256$720000$ZsGbgA525hOnhQJAsMbvx0$bOkyX2v2k1pWyI1pr/Zr1ngAS2xQdjZzc6FrlsfCHno=', NULL, 0, '萧红_G51263520', '', '', '', 0, 1, '2025-03-10 09:23:47.823789');
INSERT INTO `auth_user` VALUES (14, 'pbkdf2_sha256$720000$sW29EUbXrolp2RD8BS515y$2hSakaKav9ds2BPPfGLdEFehprtHo7TAoqJUMXSsMj0=', NULL, 0, '戴亮_G47662020', '', '', '', 0, 1, '2025-03-10 09:23:48.500011');
INSERT INTO `auth_user` VALUES (15, 'pbkdf2_sha256$720000$7NTKGlSC1K5yGVsjGrel7T$B4rA5SZjT6VQR5STLZ3NKL21OXk0KONBZexrdnOljlo=', NULL, 0, '张婷婷_G56558420', '', '', '', 0, 1, '2025-03-10 09:23:49.170542');
INSERT INTO `auth_user` VALUES (16, 'pbkdf2_sha256$720000$kQw5dPoUcVxbejM9j025bG$Mj84nQof5kEqTh/kb1Sznotz1KPb0NxFId7uDZP8Qgc=', NULL, 0, '伊娟_G40675220', '', '', '', 0, 1, '2025-03-10 09:23:49.836162');
INSERT INTO `auth_user` VALUES (17, 'pbkdf2_sha256$720000$rN5u2VbuZkUrWFsVFCsb1v$azEutzDTwYUJjwpEUzqSkcWt/y0Jz1gxrSlecD54AUs=', NULL, 0, '刘雪梅_G65209120', '', '', '', 0, 1, '2025-03-10 09:23:50.509096');
INSERT INTO `auth_user` VALUES (18, 'pbkdf2_sha256$720000$FOGtQ3zQSgItO8JfUSCecV$nXr2iPglWnmFiEBdbTn780pxGJCWLD5bVpeQTPDJWs0=', NULL, 0, '宋勇_G63686520', '', '', '', 0, 1, '2025-03-10 09:23:51.178695');
INSERT INTO `auth_user` VALUES (19, 'pbkdf2_sha256$720000$yAnSGObTqzVNFnMCnBzBGY$Svof2xKqkWG0I53wjI62mfKigVo1SL8nujfiEy/Yv5s=', NULL, 0, '余帅_G54325920', '', '', '', 0, 1, '2025-03-10 09:23:51.844573');
INSERT INTO `auth_user` VALUES (20, 'pbkdf2_sha256$720000$GWPyXd9hDPuN3SVFb560Am$5SoglhgK2hm8g1L/asIeGkODcUgHU8EhBpL+j/6t/+Y=', NULL, 0, '阮颖_G48028220', '', '', '', 0, 1, '2025-03-10 09:23:52.513799');
INSERT INTO `auth_user` VALUES (21, 'pbkdf2_sha256$720000$LdNdSyKIVcy9ZygCCiOYjY$+ZbtjpKwzM/r0N1XVTgKFU3CJvf7D035I9nqy6Qsjzc=', NULL, 0, '李洁_G48028221', '', '', '', 0, 1, '2025-03-10 09:23:53.176235');
INSERT INTO `auth_user` VALUES (22, 'pbkdf2_sha256$720000$X0Bwp8LsCi6DgoFkUYwODm$O7odTJjLQiCTAVsquM1NnauEsemu8Ai+gNSO8FtAueo=', NULL, 0, '王娟_G62311320', '', '', '', 0, 1, '2025-03-10 09:23:53.843887');
INSERT INTO `auth_user` VALUES (23, 'pbkdf2_sha256$720000$v5Ce0XBDJoh2xd6zMtAbrQ$QQAOgWi1lfwqWy/IchP+84kpKtMGkjY87b9NN0WR6m4=', NULL, 0, '吴博_G62311321', '', '', '', 0, 1, '2025-03-10 09:23:54.510547');
INSERT INTO `auth_user` VALUES (24, 'pbkdf2_sha256$720000$LgWw4gGtZSwFWAdzH6fSj6$LAUbRUtlFXACtu5S5bNbf8uQZ0qp1KP8EWYBOPsJgIQ=', NULL, 0, '朱玉_G65530820', '', '', '', 0, 1, '2025-03-10 09:23:55.179449');
INSERT INTO `auth_user` VALUES (25, 'pbkdf2_sha256$720000$74vkIBq1IUzdKiNqIArgbC$4CPjCtYXQ+m7tDNQhqGJDpjyNXz+K8o113V44VUI3vU=', NULL, 0, '张桂香_G58647620', '', '', '', 0, 1, '2025-03-10 09:23:55.867707');
INSERT INTO `auth_user` VALUES (26, 'pbkdf2_sha256$720000$K5IlIqYPrcvhaswdOdetTz$t8tedwrCkY4Wek6fwdP0cUl1cUqXZs6UO1p5AcS7r0A=', NULL, 0, '王淑华_G62911620', '', '', '', 0, 1, '2025-03-10 09:23:56.580009');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2025-02-09 09:44:14.722116', '1', '1年2班', 1, '[{\"added\": {}}]', 7, 1);
INSERT INTO `django_admin_log` VALUES (2, '2025-02-09 09:44:34.905284', '2', '1年3班', 1, '[{\"added\": {}}]', 7, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (7, 'grades', 'grade');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (8, 'students', 'student');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2025-02-08 07:13:43.303390');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2025-02-08 07:13:44.010567');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2025-02-08 07:13:44.239295');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2025-02-08 07:13:44.249270');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2025-02-08 07:13:44.259244');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2025-02-08 07:13:44.394638');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2025-02-08 07:13:44.466507');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2025-02-08 07:13:44.496426');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2025-02-08 07:13:44.508402');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2025-02-08 07:13:44.573299');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2025-02-08 07:13:44.580245');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2025-02-08 07:13:44.590220');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2025-02-08 07:13:44.685886');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2025-02-08 07:13:44.766200');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2025-02-08 07:13:44.792133');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2025-02-08 07:13:44.811040');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2025-02-08 07:13:44.893770');
INSERT INTO `django_migrations` VALUES (18, 'sessions', '0001_initial', '2025-02-08 07:13:44.943262');
INSERT INTO `django_migrations` VALUES (19, 'grades', '0001_initial', '2025-02-08 09:59:07.951494');
INSERT INTO `django_migrations` VALUES (20, 'students', '0001_initial', '2025-02-10 08:31:01.653066');
INSERT INTO `django_migrations` VALUES (21, 'students', '0002_alter_student_gender', '2025-03-01 08:33:16.320854');
INSERT INTO `django_migrations` VALUES (22, 'students', '0003_alter_student_options_alter_student_table', '2025-03-01 08:33:16.351887');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('day9esffsz5vh8fa5q00eo5v98jr8hsv', '.eJxVjDsOwjAQBe_iGlmO8WdDSZ8zRLvrNQ4gR4qTCnF3iJQC2jcz76VG3NYybk2WcUrqojp1-t0I-SF1B-mO9TZrnuu6TKR3RR-06WFO8rwe7t9BwVa-NWQKDoxDD-CNY2OFCEyEACGfwUr00vUgAWOfc5cisrUiAI7JE7N6fwDKmzfy:1th3oq:IZfWA5_sOvHR9gGGYyPx13IKTywcWTCC8JXa7Huula0', '2025-02-23 09:41:40.595129');
INSERT INTO `django_session` VALUES ('zdc77nelx96cimpfa84tbrj0psjckgvx', '.eJxVjDsOwjAQBe_iGlmO8WdDSZ8zRLvrNQ4gR4qTCnF3iJQC2jcz76VG3NYybk2WcUrqojp1-t0I-SF1B-mO9TZrnuu6TKR3RR-06WFO8rwe7t9BwVa-NWQKDoxDD-CNY2OFCEyEACGfwUr00vUgAWOfc5cisrUiAI7JE7N6fwDKmzfy:1tgfGv:KV1bhyMzurEzk9S6a0NUaj3esyvzWQ94hTA2uIHt0AI', '2025-02-22 07:29:01.403182');

-- ----------------------------
-- Table structure for grade
-- ----------------------------
DROP TABLE IF EXISTS `grade`;
CREATE TABLE `grade`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `grade_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grade_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `grade_name`(`grade_name` ASC) USING BTREE,
  UNIQUE INDEX `grade_number`(`grade_number` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of grade
-- ----------------------------
INSERT INTO `grade` VALUES (1, '1年2班', 'x0102');
INSERT INTO `grade` VALUES (2, '1年3班', 'x0103');
INSERT INTO `grade` VALUES (3, '1年6班', 'x0106');
INSERT INTO `grade` VALUES (4, '1年7班', 'x0107');
INSERT INTO `grade` VALUES (6, '1年1班', 'x0101');
INSERT INTO `grade` VALUES (7, '2年1班', 'x0201');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `student_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `birthday` date NOT NULL,
  `contact_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grade_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `student_number`(`student_number` ASC) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `students_student_grade_id_37795273_fk_grade_id`(`grade_id` ASC) USING BTREE,
  CONSTRAINT `students_student_grade_id_37795273_fk_grade_id` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `students_student_user_id_56286dbb_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (7, 'G48619020', '张亮', 'F', '2015-08-05', '14536449112', '内蒙古自治区红梅县清城陈路f座810872', 6, 7);
INSERT INTO `student` VALUES (8, 'G53396920', '吕帅', 'F', '2015-08-05', '13845744811', '天津市汕尾县南溪兰州街Q座 312430', 6, 8);
INSERT INTO `student` VALUES (9, 'G54886220', '金鑫', 'F', '2016-12-17', '13801853311', '辽宁省英市涪城张街M座 858936', 6, 9);
INSERT INTO `student` VALUES (10, 'G56271720', '张欣', 'F', '2011-10-26', '13801853312', '黑龙江省晨市长寿陈路P座 536741', 6, 10);
INSERT INTO `student` VALUES (11, 'G61019820', '黄伟', 'F', '2016-12-24', '13801853313', '海南省红霞市清河长沙路Q座801313', 6, 11);
INSERT INTO `student` VALUES (12, 'G55603520', '钟佳', 'F', '2017-03-19', '13801853314', '海南省南昌市城北董街T座345005', 6, 12);
INSERT INTO `student` VALUES (13, 'G51263520', '萧红', 'F', '2013-02-19', '13801853315', '广东省金凤县高港谢路Q座 776887', 6, 13);
INSERT INTO `student` VALUES (14, 'G47662020', '戴亮', 'F', '2012-11-07', '13801853316', '山西省拉萨县白云福州路p座486476', 6, 14);
INSERT INTO `student` VALUES (15, 'G56558420', '张婷婷', 'F', '2014-10-15', '13801853317', '陕西省雪梅市徐汇曾路i座737916', 6, 15);
INSERT INTO `student` VALUES (16, 'G40675220', '伊娟', 'F', '2016-11-23', '13801853318', '上海市宜都县秀英金街J座 622949', 6, 16);
INSERT INTO `student` VALUES (17, 'G65209120', '刘雪梅', 'F', '2012-10-20', '13801853319', '广西壮族自治区兰州市城东高路s座 681659', 6, 17);
INSERT INTO `student` VALUES (18, 'G63686520', '宋勇', 'F', '2014-12-19', '13801853320', '海南省敏县吉区谭路n座360145', 6, 18);
INSERT INTO `student` VALUES (19, 'G54325920', '余帅', 'F', '2015-05-06', '13801853321', '山西省萍县南溪马鞍山街r座251650', 6, 19);
INSERT INTO `student` VALUES (20, 'G48028220', '阮颖', 'F', '2014-10-04', '13801853322', '云南省哈尔滨市山亭昆明街w座936047', 6, 20);
INSERT INTO `student` VALUES (21, 'G48028221', '李洁', 'F', '2014-10-05', '13801853323', '甘肃省北京市合川太原路C座152738', 6, 21);
INSERT INTO `student` VALUES (22, 'G62311320', '王娟', 'F', '2013-06-03', '13801853324', '宁夏回族自治区澳门县双深深圳路o座 594458', 6, 22);
INSERT INTO `student` VALUES (23, 'G62311321', '吴博', 'F', '2013-06-04', '13801853325', '宁夏回族自治区澳门县双深深圳路o座 ', 6, 23);
INSERT INTO `student` VALUES (24, 'G65530820', '朱玉', 'F', '2011-10-03', '13801853326', '湖南省淑英县牧野郭路W座969796', 6, 24);
INSERT INTO `student` VALUES (25, 'G58647620', '张桂香', 'F', '2015-08-26', '13801853327', '河南省刚县合川严路J座 180114', 6, 25);
INSERT INTO `student` VALUES (26, 'G62911620', '王淑华', 'F', '2013-05-06', '13801853328', '广西壮族自治区东莞县梁平赵街t座 127684', 6, 26);

SET FOREIGN_KEY_CHECKS = 1;
